
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/providers/sever_provider.dart';
import 'package:hitop_cafe/screens/raw_ware_screen/widgets/action_button.dart';
import 'package:network_info_plus/network_info_plus.dart';
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
    portController.text=Provider.of<ServerProvider>(context,listen: false).port.toString();
    ipController.text=Provider.of<ServerProvider>(context,listen: false).ip;
    super.initState();}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("server Screen"),
      ),
      body: Consumer<ServerProvider>(builder: (context, serverProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ActionButton(
                  label: "default ip",
                  icon: Icons.system_update_tv,
                  bgColor: Colors.teal,
                  onPress: () async{
                    String? ip= await networkInfo.getWifiIP();
                    if(ip!=null) {
                      ipController.text=ip;
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
                          label: "ip address", controller: ipController),
                    ),
                  ],
                ),
                const Gap(20),
                Wrap(
                  spacing: 8,
                  children: [
                    ///create server button
                    ActionButton(
                      icon: Icons.circle,
                      label: "ایجاد سرور",
                      onPress: () {
                        if(_formKey.currentState!.validate()) {
                          serverProvider.setIpAndPort(ipController.text, int.parse(portController.text));
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
                          serverProvider.setServer(null);
                          setState(() {});

                      },
                    ),
                  ],
                ),
                const Gap(20),
                if(serverProvider.server!=null)
                Row(
                  children: [
                    ActionButton(
                      onPress: () async{
                        await serverProvider.startOrCloseServer();
                      },
                      icon:serverProvider.server!.running?Icons.stop:Icons.play_arrow,
                      label: serverProvider.server!.running?"stop":"start",
                      bgColor: serverProvider.server!.running?Colors.red:Colors.green,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: serverProvider.server!.running?Colors.green:Colors.red,borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        serverProvider.server!.running?"server is running":"server is stopped!",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text("message")),
                        controller: messageController,
                      ),
                    ),
                    IconButton(onPressed: (){
                      serverProvider.handleMessage(messageController.text);
                      messageController.clear();
                      setState(() {});
                    }, icon: const Icon(Icons.send)),
                  ],
                ),
                const Gap(20),

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
                      children:serverProvider.serverLogs.map((e) => Card(
                        child: ListTile(
                          title: CText(
                            e.device,
                          ),
                          subtitle:CText(
                            e.message,
                          ),
                          trailing: CText(e.date.toString()),
                        ),
                      ),).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}