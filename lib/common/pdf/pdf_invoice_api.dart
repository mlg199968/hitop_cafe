import 'dart:io';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/services.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class PdfInvoiceApi {
  PdfInvoiceApi(this.context,{required this.bill});
  final Order bill;
  final mat.BuildContext context;

  static _customTheme() async {
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
  Future<Uint8List> generatePdfA4() async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme: await _customTheme());

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
  Future<Uint8List> generatePdf80({double scale=1}) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme: await _customTheme());

    final totalPart = await buildTotal80(bill, shopData,scale: scale);
    final invoicePart = await buildInvoice80(bill, shopData,scale: scale);
    final titlePart = await buildTitle80(bill, shopData,scale: scale);
    pdf.addPage(Page(
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.roll80.copyWith(marginLeft: 5, marginRight: 5),
      build: (context) => pw.Column(children: [
        titlePart,
        buildHeader(bill),
        SizedBox(height: 1 * PdfPageFormat.cm),
        invoicePart,
        Divider(),
        totalPart,
        Directionality(
            textDirection: TextDirection.rtl, child: buildFooter(shopData))
      ]),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }

  ///paper size 72mm
  Future<Uint8List> generatePdf72({double scale=.85}) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme: await _customTheme());

    final totalPart = await buildTotal80(bill, shopData,scale: scale);
    final invoicePart = await buildInvoice80(bill, shopData,scale: scale);
    final titlePart = await buildTitle80(bill, shopData,scale: scale);
    pdf.addPage(Page(
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.roll57.copyWith(
          width: 72 * PdfPageFormat.mm, marginLeft: 5, marginRight: 5),
      build: (context) => pw.Column(children: [
        titlePart,
        buildHeader(bill,scale: scale),
        SizedBox(height: 1 * PdfPageFormat.mm),
        invoicePart,
        Divider(),
        totalPart,
        Directionality(
            textDirection: TextDirection.rtl, child: buildFooter(shopData,scale: scale))
      ]),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }

  ///paper size 57mm
  Future<Uint8List> generatePdf57({double scale=.7}) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme: await _customTheme());

    final totalPart = await buildTotal80(bill, shopData,scale: scale);
    final invoicePart = await buildInvoice80(bill, shopData,scale: scale);
    final titlePart = await buildTitle80(bill, shopData,scale: scale);
    pdf.addPage(Page(
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.roll57.copyWith(marginLeft: 5, marginRight: 5),
      build: (context) => pw.Column(children: [
        titlePart,
        buildHeader(bill,scale: scale),
        SizedBox(height: 1 * PdfPageFormat.mm),
        invoicePart,
        Divider(),
        totalPart,
        Directionality(
            textDirection: TextDirection.rtl, child: buildFooter(shopData,scale: scale))
      ]),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }


  ///order list for kitchen
  Future<Uint8List> generateOrderPdf({double scale=.9,bool reOrder=false}) async {
    UserProvider shopData = Provider.of<UserProvider>(context, listen: false);

    final pdf = Document(theme: await _customTheme());

    final invoicePart = await buildOrderList(bill, shopData,scale: scale);
    pdf.addPage(Page(
      textDirection: TextDirection.rtl,
      pageFormat: PdfPageFormat.roll80.copyWith(marginLeft: 5, marginRight: 5),
      build: (context) => pw.Column(children: [
        buildInvoiceInfo(bill,scale: scale,reOrder: reOrder),
        SizedBox(height: 1 * PdfPageFormat.mm),
        invoicePart,
        Divider(),
      ]),
    ));

    return pdf.save();

    // return PdfApi.saveDocument(
    // name: "  فاکتور${bill.billNumber}.pdf", pdf: pdf);
  }






  ///********* widgets part *************
  static Widget buildHeader(Order bill, {double scale = 1}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildInvoiceInfo(bill, scale: scale),
        ],
      );

  static Widget buildInvoiceInfo(Order bill, {required double scale,bool reOrder=false}) {
    //final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'شماره میز:',
      'شماره فاکتور:',
      'تاریخ فاکتور:',
      'تاریخ تسویه:',
    ];
    final data = <String>[
      bill.tableNumber.toString().toPersianDigit(),
      bill.billNumber.toString().toPersianDigit(),
      bill.orderDate.toPersianDate(showTime: true),
      bill.dueDate == null
          ? "مشخص نشده"
          : bill.dueDate!.toPersianDate(), //paymentTerms
    ];

    return Column(
      children: [
        if(reOrder)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: PdfColors.black,borderRadius: BorderRadius.circular(7)),
            child: Text("سفارش ویرایش شده",style: TextStyle(color: PdfColors.white,fontSize: 13*scale)),),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(titles.length, (index) {
            final title = titles[index];
            final value = data[index];

            return buildText(
                title: title,
                value: value,
                width: 50 * PdfPageFormat.mm,
                scale: scale);
          }),
        )
      ]
    );
  }

  static Future<Widget> buildTitle(Order bill, UserProvider shopData,
      {double scale = 1}) async {
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
            style:  TextStyle(
              fontSize: 24*scale,
            ),
          ),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.shopName),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.description,style: TextStyle(fontSize: 15*scale)),
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

  static Future<Widget> buildTitle80(Order bill, UserProvider shopData,
      {double scale = 1}) async {
    File? logoImageFile = shopData.logoImage != null
        ? (await File(shopData.logoImage!).exists()
            ? File(shopData.logoImage!)
            : null)
        : null;

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
          Text(shopData.shopName, style: TextStyle(fontSize: 20 * scale)),
          SizedBox(height: 0.1 * PdfPageFormat.cm),
          Text(shopData.description,style: TextStyle(fontSize: 11*scale)),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      ),
    ]);
  }

  static Future<Widget> buildInvoice(Order bill, UserProvider shopData,
      {double scale = 1}) async {
    String currency = shopData.currency;
    final headers = [
      '#',
      'نام آیتم',
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
      headerStyle:  TextStyle(
        fontSize: 12*scale,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.grey300,
      ),
      cellHeight: 30,
      cellStyle:  TextStyle(fontSize: 11*scale),
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

  static Future<Widget> buildInvoice80(Order bill, UserProvider shopData,
      {double scale = 1}) async {
    String currency = shopData.currency;
    final headers =
        ['#', 'نام آیتم', 'تعداد', 'جمع ($currency)'].reversed.toList();
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
      headerStyle: TextStyle(
        color: PdfColors.white,
        fontSize: 12*scale,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.black,
      ),
      cellHeight: 25,
      cellStyle:  TextStyle(fontSize: 11*scale),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }
  ///order list creator for kitchen
  static Future<Widget> buildOrderList(Order bill, UserProvider shopData,
      {double scale = 1}) async {
    final headers =
        ['#', 'نام آیتم', 'تعداد', 'توضیحات'].reversed.toList();
    final data = bill.items.map((item) {
      return [
        "${bill.items.indexOf(item) + 1}".toPersianDigit(),
        item.itemName,
        '${item.quantity}'.toPersianDigit(),
        item.description,
      ].reversed.toList();
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    pw.TableHelper.fromTextArray(
    headers: headers,
      data: data,
      border: TableBorder.all(color: PdfColors.black,width: .1),
      headerStyle: TextStyle(
        color: PdfColors.white,
        fontSize: 12*scale,
      ),
      headerDecoration: const BoxDecoration(
        color: PdfColors.black,
      ),
      cellHeight: 20,
      cellStyle:  TextStyle(fontSize: 11*scale),
      cellAlignments: {
        0: Alignment.centerRight,
        1: Alignment.center,
        2: Alignment.centerRight,
        3: Alignment.center,
      },
      columnWidths: {
        0: const FlexColumnWidth(8),
        1: const FlexColumnWidth(3),
        2: const FlexColumnWidth(6),
        3: const FlexColumnWidth(2),
      },
    ),
        Divider(),
        Text("توضیحات کلی سفارش:",style: TextStyle(fontSize: 12*scale),maxLines: 3),
        Text(bill.description,style: TextStyle(fontSize: 11*scale),maxLines: 20),
      ]
    );
  }

  static Future<Widget> buildTotal(Order bill, UserProvider shopData,
      {double scale = 1}) async {
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
                  scale: scale,
                  title: 'جمع خرید',
                  value: "${addSeparator(bill.itemsSum)} $currency",
                  unite: true,
                ),
                buildText(
                  scale: scale,
                  title: 'پرداخت شده',
                  value: "${addSeparator(payments)} $currency",
                  unite: true,
                ),
                buildText(
                  scale: scale,
                  title: 'تخفیف',
                  value: "${addSeparator(bill.discount)} $currency",
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'قابل پرداخت',
                  scale: scale,
                  titleStyle: TextStyle(
                    fontSize: 13*scale,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "${addSeparator(bill.payable)} $currency",
                  unite: true,
                ),
                buildText(
                  title: 'به حروف',
                  scale: scale,
                  titleStyle: TextStyle(
                    fontSize: 13*scale,
                    fontWeight: FontWeight.bold,
                  ),
                  value: "",
                  unite: true,
                ),
                Text("  ${addSeparator(bill.payable).toWord()} $currency ",style: TextStyle(fontSize: 11*scale)),
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

  static Future<Widget> buildTotal80(Order bill, UserProvider shopData,
      {double scale = 1}) async {
    String currency = shopData.currency;
    final payments = bill.cashSum + bill.atmSum;
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(
            title: 'جمع خرید',
            value: "${addSeparator(bill.itemsSum)} $currency",
            unite: true,
            scale: scale,
          ),
          buildText(
            title: 'پرداخت شده',
            value: "${addSeparator(payments)} $currency",
            unite: true,
            scale: scale,
          ),
          buildText(
            title: 'تخفیف',
            value: "${addSeparator(bill.discount)} $currency",
            unite: true,
            scale: scale,
          ),
          Divider(),
          buildText(
            title: 'قابل پرداخت',
            scale: scale,
            titleStyle: TextStyle(
              fontSize: 14*scale,
              fontWeight: FontWeight.bold,
            ),
            value: "${addSeparator(bill.payable)} $currency",
            unite: true,
          ),
          buildText(
            title: 'به حروف',
            scale: scale,
            titleStyle: TextStyle(
              fontSize: 14*scale,
              fontWeight: FontWeight.bold,
            ),
            value: "",
            unite: true,
          ),
          Text("  ${addSeparator(bill.payable).toWord()} $currency ",style: TextStyle(fontSize: 11*scale)),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Container(height: 1, color: PdfColors.grey400),
          SizedBox(height: 0.5 * PdfPageFormat.mm),
          Container(height: 1, color: PdfColors.grey400),
        ],
      ),
    );
  }

  static Widget buildFooter(UserProvider shop, {double scale = 1}) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'آدرس:', value: shop.address,scale: scale),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'شماره تماس:',
              value: "${shop.phoneNumber} - ${shop.phoneNumber2}",scale: scale),
        ],
      );





  ///*************************************
  static buildSimpleText({
    required String title,
    required String value,
    double scale = 1,
  }) {
    final style = TextStyle(
      fontSize: 12 *scale,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(value,style: style),
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
    double scale = 1,
  }) {
    final style = titleStyle ??  TextStyle(color: PdfColors.black,fontSize: 11*scale);
    final valStyle = valueStyle ??  TextStyle(color: PdfColors.black,fontSize: 12*scale);

    return SizedBox(
        width: width,
        child: Expanded(
          child: Row(
            mainAxisAlignment: axisAlignment,
            children: [
              Text(title.toPersianDigit(), style: style, maxLines: 3),
              SizedBox(width: 5),
              Text(value.toPersianDigit(),
                  style: unite ? style : valueStyle ?? valStyle, maxLines: 3),
            ],
          ),
        ));
  }
}
