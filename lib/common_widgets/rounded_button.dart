import 'package:fitness/common/color_extension.dart';
import 'package:flutter/material.dart';

enum RoundedButtonType { bgGradient, bgSGradient, textGradient }

class RoundedButton extends StatelessWidget {
  final String title;
  final RoundedButtonType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;
  final bool isLoading;

  const RoundedButton({
    super.key,
    required this.title,
    this.type = RoundedButtonType.bgGradient,
    this.fontSize = 16,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: type == RoundedButtonType.bgSGradient
              ? TextColor.secondaryGradient
              : TextColor.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: type == RoundedButtonType.bgGradient ||
                type == RoundedButtonType.bgSGradient
            ? const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.5,
                    offset: Offset(0, 0.5))
              ]
            : null,
      ),
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed, // Disable button if loading
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: TextColor.primaryColor1,
        minWidth: double.maxFinite,
        elevation: type == RoundedButtonType.bgGradient ||
                type == RoundedButtonType.bgSGradient
            ? 0
            : elevation,
        color: type == RoundedButtonType.bgGradient ||
                type == RoundedButtonType.bgSGradient
            ? Colors.transparent
            : TextColor.white,
        child: isLoading
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TextColor.white),
              )
            : type == RoundedButtonType.bgGradient ||
                    type == RoundedButtonType.bgSGradient
                ? Text(title,
                    style: TextStyle(
                        color: TextColor.white,
                        fontSize: fontSize,
                        fontWeight: fontWeight))
                : ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                              colors: TextColor.primaryGradient,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)
                          .createShader(
                              Rect.fromLTRB(0, 0, bounds.width, bounds.height));
                    },
                    child: Text(title,
                        style: TextStyle(
                            color: TextColor.primaryColor1,
                            fontSize: fontSize,
                            fontWeight: fontWeight)),
                  ),
      ),
    );
  }
}
