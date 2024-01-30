import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/present_orders/widgets/card_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/panels/waiter_order_info_panel.dart';
import 'package:hitop_cafe/waiter_app/services/pack_tools.dart';
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

    return Consumer<ClientProvider>(
      builder: (context,clientProvider,child) {
        return Scaffold(
          key: waiterScaffoldKey,
          floatingActionButton: CustomFloatActionButton(
            bgColor: kSecondaryColor,
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
                    iconColor: clientProvider.isConnected?Colors.lightGreenAccent:Colors.red,
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
                      height: 80,
                      margin: const EdgeInsets.only(top: 80),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: const BoxDecoration(
                        gradient: kMainGradiant,
                      ),
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
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ValueListenableBuilder<Box<Pack>>(
                          valueListenable: HiveBoxes.getPack().listenable(),
                          builder: (context, box, _) {
                            List<Order> orderList =[];
                            List<Pack> packList =[];
                              for (var e in box.values) {
                                  if(e.type==PackType.order.value) {
                                    packList.add(e);
                                  }
                            }
                            //filter the list in order to the search results
                            List<Pack> filteredList = PackTools.filterList(packList, keyWord, sortItem);
                            if (filteredList.isNotEmpty) {
                              return WaiterHomeScreenListPart(
                                packList: filteredList,
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
                )),
          ),
        );
      }
    );
  }
}


class WaiterHomeScreenListPart extends StatefulWidget {
  const WaiterHomeScreenListPart({Key? key,required this.packList}) : super(key: key);

  final List<Pack> packList;
  List<Order> get orderList=>packList.map((e) => Order().fromJson(e.object!.single)).toList();

  @override
  State<WaiterHomeScreenListPart> createState() => _CreditListPartState();
}

class _CreditListPartState extends State<WaiterHomeScreenListPart> {
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
            return InkWell(
              onTap: (){
                showDialog(context: context, builder: (context)=>WaiterOrderInfoPanel( pack: widget.packList[index]));
              },
              child: CardTile(
                color: order.isChecked?Colors.teal:kMainColor,
                orderDetail: widget.orderList[index],
                button: ActionButton(
                  label: "ویرایش",
                  icon: Icons.mode_edit_outline_rounded,
                  bgColor: Colors.deepOrangeAccent,
                  onPress:() {
                    Navigator.pushNamed(context, WaiterAddOrderScreen.id,
                        arguments: order);
                  },
                ),
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