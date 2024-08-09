import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGroupMessage extends StatefulWidget {
  const NewGroupMessage({super.key});

  @override
  State<NewGroupMessage> createState() => _NewGroupMessageState();
}

class _NewGroupMessageState extends State<NewGroupMessage> {
  final _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _msgController.text;
    if (enteredMessage.trim().isEmpty) return;

    FocusScope.of(context).unfocus();
    _msgController.clear();

    final group = FirebaseFirestore.instance.collection("groups").get();

    final groupId = group.toString();

    log("groupData: ${groupId}.");

    // FirebaseFirestore.instance.collection("chats").add(
    //   {
    //     "text": enteredMessage,
    //     "createdAt": Timestamp.now(),
    //     "userId": user.uid,
    //     "userName": userData.data()!["username"],
    //     "userImage": userData.data()!["image_url"],
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 1,
        bottom: 14,
        left: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _msgController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: "Type a message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: Icon(
              CupertinoIcons.paperplane_fill,
              color: Colors.blue[500],
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
