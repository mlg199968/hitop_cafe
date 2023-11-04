import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';


class ImagePickerHolder extends StatelessWidget {
  const ImagePickerHolder(
      {super.key, this.text, required this.onPress, this.imageFile,this.onDelete});
  final String? text;
  final File? imageFile;
  final VoidCallback onPress;
  final VoidCallback? onDelete;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () async {
            await storagePermission(context,Allow.storage);
            onPress();
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white54,
                border: Border.all(color: Colors.black26)),
            width: MediaQuery.of(context).size.width / 4,
            child: imageFile == null
                ? Text(
              text ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black38),
            )
                : Image.file(imageFile!),
          ),
        ),
        if(imageFile != null)
          InkWell(
            onTap:onDelete,
            child: const Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
      ],
    );
  }
}