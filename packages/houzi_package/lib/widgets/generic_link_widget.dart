import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/text_span_widgets/text_span_widgets.dart';

class GenericLinkWidget extends StatelessWidget {
  final String? preLinkText;
  final String? postLinkText;
  final String linkText;
  final void Function() onLinkPressed;
  final StrutStyle? strutStyle;

  const GenericLinkWidget({
    Key? key,
    required this.linkText,
    required this.onLinkPressed,
    this.preLinkText,
    this.postLinkText,
    this.strutStyle = const StrutStyle(forceStrutHeight: true, height: 1.5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        // style: AppThemePreferences().appTheme.body01TextStyle,
        // style: TextStyle(
        //   fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily!,
        // ),

        children: [
          if(preLinkText != null && preLinkText!.isNotEmpty)
            GenericNormalTextSpanWidget(text: preLinkText!),

          GenericLinkTextSpanWidget(
            text: " $linkText",
            onTap: onLinkPressed,
          ),

          if(postLinkText != null && postLinkText!.isNotEmpty)
            GenericNormalTextSpanWidget(text: postLinkText!),
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

  const GenericInlineLinkWidget({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onLinkPressed,
    this.strutStyle = const StrutStyle(forceStrutHeight: true, height: 1.5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> pieces = text.split(linkText);

    return RichText(
      strutStyle: strutStyle,
      text: TextSpan(
        // style: TextStyle(
        //   fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily!,
        // ),
        children: [
          GenericNormalTextSpanWidget(text: pieces.first),
          GenericLinkTextSpanWidget(
            text: linkText,
            onTap: onLinkPressed,
          ),
          GenericNormalTextSpanWidget(text: pieces.last),
        ],
      ),
    );
  }
}