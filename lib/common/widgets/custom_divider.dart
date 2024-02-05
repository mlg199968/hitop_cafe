

import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key,this.color,this.title});
      final Color? color;
      final String? title;



  @override
  Widget build(BuildContext context) {
    double indent=0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1,height:50,indent: indent,endIndent: indent,color: color ?? Colors.black12 ,)),
          SizedBox(
            child: title==null?null:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(title!,style: TextStyle(color:color ?? Colors.black38,fontSize: 16 ,fontFamily: "arial"),),
            ),
          ),
          Expanded(child: Divider(thickness: 1,height:50,indent: indent,endIndent: indent,color: color ?? Colors.black12 ,)),
        ],
      ),
    );
  }
}
