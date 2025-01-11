import 'package:flutter/material.dart';
import 'package:your_app_name/core/theme/app_theme.dart';

class SpinWheelItem {
  final String label;
  final int value;
  final Color color;

  const SpinWheelItem({
    required this.label,
    required this.value,
    this.color = AppColors.accent,
  });
}
