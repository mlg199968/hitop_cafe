import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/add_order_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/order_info_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/present_orders/widgets/card_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class PresentOrderScreen extends StatefulWidget {
  static const String id = "/present-order-screen";
  const PresentOrderScreen({Key? key}) : super(key: key);
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
      child: Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        floatingActionButton: CustomFloatActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddOrderScreen.id);
            }),
        appBar: screenType(context) != ScreenType.mobile
            ? null
            : AppBar(
          backgroundColor: Colors.transparent,

          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                size: 30,
              ),
            ),
          ],
          leading: const BackButton(),
          flexibleSpace: Container(
          ),
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
          automaticallyImplyLeading: false,
        ),
        body:Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ///Search bar customer list
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
                  decoration: const BoxDecoration(
                      gradient: kMainGradiant,
                    borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(100, 20))
                  ),
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
                        onSort: (val){
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
                        List<Order> filteredList =orderList;
                        OrderTools.filterList(orderList, keyWord, sortItem);
                        filteredList.removeWhere((element) => element.payable<=0);
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
        ),),
    );
  }
}

class CreditListPart extends StatefulWidget {
  const CreditListPart({Key? key, required this.orderList}) : super(key: key);
  final List<Order> orderList;

  @override
  State<CreditListPart> createState() => _CreditListPartState();
}

class _CreditListPartState extends State<CreditListPart> {
  Order? selectedOrder;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
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
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              alignment: WrapAlignment.center,
              children:
                List.generate(
                    widget.orderList.length,
                    (index) {

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
                          child: CardTile(
                            enabled: !isTablet,
                            orderDetail: widget.orderList[index],
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
          ),
        ],
      );
    });
  }
}
