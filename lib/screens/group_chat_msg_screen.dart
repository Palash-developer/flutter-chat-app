// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_app/widgets/group_message_bubble.dart';
// import 'package:flutter_chat_app/widgets/new_group_message.dart';

// class GroupChatMsgScreen extends StatefulWidget {
//   const GroupChatMsgScreen(
//       {super.key, required this.groupName, required this.groupId});

//   final groupName;
//   final groupId;

//   @override
//   State<GroupChatMsgScreen> createState() => _GroupChatMsgScreenState();
// }

// class _GroupChatMsgScreenState extends State<GroupChatMsgScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final group = widget.groupName;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.8),
//         leading: IconButton(
//           icon: Icon(
//             CupertinoIcons.back,
//             color: Theme.of(context).colorScheme.surface,
//             size: 30,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop(); // Navigate back
//           },
//         ),
//         title: Text(
//           group['groupName'],
//           style: TextStyle(color: Theme.of(context).colorScheme.surface),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20, bottom: 0.1),
//             child: Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
//               ),
//               child: Center(
//                 child: Text(
//                   group['groupName'][0].toUpperCase(),
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('groups')
//                   .doc(widget.groupId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
//                 if (chatSnapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final chatDocs = chatSnapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: chatDocs.length,
//                   itemBuilder: (ctx, index) => GroupMessageBubble(
//                     isMe: chatDocs[index]['senderId'] ==
//                         FirebaseAuth.instance.currentUser!.uid,

//                     // chatDocs[index]['senderId'] ==
//                     //     FirebaseAuth.instance.currentUser?.uid, // Adjust this
//                     // ,
//                     message: chatDocs[index]['messageText'] ?? '',
//                     userId: chatDocs[index]
//                         ['senderId'], // Add more fields as needed
//                   ),
//                 );
//               },
//             ),
//           ),
//           NewGroupMessage(groupId: widget.groupId),
//         ],
//       ),

//       // Column(
//       //   children: [
//       //     // pass group id
//       //     NewGroupMessage(),
//       //   ],
//       // ),
//     );
//   }
// }

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/group_message_bubble.dart';
import 'package:flutter_chat_app/widgets/new_group_message.dart';

class GroupChatMsgScreen extends StatefulWidget {
  const GroupChatMsgScreen(
      {super.key, required this.groupName, required this.groupId});

  final String groupName;
  final String groupId;

  @override
  State<GroupChatMsgScreen> createState() => _GroupChatMsgScreenState();
}

class _GroupChatMsgScreenState extends State<GroupChatMsgScreen> {
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
          widget.groupName,
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 0.1),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
              ),
              child: Center(
                child: Text(
                  widget.groupName[0].toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('groups')
                    .doc(widget.groupId)
                    .collection('messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (chatSnapshot.hasError) {
                    log("Error: ${chatSnapshot.error}");
                    return Center(
                      child: Text('Error: ${chatSnapshot.error}'),
                    );
                  }

                  if (!chatSnapshot.hasData ||
                      chatSnapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }
                  final chatDocs = chatSnapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) {
                      final message = chatDocs[index]['text'];
                      final senderId = chatDocs[index]['senderId'];
                      final userEmail =
                          chatDocs[index]['senderName'].split('@')[0];

                      return GroupMessageBubble(
                        isMe:
                            senderId == FirebaseAuth.instance.currentUser!.uid,
                        message: message,
                        userId: senderId,
                        userEmail: userEmail,
                      );
                    },
                  );
                }),
          ),
          NewGroupMessage(groupId: widget.groupId),
        ],
      ),
    );
  }
}
