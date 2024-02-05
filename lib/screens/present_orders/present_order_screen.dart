import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/providers/sever_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/present_orders/widgets/card_tile.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/side_bar/setting/server_screen/local_server_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class PresentOrderScreen extends StatefulWidget {
  static const String id = "/present-order-screen";
  const PresentOrderScreen({super.key});
  @override
  State<PresentOrderScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<PresentOrderScreen> {
  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey filterScreenKey = GlobalKey();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Consumer<ServerProvider>(
        builder: (context,serverProvider,child) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            key: scaffoldKey,
            floatingActionButton: CustomFloatActionButton(onPressed: () {
              Navigator.pushNamed(context, AddOrderScreen.id);
            }),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                ActionButton(
                  label: "شبکه",
                  icon: Icons.circle,
                  bgColor: kSecondaryColor,
                  iconColor: serverProvider.isRunning?Colors.lightGreenAccent:Colors.red,
                  onPress: () {
                    Navigator.pushNamed(context, LocalServerScreen.id);
                  },
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    size: 30,
                  ),
                ),
              ],
              title: Container(
                padding: const EdgeInsets.only(right: 5),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("سفارشات حاضر"),
                  ],
                ),
              ),
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ///Search bar customer list
                    Container(
                      height: 200,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                      decoration: const BoxDecoration(
                          gradient: kMainGradiant,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.elliptical(100, 20))),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomSearchBar(
                            focusNode: focusNode,
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
                      child: ValueListenableBuilder<Box<Order>>(
                          valueListenable: HiveBoxes.getOrders().listenable(),
                          builder: (context, box, _) {
                            List<Order> orderList =
                                box.values.toList().cast<Order>();
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
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}

class CreditListPart extends StatefulWidget {
  const CreditListPart({super.key, required this.orderList});
  final List<Order> orderList;

  @override
  State<CreditListPart> createState() => _CreditListPartState();
}

class _CreditListPartState extends State<CreditListPart> {
  Order? selectedOrder;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Wrap(
        runSpacing: 10,
        spacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(widget.orderList.length, (index) {
          Order order=widget.orderList[index];
          if (Provider.of<FilterProvider>(context, listen: false).compareData(
              order.dueDate,
             order.payable,
             order.orderDate)) {
            return CardTile(
              color: order.isChecked?Colors.teal:kMainColor,
              orderDetail: widget.orderList[index],
              button: ActionButton(
                label: "تسویه",
                icon: Icons.credit_score,
                bgColor: Colors.deepOrangeAccent,
                onPress:() {
                  Navigator.of(context).pushNamed(AddOrderScreen.id,arguments:order);
                },
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      );
    });
  }
}
