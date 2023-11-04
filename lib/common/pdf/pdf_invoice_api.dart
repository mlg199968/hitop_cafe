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
  //static Shop shopData = HiveBoxes.getShopInfo().get(0)!;
  //static String currency=shopData.currency;
  static Future<File> generate(Order bill,mat.BuildContext context) async {
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
    final totalPart = await buildTotal(bill,shopData);
    final invoicePart=await buildInvoice(bill,shopData);
    final titlePart=await buildTitle(bill,shopData);
    pdf.addPage(MultiPage(
      build: (context) => [
        Directionality(
            textDirection: TextDirection.rtl, child:titlePart ),
        Directionality(
            textDirection: TextDirection.rtl, child: buildHeader(bill)),
        SizedBox(height: 1 * PdfPageFormat.cm),
        invoicePart,
        Divider(),
        Directionality(textDirection: TextDirection.rtl, child: totalPart),
      ],
      footer: (context) => Directionality(
          textDirection: TextDirection.rtl, child: buildFooter(shopData)),
    ));

    return PdfApi.saveDocument(
        name: "  فاکتور${bill.billNumber}.pdf",
        pdf: pdf);
  }

  static Widget buildHeader(Order bill) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInvoiceInfo(bill),
              pw.VerticalDivider(),
              // buildCustomerAddress(bill.customer),
            ],
          ),
        ],
      );

  // static Widget buildCustomerAddress(CustomerHive customer) => Expanded(child:Column(
  //       crossAxisAlignment: CrossAxisAlignment.end,
  //       children: [
  //         buildText(
  //             title: "نام مشتری:",
  //             valueStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
  //             axisAlignment: MainAxisAlignment.end,
  //             value: "${customer.firstName} ${customer.lastName} (${customer.nickName})",
  //         ),
  //         buildText(
  //             title: "شماره تماس:",
  //             valueStyle: const TextStyle(fontSize: 15),
  //             axisAlignment: MainAxisAlignment.end,
  //             value: customer.phoneNumber,
  //         ),
  //         Text(customer.description.toPersianDigit()),
  //       ],
  //     ));

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

        return buildText(title: title, value: value, width: 150);
      }),
    );
  }

  // static Widget buildSupplierAddress(Shop supplier) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(supplier.shopName),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         Text(supplier.address),
  //       ],
  //     );

  static Future<Widget> buildTitle(Order bill,UserProvider shopData) async{
    File? logoImageFile=shopData.logoImage != null
        ? (await File(shopData.logoImage!).exists()?File(shopData.logoImage!):null):null;

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

  static Future<Widget> buildInvoice(Order bill,UserProvider shopData) async{
    String currency=shopData.currency;
    final headers = ['#','نام محصول', 'تعداد','قیمت واحد ($currency)','جمع ($currency)']
        .reversed
        .toList();
    final data = bill.items.map((item) {
      return [
        "${bill.items.indexOf(item) + 1}".toPersianDigit(),
        item.itemName,
        '${item.quantity}'.toPersianDigit(),
        addSeparator(item.sale),
        addSeparator(item.sum),
      ].reversed.toList();
    }).toList();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: pw.TableHelper.fromTextArray(
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
          oddCellStyle:const TextStyle(),
        ));
  }

  static Future<Widget> buildTotal(Order bill,UserProvider shopData) async {
    String currency=shopData.currency;
    File? signatureImageFile = shopData.signatureImage != null
        ?(await File(shopData.signatureImage!).exists()?File(shopData.signatureImage!):null)
        :null ;
    File? stampImageFile =
        shopData.stampImage != null
            ?(await File(shopData.stampImage!).exists() ? File(shopData.stampImage!) :null )
            :null;

    final payments = bill.cashSum +bill.atmSum;
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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

    final style = titleStyle ?? const TextStyle(color: PdfColors.black );

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
