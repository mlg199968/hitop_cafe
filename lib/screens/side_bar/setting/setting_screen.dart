import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/dynamic_button.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/screens/side_bar/bug_screen/bug_list_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/backup/backup_tools.dart';
import 'package:hitop_cafe/screens/side_bar/setting/server_screen/local_server_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/storage_manger/storage_manage_screen.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/choose_app_type_screen.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController taxController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController printerIpController = TextEditingController();
  final TextEditingController printerIp2Controller = TextEditingController();
  late String selectedCurrency;
  String selectedFont = kFonts[0];
  late UserProvider provider;
  String? backupDirectory;

  ///printer
  Printer? selectedPrinter;
  Printer? selectedPrinter2;
  String printTemplate = PrintType.p80mm.value;

  ///save setting
  void storeInfoShop() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    shopInfo ??= Shop();
    shopInfo
      ..currency = selectedCurrency
      ..fontFamily = selectedFont
      ..preTax = stringToDouble(taxController.text)
      ..preBillNumber = stringToDouble(billNumberController.text).toInt()
      ..printer = selectedPrinter?.toMap()
      ..printer2 = selectedPrinter2?.toMap()
      ..printerIp =
          printerIpController.text == "" ? null : printerIpController.text
      ..printerIp2 =
          printerIp2Controller.text == "" ? null : printerIp2Controller.text
      ..printTemplate = printTemplate
      ..backupDirectory = backupDirectory;
    provider.getData(shopInfo);
    HiveBoxes.getShopInfo().put(0, shopInfo);
  }

  ///get stored data to show
  void getData() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    if (shopInfo != null) {
      selectedCurrency = shopInfo.currency;
      selectedFont = shopInfo.fontFamily ?? kFonts[0];
      taxController.text = shopInfo.preTax.toString();
      billNumberController.text = shopInfo.preBillNumber.toString();
      printerIpController.text = shopInfo.printerIp ?? "192.168.1.1";
      printerIp2Controller.text = shopInfo.printerIp2 ?? "192.168.1.2";
      selectedPrinter =
          shopInfo.printer != null ? Printer.fromMap(shopInfo.printer!) : null;
      selectedPrinter2 = shopInfo.printer2 != null
          ? Printer.fromMap(shopInfo.printer2!)
          : null;
      printTemplate = shopInfo.printTemplate ?? PrintType.p80mm.value;
      backupDirectory = shopInfo.backupDirectory;
      setState(() {});
    }
  }

  @override
  void initState() {
    provider = Provider.of<UserProvider>(context, listen: false);
    selectedCurrency = kCurrencyList[0];
    getData();
    super.initState();
  }

  @override
  void dispose() {
    storeInfoShop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: kMainGradiant),
          ),
          title: const Text("تنظیمات"),
        ),
        body: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(gradient: kMainGradiant),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: 500,
                      child: Column(
                        children: [
                          ///backup buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: DynamicButton(
                                    label: "پشتیبان گیری کامل",
                                    icon: Icons.backup,

                                    bgColor: Colors.red.withRed(250),
                                    onPress: () async {
                                      await storagePermission(
                                          context, Allow.externalStorage);
                                      // ignore: use_build_context_synchronously
                                      await storagePermission(
                                          context, Allow.storage);
                                      if (context.mounted) {
                                        await BackupTools().createBackup(context,
                                            directory: backupDirectory);
                                      }
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: DynamicButton(
                                    label: "بارگیری فایل پشتیبان",
                                    icon: Icons.settings_backup_restore,
                                    bgColor: Colors.teal,
                                    onPress: () async {
                                      await storagePermission(
                                          context, Allow.storage);
                                      if (context.mounted) {
                                        await storagePermission(
                                            context, Allow.externalStorage);
                                      }
                                      if (context.mounted) {
                                        await BackupTools.readZipFile(context);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///database backup
                          Align(
                            child: DynamicButton(
                              label: "پشتیبان گیری سریع",
                              icon: Icons.backup,
                              borderRadius: 5,
                              iconColor: Colors.red,
                              bgColor: Colors.black87,
                              onPress: () async {
                                await storagePermission(
                                    context, Allow.externalStorage);
                                // ignore: use_build_context_synchronously
                                await storagePermission(
                                    context, Allow.storage).then((value) => null);
                                if (context.mounted) {
                                  await BackupTools(quickBackup: true).createBackup(context,
                                      directory: backupDirectory);
                                }
                              },
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.all(10),
                              child: const CText(
                                "انتخاب مسیر ذخیره سازی فایل پشتیبان :",
                                color: Colors.white,
                                textDirection: TextDirection.rtl,
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                margin: const EdgeInsets.all(5),
                                padding: const EdgeInsets.all(5),
                                alignment: Alignment.centerRight,
                                height: 40,
                                decoration: BoxDecoration(
                                    gradient: kBlackWhiteGradiant,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: CText(backupDirectory ??
                                            "مسیری انتخاب نشده است")),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    ActionButton(
                                      label: "انتخاب",
                                      icon: Icons.folder_open_rounded,
                                      onPress: () async {
                                        await storagePermission(
                                            context, Allow.externalStorage);
                                        if (context.mounted) {
                                          await storagePermission(
                                              context, Allow.storage);
                                        }
                                        String? newDir =
                                            await BackupTools.chooseDirectory();
                                        if (newDir != null) {
                                          backupDirectory = newDir;
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          ///currency unit
                          DropListItem(
                              title: "واحد پول",
                              selectedValue: selectedCurrency,
                              listItem: kCurrencyList,
                              onChange: (val) {
                                selectedCurrency = val;
                                setState(() {});
                              }),

                          /// preTax value
                          InputItem(
                            label: "تخفیف پیشفرض :",
                            inputLabel: "درصد",
                            controller: taxController,
                            width: 100,
                            onChange: (val) {
                              if (val != "" && stringToDouble(val) > 100) {
                                taxController.text = 99.toString();
                                setState(() {});
                              }
                            },
                          ),

                          ///change font family entire app
                          DropListItem(
                            title: "نوع فونت نمایشی",
                            selectedValue: selectedFont,
                            listItem: kFonts,
                            dropWidth: 120,
                            onChange: (val) {
                              selectedFont = val;
                              userProvider.setFontFamily(val);
                              setState(() {});
                            },
                          ),

                          ///printers setting parts
                          const CText(
                            "تنظیمات پرینتر",
                            fontSize: 16,
                            color: Colors.white60,
                          ),

                          ///change font family entire app
                          DropListItem(
                            title: "قاب پیشفرض چاپ",
                            selectedValue: printTemplate,
                            listItem: kPrintTemplateList,
                            dropWidth: 120,
                            onChange: (val) {
                              printTemplate = val;
                              setState(() {});
                            },
                          ),

                          ///list of windows printers when platform is windows
                          if (Platform.isWindows)
                            ButtonTile(
                                onPress: () async {
                                  // Show the native printer picker and get the selected printer
                                  final printer = await Printing.pickPrinter(
                                      context: context,
                                      title: "پرینتر را انتخاب کنید");
                                  if (printer != null) {
                                    selectedPrinter = printer;
                                  }
                                  setState(() {});
                                },
                                label: "انتخاب پرینتر",
                                buttonLabel: selectedPrinter == null
                                    ? "انتخاب نشده"
                                    : selectedPrinter!.name),
                          if (Platform.isWindows)
                            ButtonTile(
                                onPress: () async {
                                  // Show the native printer picker and get the selected printer
                                  final printer = await Printing.pickPrinter(
                                      context: context,
                                      title: "پرینتر2 را انتخاب کنید");
                                  if (printer != null) {
                                    selectedPrinter2 = printer;
                                  }
                                  setState(() {});
                                },
                                label: "انتخاب پرینتر2",
                                buttonLabel: selectedPrinter2 == null
                                    ? "انتخاب نشده"
                                    : selectedPrinter2!.name),

                          ///printer ip textfield
                          InputItem(
                              controller: printerIpController,
                              label: "ای پی پرینتر",
                              inputLabel: "ip"),
                          InputItem(
                              controller: printerIp2Controller,
                              label: "ای پی پرینتر 2",
                              inputLabel: "ip"),

                          ///local network options section
                          const CText(
                            "تنظیمات شبکه",
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                          ButtonTile(
                              onPress: () {
                                Navigator.pushNamed(
                                    context, LocalServerScreen.id);
                              },
                              label: "تنظیمات سرور",
                              buttonLabel: "تعیین سرور"),

                          const CText(
                            "متفرقه",
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                          ButtonTile(
                              onPress: () {
                                Navigator.pushNamed(context, StorageManageScreen.id);
                              },
                              label: "مدیریت داده ها",
                              buttonLabel: "رفتن به صفحه مدیریت"),

                          ///back to app Type screen
                          ButtonTile(
                              onPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CustomAlert(
                                    title:
                                        "آیا از تغییر نوع برنامه (اصلی به سفارشگیر) مطمئن هستید؟",
                                    onNo: () {
                                      Navigator.pop(context);
                                    },
                                    onYes: () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          AppTypeScreen.id, (context) => false);
                                    },
                                  ),
                                );
                              },
                              label: "تغییر نوع کاربری برنامه",
                              buttonLabel: "تغییر"),

                          ///developer section
                          const CText(
                            "توسعه دهنده",
                            fontSize: 16,
                            color: Colors.white60,
                          ),
                          ButtonTile(
                              onPress: () {
                                Navigator.pushNamed(context, BugListScreen.id);
                              },
                              label: "error List",
                              buttonLabel: "see"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              ///**************************************************************************************************
              ///condition for:if user not purchase the app,it will see purchase button to buy complete version
              userProvider.userLevel != 0
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.black87.withOpacity(.7),
                      //height: MediaQuery.of(context).size.height,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "برای استفاده از این بخش نسخه کامل برنامه را فعال کنید.",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          PurchaseButton(),
                        ],
                      ),
                    ),
            ],
          );
        }),
      ),
    );
  }
}

