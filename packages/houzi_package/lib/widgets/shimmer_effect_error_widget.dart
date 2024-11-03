import 'package:flutter/cupertino.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

class ShimmerEffectErrorWidget extends StatelessWidget {
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;
  final Color? backgroundColor;

  const ShimmerEffectErrorWidget({
    Key? key,
    this.iconData,
    this.iconSize = 80,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(
        child: Icon(
          iconData ?? AppThemePreferences.imageIcon,
          size: iconSize,
          color: iconColor ?? AppThemePreferences().appTheme.shimmerEffectErrorIconColor,
        ),
      ),
    );
  }
}