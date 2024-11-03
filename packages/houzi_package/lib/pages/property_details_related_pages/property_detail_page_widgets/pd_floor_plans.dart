import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_image_view.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/staggeredGridWidget.dart';

class PropertyDetailPageFloorPlans extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageFloorPlans({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageFloorPlans> createState() =>
      _PropertyDetailPageFloorPlansState();
}

class _PropertyDetailPageFloorPlansState
    extends State<PropertyDetailPageFloorPlans> {
  Article? _article;

  String title = "";
  List<dynamic> floorPlansList = [];

  @override
  void initState() {
    _article = widget.article;
    loadData(_article!);
    super.initState();
  }

  loadData(Article article) {
    floorPlansList = article.features!.floorPlansList ?? [];
    title = widget.title;
    if(mounted)setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    if (title.isEmpty) {
      title = UtilityMethods.getLocalizedString("floor_plans");
    }

    return floorPlansList.isNotEmpty
        ? Column(
            children: [
              textHeadingWidget(text: UtilityMethods.getLocalizedString(title)),
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
                child: Column(
                  children: floorPlansList.map((item) {
                    int index = floorPlansList.indexOf(item);
                    Map<String, dynamic> floorPlanDetailsMap = {};

                    String title = item.title ?? "";
                    String rooms = item.rooms ?? "";
                    String bathrooms = item.bathrooms ?? "";
                    String price = item.price ?? "";
                    String pricePostFix = item.pricePostFix ?? "";
                    if (price.isNotEmpty && pricePostFix.isNotEmpty) {
                      price = price + pricePostFix;
                    }
                    String size = item.size ?? "";
                    String image = item.image ?? "";
                    // String description = item.description;

                    if (rooms.isNotEmpty) {
                      floorPlanDetailsMap[FLOOR_PLAN_ROOMS] = {
                        FLOOR_PLAN_ICON: AppThemePreferences.bedIcon,
                        FLOOR_PLAN_VALUE: rooms,
                      };
                    }
                    if (bathrooms.isNotEmpty) {
                      floorPlanDetailsMap[FLOOR_PLAN_BATHROOMS] = {
                        FLOOR_PLAN_ICON: AppThemePreferences.bathtubIcon,
                        FLOOR_PLAN_VALUE: bathrooms,
                      };
                    }
                    if (price.isNotEmpty) {
                      floorPlanDetailsMap[FLOOR_PLAN_PRICE] = {
                        FLOOR_PLAN_ICON: AppThemePreferences.priceTagIcon,
                        FLOOR_PLAN_VALUE: price,
                      };
                    }
                    if (size.isNotEmpty) {
                      floorPlanDetailsMap[FLOOR_PLAN_SIZE] = {
                        FLOOR_PLAN_ICON: AppThemePreferences.areaSizeIcon,
                        FLOOR_PLAN_VALUE: size,
                      };
                    }

                    // floorPlanDetailsMap = {};
                    return floorPlanDetailsMap.isEmpty
                        ? FloorPlanWithoutDetails(
                            title: title,
                            index: index,
                            onFloorPlanTap: () => onFloorPlanTap(title, image),
                          )
                        : FloorPlanWithDetails(
                            title: title,
                            index: index,
                            image: image,
                            floorPlanDetailsMap: floorPlanDetailsMap,
                            onFloorPlanTap: () => onFloorPlanTap(title, image),
                          );
                  }).toList(),
                ),
              ),
            ],
          )
        : Container();
  }

  void onFloorPlanTap(String title, String imageURL) {
    // if (imageURL.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageView(
            imageUrls: [imageURL],
            tag: title + "floorPlans",
            floorPlan: true,
          ),
        ),
      );
    // }
  }
}

class FloorPlanWithoutDetails extends StatelessWidget {
  final String title;
  final int index;
  final void Function()? onFloorPlanTap;

