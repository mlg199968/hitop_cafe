import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_alert_dialog.dart';
import 'package:hitop_cafe/models/bug.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class BugDetailPanel extends StatelessWidget {
  const BugDetailPanel({super.key, required this.bug});
  final Bug bug;
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      borderRadius: 8,
      opacity: 1,
      height: 450,
      title: bug.bugDate.toPersianDateStr(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bug.title ?? "",
                style: const TextStyle(fontSize: 20),
                maxLines: 4,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                bug.errorText ?? "",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${bug.bugDate.toPersianDate()}  ${bug.bugDate.hour}:${bug.bugDate.minute}",
                style: const TextStyle(fontSize: 14, color: Colors.black45),
              ),
              const SizedBox(
                height: 20,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
