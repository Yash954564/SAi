import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class ArticleBox10 extends StatelessWidget {
  final bool isInMenu;
  final void Function() onTap;
  final Map<String, dynamic> infoDataMap;

  const ArticleBox10({
    super.key,
    this.isInMenu = false,
    required this.onTap,
    required this.infoDataMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7.0),
      child: CardWidget(
        color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: Stack(
          children: [
            // infoDataMap[AB_PROPERTY_VIDEO_AD_URL] != null && infoDataMap[AB_PROPERTY_VIDEO_AD_URL].isNotEmpty
            //     ? VideoPlayerWidget(height: 240.0, infoDataMap: infoDataMap)
            //     :
            ArticleBox10ImageWidget(
                height: 240.0,
                infoDataMap: infoDataMap,
                isInMenu: isInMenu,
                onTap : onTap
            )
          ],
        ),
      ),
    );
  }
}

class ArticleBox10ImageWidget extends StatelessWidget {
  final bool isInMenu;
  final double height;
  final double width;
  final Map<String, dynamic> infoDataMap;
  final void Function() onTap;

  const ArticleBox10ImageWidget({
    super.key,
    this.isInMenu = false,
    this.height = 160.0,
    this.width = double.infinity,
    required this.infoDataMap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String _imageUrl = infoDataMap[AB_IMAGE_URL];

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FancyShimmerImage(
            imageUrl: _imageUrl,
            boxFit: BoxFit.cover,
            boxDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
            errorWidget: ShimmerEffectErrorWidget(iconSize: 100),
          ),
        ),
      ),
    );
  }
}