import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class InfoPanelRow extends StatelessWidget {
  const InfoPanelRow({super.key, required this.infoList, required this.title});

  final String infoList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                ))),
        width: MediaQuery.of(context).size.width * .5,
        padding: const EdgeInsets.only(bottom: 10),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.toPersianDigit()),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Text(
                infoList.toPersianDigit(),
                textAlign: TextAlign.left,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}