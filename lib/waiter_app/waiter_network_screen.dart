import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_icon_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/hide_keyboard.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class WaiterNetworkScreen extends StatefulWidget {
  static const String id = "/waiter-setting-screen";
  const WaiterNetworkScreen({super.key});

  @override
  State<WaiterNetworkScreen> createState() => _WaiterNetworkScreenState();
}

class _WaiterNetworkScreenState extends State<WaiterNetworkScreen> {
  final _formKey = GlobalKey<FormState>();
  final subnetController = TextEditingController();
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final messageController = TextEditingController();

  bool ipRunning = false;

  saveData() {
    Shop shop = HiveBoxes.getShopInfo().get(0) ?? Shop();
    shop
      ..port = int.parse(portController.text)
      ..ipAddress = ipController.text
      ..subnet = subnetController.text;
    HiveBoxes.getShopInfo().putAt(0, shop);
  }

  restoreData() {
    Shop? shop = HiveBoxes.getShopInfo().get(0);
    if (shop != null) {
      portController.text = shop.port?.toString() ?? "4000";
      ipController.text = shop.ipAddress ?? "192.168.1.3";
      subnetController.text = shop.subnet ?? "192.168.1";
    }
  }

  @override
  void initState() {
    restoreData();
    super.initState();
  }

  @override
  void dispose() {
    saveData();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تنظیمات شبکه"),
        ),
        body:
            Consumer<ClientProvider>(builder: (context, clientProvider, child) {
          return Container(
            decoration: const BoxDecoration(gradient: kBlackWhiteGradiant),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ///subnet search
                          CustomTextField(
                              validate: true,
                              label: "subnet",
                              suffixIcon: CustomIconButton(
                                icon: Icons.search,
                                label: "جست و جو",
                                onPress: () {
                                  clientProvider.getIpAddress(subnet:subnetController.text,
                                      port:int.parse(portController.text));
                                  if (clientProvider.address != null) {
                                    print(clientProvider.address!.ip);
                                    ipController.text =
                                        clientProvider.address!.ip;
                                    setState(() {});
                                  }
                                },
                              ),
                              controller: subnetController),
                          const Gap(20),

                          if (clientProvider.searching)
                             Container(
                               margin:const EdgeInsets.all(10),

                              child:  Row(
                                children: [
                                  CustomIconButton(
                                    icon: Icons.close_rounded,
                                    onPress: (){
                                      clientProvider.getIpAddress(cancel: true);

                                    },
                                  ),
                                  SizedBox(
                                    height: 3,
                                    width: 100,
                                    child: LinearProgressIndicator(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (clientProvider.address != null)
                            CText(
                              clientProvider.address!.ip,
                              color: Colors.green,
                            )
                          else if (clientProvider.address == null)
                            const SizedBox()
                          else
                            const CText("سرور فعالی یافت نشد",color: Colors.black54,),
                        ],
                      ),
                      const Gap(50),
                      ///port & ip address
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                              label: "port",
                              textFormat: TextFormatter.number,
                              validate: true,
                              width: 100,
                              controller: portController),
                          const Gap(8),
                          Expanded(
                            child: CustomTextField(
                                validate: true,
                                label: "ip address",
                                controller: ipController),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (clientProvider.connecting)
                            const SizedBox(
                                width: 100,
                                child: LinearProgressIndicator(
                                  color: Colors.black54,
                                ))
                          else if (clientProvider.client != null &&
                              clientProvider.client!.isConnected)
                            const CText(
                              "کاربر به سرور متصل است",
                              color: Colors.teal,
                            )
                          else if (clientProvider.client == null ||
                              !clientProvider.client!.isConnected)
                            const CText(
                              "کاربر به سرور متصل نشد",
                              color: Colors.red,
                            )
                          else
                            const SizedBox(),
                          const Gap(10),

                          ///connection button
                          ActionButton(
                            icon: (clientProvider.client != null &&
                                    clientProvider.client!.isConnected)
                                ? Icons.close
                                : Icons.check,
                            label: (clientProvider.client != null &&
                                    clientProvider.client!.isConnected)
                                ? "disconnect"
                                : "connect",
                            bgColor: Colors.black,
                            iconColor: clientProvider.isConnected
                                ? Colors.red
                                : Colors.green,
                            borderRadius: 5,
                            onPress: () async {
                              if (_formKey.currentState!.validate()) {
                                await clientProvider.connectOrDisconnectClient(
                                    ipController.text,
                                    int.parse(portController.text));
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                      const Gap(20),

                      ///message part
                      if (clientProvider.client != null &&
                          clientProvider.client!.isConnected)
                        Column(
                          children: [
                            /// message textField
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: "ارسال پیام به سرور",
                                    controller: messageController,
                                  ),
                                ),

                                ///send message button
                                IconButton(
                                    onPressed: () async {
                                      String deviceName =
                                          await getDeviceInfo2(info: "name");
                                      Pack newPack = clientProvider.samplePack;
                                      newPack.message = messageController.text;
                                      newPack.device = deviceName;
                                      clientProvider.sendPack(newPack);
                                      messageController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.send)),

                                ///clear log button
                                IconButton(
                                    onPressed: () {
                                      clientProvider.clearLogs();
                                    },
                                    icon: const Icon(Icons.clear)),
                              ],
                            ),
                            const Gap(15),

                            ///result part
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: clientProvider.logs.reversed
                                    .map(
                                      (e) => Card(
                                        surfaceTintColor: Colors.white,
                                        child: ListTile(
                                          title: CText(
                                            e.device,
                                            fontSize: 16,
                                            color: e.device == "Server"
                                                ? Colors.blueGrey
                                                : null,
                                          ),
                                          subtitle: CText(
                                            e.message,
                                            color: Colors.black54,
                                          ),
                                          trailing: CText(
                                            e.date.toPersianDate(
                                                showTime: true,
                                                showTimeSecond: true),
                                            color: Colors.black38,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
