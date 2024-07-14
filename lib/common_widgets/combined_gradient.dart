import 'package:fitness/common_widgets/selected_tabIcon.dart';
import 'package:fitness/common_widgets/selected_tabText.dart';
import 'package:flutter/material.dart';


class GradientIconWithText extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;

  GradientIconWithText({
    required this.icon,
    required this.label,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientIcon(
          icon: icon,
          size: 30.0,
          gradient: gradient,
        ),
        GradientText(
          text: label,
          style: TextStyle(fontSize: 15),
          gradient: gradient,
        ),
      ],
    );
  }
}
