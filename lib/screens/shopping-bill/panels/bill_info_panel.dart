import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:hitop_cafe/screens/shopping-bill/add-shopping-bill-screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';




// ignore: must_be_immutable
class BillInfoPanel extends StatelessWidget {
  BillInfoPanel(this.infoData, {super.key});
  Bill infoData;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      context: context,
      height: MediaQuery.of(context).size.height * .6,
      title: "مشخصات مشتری",
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[


                  InfoPanelRow(
                      title: "توضیحات:", infoList: infoData.description),
                  InfoPanelRow(
                      title: "تاریخ ایجاد:",
                      infoList: infoData.billDate.toPersianDateStr()),
                   InfoPanelRow(
                      title: "تاریخ تغییر:",
                      infoList: infoData.modifiedDate.toPersianDateStr()),
                  InfoPanelRow(
                      title: "باقی مانده:", infoList:addSeparator(infoData.payable)),
                   InfoPanelRow(
                      title: "جمع پرداخت با کارت:", infoList:addSeparator(infoData.atmSum)),
                   InfoPanelRow(
                      title: "جمع نقد:", infoList:addSeparator(infoData.cashSum)),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ActionButton(
                  label: "حذف",
                  bgColor: Colors.red,
                  onPress: () async {
                    //delete();
                    infoData.delete();
                    Navigator.pop(context);
                  },
                  icon: Icons.delete,
                ),
                ActionButton(
                  label: "ویرایش",
                  icon: Icons.drive_file_rename_outline_sharp,
                  onPress: () {
                    Navigator.pushNamed(context,AddShoppingBillScreen.id,
                        arguments: infoData);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





class BillInfoPanelDesktop extends StatelessWidget {
  const BillInfoPanelDesktop({required this.infoData, super.key, required this.onDelete});
  final Bill infoData;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 30,horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: ScrollController(),
                children: <Widget>[

                  InfoPanelRow(
                      title: "توضیحات:", infoList: infoData.description),
                  InfoPanelRow(
                      title: "تاریخ ایجاد:",
                      infoList: infoData.billDate.toPersianDateStr()),
                  InfoPanelRow(
                      title: "تاریخ تغییر:",
                      infoList: infoData.modifiedDate.toPersianDateStr()),
                  const SizedBox(height: 50,),
                  InfoPanelRow(
                      title: "باقی مانده:", infoList:addSeparator(infoData.payable)),
                  InfoPanelRow(
                      title: "جمع چک ها:", infoList:addSeparator(infoData.atmSum)),
                  InfoPanelRow(
                      title: "جمع نقد:", infoList:addSeparator(infoData.cashSum)),
                  InfoPanelRow(
                      title: "تاریخ تسویه:", infoList:infoData.dueDate==null?"نامشخص":infoData.dueDate!.toPersianDate()),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ActionButton(
                  label: "حذف",
                  bgColor: Colors.red,
                  onPress: () async {
                    //delete();
                    infoData.delete();
                    onDelete();
                  },
                  icon: Icons.delete,
                ),
                ActionButton(
                  label: "ویرایش",
                  icon: Icons.drive_file_rename_outline_sharp,
                  onPress: () {
                    Navigator.pushNamed(context, AddShoppingBillScreen.id,
                        arguments: infoData);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
