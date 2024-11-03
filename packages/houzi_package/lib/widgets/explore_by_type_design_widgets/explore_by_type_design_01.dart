import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/staggeredGridWidget.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

Widget exploreByTypeDesign01({
  required BuildContext context,
  required List<dynamic> data,
  bool isInMenu = false,
  required Function(String, String) onTap,
}) {
  return Container(
    // padding: EdgeInsets.only(left: 10),
    padding: EdgeInsets.only(
        left: UtilityMethods.isRTL(context) ? 0 : 10,
        right: UtilityMethods.isRTL(context) ? 10 : 0),
    height: 400,
    margin: const EdgeInsets.all(10),
    child: CustomStaggeredGridWidget(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        //10,
        mainAxisSpacing: 12,
        //12,
        itemCount: data.length,
        itemBuilder: (context, index) {
          var item = data[index];
          return design01(
              context: context,
              metaDataList: data,
              item: item,
              isInMenu: isInMenu,
              onTap: onTap);
        },
        staggeredTileBuilder: (index) {
          return StaggeredTile.count(
            1,
            data[index].name.length > 13 || index.isEven ? 1.6 : 1,
          );
        }),
  );
}

Widget design01({
  required BuildContext context,
  required List<dynamic> metaDataList,
  var item,
  bool isInMenu = false,
  required Function(String, String) onTap,
}) {
  bool _validURL = UtilityMethods.validateURL(item.fullImage);
  return isInMenu == false
      ? Stack(
          children: [
            SizedBox(
              height: 200, //240,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    !_validURL
                        ? errorWidget()
                        : FancyShimmerImage(
                            imageUrl: item.fullImage,
                            boxFit: BoxFit.cover,
                            shimmerBaseColor: AppThemePreferences()
                                .appTheme
                                .shimmerEffectBaseColor,
                            shimmerHighlightColor: AppThemePreferences()
                                .appTheme
                                .shimmerEffectHighLightColor,
                            errorWidget: errorWidget(),
                          ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor:
                              Theme.of(context).highlightColor.withOpacity(0.5),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          onTap: () {
                            onTap(item.slug, item.taxonomy);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: InkWell(
                onTap: () {
                  onTap(item.slug, item.taxonomy);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: GenericTextWidget(
                            "${item.totalPropertiesCount} ${UtilityMethods.getLocalizedString("properties")}",
                            style:
                                AppThemePreferences().appTheme.subBodyTextStyle,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: GenericTextWidget(
                            HtmlUnescape().convert(item.name),
                            maxLines: 1,
                            strutStyle:
                                const StrutStyle(forceStrutHeight: true),
                            overflow: TextOverflow.ellipsis,
                            style: AppThemePreferences()
                                .appTheme
                                .explorePropertyTextStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      : Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200, //240,
                  width: MediaQuery.of(context).size.width, //330,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.asset(
                      item.fullImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              // right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.8),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: GenericTextWidget(
                          "${item.totalPropertiesCount} ${UtilityMethods.getLocalizedString("properties")}",
                          style:
                              AppThemePreferences().appTheme.subBodyTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                        child: GenericTextWidget(
                          HtmlUnescape().convert(item.name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppThemePreferences()
                              .appTheme
                              .explorePropertyTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
}

Widget errorWidget() {
  return Container(
    color:
        AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
    child: Center(
      child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon,
    ),
  );
}
