import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_text.dart';
import 'package:hitop_cafe/constants/constants.dart';

class CheckButton extends StatelessWidget {
  const CheckButton({
    super.key, required this.label, required this.value, required this.onChange, this.icon,
  });
  final String label;
  final bool value;
  final IconData? icon;
  final Function(bool? val) onChange;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChange(!value);
      },
      child: Container(
          height: 20,
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              color: value?kMainColor:Colors.black26,
              borderRadius: BorderRadius.circular(5)
          ),
          child:Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon!=null)
                Icon(icon,color:value? Colors.white:Colors.black54,size: 17,),
              if(icon!=null)
                const SizedBox(width: 3,),
              CText(label,fontSize: 10,color:value? Colors.white:Colors.black54,),
              const SizedBox(width: 5,),
              Transform.scale(
                scale:.7,
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: Checkbox(
                    value: value,
                    onChanged: onChange,
                    side: const BorderSide(width: .1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    splashRadius: 1,
                  ),
                ),)
            ],
          )),
    );
  }
}
