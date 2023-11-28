
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


const String hostUrl="https://mlggrand.ir/db";

const kMainGradiant2 = LinearGradient(
  colors: [Colors.brown, Colors.deepOrangeAccent],
);
const kMainGradiant = LinearGradient(
  colors: [Color(0XFF543000),Color(0XFFED921B),Color(0XFFC95E00),Color(0XFFBF9200),],
 begin: Alignment.topRight,
 end: Alignment.bottomLeft
 // transform: GradientRotation(30),
);
const kBlackWhiteGradiant = LinearGradient(
    colors: [Color(0XFFffffff),Color(0XFFE0E0E0),Color(0XFFffffff),Color(0XFFE0E0E0),],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft

);

const kMainColor=Color(0XFFED921B);
const kSecondaryColor=Colors.teal;

const kMainDisableColor=Colors.orangeAccent;
const kMainActiveColor=Colors.deepOrange;
const kMainColor2=Colors.black38;
const kMainColor3=Colors.black87;



const List<String> unitList=['عدد','متر','کیلو','متر مربع','متر مکعب','لیتر','سی سی','گرم','شاخه','بسته','فنجان','لیوان','بسته'];
const List<String> kFonts=['Shabnam','Koodak','Roya','Terafik','Elham','Titr',];
const List<String> sortList=['تاریخ تسویه','حروف الفبا','تاریخ ثبت'];
const List<String> kCurrencyList=["ریال","تومان","دلار","لیر","درهم"];

///text properties
const String kCustomFont="persian";


final kBoxDecoration=BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: kMainColor));

