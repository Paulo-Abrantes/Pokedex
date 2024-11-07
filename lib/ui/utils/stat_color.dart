import 'package:flutter/material.dart';

Color getStatColor(int statValue) {
  if (statValue >= 130) {
    return Colors.blueAccent[800]!;
  } else if (statValue >= 100) {
    return Colors.green[400]!;
  } else if (statValue >= 60) {
    return Colors.green;
  } else {
    statValue >= 31;
    {
      return Colors.green;
    }
  }
}