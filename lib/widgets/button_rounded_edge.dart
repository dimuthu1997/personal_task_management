// ignore_for_file: depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    super.key,
    this.label,
    this.margin,
    this.padding,
    this.textColor,
    this.onPressed,
    required this.boarderWidth,
    this.radius,
    this.color,
    this.borderColor,
    this.isShowingLoader = false,
    this.labelStyle,
    this.width,
    this.height,
    this.icon,
    this.isBoxShadowNeeded = false,
  });

  final String? label;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;
  final TextStyle? labelStyle;
  final double? radius;
  bool isBoxShadowNeeded = false;
  final double boarderWidth;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final Icon? icon;
  bool isShowingLoader = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48.w,
        width: width ?? double.infinity,
        alignment: Alignment.center,
        margin: margin,
        decoration: BoxDecoration(
          boxShadow: [
            isBoxShadowNeeded == false
                ? BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0),
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(0, 0), // changes position of shadow
                )
                : BoxShadow(
                  color: Color.fromRGBO(74, 111, 165, 0.4),
                  spreadRadius: -10,
                  blurRadius: 23,
                  offset: Offset(2, 4), // changes position of shadow
                ),
          ],
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 12),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: boarderWidth,
          ),
        ),
        child:
            isShowingLoader
                ? Container(
                  height: 19.w,
                  width: 19.w,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3.0,
                    color: Colors.purple,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon != null
                        ? Row(children: [icon!, SizedBox(width: 20.w)])
                        : Container(),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        label!,
                        style:
                            labelStyle ??
                            TextStyle(color: textColor ?? Colors.purple),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
