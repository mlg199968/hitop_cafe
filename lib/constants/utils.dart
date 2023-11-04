import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/shape/shape02.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart'as intl;
import 'package:path_provider/path_provider.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

enum SnackType{
  normal,
  success,
  warning,
  error,
}
enum ScreenType{
  mobile,
  tablet,
  desktop
}


/// find out Screen size and return it
ScreenType screenType(BuildContext context){
  late ScreenType screenType;
  if(MediaQuery.of(context).size.width<500){
    screenType=ScreenType.mobile;
  }else if(MediaQuery.of(context).size.width>500 && MediaQuery.of(context).size.width<1000){
    screenType=ScreenType.tablet;
  }else{
    screenType=ScreenType.desktop;
  }
  return screenType;
}


///Show snake bar in active context
void showSnackBar(BuildContext context, String title,
    {SnackType type=SnackType.normal,double? height}) {
  Color? color;
  switch(type){
    case SnackType.normal:
      color=Colors.blue;
      break;
  case SnackType.success:
      color=Colors.green;
      break;
     case SnackType.error:
      color=Colors.red;
      break;
      case SnackType.warning:
      color=Colors.orange;
      break;

  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      width: 350,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.transparent,
        content: BlurryContainer(
          padding: const EdgeInsets.all(0),
          height:height ?? 50,
            color: Colors.black.withOpacity(.8),
            borderRadius: BorderRadius.circular(20),
          child: BackgroundShape2(
            color: color ,
            height: height ?? 50,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(title.toPersianDigit(),style: const TextStyle(fontFamily: kCustomFont,color: Colors.white),textDirection: TextDirection.rtl,),
            ),
          ),
        )),
  );
}
// ///Show snake bar in active context
// void showSnackBar(BuildContext context,String title,{String? subTitle,ContentType? type}) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       elevation: 0,
//       behavior: SnackBarBehavior.fixed,
//       dismissDirection: DismissDirection.up,
//       backgroundColor: Colors.transparent,
//       content: AwesomeSnackbarContent(
//        // color: Colors.blue,
//           title: title,
//       message: subTitle ?? "",
//       contentType:type ?? ContentType.warning,
//       ),
//     ),
//   );
// }

///Show snake bar in active context
Divider customDivider({required BuildContext context, Color? color}) {
  double indent = MediaQuery.of(context).size.width / 7;
  return Divider(
    thickness: 1,
    height: 20,
    indent: indent,
    endIndent: indent,
    color: color ?? Colors.black12,
  );
}

///convert string to double
double stringToDouble(String text) {
  String englishText = text.toEnglishDigit();

  return double.parse(englishText.replaceAll(RegExp(r'[^0-9.-]'), ''))
      .toDouble();
}

///add separator for show price number and persian number
String addSeparator(num number) {
  return intl.NumberFormat('###,###,###,###').format(number).toPersianDigit();
}

/// for launch urls
Future<void> urlLauncher({required context, required String urlTarget}) async {
  Uri url = Uri.parse(urlTarget);
  if (!await launchUrl(url,mode: LaunchMode.externalApplication)) {
    showSnackBar(context, "Could not open this url!",
        type: SnackType.error);
  }
}

///choose directory
Future<String?> chooseDirectory() async {
  String? result = await FilePicker.platform.getDirectoryPath();

  if (result != null) {
    //print(File(result).path);
    // File backupFile = File(result);
    return result;
  }
  return null;
}

/// condition for pick image from device storage
Future<File?> pickImage(String imageName) async {
  final ImagePicker imagePicker = ImagePicker();
  final Directory directory = await getApplicationDocumentsDirectory();
  final newDirectory = Directory("${directory.path}/cache/images");
  File? copyFile;
  try {
    XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      //here we create new path for cache images and condition check if directory not exist,create directory

      if (!await newDirectory.exists()) {
        newDirectory.create(recursive: true);
      }

      //print(newDirectory.path);

      copyFile =
          await File(pickedFile.path).copy("${newDirectory.path}/$imageName");
      Directory(pickedFile.path).delete(recursive: true);
      return copyFile;
    }
  } catch (e) {
    debugPrint('image picker error:::::: $e');
  }
  if (await File("${newDirectory.path}/$imageName").exists()) {
    copyFile = File("${newDirectory.path}/$imageName");
  }
  return copyFile;
}

/// condition for pick image from device storage
Future<File?> pickFile(String imageName,{String? root}) async {
  int imageIndex = 0;
  final Directory directory = await getApplicationDocumentsDirectory();

  final newDirectory = Directory("${directory.path}${root ?? "/cache/images"}");
  File? copyFile;
  try {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      File selectedFile=File(pickedFile.files.single.path!);
      //here we create new path for cache images and condition check if directory not exist,create directory
      if (!await newDirectory.exists()) {
        newDirectory.create(recursive: true);
      }
      //when user want to choose another image,app load the old image name,cause of it new image not being applied
      //for fix this we give new name to save then delete the old one
      if (!await File("${newDirectory.path}/0 $imageName").exists()) {
        copyFile = await selectedFile
            .copy("${newDirectory.path}/$imageIndex $imageName");
        imageIndex++;
        copyFile = await selectedFile
            .copy("${newDirectory.path}/$imageIndex $imageName");
      } else {
        imageIndex++;
        while (!await File("${newDirectory.path}/$imageIndex $imageName")
                .exists() &&
            imageIndex < 1000) {
          imageIndex++;
        }
        await File("${newDirectory.path}/$imageIndex $imageName")
            .delete(recursive: true);
        imageIndex++;
        copyFile = await selectedFile
            .copy("${newDirectory.path}/$imageIndex $imageName");
      }
      //delete cache file
      Directory(pickedFile.files.single.path!).delete(recursive: true);
      return copyFile;
    }
  } catch (e) {
    debugPrint('file picker error:::::: $e');
  }
  return copyFile;
}

reSizeImage(String iPath,{int width=600})async{
  await (img.Command()
  // Read a WebP image from a file.
    ..decodeJpgFile(iPath)
  // Resize the image so its width is 120 and height maintains aspect
  // ratio.
    ..copyResize(width: width)
  // Save the image to a PNG file.
    ..writeToFile(iPath))
  // Execute the image commands in an isolate thread
      .executeThread();
}

/// find max date in the date list
DateTime findMaxDate(List<DateTime> dateList) {
  DateTime maxDate = dateList[0];
  for (int i = 1; i < dateList.length; i++) {
    if (maxDate.isBefore(dateList[i])) {
      maxDate = dateList[i];
    }
  }
  return maxDate;
}

DateTime findMinDate(List<DateTime> dateList) {
  DateTime minDate = dateList[0];
  for (int i = 1; i < dateList.length; i++) {
    if (minDate.isAfter(dateList[i])) {
      minDate = dateList[i];
    }
  }
  return minDate;
}


///custom target focus for coach mark tutorial
// TargetFocus customTargetFocus({
//   required String identify,
//   required GlobalKey key,
//   required String text,
//   ContentAlign? contentAlign,
// }) {
//   return TargetFocus(
//       identify: identify,
//       keyTarget: key,
//       shape: ShapeLightFocus.RRect,
//       radius: 50,
//       contents: [
//         TargetContent(
//           align: contentAlign ?? ContentAlign.bottom,
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20)
//                     .copyWith(topRight: const Radius.circular(0)),
//                 border: Border.all(color: Colors.white, width: 1),
//               ),
//               child: Text(
//                 text,
//                 style: const TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             ),
//           ),
//         )
//       ]);
// }
