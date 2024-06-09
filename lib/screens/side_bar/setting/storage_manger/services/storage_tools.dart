import 'package:hitop_cafe/models/bill.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

class StorageTools {
  ///delete Orders
  static deleteOrders({DateTime? begin, DateTime? end}) {
    List<Order> orders = HiveBoxes.getOrders().values.toList();
    if (begin != null && end != null) {
      for (Order element in orders) {
        if (element.orderDate.isBefore(end) &&
            element.orderDate.isAfter(begin)) {
          element.delete();
        }
      }
    }
  }

  ///delete Items
  static deleteItems({DateTime? begin, DateTime? end}) {
    List<Item> items = HiveBoxes.getItem().values.toList();
    if (begin != null && end != null) {
      for (Item element in items) {
        if (element.createDate.isBefore(end) &&
            element.createDate.isAfter(begin)) {
          element.delete();
        }
      }
    }
  }

  ///delete Wares
  static deleteWares({DateTime? begin, DateTime? end}) {
    List<RawWare> wares = HiveBoxes.getRawWare().values.toList();
    if (begin != null && end != null) {
      for (RawWare element in wares) {
        if (element.createDate.isBefore(end) &&
            element.createDate.isAfter(begin)) {
          element.delete();
        }
      }
    }
  }

  ///delete Bills
  static deleteBills({DateTime? begin, DateTime? end}) {
    List<Bill> bills = HiveBoxes.getBills().values.toList();
    if (begin != null && end != null) {
      for (Bill element in bills) {
        if (element.billDate.isBefore(end) && element.billDate.isAfter(begin)) {
          element.delete();
        }
      }
    }
  }
}
