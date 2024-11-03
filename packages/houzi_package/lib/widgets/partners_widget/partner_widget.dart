import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/partner.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerWidget extends StatelessWidget {
  final List<dynamic> partnersList;
  final String listingView;

  const PartnerWidget({
    Key? key,
    required this.partnersList,
    this.listingView = CAROUSEL_VIEW,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return partnersList.isEmpty ? Container() : SizedBox(
      height: listingView == CAROUSEL_VIEW ? 130 : null,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: listingView == LIST_VIEW
            ? Axis.vertical : Axis.horizontal,
        physics: listingView == LIST_VIEW
            ? const NeverScrollableScrollPhysics() : null,
        itemCount: partnersList.length,
        itemBuilder: (context, index) {
          var item = partnersList[index];
          if (item is Partner) {
            return Container(
              height: 140,
              padding: listingView == LIST_VIEW
                  ? const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                  : EdgeInsets.only(
                left: UtilityMethods.isRTL(context)
                    ? (index == (partnersList.length - 1) ? 20.0 : 0.0)
                    : (index == 0 ? 20.0 : 5.0),
                right: UtilityMethods.isRTL(context)
                    ? (index == 0 ? 20.0 : 5.0)
                    : (index == (partnersList.length - 1) ? 20.0 : 0.0),
                bottom: 10.0,
              ),
              child: listingView == LIST_VIEW ? Row(
                children: [
                  Expanded(child:  PartnerViewWidget(
                    imageURL: item.featuredImageUrl ?? "",
                    websiteLink: item.link ?? "",
                  )),
                ],
              )
                  : PartnerViewWidget(
                imageURL: item.featuredImageUrl ?? "",
                websiteLink: item.link ?? "",
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class PartnerViewWidget extends StatelessWidget {
  final String websiteLink;
  final String imageURL;
  final double? imageWidth;

  const PartnerViewWidget({
    super.key,
    required this.websiteLink,
    required this.imageURL,
    this.imageWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
      child: CardWidget(
        color: AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.articleDesignRoundedCornersRadius),
        elevation: AppThemePreferences.articleDeignsElevation,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: PartnerImageWidget(
            imageURL: imageURL,
            imageWidth: imageWidth,
          ),
          onTap: () async {
            if(websiteLink.isNotEmpty) {
              if (await canLaunchUrl(Uri.parse(websiteLink))) {
                await launchUrl(
                  Uri.parse(websiteLink),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                print('Could not launch $websiteLink');
              }
            }
          },
        ),
      ),
    );
  }
}

class PartnerImageWidget extends StatelessWidget {
  final String imageURL;
  final double? imageWidth;

  const PartnerImageWidget({
    super.key,
    required this.imageURL,
    this.imageWidth = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: imageWidth,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: FancyShimmerImage(
          cacheKey: imageURL,
          imageUrl: imageURL,
          boxFit: BoxFit.fill,
          errorWidget: const ShimmerEffectErrorWidget(iconSize: 50),
        ),
      ),
    );
  }
}


