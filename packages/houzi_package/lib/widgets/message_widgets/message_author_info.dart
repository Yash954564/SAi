import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class MessageAuthorInfoWidget extends StatelessWidget {
  final String name;
  final String pictureUrl;
  final double? pictureWidth;
  final double? pictureHeight;
  final bool? useHeadingTextStyle;
  final void Function()? onTap;

  const MessageAuthorInfoWidget({
    super.key,
    required this.name,
    required this.pictureUrl,
    this.pictureWidth,
    this.pictureHeight,
    this.useHeadingTextStyle = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MessageAuthorAvatarWidget(
          avatarUrl: pictureUrl,
          width: pictureWidth,
          height: pictureHeight,
          onTap: onTap,
        ),
        const SizedBox(width: 10),
        MessageAuthorNameWidget(
          name: name,
          useHeadingTextStyle: useHeadingTextStyle,
        ),
      ],
    );
  }
}

class MessageAuthorAvatarWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String avatarUrl;
  final BoxFit? boxFit;
  final Widget? errorWidget;
  final void Function()? onTap;

  const MessageAuthorAvatarWidget({
    Key? key,
    required this.avatarUrl,
    this.width = 35,
    this.height = 35,
    this.boxFit,
    this.errorWidget,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 0.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: FancyShimmerImage(
            imageUrl: avatarUrl,
            boxFit: boxFit ?? BoxFit.cover,
            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
            width: width ?? 25,
            height: height ?? 25,
            errorWidget: errorWidget ?? ShimmerEffectErrorWidget(iconData: AppThemePreferences.personIcon),
          ),
        ),
      ),
    );
  }
}

class MessageAuthorNameWidget extends StatelessWidget {
  final String name;
  final bool? useHeadingTextStyle;
  final EdgeInsetsGeometry? padding;

  const MessageAuthorNameWidget({
    super.key,
    required this.name,
    this.useHeadingTextStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GenericTextWidget(
        name,
        style: useHeadingTextStyle == true
            ? AppThemePreferences().appTheme.crmHeadingTextStyle
            : AppThemePreferences().appTheme.crmNormalTextStyle,
        // style: AppThemePreferences().appTheme.crmHeadingTextStyle,
      ),
    );
  }
}
