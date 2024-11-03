import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/featured_tag_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/tags_widgets/tag_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class PropertyDetailPageStatusAndPrice extends StatefulWidget {
  final Article article;

  const PropertyDetailPageStatusAndPrice({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  State<PropertyDetailPageStatusAndPrice> createState() => _PropertyDetailPageStatusAndPriceState();
}

class _PropertyDetailPageStatusAndPriceState extends State<PropertyDetailPageStatusAndPrice> {
  Article? _article;
  String _propertyStatus = "";
  String _finalPrice = "";
  List propertyTagsList = [];

  @override
  void initState() {
    super.initState();
    _article = widget.article;
    loadData();
  }

  loadData() {
    List _propertyStatusList = widget.article.features!.propertyStatusList ?? [];
    List _propertyLabelList = widget.article.features!.propertyLabelList ?? [];
    propertyTagsList = [..._propertyStatusList, ..._propertyLabelList];
    bool _isFeatured = widget.article.propertyInfo!.isFeatured ?? false;
    if (_isFeatured) {
      propertyTagsList.insert(0, _isFeatured);
    }
    _propertyStatus = widget.article.propertyInfo!.propertyStatus ?? "";
    _finalPrice = _article!.getListingPrice();
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData();
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (propertyTagsList.isNotEmpty)
            Wrap(
              children: propertyTagsList.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5,bottom: 5),
                  child: item is bool ? FeaturedTagWidget() : TagWidget(label: item),
                );
              }).toList(),
            )
          else if(_propertyStatus.isNotEmpty) TagWidget(label: _propertyStatus),
          if(_finalPrice.isNotEmpty) Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GenericTextWidget(
              _finalPrice,
              strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.propertyDetailsPagePropertyPriceTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
