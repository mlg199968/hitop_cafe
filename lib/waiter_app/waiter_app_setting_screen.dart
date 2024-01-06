import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/side_bar/bug_screen/bug_list_screen.dart';
import 'package:hitop_cafe/screens/side_bar/setting/setting_screen.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/waiter_app/choose_app_type_screen.dart';
import 'package:provider/provider.dart';

class WaiterAppSettingScreen extends StatefulWidget {
  static const String id = "/waiter-app-setting-screen";
  const WaiterAppSettingScreen({super.key});

  @override
  State<WaiterAppSettingScreen> createState() => _WaiterAppSettingScreenState();
}

class _WaiterAppSettingScreenState extends State<WaiterAppSettingScreen> {
  final TextEditingController taxController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  final TextEditingController printerIpController = TextEditingController();
  late String selectedCurrency;
  String selectedFont = kFonts[0];
  late UserProvider provider;



  ///save setting
  void storeInfoShop() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    shopInfo ??= Shop();
    shopInfo
      ..currency = selectedCurrency
      ..fontFamily = selectedFont
      ..preTax = stringToDouble(taxController.text)
      ..preBillNumber = stringToDouble(billNumberController.text).toInt()
      ..printerIp=printerIpController.text;
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
    return Scaffold(
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
                    width: 450,
                    child: Column(
                      children: [

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
                        const CText(
                          "تنظیمات پرینتر",
                          fontSize: 16,
                          color: Colors.white60,
                        ),







                        const CText(
                          "متفرقه",
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                        ///back to app Type screen
                        ButtonTile(onPress: (){
                          Navigator.pushNamedAndRemoveUntil(context, AppTypeScreen.id,(context)=>false);
                        }, label: "تغییر نوع کاربری برنامه", buttonLabel:"تغییر"),
                        ///developer section
                        const CText(
                          "توسعه دهنده",
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                        ButtonTile(onPress: (){
                          Navigator.pushNamed(context, BugListScreen.id);
                        }, label: "error List", buttonLabel:"see"),
                      ],
                    ),
                  ),
                ),
              ),
            ),


          ],
        );
      }),
    );
  }
}
