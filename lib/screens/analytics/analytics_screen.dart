import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/analytics/charts/chart_range_selector.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsScreen extends StatefulWidget {
  static const String id = "/analytics-screen";
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  bool payments = true;
  bool sales = true;
  List<ChartData> saleData = [];
  List<ChartData> costData = [];
  List<ChartData> paysData = [];
  List<ChartData> atmData = [];
  List<ChartData> cashData = [];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 5000));
  DateTime endDate = DateTime.now();
  num saleSum = 0;
  num costSum = 0;
  num income = 0;
  num atmIncome = 0;
  num cashIncome = 0;
  List<_PieData> pieList = [];
///date condition
  bool dateCondition(date) {
    return date.isAfter(startDate.subtract(const Duration(hours: 1))) &&
        date.isBefore(endDate.add(const Duration(hours: 1)));}
  ///
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

  ///calculate sum of cheques,cashes,all pays and all sales between two date
  void calculateSum() {
    saleSum = 0;
    costSum = 0;
    income = 0;
    atmIncome = 0;
    cashIncome = 0;


    for (ChartData sale in saleData) {
      dateCondition(sale.date) ? saleSum += sale.value : null;
    }
    for (ChartData cost in costData) {
      dateCondition(cost.date) ? costSum += cost.value : null;
    }
    for (ChartData pays in paysData) {
      dateCondition(pays.date) ? income += pays.value : null;
    }
    for (ChartData atmPay in atmData) {
      dateCondition(atmPay.date) ? atmIncome += atmPay.value : null;
    }
    for (ChartData cash in cashData) {
      dateCondition(cash.date) ? cashIncome += cash.value : null;
    }
  }
  ///user sale data
  getUserSale(List<Order> orderList) {
    pieList = [];
    bool exists=false;

    for (Order order in orderList) {
      exists=false;
      if (order.user != null && dateCondition(order.orderDate)) {
        for (_PieData pie in pieList) {
          if(pie.text==order.user!.name) {
            pie.yData+=order.itemsSum;
            exists=true;
          }
        }
        if(!exists && dateCondition(order.orderDate)) {
          pieList.add(_PieData(addSeparator(order.itemsSum), order.itemsSum,order.user!.name));
        }
      }
    }
  }
  ///box decoration
 final BoxDecoration decoration= BoxDecoration(
    gradient: kBlackWhiteGradiant,
    boxShadow: const [
      BoxShadow(offset: Offset(2, 3),blurRadius: 5,color: Colors.black38),
    ],
   borderRadius: BorderRadius.circular(10),
 );
  ///************************************** widget tree *************************************
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("آنالیز"),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(gradient: kMainGradiant),
          child: ValueListenableBuilder<Box<Order>>(
              valueListenable: HiveBoxes.getOrders().listenable(),
              builder: (context, box, _) {
                List<Order> orderList = box.values.toList();
                return ValueListenableBuilder<Box<Bill>>(
                    valueListenable: HiveBoxes.getBills().listenable(),
                    builder: (context, box, _) {
                      List<Bill> billList = box.values.toList();

                      bool chartCondition =
                          billList.length < 2 && orderList.length < 2;
                      getData(billList, orderList);
                      getUserSale(orderList);
                      calculateSum();
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 60,),
                            ///show when we have more than 2 data
                            if (chartCondition)
                              const EmptyHolder(
                                height: 400,
                                icon:Icons.analytics_outlined,
                                text: "برای نمایش نمودار نیاز به داده بیشتری است ! ",
                                color: Colors.white60,
                              )
                              ///line chart
                            else
                              Container(
                                margin: const EdgeInsets.all(15),
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height*.6,
                                width: 800,
                                decoration: decoration,
                                child: RangeSelectorLabelCustomization(
                                  billList: billList,
                                  orderList: orderList,
                                  payments: payments,
                                  sales: sales,
                                  onChange: (val) {
                                    startDate = val.start;
                                    endDate = val.end;
                                    //calculateSum(val.start, val.end,false);
                                    setState(() {});
                                  },
                                ),
                              ),

                            Wrap(
                              children: [
                                ///pie chart
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  alignment: Alignment.center,
                                  height: 200,
                                  width: 400,
                                  decoration: decoration,
                                  child: SfCircularChart(
                                      title: const ChartTitle(text: 'فروش هر کاربر'),
                                      legend: const Legend(isVisible: true),
                                      series: <PieSeries<_PieData, String>>[
                                        PieSeries<_PieData, String>(
                                            explode: true,
                                            explodeIndex: 0,
                                            dataSource: pieList,
                                            xValueMapper: (_PieData data, _) => data.xData,
                                            yValueMapper: (_PieData data, _) => data.yData,
                                            dataLabelMapper: (_PieData data, _) => data.text,
                                            dataLabelSettings:
                                            const DataLabelSettings(isVisible: true)),
                                      ]),
                                ),
                                ///numerical data part
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  width: 250,
                                  height: 200,
                                  decoration: decoration,
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Column(
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        BuildRowText(
                                            title: "فروش کل:",
                                            value: addSeparator(saleSum)),
                                        BuildRowText(
                                            title: "هزینه ها:",
                                            value: addSeparator(costSum)),
                                        BuildRowText(
                                            title: "درآمد کل:",
                                            value: addSeparator(income)),
                                        BuildRowText(
                                            title: "درآمد از کارتخوان:",
                                            value: addSeparator(atmIncome)),
                                        BuildRowText(
                                            title: "درآمد نقدی:",
                                            value: addSeparator(cashIncome)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}

class BuildRowText extends StatelessWidget {
  const BuildRowText({
    super.key,
    required this.title,
    required this.value,
    this.width = double.infinity,
    this.titleStyle,
    this.valueStyle,
    this.axisAlignment = MainAxisAlignment.spaceBetween,
  });
  final String title;
  final String value;
  final double width;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final MainAxisAlignment axisAlignment;

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<UserProvider>(context, listen: false).currency;
    final style =
        titleStyle ?? const TextStyle(color: Colors.black45, fontSize: 12);
    final valStyle =
        titleStyle ?? const TextStyle(color: Colors.black87, fontSize: 13);
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.black12,
          width: .5,
        ))),
        width: width,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Text(title.toPersianDigit(), style: style, maxLines: 3),
            const SizedBox(width: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value.toPersianDigit(),
                    style: valueStyle ?? valStyle, maxLines: 3),
                const Gap(3),
                Text(currency,
                    style: const TextStyle(color: Colors.black38, fontSize: 9)),
              ],
            )
          ],
        ));
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  num yData;
  String? text;
}