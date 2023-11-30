import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/printer_provider.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:hitop_cafe/screens/side_bar/setting/backup/backup_tools.dart';
import 'package:hitop_cafe/screens/side_bar/setting/print-services/print_services.dart';
import 'package:hitop_cafe/screens/side_bar/setting/print_screen.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController taxController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  late String selectedCurrency;
  String selectedFont = kFonts[0];
  late UserProvider provider;

  ///printer
  Printer? selectedPrinter;

  ///android printer
  BluetoothDevice? selectedBluetoothPrinter;
  final bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
  bool isBtScanning = false;
  final devices = <BluetoothDevice>[];
  final _isBle = true;

  ///save setting
  void storeInfoShop() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    shopInfo ??= Shop();
    shopInfo
      ..currency = selectedCurrency
      ..fontFamily = selectedFont
      ..preTax = stringToDouble(taxController.text)
      ..preBillNumber = stringToDouble(billNumberController.text).toInt()
      ..printer = selectedPrinter == null ? null : selectedPrinter!.toMap();
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
      selectedPrinter =
          shopInfo.printer != null ? Printer.fromMap(shopInfo.printer!) : null;
    }
  }

  void selectDevice(BluetoothDevice device) async {
    if (selectedBluetoothPrinter != null) {
      if (device.address != selectedBluetoothPrinter!.address) {
        await bluetoothManager.disconnect();
      }
    }

    selectedBluetoothPrinter = device;
    setState(() {});
  }

  @override
  void initState() {
    selectedCurrency = kCurrencyList[0];
    getData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
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
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        decoration:
                            BoxDecoration(border: Border.all(color: Colors.blue)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              text: "پشتیبان گیری",
                              color: Colors.red.withRed(250),
                              onPressed: () async {
                                await storagePermission(
                                    context, Allow.externalStorage);
                                // ignore: use_build_context_synchronously
                                await storagePermission(context, Allow.storage);
                                if (context.mounted) {
                                  await BackupTools.createBackup(context);
                                }
                              },
                            ),
                            CustomButton(
                              text: "بارگیری فایل پشتیبان",
                              color: Colors.green,
                              onPressed: () async {
                                await storagePermission(context, Allow.storage);
                                if (context.mounted) {
                                  await storagePermission(
                                      context, Allow.externalStorage);
                                }
                                if (context.mounted) {
                                  // await BackupTools.restoreBackup(context);
                                  await BackupTools.readZipFile(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
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
                        userProvider.getFontFamily(val);
                        setState(() {});
                      },
                    ),

                    ///printers setting parts
                    const Text(
                      "تنظیمات پرینتر",
                      style: TextStyle(fontSize: 17),
                    ),

                    ///list of windows printers when platform is windows
                    if (Platform.isWindows)
                      ButtonTile(
                          onPress: () async {
                            // Show the native printer picker and get the selected printer
                            final printer = await Printing.pickPrinter(
                                context: context, title: "پرینتر را انتخاب کنید");
                            if (printer != null) {
                              selectedPrinter = printer;
                            }
                            setState(() {});
                          },
                          label: "انتخاب پرینتر",
                          buttonLabel: selectedPrinter == null
                              ? "پرینتری یافت نشد"
                              : selectedPrinter!.name),

                    ///list of bluetooth devices in android and ios if exist
                    if (Platform.isAndroid || Platform.isIOS)
                      ButtonTile(
                        label: "انتخاب پرینتر بلوتوثی",
                        buttonLabel: isBtScanning
                            ? "درحال اسکن"
                            : selectedBluetoothPrinter == null
                                ? "پرینتری یافت نشد"
                                : selectedBluetoothPrinter!.name,
                        extra: isBtScanning
                            ? const CircularProgressIndicator()
                            : ActionButton(
                                bgColor: Colors.white70,
                                icon: Icons.search,
                                onPress: () {
                                  Navigator.pushNamed(context, PrinterPage.id);
                                },
                              ),
                        onPress: () async {
                          // Show the native printer picker and get the selected printer
                          isBtScanning = true;
                          await PrintServices.scanSimpleBluetoothDevices(_isBle,
                              onChange: (btList, scanning) {
                            isBtScanning = scanning!;
                            if (btList != null) {
                              devices.addAll(btList);
                              setState(() {});
                            }
                          });
                          Column(
                              children: devices
                                  .map(
                                    (device) => ListTile(
                                      title: Text(device.name),
                                      subtitle: Text(device.address),
                                      onTap: () {
                                        // do something
                                        selectDevice(device);
                                      },
                                    ),
                                  )
                                  .toList());
                        },
                      ),
                  ],
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
                              style: TextStyle(color: Colors.white, fontSize: 18),
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
      {Key? key,
      required this.controller,
      this.onChange,
      this.width = 150,
      required this.label,
      required this.inputLabel})
      : super(key: key);

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    Key? key,
    required this.onPress,
    this.width = 150,
    required this.label,
    required this.buttonLabel,
    this.extra,
  }) : super(key: key);

  final String label;
  final String buttonLabel;
  final VoidCallback onPress;
  final double width;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            ElevatedButton(
              onPressed: onPress,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
