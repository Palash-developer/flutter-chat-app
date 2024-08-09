import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/new_group_message.dart';

class GroupChatMsgScreen extends StatefulWidget {
  const GroupChatMsgScreen({super.key, required this.groupName});

  final groupName;

  @override
  State<GroupChatMsgScreen> createState() => _GroupChatMsgScreenState();
}

class _GroupChatMsgScreenState extends State<GroupChatMsgScreen> {
  @override
  Widget build(BuildContext context) {
    final group = widget.groupName;
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
          group['groupName'],
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
                  group['groupName'][0].toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const Column(
        children: [
          NewGroupMessage(),
        ],
      ),
    );
  }
}
