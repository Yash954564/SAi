import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class PropertyDetailPageFeaturesDetail extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageFeaturesDetail({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageFeaturesDetail> createState() => _PropertyDetailPageFeaturesDetailState();
}

class _PropertyDetailPageFeaturesDetailState extends State<PropertyDetailPageFeaturesDetail> {

  Article? _article;
  bool isMoreDetails = false;
  bool hide = false;

  Map<String, String> articleDetailsMap = {};
  Map<String, String> customFieldsMap = {};

  List<dynamic> additionalDetailsList = [];
  
  @override
  void initState() {
    super.initState();
    _article = widget.article;
    HidePriceHook hidePrice = HooksConfigurations.hidePriceHook;
    hide = hidePrice();
    loadData(_article!);
  }

  loadData(Article article) {
    articleDetailsMap = article.propertyDetailsMap ?? {};
    customFieldsMap = article.propertyInfo!.customFieldsMap ?? {};

    if (customFieldsMap.isNotEmpty) {
      articleDetailsMap.addAll(customFieldsMap);
    }
    if(UtilityMethods.isValidString(article.propertyInfo!.propertyStatus)){
      articleDetailsMap[ARTICLE_STATUS] = article.propertyInfo!.propertyStatus!;
    }

    additionalDetailsList = article.features!.additionalDetailsList ?? [];
    if(mounted) {
      setState(() {});
    }
  }

  void onShowMoreTapped() {
    if (mounted) {
      setState(() {
        isMoreDetails = !isMoreDetails;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }

    return FeaturesDetailsWidget(
      onShowMoreTap: ()=> onShowMoreTapped(),
      title: widget.title,
      article: _article,
      hide: hide,
      isMoreDetails: isMoreDetails,
      articleDetailsMap: articleDetailsMap,
      additionalDetailsList: additionalDetailsList,
    );
  }
}

class FeaturesDetailsWidget extends StatelessWidget {
  final String title;
  final Article? article;
  final bool hide;
  final bool isMoreDetails;
  final Map<String, String> articleDetailsMap;
  final List<dynamic> additionalDetailsList;
  final void Function() onShowMoreTap;

  const FeaturesDetailsWidget({
    super.key,
    required this.title,
    required this.article,
    required this.hide,
    required this.isMoreDetails,
    required this.articleDetailsMap,
    required this.additionalDetailsList,
    required this.onShowMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    if (articleDetailsMap.isNotEmpty) {
      return Column(
        children: [
          textHeadingWidget(
            text: UtilityMethods.getLocalizedString(title),
            widget: ShowMoreDetails(
              additionalDetailsList: additionalDetailsList,
              articleDetailsMap: articleDetailsMap,
              isMoreDetails: isMoreDetails,
              listener: (isTapped) => onShowMoreTap(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CardWidget(
              elevation: AppThemePreferences.zeroElevation,
              shape: AppThemePreferences.roundedCorners(AppThemePreferences.propertyDetailPageRoundedCornersRadius),
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: articleDetailsMap.length > 3
                      ? (isMoreDetails ? articleDetailsMap.length : 3)
                      : articleDetailsMap.length,
                  itemBuilder: (context, int index) {
                    String key = articleDetailsMap.keys.elementAt(index);
                    String value = articleDetailsMap[key] ?? "";
                    if(value.contains("\n")){
                      value = value.replaceAll("\n", ", ");
                    }
                    if (key == FIRST_PRICE ||key == PRICE || key == SECOND_PRICE) {
                      if (hide) {
                        return Container();
                      }
                      value = UtilityMethods.priceFormatter(value, "", article!.propertyInfo!.pricePrefix ?? "");
                    }
                    if (key == PROPERTY_DETAILS_PROPERTY_SIZE) {
                      if (UtilityMethods.isValidString(article!.features!.propertyAreaUnit)) {
                        value = "$value ${article!.features!.propertyAreaUnit}";
                      } else {
                        value =  "$value $MEASUREMENT_UNIT_TEXT";
                      }
                    }
                    if (key == PROPERTY_DETAILS_LAND_AREA) {
                      if (UtilityMethods.isValidString(article!.features!.landAreaUnit)) {
                        value = "$value ${article!.features!.landAreaUnit}";
                      } else {
                        value =  "$value $MEASUREMENT_UNIT_TEXT";
                      }
                    }
                    key = UtilityMethods.getLocalizedString(key);
                    return Container(
                      decoration: index == 0
                          ? null
                          : AppThemePreferences.dividerDecoration(top: true),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: SingleFeatureDetailWidget(
                        itemKey: key,
                        value: value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ArticleAdditionalFeaturesDetailsWidget(
            additionalDetailsList: additionalDetailsList,
            articleDetailsMap: articleDetailsMap,
            isMoreDetails: isMoreDetails,
          ),
        ],
      );
    }
    return Container();
  }
}


class ArticleAdditionalFeaturesDetailsWidget extends StatelessWidget {
  final bool isMoreDetails;
  final Map<String, String> articleDetailsMap;
  final List<dynamic> additionalDetailsList;

  const ArticleAdditionalFeaturesDetailsWidget({
    super.key,
    required this.isMoreDetails,
    required this.articleDetailsMap,
    required this.additionalDetailsList,
  });

  @override
  Widget build(BuildContext context) {
    if (isMoreDetails && additionalDetailsList.isNotEmpty) {
      return Column(
        children: [
          textHeadingWidget(
            text: UtilityMethods.getLocalizedString("additional_details"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CardWidget(
              elevation: AppThemePreferences.zeroElevation,
              shape: AppThemePreferences.roundedCorners(AppThemePreferences.propertyDetailPageRoundedCornersRadius),
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: additionalDetailsList.length,
                  itemBuilder: (context, int index) {
                    String title = additionalDetailsList[index].title ?? "";
                    String value = additionalDetailsList[index].value ?? "";
                    return Container(
                      decoration: index == 0
                          ? null
                          : AppThemePreferences.dividerDecoration(top: true),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      child: SingleFeatureDetailWidget(
                          itemKey: title,
                          value: value,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}

class SingleFeatureDetailWidget extends StatelessWidget {
  final String itemKey;
  final String value;

  const SingleFeatureDetailWidget({
    super.key,
    required this.itemKey,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GenericTextWidget(
          itemKey + " : ",
          textAlign: TextAlign.start,
          strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
          style: AppThemePreferences().appTheme.subBody01TextStyle,
        ),
        Expanded(
          child: GenericTextWidget(
            UtilityMethods.getLocalizedString(value),
            textAlign: TextAlign.end,
            strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
            style: AppThemePreferences().appTheme.label01TextStyle,
          ),
        ),
      ],
    );
  }
}

typedef ShowMoreDetailsListener = void Function(bool isTapped);
class ShowMoreDetails extends StatelessWidget {
  final bool isMoreDetails;
  final Map<String, String> articleDetailsMap;
  final List<dynamic> additionalDetailsList;
  final ShowMoreDetailsListener listener;

  const ShowMoreDetails({
    super.key,
    required this.isMoreDetails,
    required this.articleDetailsMap,
    required this.additionalDetailsList,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    if (articleDetailsMap.length > 3 || additionalDetailsList.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: InkWell(
              onTap: ()=> listener(true),
              child: GenericTextWidget(
                isMoreDetails
                    ? UtilityMethods.getLocalizedString("less_details")
                    : UtilityMethods.getLocalizedString("more_details"),
                strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                style: AppThemePreferences().appTheme.readMoreTextStyle,
                // textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
