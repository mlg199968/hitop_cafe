import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_icon_button.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
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
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: kBlackWhiteGradiant,
          ),

          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                              controller: ipController,
                          suffixIcon:CustomIconButton(
                            label: "default ip",
                            icon: Icons.system_update_tv,
                            onPress: () async {
                              String? ip = await networkInfo.getWifiIP();
                              if (ip != null) {
                                ipController.text = ip;
                                serverProvider.setIpAndPort(ip, 4000);
                                setState(() {});
                              }
                            },
                          ),),
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
                            bgColor: Colors.black,
                            label: "احراز سرور",
                            iconColor: serverProvider.server!=null?(serverProvider.server!.running
                                ? Colors.green
                                : Colors.redAccent):null,
                            onPress: () {
                              try{
                              if (_formKey.currentState!.validate()) {
                                serverProvider.setIpAndPort(ipController.text,
                                    int.parse(portController.text));
                                serverProvider.initServer();
                                serverProvider.startOrCloseServer().onError((error, stackTrace) => ErrorHandler.errorManger(context, error,title: "خطا در احراز ای پی سرور",showSnackbar: true));

                               // showSnackBar(context, "سرور احراز شد",type: SnackType.success);
                                setState(() {});
                              }}catch(e){
                                ErrorHandler.errorManger(context, e,title: "خطا در احراز ای پی سرور",showSnackbar: true);
                              }
                            },
                          ),

                          ///cancel server button
                          ActionButton(
                            label: "طرد",
                            icon: Icons.cancel_outlined,
                            bgColor: Colors.black,
                            iconColor: Colors.red,
                            onPress: () {
                              serverProvider.closeServer();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    if(serverProvider.server != null && serverProvider.server!.running)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ///send items and wares button
                        ActionButton(
                          label: "ارسال آیتم ها به کاربران",
                          icon: Icons.warehouse,
                          onPress: () async{
                            List waresJson = HiveBoxes.getRawWare()
                                .values
                                .map((e) => e.toJson())
                                .toList();
                            Pack itemsPack = serverProvider.samplePack;
                            itemsPack
                              ..type = PackType.wareList.value
                              ..object = waresJson
                              ..message = "لیست پیش نیاز های ارسال شده از سمت سرور";
                            serverProvider.handleMessage(itemsPack);
                            await Future.delayed(const Duration(milliseconds: 1000));
                            List itemsJson = HiveBoxes.getItem()
                                .values
                                .map((e) => e.toJson())
                                .toList();
                            Pack waresPack = serverProvider.samplePack;
                            waresPack
                              ..type = PackType.itemList.value
                              ..object = itemsJson
                              ..message = "لیست آیتم های ارسال شده از سمت سرور";
                            serverProvider.handleMessage(waresPack);
                            setState(() {});
                          },
                        ),
                        const Gap(20),
                        ///send message textfield
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
                            children: serverProvider.serverLogs.reversed
                                .map(
                                  (e) => Card(
                                    surfaceTintColor: Colors.white,
                                child: ListTile(
                                  title: CText(
                                    e.device,
                                    color:e.device == "Server"
                                        ? Colors.blueGrey
                                        : null,
                                    fontSize: 12,
                                  ),
                                  subtitle: CText(
                                    e.message,
                                    color: Colors.black54,
                                    fontSize: 11,
                                  ),
                                  trailing: CText(
                                    e.date.toPersianDate(
                                        showTimeSecond: true, showTime: true),
                                    fontSize: 9,
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
