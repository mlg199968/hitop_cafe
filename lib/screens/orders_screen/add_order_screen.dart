import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_divider.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/discount_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/item_to_bill_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/payment_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/bill_number.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/payments_part.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/shopping_list.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/bill_action_button.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/text_data_field.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/title_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
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
  TextEditingController billNumberController = TextEditingController();
  late final AddOrderScreen oldState;
  List<Item> items = [];
  List<Payment> payments = [];

  num discount = 0;
  int billNumber = 1;
  bool didStateUpdate = false;
  Jalali date = Jalali.now();
  DateTime dueDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();
  // String time = intl.DateFormat('kk:mm').format(DateTime.now());

  ///animation
  late Animation<double> _animation;
  late AnimationController _animationController;

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
          .map((e) => e.method == "atm" ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///calculate cash amount
  num get cashSum => payments.isEmpty
      ? 0
      : payments
          .map((e) => e.method == "cash" ? e.amount : 0)
          .reduce((a, b) => a + b);

  ///create orderBill object with given data
  Order createBillObject({String? id}) {
    Order orderBill = Order(
        items: items,
        payments: payments,
        discount: discount,
        payable: payable(),
        orderDate: id != null ? widget.oldOrder!.orderDate : DateTime.now(),
        tableNumber: int.parse(tableNumberController.text),
        billNumber: billNumber,
        dueDate: dueDate,
        modifiedDate: DateTime.now(),
        orderId: id ?? const Uuid().v1(),
        description: '');
    return orderBill;
  }

  ///Hive Database Save function
  void saveBillOnLocalStorage({String? id}) async {
    //condition for limitation of free version
    if ( HiveBoxes.getOrders().values.length < userProvider.ceilCount) {
      if(items.isNotEmpty){
        Order orderBill = createBillObject(id: id);
        OrderTools.subtractFromWareStorage(items, oldOrder: widget.oldOrder);
        HiveBoxes.getOrders().put(orderBill.orderId, orderBill);
        Navigator.pop(context, false);
      }else {
        showSnackBar(context, "لیست آیتم ها خالی است!", type: SnackType.error);
      }
    }
    else {
      showSnackBar(context, ceilCountMessage, type: SnackType.error);
    }
  }

  ///export pdf function
  void exportPdf() async {
    // Order orderBill = createBillObject();
    // final file = await PdfInvoiceApi.generate(orderBill,context);
    // PdfApi.openFile(file);
  }

  ///replace old  orderBill data for edit
  void oldOrderReplace(Order oldOrder) {
    items.clear();
    payments.clear();
    items.addAll(oldOrder.items);
    payments.addAll(oldOrder.payments);
    billNumber = oldOrder.billNumber ?? 0;
    discount = oldOrder.discount;
    date = Jalali.fromDateTime(oldOrder.orderDate);
    modifiedDate = oldOrder.modifiedDate;
    dueDate = oldOrder.dueDate!;
    tableNumberController.text = oldOrder.tableNumber!.toString();
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.oldOrder != null) {
      oldOrderReplace(widget.oldOrder!);
    } else {
      billNumber = OrderTools.getOrderNumber();
      tableNumberController.text = 1.toString();
    }

    ///initState animation part
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
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
    return await customAlert(
        title: "تغییرات داده شده ذخیره شود؟",
        context: context,
        onYes: () {
          saveBillOnLocalStorage(
              id: widget.oldOrder == null ? null : widget.oldOrder!.orderId);


          Navigator.pop(context, false);
        },
        onNo: () {
          Navigator.pop(context, false);
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: didUpdateData() ? willPop : null,
      child: Scaffold(
        ///save float action button
        floatingActionButton: screenType(context) != ScreenType.mobile
            ? null
            : CustomFloatActionButton(
                icon: Icons.save_outlined,
                onPressed: () {
                  saveBillOnLocalStorage(
                    id: widget.oldOrder == null
                        ? null
                        : widget.oldOrder!.orderId,
                  );
                }),
        appBar: AppBar(
          title: const Text(
            "فاکتور فروش",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          flexibleSpace: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.bottomRight,
            decoration: const BoxDecoration(gradient: kMainGradiant),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  text: "چاپ",
                  width: 70,
                  onPressed: () {
                    saveBillOnLocalStorage(
                        id: widget.oldOrder == null
                            ? null
                            : widget.oldOrder!.orderId);
                    exportPdf();
                    Navigator.pop(context, false);
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
            child: Row(
              children: [
                ///side bar panel in tablet snd desktop mode
                screenType(context) == ScreenType.mobile
                    ? const SizedBox()
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        width: 200,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),

                            ///orderBill date and orderBill number section
                            SizedBox(
                              height: 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ///invoice number
                                  TitleButton(
                                    title: "شماره میز:",
                                    value: billNumber.toString(),
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const BillNumber()).then((value) {
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
                                          await TimeTools.chooseDate(context);
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
                                          await TimeTools.chooseDate(context);
                                      if (picked != null) {
                                        setState(() {
                                          dueDate = picked.toDateTime();
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            BillActionButton(
                              label: "افزودن کالا",
                              icon: Icons.add_shopping_cart_sharp,
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
                            BillActionButton(
                              label: "پرداخت چکی",
                              icon: Icons.featured_play_list_outlined,
                              bgColor: Colors.green,
                              onPress: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (context) => const ChequeToBill()).then((value) {
                                //   if (value != null) {
                                //     atmPayments.add(value);
                                //   }
                                //   setState(() {});
                                // });
                              },
                            ),
                            BillActionButton(
                              label: "پرداخت نقدی",
                              icon: Icons.monetization_on_outlined,
                              bgColor: Colors.green,
                              onPress: () {
                                // showDialog(context: context, builder: (context) => PaymentToBill())
                                //     .then((value) {
                                //   if (value != null) {
                                //     cashPayments.add(value);
                                //   }
                                //   setState(() {});
                                // });
                              },
                            ),
                            BillActionButton(
                              label: "تخفیف",
                              icon: Icons.discount_outlined,
                              bgColor: Colors.orangeAccent,
                              onPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const DiscountToBill()).then((value) {
                                  if (value != null) {
                                    discount = value;
                                  }
                                  setState(() {});
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                ///main part like items list
                Flexible(
                  child: Container(
                    width: 450,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: ListView(
                      children: [
                        ///top customer data part on mobile screen
                        screenType(context) != ScreenType.mobile
                            ? const SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///top right
                                    Column(
                                      children: [
                                        const Text("شماره میز:"),
                                        Container(
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: Colors.brown)),
                                          child: CustomTextField(
                                            label: "",
                                            controller: tableNumberController,
                                            textFormat: TextFormatter.number,
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

                        ///final data of orderBill like sale total
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: kBoxDecoration,
                          child: Column(
                            children: [
                              TextDataField(title: "جمع خرید", value: itemsSum),
                              TextDataField(
                                  title: "پرداخت نقد", value: cashSum),
                              TextDataField(
                                  title: "پرداخت با کارت", value: atmSum),
                              TextDataField(title: "تخفیف", value: discount),
                            ],
                          ),
                        ),

                        ///total payment
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: kBoxDecoration.copyWith(
                              color: payable() == 0
                                  ? Colors.green
                                  : (payable() < 0 ? Colors.blue : Colors.red),
                            ),
                            child: TextDataField(
                              title: "قابل پرداخت",
                              value: payable(),
                              color: Colors.white,
                            )),

                        ///Product List Part
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "لیست خرید",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              ActionButton(
                                label: "افزودن آیتم",
                                icon: FontAwesomeIcons.plus,
                                bgColor: Colors.orange.shade800,
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
                            ],
                          ),
                        ),
                        ShoppingList(
                          items: items,
                          onChange: () {
                            setState(() {});
                          },
                        ),

                        ///Payment List Part
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "لیست پرداخت",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white),
                              ),
                              ActionButton(
                                label: "پرداخت جدید",
                                icon: FontAwesomeIcons.plus,
                                bgColor: Colors.orange.shade800,
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
                            ],
                          ),
                        ),
                        screenType(context) == ScreenType.desktop
                            ? const SizedBox()
                            : PaymentList(
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

                ///Payment List Part on desktop mode
                screenType(context) != ScreenType.desktop
                    ? const SizedBox()
                    : Flexible(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          width: 450,
                          child: Column(
                            children: [
                              const CustomDivider(
                                title: "پرداختی ها",
                                color: Colors.white,
                              ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
