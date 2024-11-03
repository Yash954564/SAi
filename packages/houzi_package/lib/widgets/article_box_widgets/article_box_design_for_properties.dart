import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/tag_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/featured_tag_widget.dart';

typedef PropertiesArticleBoxWidgetListener = void Function(Map<String, dynamic> actionButtonMap);

class PropertiesArticleBox extends StatelessWidget {
  final Article item;
  final Map<String, dynamic> actionButtonMap;
  final void Function() onTap;
  final PropertiesArticleBoxWidgetListener propertiesArticleBoxWidgetListener;

  const PropertiesArticleBox({
    super.key,
    required this.item,
    required this.actionButtonMap,
    required this.onTap,
    required this.propertiesArticleBoxWidgetListener,
  });

  @override
  Widget build(BuildContext context) {
    String _imageUrl = item.imageList != null && item.imageList!.isNotEmpty ? item.imageList![0] : "";
    String _status = item.status!;
    String _title = UtilityMethods.stripHtmlIfNeeded(item.title!);
    String heroId = item.id.toString() + RELATED;

    if (TOUCH_BASE_PAYMENT_ENABLED_STATUS == perListing && actionButtonMap["_status"] != STATUS_PUBLISH) {
      String paymentStatus = item.propertyInfo!.paymentStatus ?? "";
      if (paymentStatus == "not_paid") {
        _status = "Pay Now";
      }
    }

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: onTap,
      child: Container(
        height: 270,
        padding: const EdgeInsets.only(bottom: 7,left: 5,right: 5,top: 3),
        child: CardWidget(
          color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
          shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
          elevation: AppThemePreferences.articleDeignsElevation,
          child: Stack(
            children: <Widget>[
              PropertiesArticleBoxImageWidget(
                  heroId: heroId, imageUrl: _imageUrl),
              PropertiesArticleBoxStatusTagWidget(status: _status),
              PropertiesArticleBoxFeaturedTagWidget(article: item),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PropertiesArticleBoxTitleAndActionButtonWidget(
                        title: _title,
                        actionButtonMap: actionButtonMap,
                        articleBox09WidgetListener:
                            propertiesArticleBoxWidgetListener),
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PropertiesArticleBoxFeaturesWidget(
                              article: item,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0)),
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

class PropertiesArticleBoxImageWidget extends StatelessWidget {
  final String heroId;
  final String imageUrl;
  final double? height;

  const PropertiesArticleBoxImageWidget({
    super.key,
    required this.heroId,
    required this.imageUrl,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    bool _validURL = UtilityMethods.validateURL(imageUrl);

    return SizedBox(
      height: height ?? 175,
      width: MediaQuery.of(context).size.width,
      child: Hero(
        tag: heroId,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: !_validURL
              ? PropertiesArticleBoxErrorWidget()
              : FancyShimmerImage(
                  imageUrl: imageUrl,
                  boxFit: BoxFit.cover,
                  shimmerBaseColor:
                      AppThemePreferences().appTheme.shimmerEffectBaseColor,
                  shimmerHighlightColor: AppThemePreferences()
                      .appTheme
                      .shimmerEffectHighLightColor,
                  errorWidget: PropertiesArticleBoxErrorWidget(),
                ),
        ),
      ),
    );
  }
}

class PropertiesArticleBoxTitleWidget extends StatelessWidget {
  final String title;

  const PropertiesArticleBoxTitleWidget({
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

class PropertiesArticleBoxPriceWidget extends StatelessWidget {
  final Article item;

  const PropertiesArticleBoxPriceWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    String finalPrice = "";

    HidePriceHook hidePrice = HooksConfigurations.hidePriceHook;
    bool hide = hidePrice();
    if(!hide) {
      finalPrice = item.getCompactPrice();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GenericTextWidget(
        finalPrice,
        style: AppThemePreferences().appTheme.articleBoxPropertyPriceTextStyle,
      ),
    );
  }
}

class PropertiesArticleBoxTitleAndActionButtonWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> actionButtonMap;
  final PropertiesArticleBoxWidgetListener articleBox09WidgetListener;

  const PropertiesArticleBoxTitleAndActionButtonWidget({
    super.key,
    required this.title,
    required this.actionButtonMap,
    required this.articleBox09WidgetListener,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: PropertiesArticleBoxTitleWidget(title: title),
          ),
          IconButton(
            icon: Icon(AppThemePreferences.moreVert),
            onPressed: () => articleBox09WidgetListener(actionButtonMap),
          ),
        ],
      ),
    );
  }
}

class PropertiesArticleBoxStatusTagWidget extends StatelessWidget {
  final String status;

  const PropertiesArticleBoxStatusTagWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 15,
      child: status.isEmpty ? Container() : Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.topRight,
        child: TagWidget(label: UtilityMethods.getLocalizedString(status).toUpperCase()),
      ),
    );
  }
}

class PropertiesArticleBoxFeaturedTagWidget extends StatelessWidget {
  final Article article;

  const PropertiesArticleBoxFeaturedTagWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    if (article.propertyInfo!.isFeatured ?? false) {
      return Positioned(
        top: 10,
        left: 15,
        child: Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.topLeft,
          child: FeaturedTagWidget(),
        ),
      );
    }

    return Container();
  }
}

class PropertiesArticleBoxFeaturesWidget extends StatelessWidget {
  final Article article;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  const PropertiesArticleBoxFeaturesWidget({
    super.key,
    required this.article,
    this.padding = const EdgeInsets.fromLTRB(5, 5, 5, 0),
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    String _area = article.features!.propertyArea ?? "";
    String _areaPostFix = article.features!.propertyAreaUnit ?? "";
    String _bedRooms = article.features!.bedrooms ?? "";
    String _bathRooms = article.features!.bathrooms ?? "";

    if (_area.isNotEmpty && _areaPostFix.isNotEmpty) {
      _area = "$_area $_areaPostFix";
    }

    return Container(
      padding: padding,
      child: Row(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          if (showFeature(_bedRooms))
            ArticleBox01FeaturesSubWidget(
              title: _bedRooms,
              icon: AppThemePreferences().appTheme.articleBoxBedIcon!,
            ),
          if (showBedRoomsPadding(_bedRooms, _bathRooms, _area))
            const SizedBox(width: 15),

          if (showFeature(_bathRooms))
            ArticleBox01FeaturesSubWidget(
              title: _bathRooms,
              icon: AppThemePreferences().appTheme.articleBoxBathtubIcon!,
            ),
          if (showBathRoomsPadding(_bathRooms, _area))
            const SizedBox(width: 15),

          if (showFeature(_area))
            ArticleBox01FeaturesSubWidget(
              title: _area,
              icon: AppThemePreferences().appTheme.articleBoxAreaSizeIcon!,
            ),
        ],
      ),
    );
  }

  bool showFeature(String feature) {
    if (feature.isNotEmpty) {
      return true;
    }
    return false;
  }

  bool showBedRoomsPadding(String beds, String baths, String area) {
    if (showFeature(beds) && (showFeature(baths) || showFeature(area))) {
      return true;
    }
    return false;
  }

  bool showBathRoomsPadding(String baths, String area) {
    if (showFeature(baths) && showFeature(area)) {
      return true;
    }
    return false;
  }
}

class PropertiesArticleBoxErrorWidget extends StatelessWidget {
  const PropertiesArticleBoxErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }
}