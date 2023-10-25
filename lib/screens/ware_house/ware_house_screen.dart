

import 'package:flutter/material.dart';

class WareHouseScreen extends StatelessWidget {
  static const String id="/ware_house_screen";
  const WareHouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: const EdgeInsets.all(20),
        child: const Center(child: Text("Ware House Screen")),
      ),
    );
  }
}
