import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class PropertyDetailPageTitle extends StatefulWidget {
  final Article article;
  const PropertyDetailPageTitle({required this.article, Key? key}) : super(key: key);

  @override
  State<PropertyDetailPageTitle> createState() => _PropertyDetailPageTitleState();
}

class _PropertyDetailPageTitleState extends State<PropertyDetailPageTitle> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    title = widget.article.title ?? "";
    if(title.isNotEmpty){
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: GenericTextWidget(
          UtilityMethods.stripHtmlIfNeeded(title),
          strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
          style: AppThemePreferences().appTheme.propertyDetailsPagePropertyTitleTextStyle,
        ),
      );
    }else{
      return Container();
    }
  }
}
