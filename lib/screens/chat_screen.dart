import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat_messages.dart';
import 'package:flutter_chat_app/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user, required this.rUserId});
  final Map<String, dynamic> user;
  final rUserId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
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
          user['username'][0].toUpperCase() +
                  user['username'].split(".").first.substring(1) ??
              'Annonymous',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 0.1),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user['image_url'] ?? ''),
              radius: 26,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              rUserId: widget.rUserId,
            ),
          ),
          NewMessage(
            rUserId: widget.rUserId,
          ),
        ],
      ),
    );
  }
}
