import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class PropertyDetailPageDescription extends StatelessWidget {
  final Article article;
  final String title;

  const PropertyDetailPageDescription({
    super.key,
    required this.article,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (ENABLE_HTML_IN_DESCRIPTION) {
      return HTMLEnableDescriptionWidget(
        title: title,
        article: article,
      );
    }
    return SimpleDescriptionWidget(
      title: title,
      article: article,
    );
  }
}

class SimpleDescriptionWidget extends StatefulWidget {
  final Article article;
  final String title;

  const SimpleDescriptionWidget({
    super.key,
    required this.article,
    required this.title,
  });

  @override
  State<SimpleDescriptionWidget> createState() => _SimpleDescriptionWidgetState();
}

class _SimpleDescriptionWidgetState extends State<SimpleDescriptionWidget> {

  String title = "";
  String content = "";
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {

    if (widget.title.isEmpty) {
      title = UtilityMethods.getLocalizedString("description");
    } else {
      title = widget.title;
    }

    if (UtilityMethods.isValidString(widget.article.content)) {
      content = UtilityMethods.stripHtmlIfNeeded(widget.article.content!) ?? "";
    }

    if (content.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textHeadingWidget(
              text: UtilityMethods.getLocalizedString(title),
              widget: content.length > 300 ? ReadMoreWidget(
                isReadMore: isReadMore,
                listener: (readMorePressed) {
                  if (mounted) {
                    setState(() {
                      isReadMore = !isReadMore;
                    });
                  }
                },
              ) : Container()
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Align(
              alignment: UtilityMethods.isRTL(context)
                  ? Alignment.centerRight : Alignment.centerLeft,
              child: GenericTextWidget(
                content,
                enableCopy: true,
                onLongPress: (){
                  Clipboard.setData(ClipboardData(text: content));
                  ShowToastWidget(
                    buildContext: context,
                    text: UtilityMethods.getLocalizedString(TEXT_COPIED_STRING),
                  );
                },
                maxLines: isReadMore ? null : 6,
                overflow:
                    isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
                strutStyle:
                StrutStyle(height: AppThemePreferences.bodyTextHeight),
                style: AppThemePreferences().appTheme.bodyTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      );
    }

    return Container();
  }
}

class HTMLEnableDescriptionWidget extends StatefulWidget {
  final Article article;
  final String title;

  const HTMLEnableDescriptionWidget({
    super.key,
    required this.article,
    required this.title,
  });

  @override
  State<HTMLEnableDescriptionWidget> createState() => _HTMLEnableDescriptionWidgetState();
}

class _HTMLEnableDescriptionWidgetState extends State<HTMLEnableDescriptionWidget> {

  String title = "";
  String content = "";
  bool isReadMore = false;

  @override
  Widget build(BuildContext context) {

    if (title.isEmpty) {
      title = UtilityMethods.getLocalizedString("description");
    }
    String content = widget.article.content ?? "";
    String contentLess = content;
    String contentMore = content;
    if (content.length > 300) {
      contentLess = content.substring(0, 300);
      contentLess = "$contentLess ...";
    }

    if (content.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textHeadingWidget(
              text: UtilityMethods.getLocalizedString(title),
              widget: content.length > 300 ? ReadMoreWidget(
                isReadMore: isReadMore,
                listener: (readMorePressed) {
                  if (mounted) {
                    setState(() {
                      isReadMore = !isReadMore;
                    });
                  }
                },
              ) : Container()
          ),
          GestureDetector(
            onLongPress: (){
              if (UtilityMethods.isValidString(widget.article.content)) {
                content = UtilityMethods.stripHtmlIfNeeded(widget.article.content!) ?? "";
              }
              Clipboard.setData(ClipboardData(text: content));
              ShowToastWidget(
                buildContext: context,
                text: UtilityMethods.getLocalizedString(TEXT_COPIED_STRING),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Align(
                  alignment: UtilityMethods.isRTL(context)
                      ? Alignment.centerRight : Alignment.centerLeft,
                  child: isReadMore ? HtmlWidget(
                      contentMore
                  ) : HtmlWidget(
                      contentLess
                  )
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}


typedef ReadMoreWidgetListener = void Function(bool readMorePressed);

class ReadMoreWidget extends StatelessWidget {
  final bool isReadMore;
  final ReadMoreWidgetListener listener;

  const ReadMoreWidget({
    super.key,
    required this.isReadMore,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Align(
            child: InkWell(
              onTap: () => listener(true),
              child: GenericTextWidget(
                isReadMore
                    ? UtilityMethods.getLocalizedString("read_less")
                    : UtilityMethods.getLocalizedString("read_more"),
                strutStyle: StrutStyle(
                    height:
                    AppThemePreferences.genericTextHeight),
                style: AppThemePreferences()
                    .appTheme
                    .readMoreTextStyle,
                // textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

