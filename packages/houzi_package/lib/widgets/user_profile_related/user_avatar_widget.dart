import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class UserAvatarWidget extends StatelessWidget {
  final bool isUserLogged;
  final String userAvatarUrl;

  const UserAvatarWidget({
    Key? key,
    required this.isUserLogged,
    required this.userAvatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FancyShimmerImage(
          imageUrl: isUserLogged ? userAvatarUrl : "",
          boxFit: BoxFit.cover,
          shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
          width: 150,
          height: 150,
          errorWidget: ShimmerEffectErrorWidget(iconData: AppThemePreferences.personIcon),
        ),
      ),
    );
  }
}