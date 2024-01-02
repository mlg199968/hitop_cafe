import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:provider/provider.dart';


class TextDataField extends StatelessWidget {
  const TextDataField({Key? key, required this.title, required this.value,this.color=Colors.black87,this.showCurrency=false}) : super(key: key);
  final String title;
  final num value;
  final Color color;
  final bool showCurrency;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: color,fontSize: 13),
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            CText(addSeparator(value),textDirection: TextDirection.ltr,color: color,fontSize: 13),
            const Gap(2),
            if(showCurrency)
            CText(context.watch<UserProvider>().currency,textDirection: TextDirection.ltr,color: color.withOpacity(.7),fontSize: 8),
          ],
        ),
      ],
    );
  }
}