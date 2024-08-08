import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key, required this.rUserId});

  final rUserId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshorts) {
          if (chatSnapshorts.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshorts.hasData || chatSnapshorts.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages found!"),
            );
          }
          if (chatSnapshorts.hasError) {
            return const Center(
              child: Text("Opps! Something went wrong..."),
            );
          }

          // Filter messages where the current user is either the sender or receiver
          final filteredMessages = chatSnapshorts.data!.docs.where((doc) {
            final message = doc.data();
            final senderId = message['userId'];
            final receiverId = message['receiverId'];
            log(senderId.toString());
            log(receiverId.toString());
            log(currentUserId.toString());

            // Check if the current user is either the sender or receiver
            return (senderId == currentUserId && receiverId == rUserId) ||
                (senderId == rUserId && receiverId == currentUserId);
          }).toList();

          if (filteredMessages.isEmpty) {
            return const Center(
              child: Text("No messages found!"),
            );
          }

          log(filteredMessages.first.data().toString());

          return ListView.builder(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 10,
              right: 10,
            ),
            reverse: true,
            itemCount: filteredMessages.length,
            itemBuilder: (ctx, index) {
              final message = filteredMessages[index].data();
              log("msg:$message");
              final nextMsg = index + 1 < filteredMessages.length
                  ? filteredMessages[index + 1]
                  : null;
              final currentMsgUserId = message['userId'];
              final nextMsgUserId = nextMsg != null ? nextMsg['userId'] : null;
              final nextUserIsSame = nextMsgUserId == currentMsgUserId;

              final username = message["userName"][0].toUpperCase() +
                  (message['userName'] ?? '').substring(1).split('.').first;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: message["text"],
                  isMe: authUser.uid == currentMsgUserId,
                );
              } else {
                return MessageBubble.first(
                  username: username,
                  userImage: message["userImage"],
                  message: message["text"],
                  isMe: authUser.uid == currentMsgUserId,
                );
              }
            },
          );
        });
  }
}
