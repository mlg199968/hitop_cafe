

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
extension TouchScroll on ScrollBehavior {
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
  ScrollBehavior addTouch() {
return this;
  }
}

extension PrinterExtension  on Printer {
  Printer copyWith({bool? isDefault}) {
    return Printer(isDefault:isDefault ?? this.isDefault,
    url:url,
    name:name,
    comment:comment,
    isAvailable:isAvailable,
    location:location,
    model:model);
  }
}