  const FloorPlanWithoutDetails({
    super.key,
    required this.title,
    required this.index,
    this.onFloorPlanTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      elevation: AppThemePreferences.zeroElevation,
      color: AppThemePreferences()
          .appTheme
          .containerBackgroundColor,
      shape: AppThemePreferences.roundedCorners(
          AppThemePreferences.globalRoundedCornersRadius),
      child: InkWell(
        borderRadius:
        const BorderRadius.all(Radius.circular(5)),
        onTap: onFloorPlanTap,
        child: Container(
          padding:
          const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: GenericTextWidget(
                  title.isNotEmpty ? UtilityMethods.getLocalizedString(title) :
                  "${UtilityMethods.getLocalizedString("floor_plan")} ${index + 1}",
                  strutStyle: StrutStyle(
                      height: AppThemePreferences.genericTextHeight),
                  style: AppThemePreferences().appTheme.label01TextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                    10, 0, 10, 5),
                child: CircleAvatar(
                  radius: 13,
                  backgroundColor: AppThemePreferences()
                      .appTheme
                      .homeScreenTopBarRightArrowBackgroundColor,
                  // backgroundColor: AppThemePreferences().appTheme.primaryColor,
                  child: AppThemePreferences()
                      .appTheme
                      .propertyDetailPageRightArrowIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FloorPlanWithDetails extends StatelessWidget {
  final String title;
  final String image;
  final int index;
  final Map<String, dynamic> floorPlanDetailsMap;
  final void Function()? onFloorPlanTap;

  const FloorPlanWithDetails({
    super.key,
    required this.title,
    required this.image,
    required this.index,
    required this.floorPlanDetailsMap,
    this.onFloorPlanTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 1, vertical: 1),
      child: CardWidget(
        elevation: AppThemePreferences.zeroElevation,
        color: AppThemePreferences()
            .appTheme
            .containerBackgroundColor,
        shape: AppThemePreferences.roundedCorners(
            AppThemePreferences
                .globalRoundedCornersRadius),
        child: InkWell(
          borderRadius:
          const BorderRadius.all(Radius.circular(5)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageView(
                  imageUrls: [image],
                  tag: title + "floorPlans",
                  floorPlan: true,
                ),
              ),
            );
          },
          child: Container(
            padding:
            const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      10, 0, 10, 5),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString(title),
                        strutStyle: StrutStyle(
                            height: AppThemePreferences
                                .genericTextHeight),
                        style: AppThemePreferences()
                            .appTheme
                            .label01TextStyle,
                      ),
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString(
                            "view_floor_plan"),
                        strutStyle: StrutStyle(
                            height: AppThemePreferences
                                .genericTextHeight),
                        style: AppThemePreferences()
                            .appTheme
                            .readMoreTextStyle,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      10, 0, 10, 10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 50,
                      maxHeight: 60,
                    ),
                    child: CustomStaggeredGridWidget(
                      physics:
                      const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      //floorPlanMap.length,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10),
                      itemCount: floorPlanDetailsMap.length,
                      itemBuilder: (context, index) {
                        var key = floorPlanDetailsMap.keys
                            .elementAt(index);
                        var icon = floorPlanDetailsMap[key][FLOOR_PLAN_ICON];
                        var value = floorPlanDetailsMap[key][FLOOR_PLAN_VALUE] ?? "";
                        return Row(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: AppThemePreferences
                                  .propertyDetailsFloorPlansIconSize,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(
                                  left: 8.0),
                              child: GenericTextWidget(
                                key == FLOOR_PLAN_PRICE
                                    ? "${HiveStorageManager.readDefaultCurrencyInfoData() ?? '\$'}$value"
                                    : value,
                                strutStyle: StrutStyle(
                                  height: AppThemePreferences
                                      .genericTextHeight,),
                                style:
                                AppThemePreferences()
                                    .appTheme
                                    .label01TextStyle,
                              ),
                            ),
                          ],
                        );
                      },
                      staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 90, //100
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


