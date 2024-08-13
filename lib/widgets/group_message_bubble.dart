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
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//       child: Row(
//         mainAxisAlignment:
//             isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         children: [
//           if (!isMe) ...[
//             CircleAvatar(
//               radius: 23,
//               child: Text(
//                 userEmail[0]
//                     .toUpperCase(), // Display the first letter of the userId
//                 style:
//                     const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Flexible(
//             child: Container(
//               margin: const EdgeInsets.only(bottom: 6),
//               decoration: BoxDecoration(
//                 color: isMe
//                     ? Colors.grey[300]
//                     : Theme.of(context).colorScheme.secondary.withOpacity(0.7),
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(12),
//                   topRight: const Radius.circular(12),
//                   bottomLeft: isMe
//                       ? const Radius.circular(12)
//                       : const Radius.circular(0),
//                   bottomRight: isMe
//                       ? const Radius.circular(0)
//                       : const Radius.circular(12),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: isMe
//                       ? Colors.black
//                       : Theme.of(context).textTheme.bodyMedium!.color,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:flutter/material.dart';

class GroupMessageBubble extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          !isMe
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: theme.colorScheme.primary.withAlpha(180),
                    child: Text(
                      userEmail[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 23,
                    backgroundColor: theme.colorScheme.primary.withAlpha(180),
                    child: Text(
                      userEmail[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 13, right: 13),
                      child: Text(
                        userEmail[0].toUpperCase() + userEmail.substring(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: isMe
                            ? theme.colorScheme.primary.withOpacity(0.2)
                            : theme.colorScheme.secondary.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          topLeft:
                              isMe ? const Radius.circular(12) : Radius.zero,
                          topRight:
                              !isMe ? const Radius.circular(12) : Radius.zero,
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
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: isMe
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
