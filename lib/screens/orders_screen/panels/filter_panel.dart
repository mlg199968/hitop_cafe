import 'dart:math';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_radio_button.dart';
import 'package:hitop_cafe/common/widgets/date_range_picker.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterPanel extends StatefulWidget {
  const FilterPanel({Key? key}) : super(key: key);


  @override
  State<FilterPanel> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterPanel> {
  late final FilterProvider filterProvider;
  late final UserProvider userProvider;
  late SfRangeValues _payableValues;
  num _minPayablePrice=0;
  num _maxPayablePrice=100;
  num _interval=20;
  DateTime startCreateDate =DateTime.now().subtract(const Duration(days: 5));
  DateTime endCreateDate = DateTime.now();
  DateTime startDueDate =DateTime.now().subtract(const Duration(days: 5));
  DateTime endDueDate = DateTime.now();
  List<Order> orderList=[];
  List<num> payableList=[];
  List<DateTime> createDateList=[];
  List<DateTime> dueDateList=[];
  bool isCreateDate=false;
  bool isDueDate=false;
  ButtonLogic radioButtonValue=ButtonLogic.setVal(false, false, false,true);
///get credits account and calculate variables
  void getData(){
    orderList=HiveBoxes.getOrders().values.toList();
    if(orderList.length>2) {
      for (Order order in orderList) {
        payableList.add(order.payable / 10);
        createDateList.add(order.orderDate);
        if (order.dueDate != null) {
          dueDateList.add(order.dueDate!);
        }
      }
      _minPayablePrice = payableList.reduce(min);
      _maxPayablePrice = payableList.reduce(max);
      _interval = (_maxPayablePrice - _minPayablePrice) / 20;
      endCreateDate = findMaxDate(createDateList).add(const Duration(days: 1));
      startCreateDate =
          findMinDate(createDateList).subtract(const Duration(days: 1));
      //due date min and max
      if (dueDateList.isNotEmpty) {
        endDueDate = findMaxDate(dueDateList).add(const Duration(days: 1));
        startDueDate =
            findMinDate(dueDateList).subtract(const Duration(days: 1));
      }
    }
  }
  void replaceOldFilters(){
    if(filterProvider.startCreateDate!=null) {
      startCreateDate = filterProvider.startCreateDate!;
      endCreateDate = filterProvider.endCreateDate!;
    }
    isDueDate=filterProvider.isDueDate;
    isCreateDate=filterProvider.isCreateDate;
    radioButtonValue=filterProvider.radioButtonValue;

    if(filterProvider.startDueDate!=null){
      startDueDate=filterProvider.startDueDate!;
      endDueDate=filterProvider.endDueDate!;
    }
    if(filterProvider.minPayable!=null) {
      _payableValues=SfRangeValues(filterProvider.minPayable!, filterProvider.maxPayable!);
    }
  }

  @override
  void initState() {
   getData();
    _payableValues=SfRangeValues(_minPayablePrice, _maxPayablePrice);
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    filterProvider=Provider.of<FilterProvider>(context,listen: false);
    userProvider=Provider.of<UserProvider>(context,listen: false);
    super.didChangeDependencies();

      replaceOldFilters();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      titlePadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.all(0),
      title: BlurryContainer(
        child: Container(
          width: 500,
            alignment:Alignment.topRight,
            child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close,color: Colors.red))),
      ),
      actions: [
        BlurryContainer(
          child: CustomButton(
            width: 500,
            text: "اعمال فیلتر",
            onPressed: (){
              if(isDueDate){
                filterProvider.startDueDate=startDueDate;
                filterProvider.endDueDate=endDueDate;
              }else{
                filterProvider.startDueDate=null;
                filterProvider.endDueDate=null;
              }
              if(isCreateDate){
                filterProvider.startCreateDate=startCreateDate;
                filterProvider.endCreateDate=endCreateDate;
              }else{
                filterProvider.startCreateDate=null;
                filterProvider.endCreateDate=null;
              }

              filterProvider.minPayable=_payableValues.start;
              filterProvider.maxPayable=_payableValues.end;
              filterProvider.isDueDate=isDueDate;
              filterProvider.isCreateDate=isCreateDate;
              filterProvider.radioButtonValue=radioButtonValue;

              Navigator.pop(context,"");
            }),
        ),],
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.blue.shade100.withOpacity(.2),
      content: BlurryContainer(
        child: Container(
            height: MediaQuery.of(context).size.height*.65,
            padding: const EdgeInsets.all(10),
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomRadioButton(
                    setVal:radioButtonValue,
                    onChange: (val){
                      radioButtonValue=val;
                    setState(() {});
                  },),
                  const Divider(),
                  ///search by created date ,create date range

                  CustomDateRangePicker(
                    enable: isCreateDate,
                      title: "انتخاب محدوده تاریخ ایجاد شده",
                      startDate: startCreateDate,
                      endDate: endCreateDate,
                      onSwitch: (value){
                        isCreateDate=value;
                        setState(() {});
                      },
                      onPress: (picked){
                        if(picked!=null) {
                          startCreateDate = picked.start.toDateTime();
                          endCreateDate = picked.end.toDateTime();
                        }
                        setState(() {});
                      }
                  ),
                  customDivider(context: context),
                  ///payable price range picker
                  Container(
                    padding: const EdgeInsets.symmetric(vertical:10),
                    decoration: kBoxDecoration.copyWith(color: Colors.transparent),
                    child: Column(
                      children: [
                        const Divider(height: 50,),
                        SfRangeSlider(
                          min: _minPayablePrice,
                          max: _maxPayablePrice,
                          values:_payableValues,
                          interval: _interval.toDouble(),
                          showTicks: true,

                          enableTooltip: true,
                          shouldAlwaysShowTooltip: true,
                          numberFormat: intl.NumberFormat(' ###,###,###,###'),
                          onChanged: (SfRangeValues value) {
                            setState(() {
                              _payableValues = value;

                            });
                          },
                        ),
                         Text("(${userProvider.currency}) محدوده باقی مانده حساب",style: const TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  customDivider(context: context),
                  ///search by created date ,create date range
                  CustomDateRangePicker(
                    enable: isDueDate,
                      title: "انتخاب محدوده تاریخ تسویه",
                      startDate: startDueDate,
                      endDate: endDueDate,
                      onSwitch: (value){
                        isDueDate=value;
                        setState(() {});
                      },
                      onPress: (picked){
                        if(picked!=null) {
                          startDueDate = picked.start.toDateTime();
                          endDueDate = picked.end.toDateTime();
                        }
                        setState(() {});
                      }
                  ),
                  customDivider(context: context),
                ],
              ),
            )),
      ),
    );
  }
}


