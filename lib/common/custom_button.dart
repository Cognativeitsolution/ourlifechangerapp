import 'package:flutter/material.dart';

import '../colors/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    required this.buttonText,
    this.sizeHeight,
    required this.sizeWidth,
    this.buttonColor,
    this.boderRadius,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.isIcon = false,
    this.fontFamily,
    this.fontWeight,
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  Color? buttonColor;
  double? boderRadius;
  Color? textColor;
  String buttonText;
  Color? borderColor;
  IconData? icon;
  bool? isIcon;
  Color? iconColor;
  double? sizeHeight;
  double sizeWidth;
  String? fontFamily;
  FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight ?? 45,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: buttonColor ?? Mycolors.yellow,
        borderRadius: BorderRadius.circular(boderRadius ?? 25),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: isIcon == false
                  ? Text(
                      buttonText,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: fontWeight,
                          fontFamily: fontFamily ?? 'Poppins'),
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
