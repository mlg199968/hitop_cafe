import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';

// ignore: must_be_immutable
class ItemImageHolder extends StatelessWidget {
   ItemImageHolder(
      {super.key,
      required this.onEdited,
      this.imagePath,
      this.onDelete,
      required this.onSet});
  final String? imagePath;
  final VoidCallback onEdited;
  final VoidCallback? onDelete;
  final Function(String? path) onSet;
   bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () async {
            if (imagePath == null) {
              try {
                await storagePermission(context, Allow.storage);
                isLoading=true;
                FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
                if (pickedFile != null) {
                  print("Start resizing");
                // await reSizeImage(pickedFile.files.single.path!);
                 print("after resizing");
                 isLoading=false;
                  onSet(pickedFile.files.single.path!);
                }
              }catch(e){
                if (kDebugMode) {
                  print(e);
                }
              }


            //  File? file = await pickFile(imageName!, root: "/hitop-cafe/items/images");

            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26)),
            width: MediaQuery.of(context).size.width,
            child: imagePath == null
                ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,size: 80,),
                    Text(
                        "افزودن تصویر",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black38),
                      ),
                  ],
                )
                : Image.file(File(imagePath!),fit: BoxFit.fitWidth,),
          ),
        ),
        if (imagePath != null)
          Row(
            children: [
              //delete button
              IconButton(
                onPressed: () {
                  File(imagePath!).delete(recursive: true);
                  onSet(null);
                  onDelete;
                },
                icon: const Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {
                  onEdited;
                },
                icon: const Icon(
                  FontAwesomeIcons.pencil,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

      ],
    );
  }
}
