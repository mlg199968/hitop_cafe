import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/present_orders/present_order_screen.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:hitop_cafe/screens/user_screen/add_user_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/waiter_add_order_screen.dart';
import 'package:hitop_cafe/waiter_app/waiter_setting_screen.dart';
import 'package:hitop_cafe/waiter_app/waiter_side_bar_panel.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class WaiterHomeScreen extends StatefulWidget {
  static const String id = "/waiter-home-screen";
  const WaiterHomeScreen({super.key});

  @override
  State<WaiterHomeScreen> createState() => _WaiterHomeScreenState();
}

class _WaiterHomeScreenState extends State<WaiterHomeScreen> {
  final GlobalKey<ScaffoldState> waiterScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchCustomerController = TextEditingController();
  final List<String> sortList = [
    SortItem.modifiedDate.value,
    SortItem.createdDate.value,
    SortItem.billNumber.value,
    SortItem.tableNumber.value,
  ];
  String sortItem = SortItem.modifiedDate.value;
  String? keyWord;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: waiterScaffoldKey,
      floatingActionButton: CustomFloatActionButton(
        onPressed: () {
          Navigator.pushNamed(context, WaiterAddOrderScreen.id);
        },
      ),
      extendBodyBehindAppBar: true,
      drawer: const WaiterSideBarPanel(),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const CText(
          "Hitop Waiter",
          fontSize: 18,
        ),
        leading: IconButton(
          color: Colors.white54,
          onPressed: () {
            waiterScaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 30,
            color: Colors.black87,
          )),
        actions: [
          const Gap(5),
          Flexible(
            flex: 3,
            child: ActionButton(
                label: "شبکه",
                icon: Icons.circle,
                bgColor: Colors.indigo,
                onPress: () {
                  Navigator.pushNamed(context, WaiterNetworkScreen.id);
                }),
          ),
          const Gap(5),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  margin: const EdgeInsets.only(top: 80),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  decoration: const BoxDecoration(
                    gradient: kMainGradiant,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomSearchBar(
                        // focusNode: focusNode,
                        controller: searchCustomerController,
                        hint: "جست و جو سفارش",
                        onChange: (val) {
                          keyWord = val;
                          setState(() {});
                        },
                        selectedSort: sortItem,
                        sortList: sortList,
                        onSort: (val) {
                          sortItem = val;
                          setState(() {});
                        }),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ValueListenableBuilder<Box<Pack>>(
                      valueListenable: HiveBoxes.getPack().listenable(),
                      builder: (context, box, _) {
                        List<Order> orderList =[];
                          for (var e in box.values) {
                              if(e.type==PackType.order.value) {
                                orderList.add(Order().fromJson(e.object!.first));
                              }

                        }

                        //filter the list in order to the search results
                        List<Order> filteredList = orderList;
                        OrderTools.filterList(orderList, keyWord, sortItem);
                        filteredList
                            .removeWhere((element) => element.payable <= 0);
                        if (filteredList.isNotEmpty) {
                          return CreditListPart(
                            orderList: filteredList,
                            key: widget.key,
                          );

                          ///empty screen show
                        } else {
                          return Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: const Text(
                              "سفارش حاضری یافت نشد!",
                              textDirection: TextDirection.rtl,
                            ),
                          );
                        }
                      }),
                ),
                // CustomButton(
                //     text: "text",
                //     onPressed: () {
                //       Navigator.pushNamed(context, LocalServerScreen.id);
                //     })
              ],
            )),
      ),
    );
  }
}
