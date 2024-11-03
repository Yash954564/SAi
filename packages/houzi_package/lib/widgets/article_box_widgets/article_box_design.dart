import 'package:flutter/material.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';

import 'package:houzi_package/widgets/article_box_widgets/article_box_design_01.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_02.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_03.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_04.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_05.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_06.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_07.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_08.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_09.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_10.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_11.dart';

class ArticleBoxDesign{

  PropertyItemHook propertyItemHook = HooksConfigurations.propertyItem;
  PropertyItemHookV2 propertyItemHookV2 = HooksConfigurations.propertyItemV2;
  PropertyItemHeightHook propertyItemHeightHook = HooksConfigurations.propertyItemHeightHook;

  Widget getArticleBoxDesign(
      {required String design,
      required BuildContext buildContext,
      required String heroId,
      required Article article,
      bool isInMenu = false,
      required Function() onTap}) {

    Widget? articleDesignFromOldHook = propertyItemHook(buildContext, article);
    Widget? articleDesignFromHookV2 = propertyItemHookV2(
      designName: design,
      article: article,
      heroId: heroId,
      onTap: onTap,
    );

    if (articleDesignFromHookV2 != null) {
      return articleDesignFromHookV2;
    } else if (articleDesignFromOldHook != null) {
      return articleDesignFromOldHook;
    }
    return getStockArticleBoxDesign(design: design,
        buildContext: buildContext,
        heroId: heroId,
        article: article,
        onTap: onTap);
  }
  //we should separate the article box design function so it is
  //straightforward to get the design without involving hook
  //and it should take article and extract everything in the format required.
  Widget getStockArticleBoxDesign(
      {required String design,
        required BuildContext buildContext,
        required String heroId,
        required Article article,
        bool isInMenu = false,
        required Function() onTap}) {
    String _propertyPrice = "";
    String _firstPrice = "";
    String _secondPrice = "";
    bool _isFeatured = article.propertyInfo!.isFeatured ?? false;
    String _title = UtilityMethods.stripHtmlIfNeeded(article.title!);
    String _imageUrl = article.image ?? "";
    String _address = article.address!.address!;
    String _area = article.features!.propertyArea!;
    String _areaPostFix = article.features!.propertyAreaUnit == ""
        ? MEASUREMENT_UNIT_TEXT
        : article.features!.propertyAreaUnit!;
    String _bedRooms = article.features!.bedrooms!;
    String _bathRooms = article.features!.bathrooms!;
    String _propertyStatus = article.propertyInfo!.propertyStatus ?? "";
    String _propertyLabel = article.propertyInfo!.propertyLabel ?? "";
    String _propertyType = article.propertyInfo!.propertyType ?? "";
    HidePriceHook hidePrice = HooksConfigurations.hidePriceHook;
    bool hide = hidePrice();

    if(!hide) {
      _propertyPrice = article.getCompactPrice();
      _firstPrice = article.getCompactFirstPrice();
      _secondPrice = article.getCompactSecondPrice();
    }

    String _imagePath = "assets/settings/dummy_property_image.jpg";

    Map<String, dynamic> _informationDataMap = {
      AB_HERO_ID : heroId,
      AB_PROPERTY_PRICE : _propertyPrice,
      AB_PROPERTY_FIRST_PRICE : _firstPrice,
      AB_PROPERTY_SECOND_PRICE : _secondPrice,
      AB_IS_FEATURED : _isFeatured,
      AB_TITLE : _title,
      AB_IMAGE_URL : _imageUrl,
      AB_IMAGE_PATH : _imagePath,
      AB_ADDRESS : _address,
      AB_AREA : _area,
      AB_AREA_POST_FIX : _areaPostFix,
      AB_BED_ROOMS : _bedRooms,
      AB_BATH_ROOMS : _bathRooms,
      AB_PROPERTY_STATUS : _propertyStatus,
      AB_PROPERTY_TYPE : UtilityMethods.getLocalizedString(_propertyType).toUpperCase(),
      AB_PROPERTY_LABEL : _propertyLabel,
    };

    if (design == DESIGN_01) {
      return ArticleBox01 (infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_02) {
      return ArticleBox02(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_03) {
      return ArticleBox03(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_04) {
      return ArticleBox04(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_05) {
      return ArticleBox05(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_06) {
      return ArticleBox06(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_07) {
      return ArticleBox07(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_08) {
      return ArticleBox08(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_09) {
      return ArticleBox09(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_10) {
      return ArticleBox10(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }
    if (design == DESIGN_11) {
      return ArticleBox11(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
    }

    return ArticleBox01(infoDataMap: _informationDataMap, onTap: onTap, isInMenu: isInMenu);
  }

  double getArticleBoxDesignHeight({required String design}){
    if (propertyItemHeightHook(design) != null) {
      return propertyItemHeightHook(design)!;
    }

    return getStockArticleBoxDesignHeight(design: design);
  }
  //we should separate the article box design height function so it is
  //straightforward to get the design without involving hook
  double getStockArticleBoxDesignHeight({required String design}) {
    if(design == DESIGN_01){
      return 160;
    }
    if(design == DESIGN_02){
      return 295;
    }
    if(design == DESIGN_03){
      return 315;
    }
    if(design == DESIGN_04){
      return 290;
    }
    if(design == DESIGN_05){
      return 295;
    }
    if(design == DESIGN_06){
      return 310;
    }
    if(design == DESIGN_07){
      return 305;
    }
    if(design == DESIGN_08){
      return 250;
    }
    if(design == DESIGN_09){
      return 220;
    }
    if(design == DESIGN_10){
      return 240;
    }
    if(design == DESIGN_11){
      return 240;
    }

    return 160;
  }
}