// ignore_for_file: file_names

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
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/discount_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/item_to_bill_panel.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/payment_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/bill_number.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/payments_part.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/bill_action_button.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/text_data_field.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/title_button.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:hitop_cafe/screens/shopping-bill/panels/ware_to_bill_panel.dart';
import 'package:hitop_cafe/screens/shopping-bill/parts/shopping_list.dart';
import 'package:hitop_cafe/screens/shopping-bill/services/bill_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class AddShoppingBillScreen extends StatefulWidget {
  static const String id = "/add-shopping-bill-screen";
  const AddShoppingBillScreen({super.key, this.oldBill});
  final Bill? oldBill;

  @override
  State<AddShoppingBillScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddShoppingBillScreen>
    with SingleTickerProviderStateMixin {
  late UserProvider userProvider;
  final billNumberController = TextEditingController();
  Function eq = const ListEquality().equals;
  late final AddShoppingBillScreen oldState;
  List<Purchase> wares = [];
  List<Payment> payments = [];

  num discount = 0;
  int billNumber = 1;
  bool didStateUpdate = false;
  Jalali date = Jalali.now();
  DateTime dueDate = DateTime.now();
  DateTime modifiedDate = DateTime.now();
  // String time = intl.DateFormat('kk:mm').format(DateTime.now());


  ///calculate payable amount
  num payable() {
    num payable = 0;
    payable +=
    wares.isEmpty ? 0 : wares.map((e) => e.sum).reduce((a, b) => a + b);
    payable -= payments.isEmpty
        ? 0
        : payments.map((e) => e.amount).reduce((a, b) => a + b);
    payable -= discount;
    setState(() {});
    return payable;
  }

  ///calculate wares amount
  num get itemsSum =>
      wares.isEmpty ? 0 : wares.map((e) => e.sum).reduce((a, b) => a + b);

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
  Bill createBillObject({String? id}) {
    Bill orderBill = Bill(
        purchases: wares,
        payments: payments,
        discount: discount,
        payable: payable(),
        billDate: id != null ? widget.oldBill!.billDate : DateTime.now(),

        billNumber: billNumber,
        dueDate: dueDate,
        modifiedDate: DateTime.now(),
        billId: id ?? const Uuid().v1(),
        description: '');
    return orderBill;
  }

  ///Hive Database Save function
  void saveBillOnLocalStorage({String? id}) async {
    //condition for limitation of free version
    if ( HiveBoxes.getBills().values.length < userProvider.ceilCount) {
      if(wares.isNotEmpty){
        Bill orderBill = createBillObject(id: id);
        BillTools.addToWareStorage(wares, oldBill: widget.oldBill);
        HiveBoxes.getBills().put(orderBill.billId, orderBill);
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
    // Bill orderBill = createBillObject();
    // final file = await PdfInvoiceApi.generate(orderBill,context);
    // PdfApi.openFile(file);
  }

  ///replace old  orderBill data for edit
  void oldOrderReplace(Bill oldBill) {
    wares.clear();
    payments.clear();
    wares.addAll(oldBill.purchases);
    payments.addAll(oldBill.payments);
    billNumber = oldBill.billNumber;
    discount = oldBill.discount;
    date = Jalali.fromDateTime(oldBill.billDate);
    modifiedDate = oldBill.modifiedDate;
    dueDate = oldBill.dueDate!;
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.oldBill != null) {
      oldOrderReplace(widget.oldBill!);
    } else {
      billNumber = BillTools.getBillNumber();
      billNumberController.text = BillTools.getBillNumber().toString().toPersianDigit();
    }

    ///initState animation part
    super.initState();
  }

  ///Define conditions for show or not show the onWillPop
  bool didUpdateData() {
    if (widget.oldBill != null) {
      Bill oldBill = widget.oldBill!;
      if (!eq(wares, oldBill.purchases) ||
          !eq(payments, oldBill.payments) ||
          discount != oldBill.discount ||
          date != Jalali.fromDateTime(oldBill.billDate)) {
        return true;
      }
    } else {
      if (wares.isNotEmpty || payments.isNotEmpty) {
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
              id: widget.oldBill == null ? null : widget.oldBill!.billId);


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
                id: widget.oldBill == null
                    ? null
                    : widget.oldBill!.billId,
              );
            }),
        appBar: AppBar(
          title: const Text(
            "فاکتور خرید",
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
                        id: widget.oldBill == null
                            ? null
                            : widget.oldBill!.billId);
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
                              title: "شماره فاکتور:",
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
                              wares.add(value);
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

                ///main part like wares list
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
                                  const Text("شماره فاکتور:"),
                                  CustomTextField(
                                    width: 70,
                                    controller: billNumberController,
                                    textFormat: TextFormatter.number,
                                    onChange: (val){
                                      //logic for textfield if field is empty the logic put a last bill number in the field
                                      //and change the english number to persian
                                     if(val=="" || val.isEmpty){
                                       billNumberController.text=BillTools.getBillNumber().toString().toPersianDigit();
                                       setState(() {});
                                     }else{
                                       billNumberController.text=val.toPersianDigit();
                                       setState(() {});
                                     }

                                    },
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
                                      const WareToBillPanel())
                                      .then((value) {
                                    if (value != null) {
                                      wares.add(value);
                                    }
                                    setState(() {});
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ShoppingRawList(
                          wares: wares,
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
