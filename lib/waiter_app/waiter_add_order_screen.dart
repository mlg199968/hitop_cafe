
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/counter_textfield.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/providers/printer_provider.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/item_to_bill_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/payment_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/bill_number.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/payments_part.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/shopping_list.dart';
import 'package:hitop_cafe/screens/orders_screen/quick_add_screen.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/text_data_field.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/title_button.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class WaiterAddOrderScreen extends StatefulWidget {
  static const String id = "/WaiterAddOrderScreen";
  const WaiterAddOrderScreen({super.key, this.oldOrder});
  final Order? oldOrder;

  @override
  State<WaiterAddOrderScreen> createState() => _WaiterAddOrderScreenState();
}

class _WaiterAddOrderScreenState extends State<WaiterAddOrderScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider userProvider;
  late PrinterProvider printerProvider;
  final tableNumberController = TextEditingController();
  Function eq = const ListEquality().equals;
  TextEditingController descriptionController = TextEditingController();
  List<Item> items = [];
  List<Payment> payments = [];
  int billNumber = 1;
  bool didStateUpdate = false;
  Jalali date = Jalali.now();
  DateTime dueDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();
  User? user;
  bool showDescription = false;
  // String time = intl.DateFormat('kk:mm').format(DateTime.now());

  ///logic for add selected items to the list
  addToItemList(List<Item> iList) {
    bool existedItem = false;
    for (var i in iList) {
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
  num payable() {
    num payable = 0;
    payable +=
        items.isEmpty ? 0 : items.map((e) => e.sum).reduce((a, b) => a + b);
    payable -= payments.isEmpty
        ? 0
        : payments.map((e) => e.amount).reduce((a, b) => a + b);
    payable -= discount;
    setState(() {});
    return payable;
  }

  ///calculate items amount
  num get itemsSum =>
      items.isEmpty ? 0 : items.map((e) => e.sum).reduce((a, b) => a + b);

  ///calculate atm amount
  num get atmSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.atm ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate cash amount
  num get cashSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.cash ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate discount amount
  num get discount => items.isEmpty
      ? 0
      : items.map((e) => e.discount! * .01 * e.sum).reduce((a, b) => a + b);

  ///calculate Payment discount amount in payment
  num get paymentDiscount => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == PayMethod.discount ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///create orderBill object with given data
  Order createBillObject({String? id}) {
    print("create border object");
    Order orderBill = Order()
      ..user = user
      ..items = items
      ..payments = payments
      ..discount = discount + paymentDiscount
      ..payable = payable()
      ..orderDate = id != null ? widget.oldOrder!.orderDate : DateTime.now()
      ..tableNumber = int.parse(tableNumberController.text)
      ..billNumber = billNumber
      ..dueDate = dueDate
      ..modifiedDate = DateTime.now()
      ..orderId = id ?? const Uuid().v1()
      ..description = descriptionController.text;
    return orderBill;
  }

  ///Hive Database Save function
  Future<void> saveBillOnLocalStorage({String? id}) async {
    print("save button");
      if (items.isNotEmpty) {
        Order orderBill = createBillObject(id: id);
        String deviceName=await getDeviceInfo(info:"name");
        Pack pack = Pack()
          ..object = [orderBill.toJson()]
          ..device=deviceName
          ..type = "order"
          ..message = "سفارش ارسال شد"
          ..packId = orderBill.orderId;
        HiveBoxes.getPack().put(pack.packId, pack);
        if(context.mounted){
          bool res =Provider.of<ClientProvider>(context, listen: false)
              .sendPack(pack);
          if (res) {
            showSnackBar(context, "سفارش ارسال شد !");
          }else{
            showSnackBar(context, "ارتباط با سرور برقرار نیست!",
                type: SnackType.error);
          }
          Navigator.pop(context, false);
        }
      } else {
        showSnackBar(context, "لیست آیتم ها خالی است!", type: SnackType.error);
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
    descriptionController.text = oldOrder.description;
    if (oldOrder.description != "") {
      showDescription = true;
    }
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    printerProvider = Provider.of<PrinterProvider>(context, listen: false);
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
          discount != oldOrder.discount ||
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
  Future<bool> willPop() async {
    return await showDialog(
        context: context,
        builder: (context) => CustomAlert(
            title: "تغییرات داده شده ذخیره شود؟",
            onYes: () {
              saveBillOnLocalStorage(
                  id: widget.oldOrder == null
                      ? null
                      : widget.oldOrder!.orderId);

              Navigator.pop(context, false);
            },
            onNo: () {
              Navigator.pop(context, false);
              Navigator.pop(context);
            }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  ///********************************** widget *********************************************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: didUpdateData() ? willPop : null,
      child: HideKeyboard(
        child: Scaffold(
          extendBodyBehindAppBar: true,

          ///save float action button
          floatingActionButton: CustomFloatActionButton(
              label: "ذخیره",
              icon: Icons.check_rounded,
              onPressed: () async{
                print("button pressed");
                await saveBillOnLocalStorage(
                  id: widget.oldOrder == null ? null : widget.oldOrder!.orderId,
                );
              }),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              "فاکتور فروش",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              decoration: const BoxDecoration(gradient: kMainGradiant),
              child: Row(
                children: [
                  ///*****side bar panel in tablet snd desktop mode************
                  screenType(context) == ScreenType.mobile
                      ? const SizedBox()
                      : Container(
                          height: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          width: 200,
                          decoration: const BoxDecoration(
                              gradient: kBlackWhiteGradiant),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            spacing: 10,
                            runSpacing: 5,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),

                              ///orderBill date and orderBill number section
                              SizedBox(
                                height: 220,
                                child: Column(
                                  children: [
                                    const Gap(20),
                                    //user name
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
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        ///invoice number
                                        TitleButton(
                                          title: "شماره فاکتور:",
                                          value: billNumber.toString(),
                                          onPress: () {
                                            showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const BillNumber())
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
                                        const Divider(
                                          thickness: 1,
                                          height: 5,
                                        ),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              ActionButton(
                                width: 200,
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
                              ActionButton(
                                label: "افزودن سریع",
                                width: 200,
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
                              ActionButton(
                                width: 200,
                                label: "پرداخت جدید",
                                icon: Icons.add_card_rounded,
                                bgColor: Colors.teal,
                                onPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const PaymentToBill()).then((value) {
                                    if (value != null) {
                                      payments.add(value);
                                    }
                                    setState(() {});
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              ///sidebar desktop description textField
                              if (screenType(context) != ScreenType.mobile)
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: TextButton.icon(
                                      onPressed: () {
                                        showDescription = !showDescription;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        showDescription
                                            ? CupertinoIcons.minus_square
                                            : CupertinoIcons.plus_square,
                                        color: Colors.teal,
                                        size: 20,
                                      ),
                                      label: const CText(
                                        "توضیحات",
                                        color: Colors.teal,
                                      )),
                                ),
                              if (showDescription)
                                CustomTextField(
                                  controller: descriptionController,
                                  label: "توضیحات سفارش",
                                  width: double.maxFinite,
                                  maxLine: 3,
                                  maxLength: 300,
                                ),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                        ),

                  ///main part like items list
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 50),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            ///top Order data part on mobile screen
                            if (screenType(context) == ScreenType.mobile)
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white.withOpacity(.8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    const SizedBox(width: 10),

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
                                                          const BillNumber())
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ///description textField
                            if (screenType(context) == ScreenType.mobile)
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: TextButton.icon(
                                    onPressed: () {
                                      showDescription = !showDescription;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      showDescription
                                          ? CupertinoIcons.minus_square
                                          : CupertinoIcons.plus_square,
                                      color: Colors.teal,
                                      size: 20,
                                    ),
                                    label: const CText(
                                      "توضیحات",
                                      color: Colors.teal,
                                    )),
                              ),
                            if (showDescription &&
                                screenType(context) == ScreenType.mobile)
                              CustomTextField(
                                controller: descriptionController,
                                label: "توضیحات سفارش",
                                width: double.maxFinite,
                                maxLine: 3,
                                maxLength: 300,
                              ),

                            ///quick action button like add items and add payments
                            if (screenType(context) == ScreenType.mobile)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
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
                                    Flexible(
                                      child: ActionButton(
                                        label: "پرداخت جدید",
                                        icon: Icons.add_card_rounded,
                                        bgColor: Colors.teal,
                                        onPress: () {
                                          showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const PaymentToBill())
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
                              decoration: kBoxDecoration,
                              child: Column(
                                children: [
                                  TextDataField(
                                      title: "جمع خرید", value: itemsSum),
                                  TextDataField(
                                      title: "پرداخت نقد", value: cashSum),
                                  TextDataField(
                                      title: "پرداخت با کارت", value: atmSum),
                                  TextDataField(
                                      title: "تخفیف", value: discount),
                                ],
                              ),
                            ),

                            ///total payment
                            Container(
                                width: 450,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: kBoxDecoration.copyWith(
                                  color: payable() == 0
                                      ? Colors.green
                                      : (payable() < 0
                                          ? Colors.blue
                                          : Colors.red),
                                ),
                                child: TextDataField(
                                  title: "قابل پرداخت",
                                  showCurrency: true,
                                  value: payable(),
                                  color: Colors.white,
                                )),

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
                            const SizedBox(height: 90),
                          ],
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
