import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class AnalyticsScreen extends StatefulWidget {
  static const String id = "/analyticsScreen";
  const AnalyticsScreen({Key? key}) : super(key: key);

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
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();
  num saleSum = 0;
  num costSum = 0;
  num income = 0;
  num atmIncome = 0;
  num cashIncome = 0;

  void getData(List<Bill> billList, List<Order> orderList) {
    saleData = [];
    costData=[];
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
        if(pay.method==PayMethod.atm) {
          ChartData atmPays =
              ChartData(value: pay.amount, date: pay.deliveryDate);
          atmData.add(atmPays);
        }
        ///get cash payments
        if(pay.method==PayMethod.cash) {
          ChartData cashPays =
              ChartData(value: pay.amount, date: pay.deliveryDate);
          atmData.add(cashPays);
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
      ChartData billSum =
          ChartData(value: bill.waresSum, date: bill.billDate);
      costData.add(billSum);

    }
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("آنالیز"),),
      body: ValueListenableBuilder<Box<Order>>(
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
                  calculateSum(startDate, endDate);
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: 800,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (chartCondition) const SizedBox(
                            height: 400,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                      "برای نمایش نمودار نیاز به داده بیشتری است ! ",
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                            ),
                          ) else Expanded(
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
                          Container(
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                               // mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///chart check boxes
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: const Icon(
                                            FontAwesomeIcons.chartLine,
                                            color: Colors.red,
                                          ),
                                          title: const Text(
                                            "نمودار درآمد",
                                            style:
                                                TextStyle(fontSize: 12),
                                          ),
                                          trailing: Checkbox(
                                              value: payments,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  payments = value;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          leading: const Icon(
                                            FontAwesomeIcons.chartLine,
                                            color: Colors.blue,
                                          ),
                                          title: const Text(
                                            "نمودار فروش",
                                            style:
                                                TextStyle(fontSize: 12),
                                          ),
                                          trailing: Checkbox(
                                              value: sales,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  sales = value;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                  const SizedBox(
                                    height: 70,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
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
    this.unite = false,
  });
  final String title;
  final String value;
  final double width;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final MainAxisAlignment axisAlignment;
  final bool unite;

  @override
  Widget build(BuildContext context) {
    final currency = Provider.of<UserProvider>(context, listen: false).currency;
    final style = titleStyle ?? const TextStyle(color: Colors.black);
    return Card(
      child: Container(
          padding: const EdgeInsets.all(5),
          width: width,
          child: Row(
            mainAxisAlignment: axisAlignment,
            children: [
              Text(title.toPersianDigit(), style: style, maxLines: 3),
              const SizedBox(width: 5),
              Text("${value.toPersianDigit()} $currency",
                  style: unite ? style : valueStyle, maxLines: 3)
            ],
          )),
    );
  }
}
