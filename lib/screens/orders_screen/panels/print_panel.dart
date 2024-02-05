import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/pdf/pdf_api.dart';
import 'package:hitop_cafe/common/pdf/pdf_invoice_api.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/side_bar/setting/print-services/print_services.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:provider/provider.dart';

class PrintPanel extends StatefulWidget {
  const PrintPanel({super.key, required this.order,this.reOrder=false});
  final Order order;
  final bool reOrder;

  @override
  State<PrintPanel> createState() => _PrintPanelState();
}

class _PrintPanelState extends State<PrintPanel> {
  String printTemplate = PrintType.p80mm.value;


  ///print pdf function and view pdf function
  Future<void> printPdf(String printType,{bool isView=false}) async {
    try {
      PdfInvoiceApi pdfInvoice=PdfInvoiceApi(context, bill: widget.order);
      Uint8List file = await pdfInvoice.generatePdf80();
      if (printType == PrintType.p80mm.value && context.mounted) {
        file = await pdfInvoice.generatePdf80();
      } else if (printType == PrintType.pA4.value && context.mounted) {
        file = await pdfInvoice.generatePdfA4();
      }
      else if (printType == PrintType.p72mm.value && context.mounted) {
        file = await pdfInvoice.generatePdfA4();
      }
      else if (printType == PrintType.p57mm.value && context.mounted) {
        file = await pdfInvoice.generatePdf57();
      }
      if (isView) {
        File pdfFile =
        await PdfApi.saveUni8File(name: "cache pdf.pdf", uni8file: file);
        await PdfApi.openFile(pdfFile);
      }
      else if(!isView && context.mounted){
        await PrintServices().printPriority(context, unit8File: file);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.errorManger(context, e,
            title: "addOrderScreen-print pdf error", showSnackbar: true);
      }
    }
  }
  ///print pdf function for kitchen orders
  Future<void> printPdfIp2({bool isView=false}) async {
    try {
      PdfInvoiceApi pdfInvoice=PdfInvoiceApi(context, bill: widget.order);
      Uint8List file = await pdfInvoice.generateOrderPdf(reOrder:widget.reOrder );
      if(isView){
        File pdfFile =
        await PdfApi.saveUni8File(name: "cache pdf.pdf", uni8file: file);
        await PdfApi.openFile(pdfFile);
      }
      else if (!isView && context.mounted) {
        await PrintServices().printPriority(context, unit8File: file);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.errorManger(context, e,
            title: "addOrderScreen-print pdf error", showSnackbar: true);
      }
    }
  }




  @override
  void initState() {
    printTemplate=Provider.of<UserProvider>(context,listen: false).printTemplate ?? PrintType.p80mm.value ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
        height: 300,
        title: "نمایش و چاپ",
        topTrail: CustomButton(
          margin: const EdgeInsets.only(left: 10),
          width: 100,
          height: 30,
          text: "تنظیمات",
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, SettingScreen.id);
          },
          radius: 20,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CText(
                      "قالب چاپ :",
                      fontSize: 14,
                    ),
                    Flexible(
                      child: DropListModel(
                          height: 35,
                          listItem: kPrintTemplateList,
                          selectedValue: printTemplate,
                          onChanged: (val) {
                            printTemplate = val;
                            setState(() {});
                          }),
                    ),
                  ],
                ),
                const Gap(10),
                const CText(
                  "چاپ و نمایش نهایی:",
                  fontSize: 15,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ///print button
                    ActionButton(
                      label: "چاپ نهایی",
                      onPress: () async {
                        await printPdf(printTemplate);
                      },
                      bgColor: Colors.indigoAccent,
                      icon: Icons.local_printshop_outlined,
                    ),

                    ///view button action
                    ActionButton(
                      label: "نمایش",
                      onPress: () async {
                        await printPdf(printTemplate,isView: true);
                      },
                      bgColor: Colors.red,
                      icon: Icons.picture_as_pdf_outlined,
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                  color: kMainColor,
                  height: 40,
                ),
                const CText(
                  "چاپ آماده سازی سفارش:",
                  fontSize: 15,
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ///print button
                    ActionButton(
                      label: "چاپ سفارش",
                      onPress: () {
                        printPdfIp2(isView: true);
                      },
                      bgColor: Colors.deepOrange,
                      icon: Icons.local_printshop_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
