import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/screens/group_chat_screen.dart';
import 'package:flutter_chat_app/screens/groups_main_screen.dart';
import 'package:flutter_chat_app/services/img_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> uploadImage() async {
    final pickedImg = await ImgService.pickImage();
    if (pickedImg == null) {
      return;
    }
    final filePath = File(pickedImg.path);
    final userCredentials = FirebaseAuth.instance.currentUser;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child(userCredentials!.uid)
          .child("${userCredentials.uid}.jpg");
      await storageRef.putFile(filePath);
      final imgURL = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredentials.uid)
          .update({
        "image_url": imgURL,
      });
      // Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  User? currentUser;

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    // log(token.toString());
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    setupPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
        leading: SizedBox(
          child: Icon(
            CupertinoIcons.home,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
        ),
        title: Text(
          'Chatter',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (ctx) => const GroupChatScreen(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.person_2_alt,
                size: 28,
                color: Theme.of(context).colorScheme.surface,
              )),
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: const Text('Upload a new image'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('Upload Image'),
                            onPressed: () {
                              uploadImage();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            },
            icon: Icon(
              CupertinoIcons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Logout'),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              CupertinoIcons.ellipsis_vertical,
              size: 26,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found!'));
          }

          final users = snapshot.data!.docs.where((doc) {
            final user = doc.data() as Map<String, dynamic>;

            return user['email'] != currentUser?.email;
          }).toList();

          return Stack(
            children: [
              ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index].data() as Map<String, dynamic>;
                  return InkWell(
                    onTap: () {
                      final rUser = users[index];
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (ctx) => ChatScreen(
                            user: user,
                            rUserId: rUser.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user['image_url'] ?? ''),
                        ),
                        title: Text(user['username'][0].toUpperCase() +
                                user['username']
                                    .split(".")
                                    .first
                                    .substring(1) ??
                            'Annonymous'),
                        subtitle: Text(user['email'] ?? 'No Email'),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                right: 12,
                child: FloatingActionButton(
                  onPressed: () {
                    print("object");
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (ctx) => const GroupsMainScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.chat_bubble_2,
                    size: 30,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
