import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/img_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatter'),
        actions: [
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
              color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text("Logged in!"),
      ),
    );
  }
}
