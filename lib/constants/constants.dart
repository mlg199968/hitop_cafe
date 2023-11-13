
import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';



String ceilCountMessage=" برای افزودن آیتم های بیشتر نسخه کامل را فعال کنید! ".toPersianDigit();
const kMainGradiant = LinearGradient(
  colors: [Colors.brown, Colors.deepOrangeAccent],
);

const kMainColor=Colors.deepOrange;
const kMainColor2=Colors.black38;
const kMainColor3=Colors.black87;



const List<String> unitList=['عدد','متر','کیلو','متر مربع','متر مکعب','لیتر','سی سی','گرم','شاخه','بسته'];
const List<String> sortList=['تاریخ تسویه','حروف الفبا','تاریخ ثبت'];
const List<String> kCurrencyList=["ریال","تومان","دلار","لیر","درهم"];

///text properties
const String kCustomFont="persian";


final kBoxDecoration=BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: kMainColor));


const String printerName = "hp";
const String printerDefault = "hp";
