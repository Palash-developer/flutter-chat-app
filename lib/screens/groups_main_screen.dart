import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/groups_screen.dart';

class GroupsMainScreen extends StatefulWidget {
  const GroupsMainScreen({super.key});

  @override
  State<GroupsMainScreen> createState() => _GroupsMainScreenState();
}

class _GroupsMainScreenState extends State<GroupsMainScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController groupNameController;

  @override
  void initState() {
    super.initState();
    groupNameController = TextEditingController();
  }

  @override
  void dispose() {
    groupNameController.dispose();
    super.dispose();
  }

  void nextButton() {
    if (_formKey.currentState?.validate() ?? false) {
      log("Group Name: ${groupNameController.text}");
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (ctx) => GroupScreen(
            groupName: groupNameController.text,
          ),
        ),
      );
    }
  }

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
          'Create a new group',
          style: TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Card(
            shadowColor: Theme.of(context).colorScheme.shadow,
            color: Theme.of(context).colorScheme.surface,
            elevation: 14,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            margin: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: groupNameController,
                          decoration: const InputDecoration(
                            labelText: "Type a group name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a group name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.6),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                          onPressed: nextButton,
                          child: Icon(
                            CupertinoIcons.arrow_right,
                            size: 30,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
