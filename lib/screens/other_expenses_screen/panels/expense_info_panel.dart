
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_dialog.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/other_expenses_screen/panels/add_expense_panel.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/info_panel_row.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


class ExpenseInfoPanel extends StatelessWidget {
  const ExpenseInfoPanel(this.infoData, {super.key});
  final Payment infoData;
  ///map info
  Map<String, String?> get infoMap => {
    "مبلغ:": addSeparator(infoData.amount),
    "عنوان:":(infoData.description ?? "").toPersianDigit(),
    "تاریخ ثبت:": infoData.deliveryDate.toPersianDate(showTime: true),
  };
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "توضیحات هزینه",
      actions: [Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:<Widget>[
          CustomButton(
              width: 100,
              height: 30,
              text: "حذف",
              color: Colors.red,
              onPressed: () async {
                showDialog(context: context, builder: (context)=>CustomAlert(
                    title: "آیا از حذف این هزینه مطمئن هستید؟",
                  onYes: (){
                    infoData.delete();
                    Navigator.pop(context,false);
                    Navigator.pop(context,false);
                  },
                  onNo: (){
                    Navigator.pop(context,false);
                  },
                ),);
              },
              icon: const Icon(CupertinoIcons.trash_fill,
                size: 20,
                color: Colors.white70,)
          ),
          CustomButton(
            width: 100,
            height: 30,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            text: "ویرایش",
            icon: const Icon(Icons.drive_file_rename_outline_sharp,size: 20,
              color: Colors.orangeAccent,),

            onPressed: () {
              showDialog(context: context, builder: (context)=>AddExpensePanel(oldExpense: infoData,));
            },
          ),
        ],
      ),],
      child:  SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                infoMap.length,
                    (index) => InfoPanelRow(
                    title: infoMap.keys.elementAt(index),
                    infoList: infoMap.values.elementAt(index)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseInfoPanelDesktop extends StatelessWidget {
  const ExpenseInfoPanelDesktop(
      {required this.infoData, super.key, required this.onDelete});
  final Payment infoData;
  final VoidCallback onDelete;
  Map<String, String?> get infoMap => ExpenseInfoPanel(infoData).infoMap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            ///info list
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: List.generate(
                    infoMap.length,
                        (index) => InfoPanelRow(
                        title: infoMap.keys.elementAt(index),
                        infoList: infoMap.values.elementAt(index)),
                  ),
                ),
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
                    Navigator.pushNamed(context, AddOrderScreen.id,
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
