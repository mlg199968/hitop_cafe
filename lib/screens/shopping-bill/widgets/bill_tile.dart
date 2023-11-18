import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/shape/custom_bg_shape.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/providers/setting_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/order_tile.dart';
import 'package:hitop_cafe/screens/shopping-bill/services/bill_tools.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';


class BillTile extends StatelessWidget {
  const BillTile({
    super.key,
    required this.billData,
    this.height = 70,
    required this.color,
    this.enabled = true,
    required this.onSee,
    this.controller,
  });
  final Bill billData;
  final VoidCallback onSee;
  final double height;
  final Color color;
  final bool enabled;
  final ExpandableController? controller;

  @override
  Widget build(BuildContext context) {

    final String payable = addSeparator(billData.payable);
    if (billData.dueDate != null) {
    }
    //final num? billNumber=billData.billNumber;
    return Consumer<SettingProvider>(
      builder: (context,settingProvider,child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Card(
            child: BackgroundClipper(
              height: height,
              child: ExpandablePanel(
                key: key,
                controller: controller,
                collapsed: const SizedBox(),
                expanded: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ///see details button
                    DropButtons(
                        text: "مشاهده",
                        icon: Icons.list_alt,
                        onPress: onSee,
                        color: Colors.indigo),

                    ///export pdf  button
                    // DropButtons(
                    //     text: "پی دی اف",
                    //     icon: FontAwesomeIcons.filePdf,
                    //     onPress: () async {
                    //       // final file =
                    //       //     await PdfInvoiceApi.generate(billData, context);
                    //       // PdfApi.openFile(file);
                    //     },
                    //     color: Colors.teal),

                    ///delete button
                    DropButtons(
                        text: "حذف",
                        icon: CupertinoIcons.trash,
                        onPress: () async {
                          await showDialog(context: context, builder: (context)=> CustomAlert(
                              title: "آیا از حذف فاکتور مطمئن هستید؟ ",
                              onYes: () {
                                if(settingProvider.doStorageChange){
                                  BillTools.subtractFromWareHouse(billData.purchases);
                                }
                                billData.delete();
                                showSnackBar(context, "فاکتور حذف شد!",
                                    type: SnackType.success);
                                Navigator.pop(context);
                              },
                              onNo: () {
                                Navigator.pop(context);
                              },
                              extraContent: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("اعمال تغییرات در انبار"),
                                  Checkbox(
                                      value: context.watch<SettingProvider>().doStorageChange,
                                      onChanged: (val) {
                                        settingProvider.storageChangeBool(val!);
                                      }),
                                ],
                              )
                          ));
                        },
                        color: Colors.red,

                    ),
                  ],
                ),
                theme: ExpandableThemeData(
                    iconPadding: const EdgeInsets.all(0),
                    iconPlacement: ExpandablePanelIconPlacement.left,
                    tapBodyToExpand: enabled,
                    tapHeaderToExpand: enabled,
                    animationDuration: const Duration(milliseconds: 500)),

                ///main header
                header: Align(
                  child: MyListTile(
                    enable: false,
                    title: "فاکتور شماره ${billData.billNumber.toString().toPersianDigit()}",
                    leadingIcon: FontAwesomeIcons.fileInvoiceDollar,
                    type: billData.billNumber.toString().toPersianDigit(),
                    subTitle: billData.description,
                    topTrailingLabel: "تاریخ ایجاد: ",
                    topTrailing: billData.billDate.toPersianDateStr(),
                    trailing: payable,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
