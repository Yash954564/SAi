import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/text_span_widgets/text_span_widgets.dart';

class GenericLinkWidget extends StatelessWidget {
  final String? preLinkText;
  final String? postLinkText;
  final String linkText;
  final void Function() onLinkPressed;
  final StrutStyle? strutStyle;
  final TextStyle? preLinkTextStyle;
  final TextStyle? postLinkTextStyle;
  final TextStyle? linkTextStyle;

  const GenericLinkWidget({
    Key? key,
    required this.linkText,
    required this.onLinkPressed,
    this.preLinkText,
    this.postLinkText,
    this.preLinkTextStyle,
    this.postLinkTextStyle,
    this.linkTextStyle,
    this.strutStyle = const StrutStyle(forceStrutHeight: true, height: 1.5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        children: [
          if (preLinkText != null && preLinkText!.isNotEmpty)
            GenericNormalTextSpanWidget(
              text: preLinkText!,
              textStyle: preLinkTextStyle,
            ),
          GenericLinkTextSpanWidget(
            text: " $linkText",
            textStyle: linkTextStyle,
            onTap: onLinkPressed,
          ),
          if (postLinkText != null && postLinkText!.isNotEmpty)
            GenericNormalTextSpanWidget(
              text: postLinkText!,
              textStyle: postLinkTextStyle,
            ),
        ],
      ),
    );
  }
}

class GenericInlineLinkWidget extends StatelessWidget {
  final String text;
  final String linkText;
  final void Function() onLinkPressed;
  final StrutStyle? strutStyle;
  final TextStyle? preLinkTextStyle;
  final TextStyle? postLinkStyle;
  final TextStyle? linkTextStyle;

  const GenericInlineLinkWidget({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onLinkPressed,
    this.preLinkTextStyle,
    this.postLinkStyle,
    this.linkTextStyle,
    this.strutStyle = const StrutStyle(forceStrutHeight: true, height: 1.5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> pieces = text.split(linkText);

    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        children: [
          GenericNormalTextSpanWidget(text: pieces.first, textStyle: preLinkTextStyle),
          GenericLinkTextSpanWidget(
            text: linkText,
            onTap: onLinkPressed,
            textStyle: linkTextStyle
          ),
          GenericNormalTextSpanWidget(text: pieces.last, textStyle: postLinkStyle),
        ],
      ),
    );
  }
}
