import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/group_chat_msg_screen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Chatter Group Chats',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No groups found!'));
          }

          final userGroups = snapshot.data!.docs.where((doc) {
            final group = doc.data() as Map<String, dynamic>;
            final members = group['members'] as List<dynamic>?;

            return group['groupName'] != null &&
                members != null &&
                members.contains(currentUser!.uid);
          }).toList();

          if (userGroups.isEmpty) {
            return const Center(child: Text('No groups found!'));
          }

          return ListView.builder(
            itemCount: userGroups.length,
            itemBuilder: (context, index) {
              final group = userGroups[index];
              String groupId = group.id;

              return Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        group['groupName'][0].toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  title: Text(group['groupName']),
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (ctx) => GroupChatMsgScreen(
                            groupName: group['groupName'].toString(),
                            groupId: groupId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
