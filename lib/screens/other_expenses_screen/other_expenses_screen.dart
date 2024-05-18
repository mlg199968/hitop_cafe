

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_appbar.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_search_bar.dart';
import 'package:hitop_cafe/common/widgets/custom_tile.dart';
import 'package:hitop_cafe/common/widgets/empty_holder.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/providers/filter_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/filter_panel.dart';
import 'package:hitop_cafe/screens/other_expenses_screen/panels/add_expense_panel.dart';
import 'package:hitop_cafe/screens/other_expenses_screen/panels/expense_info_panel.dart';
import 'package:hitop_cafe/screens/other_expenses_screen/services/expense_tools.dart';
import 'package:hitop_cafe/screens/shopping-bill/add-shopping-bill-screen.dart';
import 'package:hitop_cafe/screens/shopping-bill/panels/bill_info_panel.dart';
import 'package:hitop_cafe/screens/shopping-bill/services/bill_tools.dart';
import 'package:hitop_cafe/screens/shopping-bill/widgets/bill_tile.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';




class OtherExpensesScreen extends StatefulWidget {
  static const String id = "/OtherExpensesScreen";
  const OtherExpensesScreen({super.key});
  @override
  State<OtherExpensesScreen> createState() => _CustomerListScreenState();
}
class _CustomerListScreenState extends State<OtherExpensesScreen> {
  FocusNode focusNode = FocusNode();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey filterScreenKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  final List<String> sortList = [
    SortItem.modifiedDate.value,
    SortItem.createdDate.value,
    SortItem.billNumber.value,
  ];
  String sortItem = SortItem.modifiedDate.value;
  String? keyWord;


  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: LayoutBuilder(
          builder: (context,constraint) {
            return Scaffold(
              key: scaffoldKey,
              floatingActionButton: CustomFloatActionButton(onPressed: () {
                showDialog(context: context, builder: (context)=>const AddExpensePanel());
              }),
              appBar: CustomAppBar(
                height: constraint.maxWidth<800?130:60,
                context2: context,
                title: "هزینه و درآمد های متفرقه",
                widgets: [
                  ///Search bar
                  CustomSearchBar(
                      focusNode: focusNode,
                      controller: searchController,
                      hint: "جست و جو",
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


                  ValueListenableBuilder<Box<Payment>>(
                      valueListenable: HiveBoxes.getExpenses().listenable(),
                      builder: (context, box, _) {
                        List<Payment> expenseList = box.values.toList().cast<Payment>();
                        //filter the list in order to the search results
                        List<Payment> filteredList =
                        ExpenseTools.filterList(expenseList, keyWord, sortItem);
                        if (filteredList.isNotEmpty) {
                          return CreditListPart(
                            expenseList: filteredList,
                            key: widget.key,
                          );
                        } else {
                          return const EmptyHolder(
                            text:"هزینه یا درآمدی یافت نشد!",
                            icon: Icons.money_off_rounded,
                          );
                        }
                      }),
                ],
              ),
            );
          }
      ),
    );
  }
}


///
class CreditListPart extends StatefulWidget {
  const CreditListPart({super.key, required this.expenseList});
  final List<Payment> expenseList;

  @override
  State<CreditListPart> createState() => _CreditListPartState();
}
class _CreditListPartState extends State<CreditListPart> {
  Payment? selectedOrder;
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
                    : ExpenseInfoPanelDesktop(
                    infoData: selectedOrder!,
                    onDelete: () {
                      selectedOrder = null;
                      setState(() {});
                    }),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.expenseList.length,
                  itemBuilder: (context, index) {
                    Payment expense=widget.expenseList[index];
                    //color condition for tile color
                    final colorCondition = expense.amount <= 0
                        ? (expense.amount == 0
                        ? Colors.green
                        : Colors.blue)
                        : Colors.red;

                      return GestureDetector(
                        onTap: () {
                          if(screenType(context)==ScreenType.mobile) {
                            showDialog(context: context, builder: (context)=>ExpenseInfoPanel(expense));
                          }
                          selectedOrder = expense;
                          setState(() {});
                        },
                        child: CustomTile(
                          enable: false,
                          title: expense.description ?? "بدون عنوان",
                          topTrailing: "",
                          trailing: addSeparator(expense.amount),
                          height: 39,
                          color: colorCondition,
                          onDelete: () {
                            if (widget.key != null) {
                              Navigator.pop(context, expense);
                            } else {
                              // Navigator.pushNamed(
                              //     context, AddOtherExpensesScreen.id,
                              //     arguments: widget.billList[index]);
                            }
                          },
                        ),
                      );
                  }),
            ),
          ],
        );
      }),
    );
  }
}