import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/property_details_page.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class DefaultRightBarButtonIdWidget extends StatefulWidget {
  const DefaultRightBarButtonIdWidget({Key? key}) : super(key: key);

  @override
  State<DefaultRightBarButtonIdWidget> createState() => _DefaultRightBarButtonIdWidgetState();
}

class _DefaultRightBarButtonIdWidgetState extends State<DefaultRightBarButtonIdWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppThemePreferences().appTheme.homeScreenTopBarSearchIcon!,
          GenericTextWidget(
            UtilityMethods.getLocalizedString("id"),
            style: AppThemePreferences().appTheme.searchByIdTextStyle,
          ),
        ],
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _searchByPropertyIdDialog(context);
      },
    );
  }

  Future _searchByPropertyIdDialog(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String propertyId = "";
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("search_property"),
      textAlign: TextAlign.center,
      content: Form(
        key: formKey,
        child: TextFormField(
          textInputAction: TextInputAction.search,
          // keyboardType: TextInputType.text,
          // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly,],
          onFieldSubmitted: (text) {
            if(formKey.currentState!.validate()){
              searchByIdOnSubmit(context, propertyId);
            }
          },
          onChanged: (text){
            propertyId = text;
          },
          validator: (text){
            if(text == null || text.isEmpty){
              return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: UtilityMethods.getLocalizedString("search"),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide(color: AppThemePreferences().appTheme.primaryColor!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            suffixIcon: AppThemePreferences().appTheme.searchBarIcon,
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          ),
        ),
      ),
      actions: <Widget>[
        TextButtonWidget(
          onPressed: () => Navigator.pop(context),
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
        ),
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("go")),
          onPressed: () {
            if(formKey.currentState!.validate()){
              searchByIdOnSubmit(context, propertyId);
            }
          },
        ),
      ],
    );
  }

  void searchByIdOnSubmit(BuildContext context, String propertyId){
    String heroId = propertyId + SINGLE + UtilityMethods.getRandomNumber().toString();
    if(UtilityMethods.isNumeric(propertyId)) {
      int id = int.parse(propertyId);
      Route route = MaterialPageRoute(
        builder: (context) => PropertyDetailsPage(
          propertyID: id,
          heroId: heroId,
          thumbnail: "",
        ),
      );
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResult(
            searchRelatedData: UtilityMethods.isText(propertyId)
                ? {PROPERTY_KEYWORD : propertyId}
                : {PROPERTY_UNIQUE_ID : propertyId},
            searchPageListener: (Map<String, dynamic> map, String closeOption){
              if(closeOption == CLOSE){
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      );
    }
  }
}
