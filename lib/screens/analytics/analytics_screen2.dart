import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/screens/analytics/charts/chart_range_selector.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen2 extends StatefulWidget {
  static const String id = "/analytics-screen2";
  const AnalyticsScreen2({super.key});

  @override
  State<AnalyticsScreen2> createState() => _AnalyticsScreen2State();
}

class _AnalyticsScreen2State extends State<AnalyticsScreen2> {
  bool payments = true;
  bool sales = true;
  List<ChartData> saleData = [];
  List<ChartData> costData = [];
  List<ChartData> paysData = [];
  List<ChartData> atmData = [];
  List<ChartData> cashData = [];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  num saleSum = 0;
  num costSum = 0;
  num income = 0;
  num atmIncome = 0;
  num cashIncome = 0;
  List<_PieData> saleByUser = [];
  void getData(List<Bill> billList, List<Order> orderList) {
    saleData = [];
    costData = [];
    paysData = [];
    atmData = [];
    cashData = [];

    ///and get all pays and sales from the order list and bill list
    ///get order data
    for (Order order in orderList) {
      /// get order all payments
      for (Payment pay in order.payments) {
        ChartData paysOrder =
            ChartData(value: pay.amount, date: pay.deliveryDate);
        paysData.add(paysOrder);

        ///get atm payments
        if (pay.method == PayMethod.atm) {
          ChartData atmPays =
              ChartData(value: pay.amount, date: pay.deliveryDate);
          atmData.add(atmPays);
        }

        ///get cash payments
        if (pay.method == PayMethod.cash) {
          ChartData cashPays =
              ChartData(value: pay.amount, date: pay.deliveryDate);
          cashData.add(cashPays);
        }
      }

      ///get order purchases sum
      for (Item item in order.items) {
        ChartData purchaseData =
            ChartData(value: item.sum, date: order.orderDate);
        saleData.add(purchaseData);
      }
    }

    /// get shopping bills data calculate costs
    for (Bill bill in billList) {
      ChartData billSum = ChartData(value: bill.waresSum, date: bill.billDate);
      costData.add(billSum);
    }
  }

  ///user sale data
  getUserSale() {
    List<Order> orderList = HiveBoxes.getOrders().values.toList();
    List<_PieData> pieList = [];
    bool exists=false;
    for (Order order in orderList) {
      exists=false;
      if (order.user != null) {
        for (_PieData pie in pieList) {
          if(pie.text==order.user!.name) {
            pie.yData+=order.itemsSum;
            exists=true;
          }
        }
        if(!exists) {
          pieList.add(_PieData(addSeparator(order.itemsSum), order.itemsSum,order.user!.name));
        }
      }
    }

    saleByUser = pieList;
  }

  ///calculate sum of cheques,cashes,all pays and all sales between two date
  void calculateSum(DateTime begin, DateTime end) {
    saleSum = 0;
    costSum = 0;
    income = 0;
    atmIncome = 0;
    cashIncome = 0;
    bool condition(date) {
      return date.isAfter(begin.subtract(const Duration(hours: 1))) &&
          date.isBefore(end.add(const Duration(hours: 1)));
    }

    for (ChartData sale in saleData) {
      condition(sale.date) ? saleSum += sale.value : null;
    }
    for (ChartData cost in costData) {
      condition(cost.date) ? costSum += cost.value : null;
    }
    for (ChartData pays in paysData) {
      condition(pays.date) ? income += pays.value : null;
    }
    for (ChartData atmPay in atmData) {
      condition(atmPay.date) ? atmIncome += atmPay.value : null;
    }
    for (ChartData cash in cashData) {
      condition(cash.date) ? cashIncome += cash.value : null;
    }
  }

  @override
  void initState() {
    getUserSale();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              alignment: Alignment.center,
              height: 200,
              decoration: BoxDecoration(
                  gradient: kBlackWhiteGradiant,
                  boxShadow: [
                    BoxShadow(offset: Offset(2, 3),blurRadius: 5,color: Colors.black38),
                  ],
                  borderRadius: BorderRadius.circular(20)),
              child: SfCircularChart(
                  title: const ChartTitle(text: 'Sales by sales person'),
                  legend: const Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                        explode: true,
                        explodeIndex: 0,
                        dataSource: saleByUser,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) => data.text,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  num yData;
  String? text;
}
