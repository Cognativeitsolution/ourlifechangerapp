import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.overflow,
    this.maxline,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxline;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxline,
      style: TextStyle(
        color: textColor ?? Colors.white,
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? 'Poppins',
      ),
    );
  }
}
