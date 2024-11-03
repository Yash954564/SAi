import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';

import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class ArticleBoxDesignForDraftProperties extends StatelessWidget {
  final String heroID;
  final Article article;
  final void Function() onTap;
  final void Function() onActionButtonTap;

  const ArticleBoxDesignForDraftProperties({
    super.key,
    required this.heroID,
    required this.article,
    required this.onTap,
    required this.onActionButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    String _title = UtilityMethods.stripHtmlIfNeeded(article.title!);

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: onTap,
      child: Container(
        height: 250, //270
        padding: const EdgeInsets.only(bottom: 7.0 , left: 5.0 , right: 5.0 , top: 3.0),
        child: CardWidget(
          color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
          shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
          elevation: AppThemePreferences.articleDeignsElevation,
          child: Stack(
            children: <Widget>[
              DraftPropertiesArticleBoxImageWidget(
                heroId: heroID,
                imagePath: article.image ?? "",
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: DraftPropertiesTitleAndButtonRowWidget(
                    title: _title, onButtonTap: onActionButtonTap),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraftPropertiesArticleBoxImageWidget extends StatelessWidget {
  final String heroId;
  final String imagePath;

  const DraftPropertiesArticleBoxImageWidget({
    super.key,
    required this.heroId,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    bool _validURL = imagePath.isNotEmpty ? true : false;

    return SizedBox(
      height: 165,
      width: double.infinity,
      child: Hero(
        tag: heroId,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: !_validURL
              ? DraftPropertiesArticleBoxErrorWidget()
              : Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                ),

          // Image.file(
          //   File(item[PROPERTY_MEDIA_IMAGE_PATH]),
          //   fit: BoxFit.cover,
          //   width: AppThemePreferences.propertyMediaGridViewImageWidth,
          //   height: AppThemePreferences.propertyMediaGridViewImageHeight,
          // )
          // child: !_validURL ? errorWidget() : Image.asset(
          //   imagePath,
          //   fit: BoxFit.cover,
          // ),
        ),
      ),
    );
  }
}

class DraftPropertiesArticleBoxErrorWidget extends StatelessWidget {
  const DraftPropertiesArticleBoxErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }
}

class DraftPropertiesTitleAndButtonRowWidget extends StatelessWidget {
  final String title;
  final void Function() onButtonTap;

  const DraftPropertiesTitleAndButtonRowWidget({
    super.key,
    required this.title,
    required this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: TitleWidget(title: title),
          ),
          Expanded(
            flex: 2,
            child: ButtonWidget(
              buttonHeight: 40,
              centeredContent: true,
              iconOnRightSide: true,
              icon: Icon(
                AppThemePreferences.dropDownArrowIcon,
                color: AppThemePreferences.filledButtonIconColor,
              ),
              text: UtilityMethods.getLocalizedString("action"),
              onPressed: onButtonTap,
            ),
          ),
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GenericTextWidget(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppThemePreferences().appTheme.titleTextStyle,
    );
  }
}