///switch field
class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.onChange,
  });

  final String title;
  final void Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(value: false, onChanged: onChange),
          ],
        ),
      ),
    );
  }
}

///drop list field
class DropListItem extends StatelessWidget {
  const DropListItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.listItem,
    required this.onChange,
    this.dropWidth = 80,
  });

  final String title;
  final String selectedValue;
  final List<String> listItem;
  final void Function(String) onChange;
  final double dropWidth;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            DropListModel(
                elevation: 0,
                width: dropWidth,
                height: 30,
                listItem: listItem,
                selectedValue: selectedValue,
                onChanged: onChange),
          ],
        ),
      ),
    );
  }
}

///text field field
class InputItem extends StatelessWidget {
  const InputItem(
      {super.key,
      required this.controller,
      this.onChange,
      this.width = 150,
      required this.label,
      required this.inputLabel});

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            CustomTextField(
                label: inputLabel,
                controller: controller,
                width: width,
                textFormat: TextFormatter.number,
                onChange: onChange)
          ],
        ),
      ),
    );
  }
}

///text field field
class ButtonTile extends StatelessWidget {
  const ButtonTile({
    super.key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
  });

  final String label;
  final String buttonLabel;
  final VoidCallback onPress;
  final double width;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            SizedBox(
              child: extra,
            ),
            OutlinedButton(
              onPressed: onPress,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
