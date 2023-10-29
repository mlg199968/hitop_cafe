

import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class TimeTools{
 static Future<Jalali?> chooseDate(BuildContext context)async{
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
    );
    return picked;
  }
  static String showHour(DateTime date){
   String hour=date.hour.toString();
   String minute=date.minute.toString();
   return "$hour:$minute".toPersianDigit();
  }
}