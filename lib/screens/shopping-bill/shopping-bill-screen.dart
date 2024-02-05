// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/filter_panel.dart';
import 'package:hitop_cafe/screens/shopping-bill/add-shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/panels/bill_info_panel.dart';
import 'package:hitop_cafe/screens/shopping-bill/services/bill_tools.dart';
import 'package:hitop_cafe/screens/shopping-bill/widgets/bill_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class ShoppingBillScreen extends StatefulWidget {
  static const String id = "/shopping-bill-screen";
  const ShoppingBillScreen({super.key});
  @override
  State<ShoppingBillScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<ShoppingBillScreen> {
  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey filterScreenKey = GlobalKey();
  TextEditingController searchCustomerController = TextEditingController();
  final List<String> sortList = [
    SortItem.modifiedDate.value,
    SortItem.createdDate.value,
    SortItem.billNumber.value,
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
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: CustomFloatActionButton(onPressed: () {
        Navigator.pushNamed(context, AddShoppingBillScreen.id);
      }),
      appBar: CustomAppBar(
        context2: context,
        title: "فاکتور های خرید",
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
          ///Search bar
          CustomSearchBar(
              focusNode: focusNode,
              controller: searchCustomerController,
              hint: "جست و جو فاکتور",
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
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[


          ValueListenableBuilder<Box<Bill>>(
              valueListenable: HiveBoxes.getBills().listenable(),
              builder: (context, box, _) {
                List<Bill> billList = box.values.toList().cast<Bill>();
                //filter the list in order to the search results
                List<Bill> filteredList =
                    BillTools.filterList(billList, keyWord, sortItem);
                if (filteredList.isNotEmpty) {
                  return CreditListPart(
                    billList: filteredList,
                    key: widget.key,
                  );
                } else {
                  return const Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "فاکتوری یافت نشد!",
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}

class CreditListPart extends StatefulWidget {
  const CreditListPart({super.key, required this.billList});
  final List<Bill> billList;

  @override
  State<CreditListPart> createState() => _CreditListPartState();
}

class _CreditListPartState extends State<CreditListPart> {
  Bill? selectedOrder;
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
                          : BillInfoPanelDesktop(
                              infoData: selectedOrder!,
                              onDelete: () {
                                selectedOrder = null;
                                setState(() {});
                              }),
                    ),
                  ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.billList.length,
                  itemBuilder: (context, index) {
                    //color condition for tile color
                    final colorCondition = widget.billList[index].payable <= 0
                        ? (widget.billList[index].payable == 0
                            ? Colors.green
                            : Colors.blue)
                        : Colors.red;
                    if (Provider.of<FilterProvider>(context, listen: false)
                        .compareData(
                            widget.billList[index].dueDate,
                            widget.billList[index].payable,
                            widget.billList[index].billDate)) {
                      return GestureDetector(
                        onTap: () {
                          selectedOrder = widget.billList[index];
                          setState(() {});
                        },
                        child: BillTile(
                          enabled: !isTablet,
                          billData: widget.billList[index],
                          color: colorCondition,
                          onSee: () {
                            if (widget.key != null) {
                              Navigator.pop(context, widget.billList[index]);
                            } else {
                              Navigator.pushNamed(
                                  context, AddShoppingBillScreen.id,
                                  arguments: widget.billList[index]);
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
