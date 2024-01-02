import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/providers/client_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';
import 'package:provider/provider.dart';

class WaiterSettingScreen extends StatefulWidget {
  static const String id = "/waiter-setting-screen";
  const WaiterSettingScreen({super.key});

  @override
  State<WaiterSettingScreen> createState() => _WaiterSettingScreenState();
}

class _WaiterSettingScreenState extends State<WaiterSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final subnetController = TextEditingController();
  final portController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final messageController = TextEditingController();

  bool ipRunning = false;

  @override
  void initState() {
   subnetController.text= Provider.of<ClientProvider>(context,listen: false).subnet;
   portController.text= Provider.of<ClientProvider>(context,listen: false).port.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تنظیمات"),
      ),
      body: Consumer<ClientProvider>(builder: (context, clientProvider, child) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if(clientProvider.searching)
              const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(strokeWidth: 1.5,),
              )
              else
              Container(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (clientProvider.address != null)
                Wrap(
                spacing: 5,
                children: [
                  ActionButton(icon:clientProvider.client!.isConnected? Icons.close:Icons.check,label: clientProvider.client!.isConnected
                      ? "disconnect"
                      : "connect",bgColor: clientProvider.client!.isConnected
                      ? Colors.red
                      : Colors.green,
                    onPress: () async{
                    if(clientProvider.client!.isConnected){
                      clientProvider.client!.disconnect(clientProvider.pack);
                    }else {
                     await clientProvider.client!.connect(clientProvider.pack);
                    }
                    setState(() {});
                    },
                  ),
                  CText(clientProvider.address!.ip,fontSize: 20,color:Colors.green,),
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
                            label: "subnet", controller: subnetController),
                      ),
                    ],
                  ),
                ),
              const Gap(20),
              ActionButton(
                icon: Icons.search,
                label: "جست و جو",
                onPress: () {
                  if(_formKey.currentState!.validate()) {
                    clientProvider.setSubnetAndPort(subnetController.text, int.parse(portController.text));
                    clientProvider.getIpAddress();

                   // setState(() {});
                  }
                },
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                      const InputDecoration(label: Text("message")),
                      controller: messageController,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                       Pack newPack= clientProvider.pack;
                       newPack.message=messageController.text;
                        clientProvider
                            .sendPack(newPack);
                        messageController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.send)),
                ],
              ),
              const Gap(20),
              ///result part
              Flexible(
                child: Container(
                  height: 300,
                  width: 350,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView(
                    children: clientProvider.logs
                        .map(
                          (e) => Card(
                        child: ListTile(
                          title: CText(
                            e.device,
                          ),
                          subtitle:CText(
                            e.message,
                          ),
                          trailing: CText(e.date.toString()),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
