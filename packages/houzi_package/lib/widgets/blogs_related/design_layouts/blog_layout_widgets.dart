import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class BlogLayoutImageWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String heroId;
  final String imageUrl;
  final BorderRadiusGeometry? borderRadius;
  final double? errorIconSize;

  const BlogLayoutImageWidget({
    super.key,
    required this.heroId,
    required this.imageUrl,
    this.height = 210.0,
    this.width = double.infinity,
    this.borderRadius,
    this.errorIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Hero(
        tag: heroId,
        child: ClipRRect(
          // borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderRadius: borderRadius ?? const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: !UtilityMethods.validateURL(imageUrl)
              ? ShimmerEffectErrorWidget(iconSize: errorIconSize)
              : FancyShimmerImage(
            imageUrl: imageUrl,
            boxFit: BoxFit.cover,
            shimmerBaseColor:
            AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences()
                .appTheme
                .shimmerEffectHighLightColor,
            errorWidget: ShimmerEffectErrorWidget(iconSize: errorIconSize),
          ),
        ),
      ),
    );
  }
}

class BlogLayoutCategoryWidget extends StatelessWidget {
  final BlogArticle article;
  final EdgeInsetsGeometry? padding;

  const BlogLayoutCategoryWidget({
    super.key,
    required this.article,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GenericTextWidget(
        getCategoryString(),
        overflow: TextOverflow.ellipsis,
        style: AppThemePreferences().appTheme.blogLayoutCategoryTextStyle,
      ),
    );
  }

  String getCategoryString() {
    List<BlogArticleCategory> categoriesList = article.categories ?? [];
    if (categoriesList.isNotEmpty) {
      List<String> dataList = [];
      for (BlogArticleCategory category in categoriesList) {
        String categoryName = category.name ?? "";
        if (categoryName.isNotEmpty) {
          dataList.add(UtilityMethods.getLocalizedString(categoryName));
        }
      }

      if (dataList.isNotEmpty) {
        return dataList.join(", ");
      }
    }
    return "";
  }
}


class BlogLayoutTitleWidget extends StatelessWidget {
  final BlogArticle article;
  final int? maxLines;
  final EdgeInsetsGeometry? padding;
  final TextOverflow? overflow;

  const BlogLayoutTitleWidget({
    super.key,
    required this.article,
    this.maxLines = 1,
    this.overflow = TextOverflow.clip,
    this.padding = const EdgeInsets.symmetric(horizontal: 10.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: GenericTextWidget(
        article.postTitle ?? "",
        maxLines: maxLines,
        overflow: overflow,
        strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.7
        ),
        style: AppThemePreferences().appTheme.titleTextStyle,
      ),
    );
  }
}

class BlogLayoutAuthorInfoWidget extends StatelessWidget {
  final BlogArticle article;
  final int? minAllowedChar;
  final double? width;
  final double? height;
  final double? centerPadding;
  final EdgeInsetsGeometry? padding;

  const BlogLayoutAuthorInfoWidget({
    super.key,
    required this.article,
    this.minAllowedChar,
    this.padding,
    this.width,
    this.height,
    this.centerPadding,
  });

  @override
  Widget build(BuildContext context) {
    String avatar = getUserAvatarUrl(article);
    String author = getUserName(article);

    return Container(
      padding: padding,
      child: Row(
        children: [
          if (avatar.isNotEmpty)
            BlogLayoutUserAvatarWidget(
              userAvatarUrl: avatar,
              width: width,
              height: height,
            ),
          if (avatar.isNotEmpty)
            SizedBox(width: centerPadding ?? 8),
          if (author.isNotEmpty)
            BlogLayoutAuthorNameWidget(name: author),
        ],
      ),
    );
  }

  String getUserAvatarUrl(BlogArticle article) {
    if (article.author != null) {
      return article.author!.avatar ?? "";
    }
    return "";
  }

  String getUserName(BlogArticle article) {
    if (article.author != null) {
      String userName = article.author!.name ?? "";
      if (userName.isNotEmpty) {
        if (minAllowedChar != null && userName.length > minAllowedChar!) {
          return userName.substring(0, minAllowedChar) + '...';
        }
        return userName;
      }
    }
    return "";
  }
}

class BlogLayoutUserAvatarWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String userAvatarUrl;

  const BlogLayoutUserAvatarWidget({
    Key? key,
    required this.userAvatarUrl,
    this.width = 25,
    this.height = 25,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FancyShimmerImage(
          imageUrl: userAvatarUrl,
          boxFit: BoxFit.cover,
          shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
          width: width ?? 25,
          height: height ?? 25,
          errorWidget: ShimmerEffectErrorWidget(iconData: AppThemePreferences.personIcon),
        ),
      ),
    );
  }
}

class BlogLayoutAuthorNameWidget extends StatelessWidget {
  final String name;

  const BlogLayoutAuthorNameWidget({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return GenericTextWidget(
      name,
      style: AppThemePreferences().appTheme.blogAuthorInfoTextStyle,
    );
  }
}

class BlogLayoutTimeInfoWidget extends StatelessWidget {
  final BlogArticle article;

  const BlogLayoutTimeInfoWidget({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    String time = article.postModifiedFormatted ?? "";
    if (time.isNotEmpty) {
      return Row(
        children: [
          if (showTimePadding(article)) const SizedBox(width: 20),
          Icon(
            AppThemePreferences.timeIcon,
            size: 16,
            color: AppThemePreferences.blogLayoutTimeIconColor,
          ),
          const SizedBox(width: 3),
          GenericTextWidget(time),
        ],
      );
    }
    return Container();
  }

  bool showTimePadding(BlogArticle article) {
    String name = article.author!.name ?? "";
    String avatar = article.author!.avatar ?? "";

    if (name.isNotEmpty || avatar.isNotEmpty) {
      return true;
    }
    return false;
  }
}