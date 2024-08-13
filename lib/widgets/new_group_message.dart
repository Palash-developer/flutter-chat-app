// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class NewGroupMessage extends StatefulWidget {
//   const NewGroupMessage({super.key});

//   @override
//   State<NewGroupMessage> createState() => _NewGroupMessageState();
// }

// class _NewGroupMessageState extends State<NewGroupMessage> {
//   final _msgController = TextEditingController();

//   @override
//   void dispose() {
//     _msgController.dispose();
//     super.dispose();
//   }

//   void _submitMessage() async {
//     final enteredMessage = _msgController.text;
//     if (enteredMessage.trim().isEmpty) return;

//     FocusScope.of(context).unfocus();
//     _msgController.clear();

//     final group = FirebaseFirestore.instance.collection("groups").get();

//     final groupId = group.toString();

//     log("groupData: ${groupId}.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(
//         right: 1,
//         bottom: 14,
//         left: 14,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _msgController,
//               textCapitalization: TextCapitalization.sentences,
//               autocorrect: true,
//               enableSuggestions: true,
//               decoration: const InputDecoration(
//                 labelText: "Type a message...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(14),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             color: Theme.of(context).colorScheme.primary,
//             onPressed: _submitMessage,
//             icon: Icon(
//               CupertinoIcons.paperplane_fill,
//               color: Colors.blue[500],
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGroupMessage extends StatefulWidget {
  final String groupId;

  const NewGroupMessage({super.key, required this.groupId});

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
    final enteredMessage = _msgController.text.trim();
    if (enteredMessage.isEmpty) return;

    FocusScope.of(context).unfocus();
    _msgController.clear();

    try {
      // Fetch the group document to get member IDs
      final groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .get();

      if (groupSnapshot.exists) {
        final groupData = groupSnapshot.data();
        final List<String> memberIds =
            List<String>.from(groupData?['members'] ?? []);

        // Replace this with actual user data, such as from Firebase Authentication
        // final user = {
        //   'uid': 'user123', // Example user ID
        //   'username': 'John Doe', // Example username
        // };

        // getAdminId() async {
        //   final user = await FirebaseFirestore.instance
        //       .collection('groups')
        //       .doc(widget.groupId)
        //       .get();

        //   if (user.exists) {
        //     final userData = user.data();
        //     return userData?['adminId'];
        //   } else {
        //     return null;
        //   }
        // }

        // Send the message to each member

        final messageData = {
          'text': enteredMessage,
          'createdAt': Timestamp.now(),
          'senderId': FirebaseAuth.instance.currentUser?.uid,
          'senderName': FirebaseAuth.instance.currentUser?.email,
        };

        // Adding the message to the messages subcollection of the current group
        await FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .collection('messages')
            .add(messageData);

        // Optionally, send notifications or update data for each member
        for (var memberId in memberIds) {
          // Example: Send a notification to each member
          log("Message sent to member $memberId in group ${widget.groupId}");
          // Add additional logic here to handle individual member updates
        }

        log("Message sent to group ${widget.groupId}");
      } else {
        log("Group not found!");
      }
    } catch (error) {
      log("Failed to send message: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send message: $error"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
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
