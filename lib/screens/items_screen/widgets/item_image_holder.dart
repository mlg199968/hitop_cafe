import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';


// ignore: must_be_immutable
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
              if (widget.imagePath == null) {
                try {
                    await storagePermission(context, Allow.storage);
                  if(context.mounted) {
                    await storagePermission(context, Allow.externalStorage);
                  }
                  isLoading = true;
                  setState(() {});
                  FilePickerResult? pickedFile =
                      await FilePicker.platform.pickFiles();
                  if (pickedFile != null) {
                    String path=pickedFile.files.single.path!;
                    String fileName=pickedFile.files.single.name;
                    if(Platform.isWindows) {
                         path=path.replaceAll(
                              fileName, "resized-$fileName");
                      await File(pickedFile.files.single.path!).copy(path);
                    }
                    debugPrint("Start resizing");
                    await reSizeImage(path);
                    debugPrint("after resizing");
                    isLoading = false;
                    widget.onSet(path);
                  }else{
                    isLoading=false;
                    setState(() {});
                  }
                } catch (e) {
                  if(context.mounted) {
                    ErrorHandler.errorManger(context, e,title: "ItemImageHolder widget error");
                  }
                }
              }
            },
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26),
                  image:widget.imagePath == null?null: DecorationImage(image: FileImage(File(widget.imagePath!)),fit: BoxFit.cover,)
                ),
                height:MediaQuery.of(context).size.width*(9/16) ,
                width: MediaQuery.of(context).size.width,
                child: widget.imagePath == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 80,
                          ),
                          Text(
                            "افزودن تصویر",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black38),
                          ),
                        ],
                      )
                    : null),
          ),
          if (widget.imagePath != null)
            Row(
              children: [
                //delete button
                IconButton(
                  onPressed: () {
                    File(widget.imagePath!).delete(recursive: true);
                    widget.onSet(null);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  onPressed: () {},
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
}
