// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/time/day_slider.dart';
import 'package:hitop_cafe/common/time/month_slider.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_toggle_button.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';


///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;

import 'line_chart.dart';

/// Renders the range selector with line chart label customization option
class CustomDateRangeSelector extends StatefulWidget {
  /// Renders the range selector with line chart label customization option
  const CustomDateRangeSelector({
    super.key,
    required this.onChange,
    required this.startDate,
    required this.endDate,
    required this.saleSum,
    required this.income,
  });
  final Function(slider.SfRangeValues values) onChange;
  final List<ChartData> saleSum;
  final List<ChartData> income;
  final DateTime startDate;
  final DateTime endDate;

  @override
  State<CustomDateRangeSelector> createState() =>
      _CustomDateRangeSelectorState();
}
class _CustomDateRangeSelectorState extends State<CustomDateRangeSelector>
    with SingleTickerProviderStateMixin {
  _CustomDateRangeSelectorState();
  DateTime selectedDay=DateTime.now();
  DateTime min = DateTime(2022, 4), max = DateTime(2023, 5);
  late RangeController rangeController;
  late slider.EdgeLabelPlacement _edgeLabelPlacement;
  late slider.LabelPlacement _labelPlacement;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

 final List<String> dateTypes=[
    "بازه دلخواه",
    "روزانه",
    "ماهانه",
  ];
  String selectedDateType="بازه دلخواه";
  ///
  void getDateRange() {
    ///get max and min date for chart range
    List<DateTime> createDateList = [];
      //get order purchases date
      createDateList.addAll(widget.saleSum.map((e) => e.date));
      // get order payments
        createDateList.addAll(widget.income.map((e) => e.date));
    /// find the min and max date from the date list
    min = findMinDate(createDateList);
    max = findMaxDate(createDateList);
    startDate = findMinDate(createDateList);
    endDate = findMaxDate(createDateList);
  }

  @override
  void initState() {
    if (widget.saleSum.length >= 2 || widget.income.length >= 2) {
      getDateRange();
    }
    super.initState();
    _labelPlacement = slider.LabelPlacement.onTicks;
    _edgeLabelPlacement = slider.EdgeLabelPlacement.inside;
    rangeController = RangeController(
      start: min,
      end: max,
    );
  }

  @override
  void dispose() {
    rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    bool isDays=selectedDateType=="روزانه";
    bool isMonths=selectedDateType=="ماهانه";
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          CustomToggleButton(labelList: dateTypes,
            selected: selectedDateType,
            onPress:(val){
            selectedDateType=dateTypes[val];
            isDays=selectedDateType=="روزانه";
            isMonths=selectedDateType=="ماهانه";
            if(isDays){
              startDate=DateTime.now().copyWith(hour: 0,minute: 0,second: 0);
              endDate=DateTime.now();
            }
            else if(isMonths){
              startDate=DateTime.now().toJalali().copy(day:1,hour: 0,minute: 0,second: 0).toDateTime();
              endDate=DateTime.now().toJalali().addMonths(1).copy(day:1,hour: 0,minute: 0,second: 0).toDateTime();
            }
            else{
              getDateRange();
            }
            min=startDate;
            max=endDate;
            rangeController.start = min;
            rangeController.end = max;
            widget.onChange(slider.SfRangeValues(startDate,endDate));
            setState(() {});
            },
          ),

          ///month range picker part
          if(selectedDateType=="ماهانه")
          MonthSlider(
              date: selectedDay,
              onChange: (current,begin,end){
            selectedDay=current;
            startDate=begin;
            endDate=end;

            min=startDate;
            max=endDate;
            rangeController.start = min;
            rangeController.end = max;
            widget.onChange(slider.SfRangeValues(startDate,endDate));
            setState(() {});
          }),
          ///day range picker part
          if(selectedDateType=="روزانه")
          DaySlider(
              date: selectedDay,
              onChange: (current,begin,end){
            selectedDay=current;
            startDate=begin;
            endDate=end;

            min=startDate;
            max=endDate;
            rangeController.start = min;
            rangeController.end = max;
            widget.onChange(slider.SfRangeValues(startDate,endDate));
            setState(() {});
          }),
          if(selectedDateType=="روزانه")
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "از ساعت",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Text(
                    TimeTools.showHour(min),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    " تا ساعت",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  Text(
                    TimeTools.showHour(max),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
          ///date range picker part
          if(selectedDateType=="بازه دلخواه" || selectedDateType=="ماهانه")
          InkWell(
            onTap: () async {
              var picked = await showPersianDateRangePicker(
                context: context,
                initialDateRange: JalaliRange(
                  start: Jalali.now().addDays(-5),
                  end: Jalali.now(),
                ),
                firstDate: Jalali(1385, 8),
                lastDate: Jalali(1450, 9),
              );
              if (picked != null) {
                startDate = picked.start.toDateTime();
                endDate = picked.end.toDateTime();
                min = startDate;
                max = endDate;
                rangeController.start = min;
                rangeController.end = max;
                widget.onChange(slider.SfRangeValues(startDate,endDate));
                setState(() {});
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "از تاریخ",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      min.toPersianDate(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      " تا تاریخ",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      max.toPersianDate(),
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ///range selector
          SfRangeSelectorTheme(
            data: SfRangeSelectorThemeData(
                activeLabelStyle: TextStyle(
                    fontSize: 12,
                    color: isLightTheme ? Colors.black : Colors.white),
                inactiveLabelStyle: TextStyle(
                    fontSize: 10,
                    color: isLightTheme
                        ? Colors.black
                        : const Color.fromRGBO(170, 170, 170, 1)),
                activeTrackColor: kMainColor,
                inactiveRegionColor: isLightTheme
                    ? Colors.white.withOpacity(0.75)
                    : const Color.fromRGBO(33, 33, 33, 0.75),
                thumbColor: Colors.white,
                thumbStrokeColor: kMainColor,
                thumbStrokeWidth: 2.0,
                overlayRadius: 1,
                overlayColor: Colors.transparent),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 15, 0),
                child: slider.SfRangeSelector(
                  edgeLabelPlacement: _edgeLabelPlacement,
                  labelPlacement: _labelPlacement,
                  min: startDate,
                  max: endDate,
                  interval: 1,
                  deferredUpdateDelay: 1000,
                  dateFormat: DateFormat.m(),
                  dateIntervalType: slider.DateIntervalType.months,
                  controller: rangeController,
                  showTicks: true,
                  showLabels: true,
                  dragMode: slider.SliderDragMode.both,
                  labelFormatterCallback:
                      (dynamic actualLabel, String formattedText) {
                    DateTime lab = actualLabel as DateTime;
                    String label = Jalali.fromDateTime(lab).month.toString();
                    return label;
                  },
                  onChanged: (slider.SfRangeValues values) {
                    min = values.start;
                    max = values.end;
                    widget.onChange(values);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
