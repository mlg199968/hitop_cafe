// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;

/// Renders the range selector with line chart label customization option
class RangeSelectorLabelCustomization extends StatefulWidget {
  /// Renders the range selector with line chart label customization option
  const RangeSelectorLabelCustomization({
    super.key,
    required this.onChange,
    required this.orderList,
    required this.billList,
    this.payments = true,
    this.sales = true,
  });

  final Function(slider.SfRangeValues values) onChange;

  final List<Order> orderList;
  final List<Bill> billList;
  final bool payments;
  final bool sales;

  @override
  State<RangeSelectorLabelCustomization> createState() =>
      _RangeSelectorLabelCustomizationState();
}

class _RangeSelectorLabelCustomizationState
    extends State<RangeSelectorLabelCustomization>
    with SingleTickerProviderStateMixin {
  _RangeSelectorLabelCustomizationState();

  DateTime min = DateTime(2022, 4), max = DateTime(2023, 5);
   List<ChartData> saleChartData = <ChartData>[];
   List<ChartData> paymentsChartData = <ChartData>[];
  late RangeController rangeController;
  late SfCartesianChart columnChart, splineChart;
  late List<ChartData> splineSeriesData;
  late slider.EdgeLabelPlacement _edgeLabelPlacement;
  late slider.LabelPlacement _labelPlacement;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();


  void getData() {
    ///get max and min date for chart range
    ///and get all pays and sales in the order list and bill list
    ///to added chartData class to use in the chart
    List<DateTime> createDateList = [];
    ///get order data
    for (Order order in widget.orderList) {
      // get order payments
      for(Payment pay in order.payments){
        ChartData orderPayments=ChartData(value: pay.amount, date: pay.deliveryDate);
        paymentsChartData.add(orderPayments);
        // get order pay delivery date
        createDateList.add(pay.deliveryDate);
      }

      //get order purchases sum
      for (Item purchase in order.items) {
        ChartData purchaseData =
            ChartData(value: purchase.sum, date:order.orderDate);
        saleChartData.add(purchaseData);
        //get order purchases date
        createDateList.add(order.orderDate);
      }
    }
    /// get bills data
    // for (Bill bill in widget.billList) {
    //   ChartData billSum=ChartData(value: bill.purchasesSum, date: bill.billDate);
    //   saleChartData.add(billSum);
    //   ChartData billPayments=ChartData(value:(bill.cashSum + bill.chequeSum), date: bill.billDate);
    //   paymentsChartData.add(billPayments);
    //   createDateList.add(bill.billDate);
    // }
    /// find the min and max date from the date list
    min = findMinDate(createDateList);
    max = findMaxDate(createDateList);
    startDate = findMinDate(createDateList);
    endDate = findMaxDate(createDateList);
   saleChartData.sort((a,b){
     return a.date.compareTo(b.date);
    });
   paymentsChartData.sort((a,b){
     return a.date.compareTo(b.date);
    });
  }

  @override
  void initState() {
    if(widget.orderList.length>=2 || widget.billList.length>=2) {
      getData();
    }
    super.initState();
    // min =startDate;
    // max =endDate;
    _labelPlacement = slider.LabelPlacement.onTicks;
    _edgeLabelPlacement = slider.EdgeLabelPlacement.inside;
    rangeController = RangeController(
      start: min,
      end: max,
    );

    splineSeriesData = saleChartData;
    columnChart = SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis: const DateTimeAxis(
        isVisible: false,
      ),
      primaryYAxis: const NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      series: <LineSeries<ChartData, DateTime>>[
        LineSeries<ChartData, DateTime>(
          initialIsVisible: widget.sales,
          dataSource: saleChartData,
          color: Colors.blue,
          xValueMapper: (ChartData sales, _) => sales.date,
          yValueMapper: (ChartData sales, _) => sales.value,
        ),
        LineSeries<ChartData, DateTime>(
          initialIsVisible: widget.payments,
          dataSource: paymentsChartData,
          color: Colors.red,
          xValueMapper: (ChartData pays, _) => pays.date,
          yValueMapper: (ChartData pays, _) =>pays.value,
        ),
      ],
    );
  }

  @override
  void dispose() {
    saleChartData.clear();
    rangeController.dispose();
    splineSeriesData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    splineChart = SfCartesianChart(
legend: const Legend(
    isVisible: true,
  position: LegendPosition.bottom,
),
      title: ChartTitle(text: ' نمودار وضعیت معاملات '.toPersianDigit()),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(
          animationDuration: 500,
          shadowColor: Colors.transparent,
          enable: true
      ),
      primaryXAxis: DateTimeAxis(
          labelStyle: const TextStyle(),
          isVisible: false,
          minimum: min,
          maximum: max,
          initialVisibleMinimum: rangeController.start,
          initialVisibleMaximum: rangeController.end,
          rangeController: rangeController),
      primaryYAxis: NumericAxis(
        labelFormat: "{value}",
        numberFormat: NumberFormat("###,###,###"),
        labelPosition: ChartDataLabelPosition.inside,
        labelAlignment: LabelAlignment.end,
        majorTickLines: const MajorTickLines(size: 0),
        axisLine: const AxisLine(color: Colors.transparent),
        anchorRangeToVisiblePoints: false,
      ),
      series: <LineSeries<ChartData, DateTime>>[
        LineSeries<ChartData, DateTime>(
          initialIsVisible: widget.sales,
          name: 'فروش',
          dataSource: saleChartData,
          color: Colors.blue,
          animationDuration: 500,
          xValueMapper: (ChartData sales, _) => sales.date,
          yValueMapper: (ChartData sales, _) => sales.value,
        ),
        LineSeries<ChartData, DateTime>(
          name: 'درآمد',
          initialIsVisible: widget.payments,
          dataSource: paymentsChartData,
          color: Colors.red,
          xValueMapper: (ChartData pays, _) => pays.date,
          yValueMapper: (ChartData pays, _) =>pays.value,
        ),
      ],
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
           // height: 500,
            child: Column(
              children: <Widget>[
                ///main chart
                Expanded(
                  child: Container(
                      width: mediaQueryData.size.width,
                      padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),

                      child: splineChart),
                ),
                ///date range picker part
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
                      min = picked.start.toDateTime();
                      max = picked.end.toDateTime();
                      startDate = picked.start.toDateTime();
                      endDate = picked.end.toDateTime();
                      rangeController.start = min;
                      rangeController.end = max;
                      // rangeController = RangeController(
                      //   start:startDate,
                      //   end: endDate,
                      // );
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
                            " تا تاریخ",
                            style: TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            max.toPersianDate(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "از تاریخ",
                            style: TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            min.toPersianDate(),
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
                          color: isLightTheme
                              ? Colors.black
                              : Colors.white),
                      inactiveLabelStyle: TextStyle(
                          fontSize: 10,
                          color: isLightTheme
                              ? Colors.black
                              : const Color.fromRGBO(170, 170, 170, 1)),
                      activeTrackColor:kMainColor,
                      inactiveRegionColor: isLightTheme
                          ? Colors.white.withOpacity(0.75)
                          : const Color.fromRGBO(33, 33, 33, 0.75),
                      thumbColor: Colors.white,
                      thumbStrokeColor:kMainColor,
                      thumbStrokeWidth: 2.0,
                      overlayRadius: 1,
                      overlayColor: Colors.transparent),
                  child: Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(14, 0, 15, 0),
                      child: slider.SfRangeSelector(
                        edgeLabelPlacement: _edgeLabelPlacement,
                        labelPlacement: _labelPlacement,
                        min: startDate,
                        max: endDate,
                        interval: 1,
                        deferredUpdateDelay: 1000,
                        dateFormat: DateFormat.m(),
                        dateIntervalType:
                            slider.DateIntervalType.months,
                        controller: rangeController,
                        showTicks: true,
                        showLabels: true,
                        dragMode: slider.SliderDragMode.both,
                        labelFormatterCallback: (dynamic actualLabel,
                            String formattedText) {
                          DateTime lab = actualLabel as DateTime;
                          String label = Jalali.fromDateTime(lab)
                              .month
                              .toString();
                          return label;
                        },
                        onChanged: (slider.SfRangeValues values) {
                          max = values.start;
                          min = values.end;
                          widget.onChange(values);
                          setState(() {});
                        },
                        child: Container(
                          height: 75,
                          padding: EdgeInsets.zero,
                          margin: EdgeInsets.zero,
                          child: columnChart,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class ChartData {
  final num value;
  final DateTime date;

  const ChartData({
    required this.value,
    required this.date,
  });
}
