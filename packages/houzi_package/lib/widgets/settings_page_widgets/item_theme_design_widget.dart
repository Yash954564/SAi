import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/property_meta_data.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design.dart';
import 'package:houzi_package/widgets/generic_settings_row_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class ItemThemeDesignWidget extends StatefulWidget {
  final ItemDesignNotifier itemDesignNotifier;
  final String tag;

  const ItemThemeDesignWidget({
    Key? key,
    required this.itemDesignNotifier,
    required this.tag,
  }) : super(key: key);

  @override
  State<ItemThemeDesignWidget> createState() => _ItemThemeDesignWidgetState();
}

class _ItemThemeDesignWidgetState extends State<ItemThemeDesignWidget> {

  String? _selectedItemDesign;
  String? _selectedExploreByTypeDesign;

  @override
  Widget build(BuildContext context) {
    return !SHOW_THEME_RELATED_SETTINGS ? Container() : GenericSettingsWidget(
      headingText: UtilityMethods.getLocalizedString("item_theme_design"),
      headingSubTitleText: UtilityMethods.getLocalizedString("customise_your_item_theme_design"),
      body: ThemeDesignDropDownWidget(
        tag: widget.tag,
        design: getDesign(),
        designList: getDesignList(),
        onChanged: (String? val) {
          if(widget.tag == ITEM_THEME_DESIGN){
            onItemDesignChange(val);
          }else if(widget.tag == EXPLORE_BY_TYPE_ITEM_THEME_DESIGN){
            onExploreTermDesignChanged(val);
          }
        },
      ),
    );
  }

  String getDesign(){
    if(widget.tag == ITEM_THEME_DESIGN){
      return widget.itemDesignNotifier.homeScreenItemDesign;
    }else if(widget.tag == EXPLORE_BY_TYPE_ITEM_THEME_DESIGN){
      return widget.itemDesignNotifier.exploreByTypeItemDesign;
    }

    return UtilityMethods.getLocalizedString("select");
  }

  List<String> getDesignList(){
    List<String> list = [];
    if(widget.tag == ITEM_THEME_DESIGN){
      list = HOME_SCREEN_ITEM_DESIGN_LIST;
    }else if(widget.tag == EXPLORE_BY_TYPE_ITEM_THEME_DESIGN){
      list = EXPLORE_BY_TYPE_ITEM_DESIGN_LIST;
    }

    return list;
  }

  onItemDesignChange(String? val) {
    if(mounted) setState(() {
      _selectedItemDesign = val!;
    });
    widget.itemDesignNotifier.setHomeScreenItemDesign(_selectedItemDesign!);
    ShowToastWidget(
      buildContext: context,
      text: UtilityMethods.getLocalizedString("item_design_is_successfully_updated"),
    );
  }

  onExploreTermDesignChanged(String? val) {
    if(mounted) setState(() {
      _selectedExploreByTypeDesign = val!;
    });
    widget.itemDesignNotifier.setExploreByTypeItemDesign(_selectedExploreByTypeDesign!);
    ShowToastWidget(
      buildContext: context,
      text: UtilityMethods.getLocalizedString("explore_by_type_is_successfully_updated"),
    );
  }
}

class ThemeDesignDropDownWidget extends StatefulWidget {
  final String tag;
  final String design;
  final List<String> designList;
  final void Function(String?) onChanged;

  ThemeDesignDropDownWidget({
    Key? key,
    required this.tag,
    required this.design,
    required this.designList,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ThemeDesignDropDownWidget> createState() => _ThemeDesignDropDownWidgetState();
}

class _ThemeDesignDropDownWidgetState extends State<ThemeDesignDropDownWidget> {

  List<dynamic> propertyMetaDataListForThemeDesign = [];

  final ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
  final ExploreByTypeDesign _exploreByTypeDesign = ExploreByTypeDesign();

  final Article _article = Article(
    title: "Title",
  );

  final Address _address = Address(
    address: "Address",
  );

  final Features _features = Features(
    propertyArea: "1000",
    propertyAreaUnit: "SqFt",
    bedrooms: "2",
    bathrooms: "2",
    garage: "1",
  );

  final PropertyInfo _propertyInfo = PropertyInfo(
    propertyStatus: "For Sale",
    price: "\$1000000",
    featured: "1",
    propertyType: "Villa",
  );
  final Term _propertyMetaData01 = Term(
    id: 01,
    name: "Title",
    slug: "title",
    parent: 0,
    totalPropertiesCount: 10,
    fullImage:  "assets/settings/dummy_property_image_01.jpg",
  );

  final Term _propertyMetaData02 = Term(
    id: 02,
    name: "Title",
    slug: "title",
    parent: 0,
    totalPropertiesCount: 10,
    fullImage:  "assets/settings/dummy_property_image_02.jpg",
  );

  final Term _propertyMetaData03 = Term(
    id: 03,
    name: "Title",
    slug: "title",
    parent: 0,
    totalPropertiesCount: 10,
    fullImage:  "assets/settings/dummy_property_image_03.jpg",
  );

  @override
  void initState() {

    _article.address = _address;
    _article.features = _features;
    _article.propertyInfo = _propertyInfo;
    _article.propertyDetailsMap!["Price"] = "1000000";
    propertyMetaDataListForThemeDesign = [_propertyMetaData01, _propertyMetaData02, _propertyMetaData03];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            itemHeight: null,
            isExpanded: true,
            icon: Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 10.0),
              child: Icon(AppThemePreferences.dropDownArrowIcon),
            ),
            hint: Container(
              padding: const EdgeInsets.only(right: 10.0,left: 10.0),
              child: GenericTextWidget(widget.design),
            ),
            items: widget.designList.map<DropdownMenuItem<String>>((item) {
              String heroId = "hero-" + item;
              return DropdownMenuItem<String>(
                value: item,
                child: ExpandablePanel(
                  theme: ExpandableThemeData(iconColor: AppThemePreferences.appIconsMasterColorLight),
                  header: GenericTextWidget(item),
                  expanded: SizedBox(
                    height: getExpandableOptionHeight(tag: widget.tag, design: item),
                    child: getExpandableOptionDesignWidget(tag: widget.tag, design: item),
                  ),
                  collapsed: Container(),
                ),
              );
            }).toList(),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }

  double? getExpandableOptionHeight({
    required String tag,
    required String design
  }){
    if(tag == ITEM_THEME_DESIGN){
      return _articleBoxDesign.getArticleBoxDesignHeight(design: design);
    }else if(tag == EXPLORE_BY_TYPE_ITEM_THEME_DESIGN){
      return _exploreByTypeDesign.getExploreByTypeDesignHeight(design: design);
    }
    return null;
  }

  Widget getExpandableOptionDesignWidget({
    required String tag,
    required String design,
  }) {
    if (tag == ITEM_THEME_DESIGN) {
      return _articleBoxDesign.getArticleBoxDesign(
        article: _article,
        heroId: "hero-${UtilityMethods.getRandomNumber()}",
        buildContext: context,
        design: design,
        isInMenu: true,
        onTap: () {},
      );
    } else if (tag == EXPLORE_BY_TYPE_ITEM_THEME_DESIGN) {
      return _exploreByTypeDesign.getExploreByTypeDesign(
        design: design,
        buildContext: context,
        metaDataList: propertyMetaDataListForThemeDesign,
        isInMenu: true,
        onTap: (slug, taxonomy) {},
      );
    }
    return Container();
  }
}

