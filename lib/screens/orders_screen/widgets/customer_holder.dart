import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/models/user.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../common/widgets/action_button.dart';
import '../../../common/widgets/custom_text.dart';
import '../../../constants/enums.dart';
import '../../../constants/utils.dart';
import '../../customer_screen/customer_list_screen.dart';
import '../../customer_screen/panels/customer_info_panel.dart';

///customer holder info
class CustomerInfoHolder extends StatelessWidget {
  static const String id = "CustomerInfoHolder";
  const CustomerInfoHolder(
      {super.key,
      this.customer,
      required this.onChange,
      this.margin,
      this.showBg = false});

  final User? customer;
  final Function(User? val) onChange;
  final EdgeInsets? margin;
  final bool showBg;

  @override
  Widget build(BuildContext context) {
    ///if customer is not being selected show add customer button
    if (customer == null) {
      return ActionButton(
        label: "انتخاب طرف حساب",
        borderRadius: 5,
        icon: Icons.person_add,
        onPress: () {
          Navigator.pushNamed(context, CustomerListScreen.id,
                  arguments: const Key("addBook"))
              .then((value) {
            if (value != null) {
              onChange(value as User);
            }
          });
        },
      );
    }

    ///
    else {
      return Container(
        padding: const EdgeInsets.all(5),
        margin: margin,
        decoration: showBg
            ? BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(8))
            : null,
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => CustomerInfoPanel(
                      customer!,
                      key: const Key(id),
                    )).then(
              (value) {
                if (value != null && value.runtimeType==User ) {
                  onChange(value as User);
                }else if(value=='delete'){
                  onChange(null);
                }
              },
            );
          },
          child: Flex(
            clipBehavior: Clip.none,
            mainAxisSize: MainAxisSize.min,
            direction: screenType(context) == ScreenType.mobile
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              ///image holder
              Flexible(
                child: CircleAvatar(
                  minRadius: 20,
                  maxRadius: 40,
                  foregroundImage: customer?.image != null
                      ? FileImage(
                          File(customer!.image!),
                        )
                      : null,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
              ),
              const Gap(8),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: CText(
                        "${customer!.name} ${customer!.lastName}",
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    if (customer!.nickName != "")
                      Flexible(
                        child: CText(
                          customer!.nickName,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    if (customer!.phone != "")
                      Flexible(
                        child: CText(
                          customer!.phones.toPersianDigit(),
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    Flexible(
                      child: CText(customer!.description,
                          fontSize: 10, color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
