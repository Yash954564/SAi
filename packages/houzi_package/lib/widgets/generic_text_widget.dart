import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class GenericTextWidget extends StatelessWidget {
  final String text;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final bool enableCopy;
  final void Function()? onLongPress;
  
  const GenericTextWidget(
      this.text, {
        Key? key,
        this.locale,
        this.strutStyle = const StrutStyle(height: 1.2, forceStrutHeight: true),
        this.style,
        this.textAlign,
        this.textDirection,
        this.softWrap,
        this.overflow,
        this.textScaleFactor,
        this.maxLines,
        this.semanticsLabel,
        this.textWidthBasis,
        this.textHeightBehavior,
        this.enableCopy = false,
        this.onLongPress,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: enableCopy ? onLongPress : null,
      child: Text(
        UtilityMethods.getLocalizedString(text),
        strutStyle: strutStyle,
        style: style,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }
}