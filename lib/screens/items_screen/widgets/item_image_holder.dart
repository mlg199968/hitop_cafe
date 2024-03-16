import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';


class ItemImageHolder extends StatefulWidget {
  const ItemImageHolder({super.key, this.imagePath, required this.onSet});
  final String? imagePath;
  final Function(String? path) onSet;

  @override
  State<ItemImageHolder> createState() => _ItemImageHolderState();
}

class _ItemImageHolderState extends State<ItemImageHolder> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ///condition for,if is image processing show circle indicator
    if (isLoading) {
      ///circle indicator part
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: kMainColor,
            semanticsLabel: "در حال پردازش تصویر",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "در حال پردازش تصویر",
            style: TextStyle(color: Colors.black38),
          ),
        ],
      );

      ///main Show image part
    } else {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          InkWell(
            onTap: () async {
              if (widget.imagePath == null || widget.imagePath == "") {
                try {
                  await storagePermission(context, Allow.storage);
                  if (context.mounted) {
                    await storagePermission(context, Allow.externalStorage);
                  }
                  isLoading = true;
                  setState(() {});
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String path = pickedFile.files.single.path!;
                    String fileName = pickedFile.files.single.name;
                    if (Platform.isWindows) {
                      path = path.replaceAll(fileName, "resized-$fileName");
                      await File(pickedFile.files.single.path!).copy(path);
                    }
                    debugPrint("Start resizing");
                    await reSizeImage(path);
                    debugPrint("after resizing");
                    isLoading = false;
                    widget.onSet(path);
                  } else {
                    isLoading = false;
                    setState(() {});
                  }
                } catch (e) {
                  if (context.mounted) {
                    ErrorHandler.errorManger(context, e,
                        title: "ItemImageHolder widget error");
                  }
                }
              }
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black26),
                  ),
                child: ClipRRect(
                  borderRadius:BorderRadius.circular(20) ,
                  child: AspectRatio(
                    aspectRatio: 16/9,
                    child: (widget.imagePath == null || widget.imagePath == "")

                          ? const EmptyHolder(text: "افزودن تصویر", icon: Icons.add_photo_alternate_outlined,iconSize:70,fontSize: 13,)
                          : Image(
                        image: FileImage(File(widget.imagePath!)),
                        fit: BoxFit.cover,
                        errorBuilder: (context,error,trace){
                          ErrorHandler.errorManger(context, error,route: trace.toString(),title: "itemImageHolder widget imageDecoration error");
                          return const EmptyHolder(text: "بارگزاری تصویر با مشکل مواجه شده است", icon: Icons.image_not_supported_outlined);
                        },
                      ),
                  ),
                ),
              ),
            ),
          ),
          ///tools buttons
          if (widget.imagePath != null && widget.imagePath != "")
            Row(
              children: [
                //delete button
                IconButton(
                  onPressed: () {
                    File(widget.imagePath!).delete(recursive: true);
                    widget.onSet(null);
                  },
                  icon: const Icon(
                    CupertinoIcons.trash,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(
                //     FontAwesomeIcons.pencil,
                //     color: Colors.teal,
                //     size: 20,
                //   ),
                // ),
              ],
            ),
        ],
      );
    }
  }
}
