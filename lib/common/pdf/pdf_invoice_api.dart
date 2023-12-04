import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:hitop_cafe/common/pdf/pdf_api.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class PdfInvoiceApi {
static  _customTheme()async{
  return ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/koodak.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/titr.ttf")),
      italic: Font.ttf(await rootBundle.load("assets/fonts/ariali.ttf")),
      boldItalic: Font.ttf(await rootBundle.load("assets/fonts/arialbi.ttf")),
      icons: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
      fontFallback: [
        Font.ttf(await rootBundle.load("assets/fonts/tahoma.ttf")),
        Font.ttf(await rootBundle.load("assets/fonts/tahomabd.ttf")),
      ]);
}



  //for printing should data be unit8list
  //so change pdf format to this format from file to unit8list
  ///paper size A4
  static Future<Uint8List> generatePdfA4(
      Order bill, mat.BuildContext context) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme:await _customTheme());


    final totalPart = await buildTotal(bill, shopData);
    final invoicePart = await buildInvoice(bill, shopData);
    final titlePart = await buildTitle(bill, shopData);
    pdf.addPage(MultiPage(
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        titlePart,
        buildHeader(bill),
        SizedBox(height: 1 * PdfPageFormat.cm),
        invoicePart,
        Divider(),
        totalPart,
      ],
      footer: (context) => buildFooter(shopData),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }
