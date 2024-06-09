import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/screens/customer_screen/add_customer_screen.dart';
import 'package:hitop_cafe/screens/customer_screen/panels/customer_info_panel.dart';
import 'package:hitop_cafe/screens/customer_screen/services/customer_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../common/widgets/custom_alert.dart';
import '../../common/widgets/custom_tile.dart';
import '../../common/widgets/empty_holder.dart';


class CustomerListScreen extends StatefulWidget {
  static const String id = "/CustomerListScreen";
  const CustomerListScreen({
    super.key,
  });

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchCustomerController = TextEditingController();
  final List<String> sortList = [
    'تاریخ ثبت',
    'تاریخ ویرایش',
    'حروف الفبا',
    'امتیاز'
  ];
  String sortItem = 'تاریخ ویرایش';
  String? keyWord;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context,constraint) {
        return SafeArea(
          child: Scaffold(
            key: scaffoldKey,
            floatingActionButton: CustomFloatActionButton(onPressed: () {
              Navigator.pushNamed(context, AddCustomerScreen.id);
            }),
            appBar:CustomAppBar(
              context2: context,
              widgets: [
                ///Search bar customer list
                CustomSearchBar(
                    controller: searchCustomerController,
                    hint: "جست و جو مشتری",
                    onChange: (val) {
                      keyWord=val;
                      setState(() {});
                    },
                    selectedSort: sortItem,
                    sortList: sortList,
                    onSort: (val) {
                      sortItem=val;
                      setState(() {});
                    }
                ),
              ],
              title:"مشتریان",
            ) ,
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: ValueListenableBuilder<Box<User>>(
                  valueListenable: HiveBoxes.getCustomers().listenable(),
                  builder: (context, box, _) {
                    final customersList =
                        box.values.toList().cast<User>();
                    List<User> filteredList=CustomerTools.filterList(customersList, keyWord, sortItem);
                    if (filteredList.isEmpty) {
                      return const Center(child: EmptyHolder(text:"مشتری ای یافت نشد",icon: Icons.perm_contact_cal_rounded,));
                    }
                    return CustomerListPart(
                      customerList: filteredList,
                      key: widget.key,
                    );
                  }),
            ),
          ),
        );
      }
    );
  }
}







class CustomerListPart extends StatefulWidget {
  const CustomerListPart({super.key, required this.customerList});
  final List<User> customerList;

  @override
  State<CustomerListPart> createState() => _CustomerListPartState();
}

class _CustomerListPartState extends State<CustomerListPart> {
  List<int> selectedItems = [];
  User? selectedCustomer;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:selectedItems.isEmpty ,
      onPopInvoked:(didPop)async{
        selectedItems.clear();
        setState(() {});
      },
      child: LayoutBuilder(
        builder: (context,constraint){
       return Row(
         mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///info panel in desktop mode
            if(screenType(context) != ScreenType.mobile)
                Flexible(
                    child: SizedBox(
                      width: 400,
                      child: selectedCustomer == null
                          ? null
                          : CustomerInfoPanelDesktop(
                              infoData: selectedCustomer!,
                              onDelete: () {
                                selectedCustomer = null;
                                setState(() {});
                              }),
                    ),
                  ),
            ///
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: ScrollController(),
                        itemCount: widget.customerList.length,
                        itemBuilder: (context, index) {
                          User customer = widget.customerList[index];
                          return InkWell(
                            onLongPress: () {
                              if (!selectedItems.contains(index)) {
                                selectedItems.add(index);
                                setState(() {});
                              }
                            },
                            onTap: () {
                              if (selectedItems.isEmpty) {
                                if (widget.key != null) {
                                  Navigator.pop(context, customer);
                                } else {
                                  selectedCustomer=customer;
                                  setState(() {});
                                  screenType(context)!=ScreenType.mobile?null:showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomerInfoPanel(
                                          widget.customerList[index]);
                                    },
                                  );
                                }
                              } else {
                                if (selectedItems.contains(index)) {
                                  selectedItems.remove(index);
                                } else {
                                  selectedItems.add(index);
                                }
                                setState(() {});
                              }
                            },
                            child: CustomTile(
                              selected: selectedItems.contains(index),
                              leadingIcon: Icons.person,
                              subTitle: customer.nickName,
                              enable: false,
                              onDelete: () {},
                              height: 50,
                              color: selectedItems.contains(index)
                                  ? Colors.blue
                                  : selectedCustomer?.userId==customer.userId?Colors.teal:Colors.deepPurpleAccent,
                              type:
                                  "${index+1}".toPersianDigit(),
                              title:
                                  customer.fullName,
                              topTrailing: customer.createDate.toPersianDateStr(),
                              trailing: (customer.phone?? "").toPersianDigit(),
                            ),
                          );
                        }),
                  ),

                  ///selected items action bottom bar
                  Opacity(
                    opacity: selectedItems.isNotEmpty ?1:0,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20 )),
                      child: Container(
                        padding: const EdgeInsets.only(right: 80),
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(20 ),
                          color:Colors.white ,
                            border:
                                Border.all(color: Colors.black87)),
                        height: selectedItems.isNotEmpty ? 40 : 0,
                        width: double.maxFinite,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(onPressed: (){
                              selectedItems.clear();
                              setState(() {});
                            }, child: const Text("لغو"),),
                            const VerticalDivider(),
                            ///delete icon
                            IconButton(

                                onPressed:selectedItems.isEmpty ?null:() {
                                  showDialog(context: context, builder: (context)=>CustomAlert(
                                      title:
                                      "آیا از حذف موارد انتخاب شده مطمئن هستید؟",
                                      onYes: () {
                                        for (int item in selectedItems) {
                                          widget.customerList[item].delete();
                                        }
                                        selectedItems.clear();
                                        Navigator.pop(context);
                                      },
                                      onNo: () {
                                        Navigator.pop(context);
                                      }));
                                },
                                icon: const Icon(
                                  Icons.delete_forever,
                                  size: 27,
                                  color: Colors.red,
                                )),
                            const Expanded(child: SizedBox()),
                           constraint.maxWidth<300?Text(selectedItems.length.toString().toPersianDigit()): Text("انتخاب شده : ${selectedItems.length.toString().toPersianDigit()}")

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
