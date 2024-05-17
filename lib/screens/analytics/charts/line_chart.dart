// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:persian_number_utility/persian_number_utility.dart';

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart' as slider;


class RangeSelectorLabelCustomization extends StatefulWidget {
  const RangeSelectorLabelCustomization({
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
  State<RangeSelectorLabelCustomization> createState() =>
      _RangeSelectorLabelCustomizationState();
}

///****
class _RangeSelectorLabelCustomizationState
    extends State<RangeSelectorLabelCustomization>
    with SingleTickerProviderStateMixin {
  _RangeSelectorLabelCustomizationState();

  late RangeController rangeController;

  @override
  void initState() {
    super.initState();
    rangeController = RangeController(
      start: widget.startDate,
      end: widget.endDate,
    );
  }

  @override
  void dispose() {
    rangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///sort the data
    widget.saleSum.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    widget.income.sort((a, b) {
      return a.date.compareTo(b.date);
    });
    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
      ),
      title: ChartTitle(text: ' نمودار وضعیت معاملات '.toPersianDigit()),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(
          animationDuration: 500,
          shadowColor: Colors.transparent,
          enable: true),
      primaryXAxis: DateTimeAxis(
          labelStyle: const TextStyle(),
          isVisible: false,
          minimum: widget.startDate,
          maximum: widget.endDate,
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
          name: 'فروش',
          dataSource: widget.saleSum,
          color: Colors.indigoAccent,
          animationDuration: 500,
          xValueMapper: (ChartData sales, _) => sales.date,
          yValueMapper: (ChartData sales, _) => sales.value,
        ),
        LineSeries<ChartData, DateTime>(
          name: 'درآمد',
          dataSource: widget.income,
          color: Colors.red,
          xValueMapper: (ChartData pays, _) => pays.date,
          yValueMapper: (ChartData pays, _) => pays.value,
        ),
      ],
    );
  }
}

///
class ChartData {
  final num value;
  final DateTime date;

  const ChartData({
    required this.value,
    required this.date,
  });
}
