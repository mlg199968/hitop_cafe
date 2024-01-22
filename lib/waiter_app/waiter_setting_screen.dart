import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/common/widgets/action_button.dart';
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
  final portController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final messageController = TextEditingController();

  bool ipRunning = false;

  @override
  void initState() {
    subnetController.text =
        Provider.of<ClientProvider>(context, listen: false).subnet;
    portController.text =
        Provider.of<ClientProvider>(context, listen: false).port.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تنظیمات"),
      ),
      body: Consumer<ClientProvider>(builder: (context, clientProvider, child) {
        return SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 450,
              child: Column(
                children: [
                  if (clientProvider.searching)
                    const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    )
                  else
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (clientProvider.address != null)
                            Wrap(
                              spacing: 5,
                              children: [
                                ActionButton(
                                  icon: clientProvider.client!.isConnected
                                      ? Icons.close
                                      : Icons.check,
                                  label: clientProvider.client!.isConnected
                                      ? "disconnect"
                                      : "connect",
                                  bgColor: clientProvider.isConnected
                                      ? Colors.red
                                      : Colors.green,
                                  onPress: () async {
                                    await clientProvider
                                        .connectOrDisconnectClient();
                                    setState(() {});
                                  },
                                ),
                                CText(
                                  clientProvider.address!.ip,
                                  fontSize: 20,
                                  color: Colors.green,
                                ),
                              ],
                            )
                          else
                            const Text("No device found"),

                          // const Gap(10),
                          // CustomTextField(
                          //     label: "نام کاربری", controller: userNameController),
                          // const Gap(10),
                          // CustomTextField(
                          //     label: "پسوورد", controller: passwordController),
                        ],
                      ),
                    ),
                  Form(
                    key: _formKey,
                    child: Row(
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
                              label: "subnet",
                              controller: subnetController),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  ActionButton(
                    icon: Icons.search,
                    label: "جست و جو",
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        clientProvider.setSubnetAndPort(subnetController.text,
                            int.parse(portController.text));
                        clientProvider.getIpAddress();

                        // setState(() {});
                      }
                    },
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: "ارسال پیام به سرور",
                          controller: messageController,
                        ),
                      ),

                      ///send message button button
                      IconButton(
                          onPressed: () async{
                            String deviceName=await getDeviceInfo(info:"name");
                            Pack newPack = clientProvider.samplePack;
                            newPack.message = messageController.text;
                            newPack.device=deviceName;
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
                  const Gap(20),

                  ///result part
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: clientProvider.logs
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
                                      showTime: true, showTimeSecond: true),
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
            ),
          ),
        );
      }),
    );
  }
}
