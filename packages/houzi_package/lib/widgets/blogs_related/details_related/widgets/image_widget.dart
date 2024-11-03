import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_image_view.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class BlogDetailsLayoutImageWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogDetailsLayoutImageWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    String imageURL = article.photo ?? "";

    if (validateURL(imageURL)) {
      return GestureDetector(
        child: SizedBox(
          height: 300,
          child: FancyShimmerImage(
            imageUrl: imageURL,
            boxFit: BoxFit.cover,
            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
            width: double.infinity,
            errorWidget: const ShimmerEffectErrorWidget(iconSize: 100),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FullScreenImageView(
                    imageUrls: [imageURL],
                    tag: "Image-${UtilityMethods.getRandomNumber()}-TAG",
                    floorPlan: false,
                  ),
            ),
          );
        },
      );
    }

    return const ShimmerEffectErrorWidget(iconSize: 100);
  }

  bool validateURL(String url) {
    if (UtilityMethods.validateURL(url)) {
      return true;
    }
    return false;
  }
}