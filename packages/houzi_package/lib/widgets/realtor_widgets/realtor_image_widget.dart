import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class RealtorImageWidget extends StatelessWidget {
  final String heroId;
  final String imageUrl;
  final String tag;

  const RealtorImageWidget({
    required this.heroId,
    required this.imageUrl,
    required this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Hero(
        tag: heroId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FancyShimmerImage(
            imageUrl: imageUrl,
            boxFit: BoxFit.cover,
            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
            width: tag == AGENTS_TAG
                ? AppThemePreferences.agentsListImageWidth
                : AppThemePreferences.agenciesListImageWidth,
            height: tag == AGENTS_TAG
                ? AppThemePreferences.agentsListImageHeight
                : AppThemePreferences.agenciesListImageHeight,
            errorWidget: const ShimmerEffectErrorWidget(iconSize: 50),
          ),
        ),
      ),
    );
  }
}