///paper size 80mm
  static Future<Uint8List> generatePdf80(
      Order bill, mat.BuildContext context) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme:await _customTheme());


    final totalPart = await buildTotal80(bill, shopData);
    final invoicePart = await buildInvoice80(bill, shopData);
    final titlePart = await buildTitle80(bill, shopData);
    pdf.addPage(Page(
      textDirection: TextDirection.rtl,
      pageFormat:PdfPageFormat.roll80.copyWith(marginLeft: 5,marginRight: 5),
      build: (context) =>pw.Column (children:[
        titlePart,
        buildHeader(bill),
        SizedBox(height: 1 * PdfPageFormat.cm),
        invoicePart,
        Divider(),
        totalPart,
        Directionality(textDirection: TextDirection.rtl, child: buildFooter(shopData))
      ]),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }









  ///********* widgets part *************
  static Widget buildHeader(Order bill) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
              buildInvoiceInfo(bill),
        ],
      );


  static Widget buildInvoiceInfo(Order bill) {
    //final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'شماره فاکتور:',
      'تاریخ فاکتور:',
      'تاریخ تسویه:',
    ];
    final data = <String>[
      bill.billNumber.toString().toPersianDigit(),
      bill.orderDate.toPersianDateStr(),
      bill.dueDate == null
          ? "مشخص نشده"
          : bill.dueDate!.toPersianDate(), //paymentTerms
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width:50 * PdfPageFormat.mm);
      }),
    );
  }

  static Future<Widget> buildTitle(Order bill, UserProvider shopData) async {
    File? logoImageFile = shopData.logoImage != null
        ? (await File(shopData.logoImage!).exists()
            ? File(shopData.logoImage!)
            : null)
        : null;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        height: 50,
        width: 50,
        child: BarcodeWidget(
          barcode: Barcode.qrCode(),
          data:
              " شماره فاکتور: ${bill.billNumber}, قابل پرداخت: ${addSeparator(bill.payable)},",
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'فاکتور فروش',
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.shopName),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      ),
      Container(
          height: 50,
          width: 50,
          child: logoImageFile == null
              ? SizedBox()
              : Image(pw.MemoryImage(logoImageFile.readAsBytesSync()),
                  fit: BoxFit.fill)),
    ]);
  }
  static Future<Widget> buildTitle80(Order bill, UserProvider shopData) async {
    File? logoImageFile = shopData.logoImage != null
        ? (await File(shopData.logoImage!).exists()
            ? File(shopData.logoImage!)
            : null)
        : null;

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          ///barcode
      Container(
        height: 50,
        width: 50,
        child: BarcodeWidget(
          barcode: Barcode.qrCode(),
          data:
              " شماره فاکتور: ${bill.billNumber}, قابل پرداخت: ${addSeparator(bill.payable)},",
        ),
      ),
      ///shop logo
      Container(
          height: 50,
          width: 50,
          child: logoImageFile == null
              ? SizedBox()
              : Image(pw.MemoryImage(logoImageFile.readAsBytesSync()),
                  fit: BoxFit.fill)),
    ]),
      ///shop name
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.shopName,style: const TextStyle(fontSize: 20)),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      ),
    ]);
  }

  static Future<Widget> buildInvoice(Order bill, UserProvider shopData) async {
    String currency = shopData.currency;
    final headers = [
      '#',
      'نام محصول',
      'تعداد',
      'قیمت واحد ($currency)',
      'جمع ($currency)'
    ].reversed.toList();
    final data = bill.items.map((item) {
      return [
        "${bill.items.indexOf(item) + 1}".toPersianDigit(),
        item.itemName,
        '${item.quantity}'.toPersianDigit(),
        addSeparator(item.sale),
        addSeparator(item.sum),
      ].reversed.toList();
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: const TextStyle(
        fontSize: 12,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey300,
      ),
      cellHeight: 30,
      cellStyle: const TextStyle(),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
      oddCellStyle: const TextStyle(),
    );
  }

  static Future<Widget> buildInvoice80(Order bill, UserProvider shopData) async {
    String currency = shopData.currency;
    final headers = [
      '#',
      'نام محصول',
      'تعداد',
      'جمع ($currency)'
    ].reversed.toList();
    final data = bill.items.map((item) {
      return [
        "${bill.items.indexOf(item) + 1}".toPersianDigit(),
        item.itemName,
        '${item.quantity}'.toPersianDigit(),
        addSeparator(item.sum),
      ].reversed.toList();
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: const TextStyle(
        color: PdfColors.white,
        fontSize: 12,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.black,
      ),
      cellHeight: 25,
      cellStyle: const TextStyle(),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
      oddCellStyle: const TextStyle(),
    );
  }

  static Future<Widget> buildTotal(Order bill, UserProvider shopData) async {
    String currency = shopData.currency;
    File? signatureImageFile = shopData.signatureImage != null
        ? (await File(shopData.signatureImage!).exists()
            ? File(shopData.signatureImage!)
            : null)
        : null;
    File? stampImageFile = shopData.stampImage != null
        ? (await File(shopData.stampImage!).exists()
            ? File(shopData.stampImage!)
            : null)
        : null;

    final payments = bill.cashSum + bill.atmSum;
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  height: 100,
                  width: 100,
                  child: stampImageFile == null
                      ? SizedBox()
                      : Image(pw.MemoryImage(stampImageFile.readAsBytesSync()),
                          fit: BoxFit.fill)),
              Container(
                  height: 100,
                  width: 100,
                  child: signatureImageFile == null
                      ? SizedBox()
                      : Image(
                          pw.MemoryImage(signatureImageFile.readAsBytesSync()),
                          fit: BoxFit.fill)),
            ]),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'جمع خرید',
                  value: "${addSeparator(bill.itemsSum)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'پرداخت شده',
                  value: "${addSeparator(payments)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'تخفیف',
                  value: "${addSeparator(bill.discount)} $currency",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'قابل پرداخت',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "${addSeparator(bill.payable)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'به حروف',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "",
                  unite: true,
                ),
                Text("  ${addSeparator(bill.payable).toWord()} $currency "),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }
  static Future<Widget> buildTotal80(Order bill, UserProvider shopData) async {
    String currency = shopData.currency;
    final payments = bill.cashSum + bill.atmSum;
    return Container(
      alignment: Alignment.centerRight,
      child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'جمع خرید',
                  value: "${addSeparator(bill.itemsSum)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'پرداخت شده',
                  value: "${addSeparator(payments)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'تخفیف',
                  value: "${addSeparator(bill.discount)} $currency",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'قابل پرداخت',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "${addSeparator(bill.payable)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'به حروف',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "",
                  unite: true,
                ),
                Text("  ${addSeparator(bill.payable).toWord()} $currency "),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
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
      ].reversed.toList(),
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
    MainAxisAlignment axisAlignment = MainAxisAlignment.spaceBetween,
    bool unite = false,
  }) {
    final style = titleStyle ?? const TextStyle(color: PdfColors.black);

    return SizedBox(
        width: width,
        child: Expanded(
          child: Row(
            mainAxisAlignment: axisAlignment,
            children: [
              Text(title.toPersianDigit(), style: style, maxLines: 3),
              SizedBox(width: 5),
              Text(value.toPersianDigit(),
                  style: unite ? style : valueStyle, maxLines: 3),
            ],
          ),
        ));
  }
}
