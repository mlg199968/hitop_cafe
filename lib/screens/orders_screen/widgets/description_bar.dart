import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DescriptionBar extends StatelessWidget {
  const DescriptionBar({super.key,required this.controller, required this.onChange});
final TextEditingController controller;
final Function(String? val)onChange;
  @override
  Widget build(BuildContext context) {

    return Consumer<UserProvider>(
      builder: (context,userProvider,child) {
        return Container(
          width: 300,
          padding: const EdgeInsets.all(5),
          child: Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: userProvider.descriptionList
                      .map(
                        (des) => InkWell(
                          onTap: (){
                            onChange(des);
                          },
                          onLongPress: (){
                            userProvider.removeDescription(des);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black45),
                            ),
                            child: Text(des,style: const TextStyle(fontSize: 11),),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if(controller.text.isNotEmpty && !userProvider.descriptionList.contains(controller.text) ){
                      userProvider.addDescription(controller.text);
                    }
                  },
                  icon: const Icon(CupertinoIcons.plus_rectangle_fill)),
            ],
          ),
        );
      }
    );
  }
}
