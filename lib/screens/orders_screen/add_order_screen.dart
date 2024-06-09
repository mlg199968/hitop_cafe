import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/check_button.dart';
import 'package:hitop_cafe/common/widgets/counter_textfield.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/item_to_bill_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/payment_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/bill_number.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/print_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/item_selection_part.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/payments_part.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/shopping_list.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/customer_holder.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/description_textfield.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/text_data_field.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/title_button.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class AddOrderScreen extends StatefulWidget {
  static const String id = "/AddOrderScreen";
  const AddOrderScreen({super.key, this.oldOrder});
  final Order? oldOrder;

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider userProvider;
  final tableNumberController = TextEditingController();
  Function eq = const ListEquality().equals;
  TextEditingController descriptionController = TextEditingController();
  late final AddOrderScreen oldState;
  List<Item> items = [];
  List<Payment> payments = [];
  int billNumber = 1;
  bool didStateUpdate = false;
  Jalali date = Jalali.now();
  DateTime dueDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();
  User? user;
  User? customer;
  bool showDescription = false;
  bool takeaway = false;
  // String time = intl.DateFormat('kk:mm').format(DateTime.now());

  ///logic for add selected items to the list
  addToItemList(List<Item> iList) {

    for (var i in iList) {
      bool existedItem = false;
      for (var element in items) {
        if (element.itemName == i.itemName) {
          element.quantity += i.quantity;
          existedItem = true;
        }
      }
      if (!existedItem) {
        items.add(i);
      }
    }
  }

  ///calculate payable amount
  num get payable => itemsSum - paymentSum - itemsDiscount;

  ///calculate items amount
  num get itemsSum =>
      items.isEmpty ? 0 : items.map((e) => e.sum).reduce((a, b) => a + b);

  ///calculate all payment amount
  num get paymentSum => payments.isEmpty
      ? 0
      : payments.map((e) => e.amount).reduce((a, b) => a + b);

  ///calculate atm amount
  num get atmSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.atm ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate card to card amount
  num get cardSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.card ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate cash amount
  num get cashSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.cash ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate items discount amount
  num get itemsDiscount => items.isEmpty
      ? 0
      : items.map((e) => e.discount! * .01 * e.sum).reduce((a, b) => a + b);

  ///calculate Payment discount amount in payment
  num get paymentDiscount => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.discount ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate all discount
  num get discount => paymentDiscount + itemsDiscount;

  ///create orderBill object with given data
  Order createBillObject({String? id}) {
    Order orderBill = Order()
      ..user = user
      ..customer = customer
      ..items = items
      ..payments = payments
      ..orderDate = id != null ? widget.oldOrder!.orderDate : DateTime.now()
      ..tableNumber = int.parse(tableNumberController.text)
      ..billNumber = billNumber
      ..dueDate = dueDate
      ..modifiedDate = DateTime.now()
      ..orderId = id ?? const Uuid().v1()
      ..takeaway=takeaway
      ..description = descriptionController.text;
    return orderBill;
  }

  ///Hive Database Save function
  void saveBillOnLocalStorage({String? id}) async {
    //condition for limitation of free version
    if (UserTools.userPermission(context,
        count: HiveBoxes.getOrders().values.length)) {
      if (items.isNotEmpty) {
        Order orderBill = createBillObject(id: id);
        OrderTools.subtractFromWareStorage(items, oldOrder: widget.oldOrder);
        HiveBoxes.getOrders().put(orderBill.orderId, orderBill);
        Navigator.pop(context, false);
      } else {
        showSnackBar(context, "لیست آیتم ها خالی است!", type: SnackType.error);
      }
    }
  }

  ///replace old  orderBill data for edit
  void oldOrderReplace(Order oldOrder) {
    items.clear();
    payments.clear();
    items.addAll(oldOrder.items);
    payments.addAll(oldOrder.payments);
    billNumber = oldOrder.billNumber ?? 0;
    date = Jalali.fromDateTime(oldOrder.orderDate);
    modifiedDate = oldOrder.modifiedDate;
    dueDate = oldOrder.dueDate!;
    tableNumberController.text = oldOrder.tableNumber!.toString();
    user = oldOrder.user;
    customer = oldOrder.customer;
    descriptionController.text = oldOrder.description ?? "";
    takeaway=oldOrder.takeaway ?? false;
    if (oldOrder.description != "") {
      showDescription = true;
    }
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.oldOrder != null) {
      oldOrderReplace(widget.oldOrder!);
    } else {
      billNumber = OrderTools.getOrderNumber();
      tableNumberController.text = 1.toString();
      user = userProvider.activeUser;
    }

    ///initState animation part
    super.initState();
  }

  ///Define conditions for show or not show the onWillPop
  bool didUpdateData() {
    if (widget.oldOrder != null) {
      Order oldOrder = widget.oldOrder!;
      if (!eq(items, oldOrder.items) ||
          !eq(payments, oldOrder.payments) ||
          date != Jalali.fromDateTime(oldOrder.orderDate) ||
          tableNumberController.text != oldOrder.tableNumber!.toString()) {
        return true;
      }
    } else {
      if (items.isNotEmpty || payments.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  ///call message on pop to previous page function
  void willPop(bool didPop) async {
    await showDialog(
        context: context,
        builder: (context) => CustomAlert(
            title: "تغییرات داده شده ذخیره شود؟",
            onYes: () {
              saveBillOnLocalStorage(id: widget.oldOrder?.orderId);

              Navigator.pop(context, false);
            },
            onNo: () {
              Navigator.pop(context, false);
              Navigator.pop(context);
            }));
  }

  @override
  void dispose() {
    tableNumberController.dispose();
    super.dispose();
  }

  ///********************************** widget *********************************************
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: didUpdateData(),
      onPopInvoked:willPop,
      child: HideKeyboard(
        child: Scaffold(
          extendBodyBehindAppBar: true,

          ///save float action button
          floatingActionButton: CustomFloatActionButton(
              label: "ذخیره",
              icon: Icons.save_outlined,
              onPressed: () {
                saveBillOnLocalStorage(
                  id: widget.oldOrder?.orderId,
                );
              }),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: CText(
              widget.oldOrder == null ? "سفارش جدید" : "ویرایش سفارش",
              color: Colors.white,
              fontSize: 20,
            ),
            actions: [
              ///print button action
              ActionButton(
                label: "چاپ و نمایش",
                bgColor: Colors.red,
                height: 30,
                icon: Icons.local_printshop_outlined,
                margin: const EdgeInsets.only(right: 10),
                onPress: () {
                  Order order = createBillObject(id: widget.oldOrder?.orderId);
                  showDialog(
                      context: context,
                      builder: (context) => PrintPanel(
                            order: order,
                            reOrder: widget.oldOrder != null,
                          ));
                  // printPdf();
                },
              ),
            ],
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: const BoxDecoration(gradient: kMainGradiant),
              child: Row(
                children: [
                  ///*****side bar panel in tablet snd desktop mode************
                  if (screenType(context) != ScreenType.mobile)
                    Container(
                      alignment: Alignment.topCenter,
                      height: MediaQuery.of(context).size.height,
                      width: screenType(context) != ScreenType.desktop
                          ? 200
                          : 300,
                      decoration:
                          const BoxDecoration(gradient: kBlackWhiteGradiant),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                          child: Column(
                            children: [
                              const Gap(30),
                              ///user name
                              Wrap(
                                children: [
                                  const CText(
                                    "کاربر:",
                                  ),
                                  CText(
                                    user?.name ?? "نامشخص",
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              ///customer desktop
                              CustomerInfoHolder(
                                  customer: customer,
                                  onChange: (val){
                                    customer=val;
                                    setState(() {});
                                  }),
                              ///order details info desktop
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("شماره میز:"),
                                  SizedBox(
                                    width: 100,
                                    child: CounterTextfield(
                                      decimal: false,
                                      controller: tableNumberController,
                                    ),
                                  ),
                                  const Gap(10 ),

                                  ///invoice number
                                  TitleButton(
                                    title: "شماره فاکتور:",
                                    value: billNumber.toString(),
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                          const DialogTextField())
                                          .then((value) {
                                        if (value != null) {
                                          billNumber = value.round();
                                        }
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 5,
                                  ),
                                  ///choose orderBill date desktop
                                  TitleButton(
                                    title: "تاریخ فاکتور:",
                                    value: date.formatCompactDate(),
                                    onPress: () async {
                                      Jalali? picked =
                                      await TimeTools.chooseDate(
                                          context);
                                      if (picked != null) {
                                        setState(() {
                                          date = picked;
                                        });
                                      }
                                    },
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 5,
                                  ),
                                  ///choose due date desktop
                                  TitleButton(
                                    title: "تاریخ تسویه:",
                                    value: dueDate.toPersianDate(),
                                    onPress: () async {
                                      Jalali? picked =
                                      await TimeTools.chooseDate(
                                          context);
                                      if (picked != null) {
                                        setState(() {
                                          dueDate = picked.toDateTime();
                                        });
                                      }
                                    },
                                  ),
                                  ///takeaway check box
                                  CheckButton(
                                    label:"بیرون بر",
                                    icon: Icons.delivery_dining_rounded,
                                    value:takeaway,
                                    onChange:(val){
                                      takeaway=val!;
                                      setState(() {});},
                                  ),
                                ],
                              ),
                              const Gap(40),
                              ///add item desktop
                              ActionButton(
                                width: 200,
                                borderRadius: 5,
                                label: "افزودن آیتم",
                                icon: CupertinoIcons.cart_badge_plus,
                                bgColor: Colors.blueGrey,
                                onPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ItemToBillPanel()).then((value) {
                                    if (value != null) {
                                      items.add(value);
                                    }
                                    setState(() {});
                                  });
                                },
                              ),
                              ///quick add desktop
                              ActionButton(
                                label: "افزودن سریع",
                                width: 200,
                                borderRadius: 5,
                                icon: CupertinoIcons.cart_badge_plus,
                                bgColor: Colors.deepOrangeAccent,
                                onPress: () {
                                  Navigator.pushNamed(context, QuickAddScreen.id)
                                      .then((value) {
                                    if (value != null) {
                                      value as List<Item>;
                                      addToItemList(value);
                                      setState(() {});
                                    }
                                  });
                                },
                              ),
                              ///add payment desktop
                              ActionButton(
                                width: 200,
                                label: "پرداخت جدید",
                                borderRadius: 5,
                                icon: Icons.add_card_rounded,
                                bgColor: Colors.teal,
                                onPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          PaymentToBill(payable)).then((value) {
                                    if (value != null) {
                                      payments.add(value);
                                    }
                                    setState(() {});
                                  });
                                },
                              ),
                              const Gap(10),
                              ///description textField sidebar desktop
                              if (screenType(context) != ScreenType.mobile)
                                DescriptionField(
                                  label: "توضیحات سفارش",
                                    id: "order",
                                    controller: descriptionController,
                                    show: showDescription,
                                    onPress: () {
                                      showDescription = !showDescription;
                                      setState(() {});
                                    }),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ///main part like items list
                  Flexible(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: screenType(context) == ScreenType.mobile
                                  ? 90
                                  : 10),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              ///top Order data part on mobile screen
                              if (screenType(context) == ScreenType.mobile)
                                CustomerInfoHolder(
                                    customer: customer,
                                    showBg: true,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    onChange: (val){
                                      customer=val;
                                      setState(() {});
                                    }),
                              ///top Order data part on mobile screen
                              if (screenType(context) == ScreenType.mobile)
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(.8)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///top right
                                      Column(
                                        children: [
                                          Wrap(
                                            children: [
                                              const CText(
                                                "کاربر:",
                                              ),
                                              CText(
                                                user?.name ?? "نامشخص",
                                                fontSize: 15,
                                              ),
                                            ],
                                          ),
                                          const Gap(5),
                                          SizedBox(
                                            width: 100,
                                            child: CounterTextfield(
                                              label: "میز:",
                                              decimal: false,
                                              controller: tableNumberController,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      ///top left
                                      SizedBox(
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ///invoice number
                                            TitleButton(
                                              title: "شماره فاکتور:",
                                              value: billNumber.toString(),
                                              onPress: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        DialogTextField(
                                                          oldValue: billNumber
                                                              .toString(),
                                                        )).then((value) {
                                                  if (value != null) {
                                                    billNumber = value.round();
                                                  }
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                            const Divider(
                                              thickness: 1,
                                              height: 5,
                                            ),
                                            ///choose orderBill date
                                            TitleButton(
                                              title: "تاریخ فاکتور:",
                                              value: date.formatCompactDate(),
                                              onPress: () async {
                                                Jalali? picked =
                                                    await TimeTools.chooseDate(
                                                        context);
                                                if (picked != null) {
                                                  setState(() {
                                                    date = picked;
                                                  });
                                                }
                                              },
                                            ),
                                            CheckButton(
                                                label:"بیرون بر",
                                                icon: Icons.delivery_dining_rounded,
                                                value:takeaway,
                                                onChange:(val){
                                              takeaway=val!;
                                              setState(() {});},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ///description textField
                              if (screenType(context) == ScreenType.mobile)
                                DescriptionField(
                                  label: "توضیحات سفارش",
                                    id: "order",
                                    controller: descriptionController,
                                    show: showDescription,
                                    onPress: () {
                                      showDescription = !showDescription;
                                      setState(() {});
                                    }),

                              ///quick action button like add items and add payments
                              if (screenType(context) == ScreenType.mobile)
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      /// add item button mobile screen
                                      Flexible(
                                        child: ActionButton(
                                          label: "افزودن آیتم",
                                          icon: CupertinoIcons.cart_badge_plus,
                                          bgColor: Colors.blueGrey,
                                          onPress: () {
                                            showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const ItemToBillPanel())
                                                .then((value) {
                                              if (value != null) {
                                                items.add(value);
                                              }
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ),

                                      ///quick add item button mobile screen
                                      Flexible(
                                        child: ActionButton(
                                          label: "افزودن سریع",
                                          icon: CupertinoIcons.cart_badge_plus,
                                          bgColor: Colors.deepOrangeAccent,
                                          onPress: () {
                                            Navigator.pushNamed(
                                                    context, QuickAddScreen.id)
                                                .then((value) {
                                              if (value != null) {
                                                value as List<Item>;
                                                addToItemList(value);
                                                setState(() {});
                                              }
                                            });
                                          },
                                        ),
                                      ),

                                      ///payment button mobile screen
                                      Flexible(
                                        child: ActionButton(
                                          label: "پرداخت جدید",
                                          icon: Icons.add_card_rounded,
                                          bgColor: Colors.teal,
                                          onPress: () {
                                            showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        PaymentToBill(payable))
                                                .then((value) {
                                              if (value != null) {
                                                payments.add(value);
                                              }
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ///final data of orderBill like sale total
                              Container(
                                width: 450,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                margin: const EdgeInsets.all(10),
                                decoration: kBoxDecoration,
                                child: Column(
                                  children: [
                                    TextDataField(
                                        title: "جمع خرید", value: itemsSum),
                                    TextDataField(
                                        title: "پرداخت نقد", value: cashSum),
                                    TextDataField(
                                        title: "پرداخت با کارتخوان", value: atmSum),
                                    TextDataField(
                                        title: "پرداخت کارت به کارت", value: cardSum),
                                    TextDataField(
                                        title: "تخفیف", value: discount),

                                    ///total payment
                                    Container(
                                        width: 450,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: payable == 0
                                              ? Colors.teal
                                              : (payable < 0
                                                  ? Colors.indigoAccent
                                                  : Colors.redAccent),
                                        ),
                                        child: TextDataField(
                                          title: "قابل پرداخت",
                                          showCurrency: true,
                                          value: payable,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),

                              ///**** item selection part in desktop ****
                              if (screenType(context) != ScreenType.mobile)
                                ItemSelectionPart(
                                  selectedItems: items,
                                  onChange: () {
                                    setState(() {});
                                  },
                                ),

                              ///sale item List Part
                              ShoppingList(
                                items: items,
                                onChange: () {
                                  setState(() {});
                                },
                              ),

                              ///Payment List Part
                              PaymentList(
                                payments: payments,
                                onChange: () {
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

