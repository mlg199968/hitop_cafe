import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
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
      child: LayoutBuilder(
        builder: (context,constraint) {
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: CustomFloatActionButton(
                onPressed: () {
              Navigator.pushNamed(context, AddOrderScreen.id);
            }),
            appBar: CustomAppBar(
              height: constraint.maxWidth<700?130:60,
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
            ),);
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
  final scrollController=ScrollController();
  Order? selectedOrder;
  List<Order> lazyList=[];
  int lazyCounter=1;

  lazyLoader()async{
    await Future.delayed(const Duration(seconds: 2));
    lazyList.addAll(widget.orderList.where((element) => element.hashCode>(lazyCounter-1)*20 && element.hashCode<lazyCounter*20));
    lazyCounter++;
    setState(() {});
  }
  @override
  void initState() {
    lazyList.addAll(widget.orderList.getRange(0, 20));
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        print(lazyCounter);
        setState(() {
          lazyLoader();
        });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraint) {
        bool isMobile = constraint.maxWidth < 500;
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///side bar info panel in desktop
            if(!isMobile)
            Flexible(
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
            ///main list view
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                  itemCount: lazyList.length,
                  itemBuilder: (context, index) {
                    //color condition for tile color
                    final colorCondition = lazyList[index].payable <= 0
                        ? (lazyList[index].payable == 0
                        ? Colors.teal
                        : Colors.indigoAccent)
                        : Colors.redAccent;
                    if (Provider.of<FilterProvider>(context, listen: false)
                        .compareData(
                       lazyList[index].dueDate,
                       lazyList[index].payable,
                       lazyList[index].orderDate)) {
                      return GestureDetector(
                        onTap: () {
                          selectedOrder = lazyList[index];
                          setState(() {});
                        },
                        child: OrderTile(
                          enabled: isMobile,
                          orderDetail: lazyList[index],
                          color: colorCondition,
                          surfaceColor: selectedOrder == lazyList[index]?kMainColor:null ,
                          onSee: () {
                            //if we come from the select order list to add order to some where this line get running
                            if (widget.key != null) {
                              Navigator.pop(context, lazyList[index]);
                            } else {
                              selectedOrder=lazyList[index];
                              setState(() {});
                              Navigator.pushNamed(context, AddOrderScreen.id,
                                  arguments: lazyList[index]);
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
