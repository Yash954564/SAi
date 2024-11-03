import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_map_view.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/staggeredGridWidget.dart';

class PropertyDetailPageAddressDetail extends StatefulWidget {
  final Article article;
  final String title;
  final List imageUrlsList;

  const PropertyDetailPageAddressDetail({
    required this.article,
    required this.title,
    required this.imageUrlsList,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageAddressDetail> createState() => _PropertyDetailPageAddressDetailState();
}

class _PropertyDetailPageAddressDetailState extends State<PropertyDetailPageAddressDetail> {

  Article? _article;

  @override
  void initState() {
    super.initState();
    _article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
    }
    return addressWidget(widget.title);
  }

  Widget addressWidget(String title) {
    if (title == null || title.isEmpty) {
      title = UtilityMethods.getLocalizedString("address");
    }
    Map<String,dynamic> addressMap = getArticleAddressFields();
    return addressMap == null || addressMap.isEmpty ? Container() : Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textHeadingWidget(
            text: UtilityMethods.getLocalizedString(title),
            widget: openInMapButton(),
          ),
          UtilityMethods.isValidString(_article!.address!.address) ?
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,0),
            child: GenericTextWidget(
              _article!.address!.address!,
              maxLines: 2,
              strutStyle: StrutStyle(
                  height: AppThemePreferences.genericTextHeight),
              style:
              AppThemePreferences().appTheme.label01TextStyle,
            ),
          ) : Container(),
          UtilityMethods.isValidString(_article!.address!.address) ?
          Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,10),
            child: Container(
              decoration: AppThemePreferences.dividerDecoration(bottom: true,width: 1),
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(13,0,13,0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                  10, 0, 10, 0),
              child: CustomStaggeredGridWidget(
              // child: MasonryGridView.count(
              // child: StaggeredGrid.count(
              // child: GridView.custom(
                physics:
                const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,//floorPlanMap.length,
                padding: const EdgeInsets.symmetric(
                    vertical: 10),
                itemCount: addressMap.length,
                itemBuilder: (context, index) {
                  var key = addressMap.keys.elementAt(index);
                  String value = addressMap[key] ?? "";
                  if(value.isEmpty) {
                    return Container();
                  }
                  return Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      GenericTextWidget(
                        key + ":",
                        maxLines: 2,
                        strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                        style: AppThemePreferences().appTheme.label04TextStyle,
                      ),
                      GenericTextWidget(
                        value,
                        strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
                        style: AppThemePreferences().appTheme.label01TextStyle,
                      ),

                    ],
                  );
                },
                staggeredTileBuilder: (int index) =>
                const StaggeredTile.fit(1),
                mainAxisSpacing: 10,
                crossAxisSpacing: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget openInMapButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Align(
            // alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () =>navigateToFullScreenMapViewArticle(),
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("open_in_map") + " >",
                strutStyle: StrutStyle(
                    height:
                    AppThemePreferences.genericTextHeight),
                style: AppThemePreferences()
                    .appTheme
                    .readMoreTextStyle,
                // textAlign: TextAlign.justify,
              ),
            ),
          ),
        ),
      ],
    );
  }

  getArticleAddressFields(){
    Map<String,dynamic> address = {
      UtilityMethods.getLocalizedString("city") : _article!.address!.city,
      UtilityMethods.getLocalizedString("area") : _article!.address!.area,
      UtilityMethods.getLocalizedString("states")  : _article!.address!.state,
      UtilityMethods.getLocalizedString("country")  : _article!.address!.country,
    };

    address.removeWhere((key, value) => value == null || value.isEmpty);
    return address;
  }

  navigateToFullScreenMapViewArticle() {
    if (widget.imageUrlsList.isNotEmpty &&
        widget.imageUrlsList[0] != null &&
        widget.imageUrlsList[0].isNotEmpty) {
      _article!.image = widget.imageUrlsList[0];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenMapViewArticle(_article!),
        ),
      );
    }
  }
}
