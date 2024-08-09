import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key, required this.groupName});

  final String groupName;

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _filteredUsers = [];
  List<QueryDocumentSnapshot> _allUsers = [];
  User? currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUsers();
    _searchController.addListener(() {
      _filterUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _allUsers = snapshot.docs.where((doc) {
          final user = doc.data() as Map<String, dynamic>;
          return user['email'] != currentUser?.email;
        }).toList();
        _filteredUsers = List.from(_allUsers);
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((doc) {
        final user = doc.data() as Map<String, dynamic>;
        final username = user['username'] as String? ?? '';
        return username.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
        title: Text(
          'Create a new group',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _filterUsers();
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredUsers.isEmpty
                      ? const Center(child: Text('No users found'))
                      : ListView.builder(
                          itemCount: _filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = _filteredUsers[index].data()
                                as Map<String, dynamic>;
                            return InkWell(
                              onTap: () {
                                final rUser = _filteredUsers[index];
                                log("rUser: ${rUser.id}");
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['image_url'] ?? ''),
                                  ),
                                  title: Text(
                                      user['username'][0].toUpperCase() +
                                              user['username']
                                                  .split(".")
                                                  .first
                                                  .substring(1) ??
                                          'Anonymous'),
                                  subtitle: Text(user['email'] ?? 'No Email'),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
