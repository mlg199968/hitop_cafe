// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/time/time.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/consts_class.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/payment.dart';
import 'package:hitop_cafe/models/purchase.dart';
import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/payment_to_bill.dart';
import 'package:hitop_cafe/screens/orders_screen/panels/bill_number.dart';
import 'package:hitop_cafe/screens/orders_screen/parts/payments_part.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/text_data_field.dart';
import 'package:hitop_cafe/screens/orders_screen/widgets/title_button.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/shopping-bill/panels/ware_to_bill_panel.dart';
import 'package:hitop_cafe/screens/shopping-bill/parts/shopping_list.dart';
import 'package:hitop_cafe/screens/shopping-bill/services/bill_tools.dart';
import 'package:hitop_cafe/screens/user_screen/services/user_tools.dart';
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
  final descriptionController = TextEditingController();
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
  User? user;
  bool showDescription = false;



  ///calculate payable amount
  num get payable => wares.isEmpty ? 0 :itemsSum-paymentsSum-wares.map((e) => e.price*e.discount).reduce((a, b) => a+b);

  ///calculate wares amount
  num get itemsSum =>
      wares.isEmpty ? 0 : wares.map((e) => e.sum).reduce((a, b) => a + b);

  ///calculate  all payments amount
  num get paymentsSum => payments.isEmpty
      ? 0
      : payments
      .map((e) =>e.amount)
      .reduce((a, b) => a + b);

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
      .map((e) => e.method == PayMethod.cash ? e.amount : 0)
      .reduce((a, b) => a + b);
  ///calculate discount amount
  num get discountSum => payments.isEmpty
      ? 0
      : payments
      .map((e) => e.method == PayMethod.discount ? e.amount : 0)
      .reduce((a, b) => a + b) + discount;

  ///create orderBill object with given data
  Bill createBillObject({String? id}) {
    Bill orderBill = Bill(
        purchases: wares,
        payments: payments,
        discount: discount,
        payable: payable,
        billDate: id != null ? widget.oldBill!.billDate : DateTime.now(),
        user: user,
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
    if ( UserTools.userPermission(context,count: HiveBoxes.getBills().values.length)) {
      if(wares.isNotEmpty){
        Bill orderBill = createBillObject(id: id);
        BillTools.addToWareStorage(wares, oldBill: widget.oldBill);
        HiveBoxes.getBills().put(orderBill.billId, orderBill);
        Navigator.pop(context, false);
      }else {
        showSnackBar(context, "لیست آیتم ها خالی است!", type: SnackType.error);
      }
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
    user=oldBill.user;
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    if (widget.oldBill != null) {
      oldOrderReplace(widget.oldBill!);
    } else {
      billNumber = BillTools.getBillNumber();
      user = userProvider.activeUser;
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
  void willPop(bool didPop) async{
     await showDialog(context: context, builder: (context)=>CustomAlert(
        title: "تغییرات داده شده ذخیره شود؟",
        onYes: () {
          saveBillOnLocalStorage(
              id: widget.oldBill?.billId);


          Navigator.pop(context, false);
        },
        onNo: () {
          Navigator.pop(context, false);
          Navigator.pop(context);
        }));
  }

///******************************************* widget ***************************************************
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: didUpdateData(),
      onPopInvoked: willPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        ///save float action button
        floatingActionButton:CustomFloatActionButton(
          label: "ذخیره",
            icon: Icons.save_outlined,
            onPressed: () {
              saveBillOnLocalStorage(
                id: widget.oldBill?.billId,
              );
            }),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            "فاکتور خرید",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: [
            ActionButton(
              label: "چاپ",
              width: 70,
              onPress: () {
              },
              bgColor: Colors.red,
              icon: Icons.local_printshop_outlined,
            ),
            const SizedBox(width: 10,),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ///******* side bar panel in tablet snd desktop mode ****
                if(screenType(context) != ScreenType.mobile)
                SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: 200,
                    decoration: const BoxDecoration(gradient: kBlackWhiteGradiant),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
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
                                children: [
                                  ///invoice number desktop
                                  TitleButton(
                                    title: "شماره فاکتور:",
                                    value: billNumber.toString(),
                                    onPress: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                          const DialogTextField()).then((value) {
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
                                  ///choose due date desktop
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
                            ],
                          ),
                        ),
                        ///add ware button desktop
                        ActionButton(
                          width: 200,
                          label: "افزودن کالا",
                          icon: Icons.add_shopping_cart_sharp,
                          onPress: () {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                const WareToBillPanel()).then((value) {
                              if (value != null) {
                                wares.add(value);
                              }
                              setState(() {});
                            });
                          },
                        ),
                        ///payment Button desktop
                        ActionButton(
                          width: 200,
                          label: "پرداخت",
                          icon: Icons.monetization_on_outlined,
                          bgColor: Colors.teal,
                          onPress: () {
                            showDialog(context: context, builder: (context) =>  PaymentToBill(payable))
                                .then((value) {
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
                ),

                ///main part like wares list
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.topCenter,
                      padding:  EdgeInsets.symmetric(
                          horizontal: 10, vertical:screenType(context) == ScreenType.mobile ?90: 10),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          ///top customer data part on mobile screen
                          if(screenType(context) == ScreenType.mobile)
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
                                  mainAxisSize: MainAxisSize.min,
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
                                               DialogTextField(oldValue: billNumber.toString(),)).then((value) {
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
                              label: "توضیحات فاکتور",
                              width: double.maxFinite,
                              maxLine: 3,
                              maxLength: 300,
                            ),
                          ///quick action button like add items and add payments
                          if(screenType(context) == ScreenType.mobile)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ActionButton(
                                  label: "افزودن آیتم",
                                  icon: CupertinoIcons.cart_badge_plus,
                                  bgColor: Colors.blueGrey,
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
                                ActionButton(
                                  label: "پرداخت جدید",
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

                              ],
                            ),
                          ),

                          ///final data of orderBill like sale total
                          Container(
                            width: 450,
                            margin: const EdgeInsets.all(10),
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
                                TextDataField(title: "تخفیف", value: discountSum),
                                ///total payment
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: payable == 0
                                          ? Colors.teal
                                          : (payable < 0 ? Colors.indigoAccent : Colors.redAccent),
                                    ),
                                    child: TextDataField(
                                      title: "قابل پرداخت",
                                      value: payable,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          ///Product List Part
                          ShoppingRawList(
                            wares: wares,
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
    );
  }
}
