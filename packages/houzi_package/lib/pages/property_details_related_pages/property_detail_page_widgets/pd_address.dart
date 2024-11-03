import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class PropertyDetailPageAddress extends StatefulWidget {
  final Article article;
  const PropertyDetailPageAddress({required this.article, Key? key}) : super(key: key);

  @override
  State<PropertyDetailPageAddress> createState() => _PropertyDetailPageAddressState();
}

class _PropertyDetailPageAddressState extends State<PropertyDetailPageAddress> {
  String address = "";

  @override
  Widget build(BuildContext context) {
    address = widget.article.address!.address ?? "";
    if(address.isNotEmpty){
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: GenericTextWidget(
          widget.article.address!.address!,
          strutStyle: StrutStyle(height: AppThemePreferences.genericTextHeight),
          style: AppThemePreferences().appTheme.bodyTextStyle,
          textAlign: TextAlign.left,
        ),
      );
    }
    return Container();
  }
}
