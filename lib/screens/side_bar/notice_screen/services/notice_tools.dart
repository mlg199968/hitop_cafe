

import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/notice.dart';
import 'package:hitop_cafe/services/backend_services.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

class NoticeTools {
  ///read new notice has been added
  static readNotifications(context,{int timeout=10}) async {
    try {
      List<Notice?>? onlineNotices =
      await BackendServices().readNotice(context,timeout: timeout );
      List<Notice> hiveNotices = HiveBoxes.getNotice().values.toList();
      if (onlineNotices != null && onlineNotices.isNotEmpty) {
        ///check if server Notice has not being cache in the hive ,then we added to the hive
        for (var onNotice in onlineNotices) {
          if (hiveNotices.isNotEmpty) {
            bool exist = false;
            for (var hiveNotice in hiveNotices) {
              if(hiveNotice.noticeId == onNotice!.noticeId){
                exist=true;
              }
            }
            if (!exist) {
              HiveBoxes.getNotice().put(onNotice!.noticeId, onNotice);
            }
          }
          else {
            HiveBoxes.getNotice().put(onNotice!.noticeId, onNotice);
          }
        }

        ///delete notice form hive if notice was deleted from server
        for (var hvNotice in hiveNotices) {
          bool isExist = false;
          for (var onNotice in onlineNotices) {
            if (hvNotice.noticeId == onNotice!.noticeId) {
              isExist = true;
            }
          }
          if (!isExist) {
            hvNotice.delete();
          }
        }
      }
      else if (onlineNotices == null || onlineNotices.isEmpty){
        HiveBoxes.getNotice().clear();
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "NoticeTools-readNotifications error", showSnackbar: true);
    }
  }
///
  static bool checkNewNotifications(){
    List<bool> seeList=HiveBoxes.getNotice().values.map((e) => e.seen).toList();
    if(seeList.contains(false)){
      return true;
    }else{
      return false;
    }
  }
}
