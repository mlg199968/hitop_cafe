import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CustomDateRangePicker extends StatelessWidget {
  const CustomDateRangePicker(
      {super.key,
      required this.title,
      this.startDate,
      this.endDate,
      required this.onPress,
      this.enable = true,
      this.onSwitch});
  final String title;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function onPress;
  final Function(bool? val)? onSwitch;
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
            decoration: BoxDecoration(
                color: Colors.transparent,
              border: Border.all(color: kMainColor),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                if (startDate != null && endDate != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            " تا تاریخ",
                            //style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            Jalali.fromDateTime(endDate!)
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
                            // style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Text(
                            Jalali.fromDateTime(startDate!)
                                .formatCompactDate()
                                .toPersianDigit(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const Icon(Icons.date_range_rounded),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black87, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      if (onSwitch != null)
        Switch(
          value: enable,
          onChanged: onSwitch!,
        )
    ]);
  }
}
