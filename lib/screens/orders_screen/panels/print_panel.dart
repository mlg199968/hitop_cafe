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
  const PrintPanel({super.key, required this.order, this.onReload});
  final Order order;
  final VoidCallback? onReload;

  @override
  State<PrintPanel> createState() => _PrintPanelState();
}

class _PrintPanelState extends State<PrintPanel> {
  String printTemplate = PrintType.p80mm.value;


  ///export pdf function
  Future<void> printPdf(String printType) async {
    try {
      Uint8List file = await PdfInvoiceApi.generatePdf80(widget.order, context);
      if (printType == PrintType.p80mm.value && context.mounted) {
        file = await PdfInvoiceApi.generatePdf80(widget.order, context);
      } else if (printType == PrintType.pA4.value && context.mounted) {
        file = await PdfInvoiceApi.generatePdfA4(widget.order, context);
      } else if (printType == PrintType.p72mm.value && context.mounted) {
        file = await PdfInvoiceApi.generatePdfA4(widget.order, context);
      }

      if (context.mounted) {
        await PrintServices().printPriority(context, unit8File: file);
      }
    } catch (e) {
      if (context.mounted) {
        ErrorHandler.errorManger(context, e,
            title: "addOrderScreen-print pdf error", showSnackbar: true);
      }
    }
  }

  ///view pdf function
  Future<void> viewPdf(String printType) async {
    Uint8List uni8file =
        await PdfInvoiceApi.generatePdf80(widget.order, context);
    if (printType == PrintType.p80mm.value && context.mounted) {
      uni8file = await PdfInvoiceApi.generatePdf80(widget.order, context);
    } else if (printType == PrintType.pA4.value && context.mounted) {
      uni8file = await PdfInvoiceApi.generatePdfA4(widget.order, context);
    } else if (printType == PrintType.p72mm.value && context.mounted) {
      uni8file = await PdfInvoiceApi.generatePdfA4(widget.order, context);
    }

    File file =
        await PdfApi.saveUni8File(name: "cache pdf.pdf", uni8file: uni8file);
    await PdfApi.openFile(file);
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
                        await viewPdf(printTemplate);
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
                        printPdf(printTemplate);
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
