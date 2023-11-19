import 'dart:typed_data';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart';

import 'package:flutter/services.dart';




class PrintServices {


  void escPosPrint(String printerIp, Uint8List unit8File) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    generator.rawBytes(unit8File);
    generator.feed(2);
    generator.cut();

    }
  }
