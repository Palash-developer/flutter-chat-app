// import 'package:flutter/material.dart';

// class GroupMessageBubble extends StatelessWidget {
//   final String message;
//   final bool isMe;
//   final String userId;
//   final String userEmail;

//   const GroupMessageBubble({
//     super.key,
//     required this.message,
//     required this.isMe,
//     required this.userId,
//     required this.userEmail,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Stack(
//         children: [
//           !isMe
//               ? Positioned(
//                   top: 0,
//                   left: 0,
//                   child: CircleAvatar(
//                     radius: 23,
//                     backgroundColor: theme.colorScheme.primary.withAlpha(180),
//                     child: Text(
//                       userEmail[0].toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 )
//               : Positioned(
//                   top: 0,
//                   right: 0,
//                   child: CircleAvatar(
//                     radius: 23,
//                     backgroundColor: theme.colorScheme.primary.withAlpha(180),
//                     child: Text(
//                       userEmail[0].toUpperCase(),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 24,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 46),
//             child: Row(
//               mainAxisAlignment:
//                   isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment:
//                       isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 13, right: 13),
//                       child: Text(
//                         userEmail[0].toUpperCase() + userEmail.substring(1),
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: isMe
//                             ? theme.colorScheme.primary.withOpacity(0.2)
//                             : theme.colorScheme.secondary.withOpacity(0.6),
//                         borderRadius: BorderRadius.only(
//                           topLeft:
//                               isMe ? const Radius.circular(12) : Radius.zero,
//                           topRight:
//                               !isMe ? const Radius.circular(12) : Radius.zero,
//                           bottomLeft: const Radius.circular(12),
//                           bottomRight: const Radius.circular(12),
//                         ),
//                       ),
//                       constraints: const BoxConstraints(maxWidth: 200),
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 10,
//                         horizontal: 14,
//                       ),
//                       margin: const EdgeInsets.symmetric(
//                         vertical: 4,
//                         horizontal: 12,
//                       ),
//                       child: Text(
//                         message,
//                         style: TextStyle(
//                           fontSize: 16,
//                           height: 1.3,
//                           color: isMe
//                               ? Colors.black87
//                               : theme.colorScheme.onSecondary,
//                         ),
//                         softWrap: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMessageBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final String userId;
  final String userEmail;

  const GroupMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.userId,
    required this.userEmail,
  });

  @override
  State<GroupMessageBubble> createState() => _GroupMessageBubbleState();
}

class _GroupMessageBubbleState extends State<GroupMessageBubble> {
  String displayName = 'Loading...';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          displayName = userData['username'] ?? 'Unknown';
          imageUrl = userData['image_url'] ?? '';
        });
      } else {
        setState(() {
          displayName = 'User not found';
        });
      }
    } catch (e) {
      setState(() {
        displayName = 'Error loading user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: widget.isMe ? null : 0,
            right: widget.isMe ? 0 : null,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: theme.colorScheme.primary.withAlpha(180),
              backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty
                  ? Text(
                      displayName[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46),
            child: Row(
              mainAxisAlignment:
                  widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: widget.isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: widget.isMe
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : theme.colorScheme.secondary.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          topLeft: widget.isMe
                              ? const Radius.circular(12)
                              : Radius.zero,
                          topRight: !widget.isMe
                              ? const Radius.circular(12)
                              : Radius.zero,
                          bottomLeft: const Radius.circular(12),
                          bottomRight: const Radius.circular(12),
                        ),
                      ),
                      constraints: const BoxConstraints(maxWidth: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: widget.isMe
                              ? Colors.black87
                              : theme.colorScheme.onSecondary,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
