import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_image_view.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PropertyDetailPageImages extends StatefulWidget {
  final Article article;
  final String heroId;
  final String thumbnail;

  const PropertyDetailPageImages({
    required this.article,
    required this.heroId,
    required this.thumbnail,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageImages> createState() =>
      _PropertyDetailPageImagesState();
}

class _PropertyDetailPageImagesState extends State<PropertyDetailPageImages> {
  Article? _article;
  String firstImage = "";
  List<String> imageUrlsList = [];
  int currentImageIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    _article = widget.article;
    imageUrlsList = _article!.imageList ?? [];
    if (imageUrlsList.isNotEmpty) {
      firstImage = imageUrlsList[0];
    }
    loadData(_article!);

    super.initState();
  }

  loadData(Article article) {
    imageUrlsList = article.imageList ?? [];
    if (imageUrlsList.isNotEmpty && imageUrlsList.first != firstImage) {
      imageUrlsList.insert(0, firstImage);
    }
    if (imageUrlsList.isEmpty && widget.thumbnail.isNotEmpty) {
      imageUrlsList.add(widget.thumbnail);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return Stack(
      children: <Widget>[
        articleImagesWidget(),
        imageIndicators(),
        imageCountIndicator(),
      ],
    );
  }

  Widget articleImagesWidget() {
    return imageUrlsList.isNotEmpty
        ? Hero(
            tag: widget.heroId,
            child: SizedBox(
              height: (UtilityMethods.showTabletView) ? 500 : 500,
              child: PageView(
                controller: pageController,
                onPageChanged: (int page) {
                  setState(() {
                    currentImageIndex = page;
                  });
                },
                children: List.generate(
                  imageUrlsList.length,
                  (index) {
                    bool _validURL =
                        UtilityMethods.validateURL(imageUrlsList[index]);
                    return GestureDetector(
                      child: !_validURL
                          ? ShimmerEffectErrorWidget(iconSize: 100)
                          : FancyShimmerImage(
                              imageUrl: imageUrlsList[index],
                              boxFit: BoxFit.cover,
                              shimmerBaseColor: AppThemePreferences()
                                  .appTheme
                                  .shimmerEffectBaseColor,
                              shimmerHighlightColor: AppThemePreferences()
                                  .appTheme
                                  .shimmerEffectHighLightColor,
                              width: MediaQuery.of(context).size.width,
                              errorWidget:
                                  ShimmerEffectErrorWidget(iconSize: 100),
                            ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageView(
                              imageUrls: imageUrlsList,
                              tag: widget.heroId,
                              floorPlan: false,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          )
        : Container(
            height: 300,
            child: errorWidget(),
          );
  }

  Widget errorWidget() {
    return Container(
      color: AppThemePreferences()
          .appTheme
          .shimmerEffectErrorWidgetBackgroundColor,
      child: Center(
          child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }

  Widget imageIndicators() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: imageUrlsList.length > 1
            ? SmoothPageIndicator(
                controller: pageController,
                count: imageUrlsList.length,
                effect: ScrollingDotsEffect(
                  dotHeight: 10.0,
                  dotWidth: 10.0,
                  spacing: 10,
                  dotColor: AppThemePreferences.countIndicatorsColor!,
                  activeDotColor: AppThemePreferences().appTheme.primaryColor!,
                ),
              )
            : Container(),
      ),
    );
  }

  Widget imageCountIndicator() {
    return Positioned(
      bottom: 30,
      left: UtilityMethods.isRTL(context) ? 10 : null,
      right: UtilityMethods.isRTL(context) ? null : 10,
      child: Align(
        alignment: Alignment.bottomRight,
        child: imageUrlsList.length > 1
            ? Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppThemePreferences.imageCountIndicatorBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppThemePreferences()
                        .appTheme
                        .propertyDetailsImageIndicatorCameraIcon!,
                    GenericTextWidget(
                      " ${currentImageIndex + 1}/${imageUrlsList.length}",
                      style: AppThemePreferences()
                          .appTheme
                          .propertyDetailsPageImageIndicatorTextTextStyle,
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
