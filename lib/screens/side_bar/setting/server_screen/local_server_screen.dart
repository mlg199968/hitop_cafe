import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/providers/sever_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';

class LocalServerScreen extends StatefulWidget {
  static const String id = "/local-server-screen";
  const LocalServerScreen({super.key});

  @override
  State<LocalServerScreen> createState() => _LocalServerScreenState();
}

class _LocalServerScreenState extends State<LocalServerScreen> {
  final networkInfo = NetworkInfo();
  final messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ipController = TextEditingController();
  final portController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    portController.text =
        Provider.of<ServerProvider>(context, listen: false).port.toString();
    ipController.text = Provider.of<ServerProvider>(context, listen: false).ip;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("server Screen"),
      ),
      body: Consumer<ServerProvider>(builder: (context, serverProvider, child) {
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 450,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ActionButton(
                      label: "default ip",
                      icon: Icons.system_update_tv,
                      bgColor: Colors.teal,
                      onPress: () async {
                        String? ip = await networkInfo.getWifiIP();
                        if (ip != null) {
                          ipController.text = ip;
                          serverProvider.setIpAndPort(ip, 4000);
                          setState(() {});
                        }
                      },
                    ),
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
                    const Gap(20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        children: [
                          ///create server button
                          ActionButton(
                            icon: Icons.circle,
                            label: "ایجاد سرور",
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                serverProvider.setIpAndPort(ipController.text,
                                    int.parse(portController.text));
                                serverProvider.initServer();
                                setState(() {});
                              }
                            },
                          ),

                          ///cancel server button
                          ActionButton(
                            label: "طرد",
                            icon: Icons.cancel_outlined,
                            bgColor: Colors.red,
                            onPress: () {
                              serverProvider.closeServer();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),

                    ///start or stop server button
                    if (serverProvider.server != null)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: serverProvider.server!.running
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ActionButton(
                              onPress: () async {
                                await serverProvider.startOrCloseServer();
                              },
                              icon: serverProvider.server!.running
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              label: serverProvider.server!.running
                                  ? "stop"
                                  : "start",
                              bgColor: serverProvider.server!.running
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            CText(
                              serverProvider.server!.running
                                  ? "سرور فعال است"
                                  : "سرور غیر فعال است",
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    const Gap(20),
                    ActionButton(
                      label: "ارسال آیتم ها به کاربران",
                      icon: Icons.warehouse,
                      bgColor: Colors.indigoAccent,
                      onPress: () {
                        List itemsJson = HiveBoxes.getItem()
                            .values
                            .map((e) => e.toJson())
                            .toList();
                        Pack newPack = serverProvider.samplePack;
                        newPack
                          ..type = PackType.itemList.value
                          ..object = itemsJson
                          ..message = "لیست آیتم های ارسال شده از سمت سرور";
                        serverProvider.handleMessage(newPack);
                        setState(() {});
                      },
                    ),
                    const Gap(10),
                    ActionButton(
                      label: "ارسال پیش نیاز ها به کاربران",
                      icon: Icons.medical_information,
                      onPress: () {
                        List waresJson = HiveBoxes.getRawWare()
                            .values
                            .map((e) => e.toJson())
                            .toList();
                        Pack newPack = serverProvider.samplePack;
                        newPack
                          ..type = PackType.wareList.value
                          ..object = waresJson
                          ..message = "لیست پیش نیاز های ارسال شده از سمت سرور";
                        serverProvider.handleMessage(newPack);
                        setState(() {});
                      },
                    ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "ارسال پیام به کاربران",
                            controller: messageController,
                          ),
                        ),

                        ///send button
                        IconButton(
                            onPressed: () {
                              Pack newPack = serverProvider.samplePack;
                              newPack.message = messageController.text;
                              serverProvider.handleMessage(newPack);
                              messageController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.send)),

                        ///clear button
                        IconButton(
                            onPressed: () {
                              serverProvider.clearLogs();
                            },
                            icon: const Icon(Icons.clear)),
                      ],
                    ),
                    const Gap(20),

                    ///result part
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: serverProvider.serverLogs
                            .map(
                              (e) => Card(
                                child: ListTile(
                                  tileColor: e.device == "Server"
                                      ? Colors.blueGrey
                                      : null,
                                  title: CText(
                                    e.device,
                                    fontSize: 16,
                                  ),
                                  subtitle: CText(
                                    e.message,
                                    color: Colors.black54,
                                  ),
                                  trailing: CText(
                                    e.date.toPersianDate(
                                        showTimeSecond: true, showTime: true),
                                    fontSize: 10,
                                    color: Colors.black38,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
