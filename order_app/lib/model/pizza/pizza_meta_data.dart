import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class PizzaMetaData{
  final Uint8List imagesByte;
  final Offset position;
  final Size size;

  PizzaMetaData(this.imagesByte, this.position, this.size);

}