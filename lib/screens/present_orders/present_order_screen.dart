import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
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

import '../../common/widgets/custom_text.dart';



class PresentOrderScreen extends StatefulWidget {
  static const String id = "/present-order-screen";
  const PresentOrderScreen({super.key});
  @override
  State<PresentOrderScreen> createState() => _PresentOrderScreenState();
}

class _PresentOrderScreenState extends State<PresentOrderScreen> {

  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey filterScreenKey = GlobalKey();
  TextEditingController searchCustomerController = TextEditingController();
  late List<Order> orderList;
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
    searchCustomerController.dispose();
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                ///local network button
                ActionButton(
                  label: "شبکه",
                  icon: Icons.circle,
                  bgColor: kMainColor,
                  iconColor: Provider.of<ServerProvider>(context,listen: false).isRunning
                      ? Colors.lightGreenAccent
                      : Colors.red,
                  onPress: () {
                    Navigator.pushNamed(context, LocalServerScreen.id);
                  },
                ),
              ],
              leading: const BackButton(
                color: Colors.black54,
              ),
              title: Container(
                padding: const EdgeInsets.only(right: 5),
                child: const Flexible(
                    child: CText(
                      "سفارشات حاضر",
                      fontSize: 18,
                      color: Colors.black87,
                    )),
              ),
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            body:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ///Search bar
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: screenType(context) != ScreenType.desktop
                        ? null
                        : BorderRadius.circular(20),
                    gradient: kMainGradiant,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
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
                Expanded(
                  child: SizedBox(
                    width: 500,
                    child: ValueListenableBuilder<Box<Order>>(
                        valueListenable: HiveBoxes.getOrders().listenable(),
                        builder: (context, box, _) {
                          List<Order> orderList =
                          box.values.toList().cast<Order>();
                          //filter the list in order to the search results
                          List<Order> filteredList =
                          OrderTools.filterList(orderList, keyWord, sortItem);

                             filteredList.removeWhere((element) => element.payable <= 0);
                          if (filteredList.isNotEmpty) {
                            return CreditListPart(
                              orderList: filteredList,
                              key: widget.key,
                            );
                          } else {
                            return const EmptyHolder(
                              text: "سفارش حاضری یافت نشد!",
                              icon: FontAwesomeIcons.beerMugEmpty,
                            );
                          }
                        }),
                  ),
                ),
              ],
            ),)

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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: widget.orderList.length,
        itemBuilder: (context, index) {
          Order order=widget.orderList[index];
          if (Provider.of<FilterProvider>(context, listen: false)
              .compareData(
              order.dueDate,
              order.payable,
              order.orderDate)) {
            return GestureDetector(
              onTap: () {
                selectedOrder = order;
                setState(() {});
              },
              child: CardTile(
                color: order.isChecked ? Colors.teal : kMainColor,
                orderDetail: order,
                button: ActionButton(
                  label: "تسویه",
                  icon: Icons.credit_score,
                  bgColor: Colors.deepOrangeAccent,
                  onPress: () {
                    Navigator.of(context)
                        .pushNamed(AddOrderScreen.id, arguments: order);
                  },
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}



