import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/order_info_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/order_tile.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/filter_panel.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const String id = "/order-screen";
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<OrderScreen> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: CustomFloatActionButton(
            onPressed: () {
          Navigator.pushNamed(context, AddOrderScreen.id);
        }),
        appBar: CustomAppBar(
          title:"لیست سفارشات",
          context2: context,
          actions: [
            ///filter button
            IconButton(
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: Colors.white,
              ),
              onPressed: () async {
                focusNode.unfocus();
                searchCustomerController.clear();
                keyWord = null;
                showDialog(
                    context: context,
                    builder: (context) => const FilterPanel())
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ],
          widgets: [
    ///Search bar customer list
            CustomSearchBar(
                focusNode: focusNode,
                controller: searchCustomerController,
                hint: "جست و جو سفارش",
                onChange: (val) {
                  keyWord = val;
                  setState(() {});
                },
                selectedSort: sortItem,
                sortList: sortList,
                onSort: (val){
                  sortItem = val;
                  setState(() {});
                }),
          ],
        ),
        body:Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ValueListenableBuilder<Box<Order>>(
                valueListenable: HiveBoxes.getOrders().listenable(),
                builder: (context, box, _) {
                  List<Order> orderList =
                  box.values.toList().cast<Order>();
                  //filter the list in order to the search results
                  List<Order> filteredList =
                  OrderTools.filterList(orderList, keyWord, sortItem);
                  if (filteredList.isNotEmpty) {
                    return CreditListPart(
                      orderList: filteredList,
                      key: widget.key,
                    );
                  } else {
                    return const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "سفارشی یافت نشد!",
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),),
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
    return Expanded(
      child: LayoutBuilder(builder: (context, constraint) {
        bool isTablet = constraint.maxWidth > 500;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !isTablet
                ? const SizedBox()
                : Flexible(
              child: SizedBox(
                width: 400,
                child: selectedOrder == null
                    ? null
                    : OrderInfoPanelDesktop(
                    infoData: selectedOrder!,
                    onDelete: () {
                      selectedOrder = null;
                      setState(() {});
                    }),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.orderList.length,
                  itemBuilder: (context, index) {
                    //color condition for tile color
                    final colorCondition = widget.orderList[index].payable <= 0
                        ? (widget.orderList[index].payable == 0
                        ? Colors.green
                        : Colors.blue)
                        : Colors.red;
                    if (Provider.of<FilterProvider>(context, listen: false)
                        .compareData(
                        widget.orderList[index].dueDate,
                        widget.orderList[index].payable,
                        widget.orderList[index].orderDate)) {
                      return GestureDetector(
                        onTap: () {
                          selectedOrder = widget.orderList[index];
                          setState(() {});
                        },
                        child: OrderTile(
                          enabled: !isTablet,
                          orderDetail: widget.orderList[index],
                          color: colorCondition,
                          onSee: () {
                            if (widget.key != null) {
                              Navigator.pop(context, widget.orderList[index]);
                            } else {
                              Navigator.pushNamed(context, AddOrderScreen.id,
                                  arguments: widget.orderList[index]);
                            }
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
            ),
          ],
        );
      }),
    );
  }
}
