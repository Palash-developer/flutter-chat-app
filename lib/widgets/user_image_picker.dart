import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/services/img_service.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.imagePickFn});

  final void Function(File pickedImgFile) imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImgFile;
  void pickImage() async {
    final pickedImg = await ImgService.pickImage();
    if (pickedImg == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image selected")),
      );
      return;
    }
    setState(() {
      pickedImgFile = File(pickedImg.path);
    });
    widget.imagePickFn(pickedImgFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.withOpacity(0.1),
          foregroundImage:
              pickedImgFile != null ? FileImage(pickedImgFile!) : null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          label: Text(
            "Upload Image",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: Icon(
            CupertinoIcons.cloud_upload,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
