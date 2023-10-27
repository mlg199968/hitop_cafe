import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomDateRangePicker extends StatelessWidget {
  const CustomDateRangePicker(
      {Key? key,
      required this.title,
      required this.startDate,
      required this.endDate,
      required this.onPress,
      this.enable = true,
      required this.onSwitch})
      : super(key: key);
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Function onPress;
  final Function onSwitch;
  final bool enable;
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topEnd, children: [
      Opacity(
        opacity: enable ? 1 : .5,
        child: InkWell(
          onTap: enable
              ? () async {
                  var picked = await showPersianDateRangePicker(
                    context: context,
                    initialDateRange: JalaliRange(
                      start: Jalali.now().addDays(-5),
                      end: Jalali.now(),
                    ),
                    firstDate: Jalali(1385, 8),
                    lastDate: Jalali(1450, 9),
                  );
                  onPress(picked);
                }
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10).copyWith(top: 25),
            alignment: Alignment.center,
            decoration: kBoxDecoration.copyWith(color: Colors.transparent),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          " تا تاریخ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          Jalali.fromDateTime(endDate)
                              .formatCompactDate()
                              .toPersianDigit(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "از تاریخ",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          Jalali.fromDateTime(startDate)
                              .formatCompactDate()
                              .toPersianDigit(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
                 Text(
                  title,
                  style: const TextStyle(color: Colors.white70,fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      Switch(
          value: enable,
          onChanged: (val) {
            onSwitch(val);
          }),
    ]);
  }
}
