import 'package:flutter/material.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_for_properties.dart';

typedef FavouritesArticleBoxDesignWidgetListener = void Function(
    int propertyListIndex, Map<String, dynamic> addOrRemoveFromFavInfo);

class FavouritesArticleBoxDesign extends StatelessWidget {
  final Article item;
  final int propertyListIndex;
  final void Function() onTap;
  final FavouritesArticleBoxDesignWidgetListener favouritesArticleBoxDesignWidgetListener;

  const FavouritesArticleBoxDesign({
    super.key,
    required this.item,
    required this.propertyListIndex,
    required this.onTap,
    required this.favouritesArticleBoxDesignWidgetListener,
  });

  @override
  Widget build(BuildContext context) {
    String heroId = item.id.toString() + FAVOURITES;
    String _imageUrl = "";
    if (item.imageList != null && item.imageList!.isNotEmpty) {
      _imageUrl = item.imageList![0];
    }
    String _title = UtilityMethods.stripHtmlIfNeeded(item.title!);

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: onTap,
      child: Container(
        height: 290,
        padding: const EdgeInsets.only(bottom: 7,left: 5,right: 5,top: 3),
        child: CardWidget(
          color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
          shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
          elevation: AppThemePreferences.articleDeignsElevation,
          child: Stack(
            children: <Widget>[
              PropertiesArticleBoxImageWidget(
                height: 180,
                heroId: heroId,
                imageUrl: _imageUrl,
              ),
              FavouritesArticleBoxDesignFavouriteWidget(
                onPressed: () async {
                  Map<String, dynamic> addOrRemoveFromFavInfo = {"listing_id": item.id};
                  favouritesArticleBoxDesignWidgetListener(propertyListIndex,addOrRemoveFromFavInfo);
                },
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FavouritesArticleBoxDesignTitleWidget(title: _title),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 3, 10, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertiesArticleBoxFeaturesWidget(article: item),
                          PropertiesArticleBoxPriceWidget(item: item),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavouritesArticleBoxDesignTitleWidget extends StatelessWidget {
  final String title;

  const FavouritesArticleBoxDesignTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 5),
      child: GenericTextWidget(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppThemePreferences().appTheme.titleTextStyle,
      ),
    );
  }
}

class FavouritesArticleBoxDesignFavouriteWidget extends StatelessWidget {
  final void Function() onPressed;

  const FavouritesArticleBoxDesignFavouriteWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 15,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppThemePreferences().appTheme.favouriteWidgetBackgroundColor,
        child: IconButton(
          icon: Icon(
            AppThemePreferences.favouriteIconFilled,
            color: AppThemePreferences.favouriteIconColor,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}