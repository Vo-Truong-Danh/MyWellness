
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../widget/canhbaohr.dart';

void Showdialoghomepage (BuildContext context, Color ColorHr,double Hr){
  if (ColorHr == Colors.orange) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Canhbaohr(HR: Hr),
      barrierDismissible: true,
    );
  }
  if (ColorHr == Colors.red) {
    showDialog(
      context: context,
      builder: (BuildContext context) => NguyHiemHR(HR: Hr),
      barrierDismissible: true,
    );
  }
}