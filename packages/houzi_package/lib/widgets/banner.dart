import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

Widget bannerWidget(){
  String preTitle = "preTitle";
  String title = "title";
  String description = "description";
  // String image = "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80";
  String image = "";
  String actionUrl = "image";
  String backgroundPhoto = "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef";
  Color backgroundColor = UtilityMethods.getColorFromString("#0000FF");
  Color textColor = UtilityMethods.getColorFromString("#FF1BB1B1");
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(backgroundPhoto), fit: BoxFit.cover),
        color: backgroundColor,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              GenericTextWidget(preTitle,style: TextStyle(color: textColor)),
              GenericTextWidget(title),
              GenericTextWidget(description),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FancyShimmerImage(
              imageUrl: image,
              boxFit: BoxFit.cover,
              shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
              shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
              width: 100,
              height: 100,
              errorWidget: Container(),
            ),
          ),
        ],
      ),
    ),
  );
}