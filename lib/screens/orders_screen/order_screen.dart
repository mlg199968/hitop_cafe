

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_float_action_button.dart';

class OrderScreen extends StatelessWidget {
  static const String id="/order-screen";
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Text("orderScreen")),
      floatingActionButton: CustomFloatActionButton(
          onPressed: (){

      }),
    );
  }
}
