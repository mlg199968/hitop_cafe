import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/enums.dart';

const String kAppName = "hitop-cafe";
const String hostUrl = "https://mlggrand.ir/db";
const String kPriceOptionKey="hitop_cafe_price";
const kMainGradiant2 = LinearGradient(
  colors: [Colors.deepOrangeAccent,Colors.brown],
);
const kMainGradiant = LinearGradient(colors: [
  Color(0XFF543000),
  Color(0XFFED921B),
  Color(0XFFC95E00),
  Color(0XFFBF9200),
], begin: Alignment.topRight, end: Alignment.bottomLeft
  // transform: GradientRotation(30),
);
const kBlackWhiteGradiant = LinearGradient(colors: [
  Color(0XFFffffff),
  Color(0XFFffffff),
  Color(0XFFE0E0E0),
  Color(0XFFffffff),
  Color(0XFFffffff),
  Color(0XFFE0E0E0),
], begin: Alignment.topRight, end: Alignment.bottomLeft);

const kMainColor = Color(0XFFED921B);
const kSecondaryColor = Colors.teal;

const kMainDisableColor = Colors.orangeAccent;
const kMainActiveColor = Colors.deepOrange;
const kMainColor2 = Colors.black38;
const kMainColor3 = Colors.black87;

const List<String> unitList = [
  'عدد',
  'متر',
  'کیلو',
  'متر مربع',
  'متر مکعب',
  'لیتر',
  'سی سی',
  'گرم',
  'شاخه',
  'بسته',
  'فنجان',
  'لیوان',
  'بسته'
];
const List<String> kFonts = [
  'Shabnam',
  'Sahel',
  'Koodak',
  'Roya',
  'Terafik',
  'Elham',
  'Titr'
];
const List<String> sortList = ['تاریخ تسویه', 'حروف الفبا', 'تاریخ ثبت'];
const List<String> kCurrencyList = ["ریال", "تومان", "دلار", "لیر", "درهم"];
final List<String> kPrintTemplateList = [
  PrintType.p80mm.value,
  PrintType.p72mm.value,
  PrintType.p57mm.value,
  PrintType.pA4.value,
];

///text properties
const String kCustomFont = "persian";

final kBoxDecoration = BoxDecoration(
    gradient: kBlackWhiteGradiant,
    borderRadius: BorderRadius.circular(5),
    boxShadow: const [BoxShadow(offset: Offset(1, 3),blurRadius: 5,color: Colors.black54)]);
const BoxShadow kShadow= BoxShadow(
    blurRadius: 5, offset: Offset(1, 2), color: Colors.black54);
