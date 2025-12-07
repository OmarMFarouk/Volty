import 'package:flutter/material.dart';

extension DevicesChecker on BuildContext {
  bool get isSmall => MediaQuery.sizeOf(this).width < 400;
}
