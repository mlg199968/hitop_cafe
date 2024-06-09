

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/constants/extensions.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class DaySlider extends StatelessWidget {
  const DaySlider({super.key, required this.date, required this.onChange});
  final DateTime date;
  final Function(DateTime current, DateTime begin, DateTime end) onChange;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                DateTime current = date.subtract(const Duration(days: 1));
                DateTime begin = current.copyWith(
                    hour: 0, minute: 0, second: 0, millisecond: 0);
                DateTime end = current.copyWith(
                    hour: 23, minute: 59, second: 59, millisecond: 9);
                onChange(current, begin, end);
              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 15,
                  ),
                  Text("روز قبل",style: TextStyle(fontSize: 11),),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                Jalali? picked = await TimeTools.chooseDate(context);
                if (picked != null) {
                  DateTime current = picked.toDateTime();
                  DateTime begin = current.copyWith(
                      hour: 0, minute: 0, second: 0, millisecond: 0);
                  DateTime end = current.copyWith(
                      hour: 23, minute: 59, second: 59, millisecond: 9);
                  onChange(current, begin, end);
                }
              },
              child: Text(date.isSameDate(DateTime.now())
                  ? "امروز"
                  : date.isSameDate(
                  DateTime.now().subtract(const Duration(days: 1)))
                  ? "دیروز"
                  : date.toPersianDateStr()
                ,style: const TextStyle(fontSize: 13,color: Colors.black87) ,
              ),
            ),
            TextButton(
                onPressed: () {
                  DateTime current = date.add(const Duration(days: 1));
                  DateTime begin = current.copyWith(
                      hour: 0, minute: 0, second: 0, millisecond: 0);
                  DateTime end = current.copyWith(
                      hour: 23, minute: 59, second: 59, millisecond: 9);
                  onChange(current, begin, end);
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("روز بعد",style: TextStyle(fontSize: 11)),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}