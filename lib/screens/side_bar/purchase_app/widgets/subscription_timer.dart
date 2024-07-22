import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/custom_text.dart';

class SubscriptionDeadLine extends StatelessWidget {
  const SubscriptionDeadLine({
    super.key,
    required this.endDate,
    this.borderRadius = 10,
    this.showDays = true,
  });

  final DateTime? endDate;
  final double borderRadius;
  final bool showDays;
  @override
  Widget build(BuildContext context) {
    ///if subs endDate is null
    if (endDate == null && showDays) {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.blueGrey,
        ),
        child: const CText(
          "شما هیچ اشتراک فعالی ندارید",
          color: Colors.white,
          fontSize: 11,
        ),
      );
    }

    ///day left of subs
    else if (endDate != null &&
        DateTime.now().isBefore(endDate!.subtract(const Duration(days: 5))) &&
        showDays) {
      Duration leftDays = endDate!.difference(DateTime.now());
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CText(
          "${leftDays.inDays}روز از اشتراک شما باقی مانده است",
          color: Colors.white,
          fontSize: 11,
        ),
      );
    }

    ///last five day left of subs
    else if (endDate != null &&
        DateTime.now().isAfter(endDate!.subtract(const Duration(days: 5))) &&
        DateTime.now().isBefore(endDate!)) {
      Duration leftDays = endDate!.difference(DateTime.now());
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.orangeAccent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CText(
          "${leftDays.inDays}روز از اشتراک شما باقی مانده است",
          color: Colors.white,
          fontSize: 11,
        ),
      );
    }

    ///if subs has been ended
    else if (endDate != null && DateTime.now().isAfter(endDate!)) {
      return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.red,
        ),
        child: const CText(
          "اشتراک شما به پایان رسیده است",
          color: Colors.white,
          fontSize: 11,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
