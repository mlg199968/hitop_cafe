import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:hitop_cafe/common/pdf/pdf_api.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:provider/provider.dart';

class PdfWareListApi {
  //static ShopHive shopData = HiveBoxes.getShopInfo().get(0)!;
  //static String currency=shopData.currency;
  static Future<File> generate(List<RawWare> wareList,mat.BuildContext context) async {
    UserProvider shopData=Provider.of<UserProvider>(context,listen: false);
    var myTheme = ThemeData.withFont(
        base: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        bold: Font.ttf(await rootBundle.load("assets/fonts/arialbd.ttf")),
        italic: Font.ttf(await rootBundle.load("assets/fonts/ariali.ttf")),
        boldItalic: Font.ttf(await rootBundle.load("assets/fonts/arialbi.ttf")),
        icons: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
        fontFallback: [
          Font.ttf(await rootBundle.load("assets/fonts/tahoma.ttf")),
          Font.ttf(await rootBundle.load("assets/fonts/tahomabd.ttf")),
        ]);
    final pdf = Document(theme: myTheme);
   // final totalPart = await buildTotal(bill,shopData);
    final invoicePart=await buildList2(wareList,shopData);
   // final titlePart=await buildTitle(bill,shopData);
    pdf.addPage(MultiPage(
      build: (context) => [
        // Directionality(
        //     textDirection: TextDirection.rtl, child:titlePart ),
        // Directionality(
        //     textDirection: TextDirection.rtl, child: buildHeader(bill)),
        // SizedBox(height: 1 * PdfPageFormat.cm),
        invoicePart,
        // Divider(),
        // Directionality(textDirection: TextDirection.rtl, child: totalPart),
      ],
      // footer: (context) => Directionality(
      //     textDirection: TextDirection.rtl, child: buildFooter(shopData)),
    ));

    return PdfApi.saveDocument(
        name: "Ware List.pdf",
        pdf: pdf);
  }









  static Future<Widget> buildList(List<RawWare> list,UserProvider shopData) async{
    String currency=shopData.currency;
    final headers = ['#','نام محصول', 'موجودی','قیمت فروش ($currency)','قیمت خرید ($currency)']
        .reversed
        .toList();
    final data = list.map((item) {
      return [
        "${list.indexOf(item) + 1}".toPersianDigit(),
        item.wareName,
        '${item.quantity}'.toPersianDigit(),
        addSeparator(item.cost),
      ].reversed.toList();
    }).toList();

    return Directionality(
        textDirection: TextDirection.rtl,
        child:
          pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
              border: null,
              headerStyle: const TextStyle(
                fontSize: 15,
              ),
              headerDecoration: const BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellHeight: 30,
              cellStyle:TextStyle(fontWeight: FontWeight.bold),
              cellAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.centerLeft,
                2: Alignment.centerRight,
                3: Alignment.centerRight,
                4: Alignment.centerRight,
              },
              oddCellStyle:const TextStyle(),
            ),
        );
  }
  static Future<Widget> buildList2(List<RawWare> list,UserProvider shopData) async{
    String currency=shopData.currency;
    final headers = ['#','نام محصول','قیمت فروش ($currency)']
        .reversed
        .toList();
    final data = list.map((item) {
      return [
        "${list.indexOf(item) + 1}".toPersianDigit(),
        item.wareName.toPersianDigit(),
        //'${item.quantity}'.toPersianDigit(),
       // addSeparator(item.cost),
        addSeparator(item.cost),
      ].reversed.toList();
    }).toList();

    return Directionality(
        textDirection: TextDirection.rtl,
        child:
            pw.TableHelper.fromTextArray(
              headers: headers,
              data: data,
              //border: null,
              headerStyle: const TextStyle(
                fontSize: 12,
              ),
              headerDecoration: const BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellHeight: 30,
              cellStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
              columnWidths: {
                2:const FixedColumnWidth(20)
              },
              headerAlignment:Alignment.center,
              cellAlignments: {
                0: Alignment.centerLeft,
                1: Alignment.centerRight,
                // 2: Alignment.centerRight,
                // 3: Alignment.centerRight,
                2: Alignment.centerRight,
              },
              oddCellStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
            ),
          );
  }

  static Widget buildFooter(UserProvider shop) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'آدرس:', value: shop.address),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'شماره تماس:',
              value: "${shop.phoneNumber} - ${shop.phoneNumber2}"),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    const style = TextStyle(
      fontSize: 12,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(value),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(title, style: style),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    MainAxisAlignment axisAlignment= MainAxisAlignment.spaceBetween,
    bool unite = false,
  }) {
    final style = titleStyle ?? const TextStyle(color: PdfColors.black);

    return SizedBox(
      width: width,
      child:Expanded(child: Row(
        mainAxisAlignment: axisAlignment,
        children: [
          Text(value.toPersianDigit(), style: unite ? style : valueStyle,maxLines: 3),
          SizedBox(width: 5),
          Text(title.toPersianDigit(), style: style,maxLines: 3)
        ],
      ),)
    );
  }
}
