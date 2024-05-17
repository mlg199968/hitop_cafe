import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:provider/provider.dart';

class DescriptionBar extends StatelessWidget {
  const DescriptionBar({
    super.key,
    required this.controller,
    required this.onChange,
    this.id,
    this.soloDes = false,
  });
  final TextEditingController controller;
  final String? id;
  final bool soloDes;
  final Function(String? val) onChange;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      userProvider.sortDescription(id);
      return Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///description list
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: userProvider.descriptionList.map((Map des) {
                    Widget desTile = InkWell(
                      onTap: () {
                        onChange(des["value"]);
                      },
                      onLongPress: () {
                        userProvider.removeDescription(des);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black45),
                        ),
                        child: Text(
                          des["value"],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    );
                    ///this condition is to isolate description if soloDescription is true
                    ///on the other hand if description is private it not being show if  des id != des textfield id
                    if (soloDes == true) {
                      if (des["id"] == id) {
                        return desTile;
                      } else {
                        return const SizedBox();
                      }
                    }
                    else {
                      if (des["id"] != id && des["isPrivate"] == 1) {
                        return const SizedBox();
                      } else {
                        return desTile;
                      }
                    }
                  }).toList(),
                ),
              ),
            ),

            ///add description button
            IconButton(
                onPressed: () {
                  //here first we check if entered description exist in list or not ,if not exist we added to list
                  //then we save list in hive
                  if (controller.text.isNotEmpty &&
                      !userProvider.descriptionList
                          .map((e) => e["value"])
                          .contains(controller.text)) {
                    userProvider.addDescription({
                      "id": id,
                      "value": controller.text,
                      "isPrivate": soloDes?1:0
                    });
                    Shop shop = HiveBoxes.getShopInfo().values.single;
                    shop.descriptionList =
                        userProvider.descriptionList.toSet().toList();
                    HiveBoxes.getShopInfo().putAt(0, shop);
                  }
                },
                icon: const Icon(CupertinoIcons.plus_rectangle_fill)),
          ],
        ),
      );
    });
  }
}
