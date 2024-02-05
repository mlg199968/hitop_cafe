
import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class SaleChart extends StatelessWidget {
   const SaleChart({super.key,required this.tooltipBehavior,required this.orderList});
  final TooltipBehavior tooltipBehavior;
  final List<Order> orderList;



  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(

        primaryXAxis: const CategoryAxis(),
        // Chart title
        title: const ChartTitle(text: 'Half yearly sales analysis'),
        // Enable legend
        legend: const Legend(isVisible: true),
        // Enable tooltip
        tooltipBehavior: tooltipBehavior,

        series: <LineSeries<Order, String>>[
          LineSeries<Order, String>(
              dataSource:  orderList,
              xValueMapper: (Order sales, _) => sales.orderDate.toPersianDate(),
              yValueMapper: (Order sales, _) => sales.itemsSum/10000,


              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true)
          )
        ]
    );
  }
}
class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}


