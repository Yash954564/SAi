import 'package:flutter/material.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';

import '../../files/app_preferences/app_preferences.dart';
import '../../files/generic_methods/utility_methods.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/generic_text_widget.dart';

class FullScreenMultiUnits extends StatefulWidget {
  final item;

  FullScreenMultiUnits(this.item);

  @override
  State<FullScreenMultiUnits> createState() => _FullScreenMultiUnitsState();
}

class _FullScreenMultiUnitsState extends State<FullScreenMultiUnits> {
  bool isInternetConnected = true;
  String faveMuTitle = "";
  String faveMuPrice = "";
  String faveMuBeds = "";
  String faveMuBaths = "";
  String faveMuSize = "";
  String faveMuSizePostfix = "";
  String faveMuType = "";
  String faveMuAvailabilityDate = "";

  @override
  void initState() {
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("multi_units"),
      ),
      body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: widget.item.length,
                itemBuilder: (context, index) {
                  var item = widget.item[index];
                  String faveMuTitle = item.title;
                  //String faveMuPrice= item.faveMuPrice;
                  String faveMuBeds = item.bedrooms;
                  String faveMuBaths = item.bathrooms;
                  String faveMuSize = "${item.size}";
                  String faveMuSizePostfix = item.sizePostfix;
                  String faveMuType = item.type;
                  String defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData();
                  String faveMuPrice = item.price;
                  if(defaultCurrency != null && defaultCurrency.isNotEmpty){
                    faveMuPrice = defaultCurrency + faveMuPrice;
                  }
                  String faveMuPricePostfix = item.pricePostfix;
                  if(faveMuPricePostfix != null && faveMuPricePostfix.isNotEmpty){
                    faveMuPrice = faveMuPrice + faveMuPricePostfix;
                  }
                  String faveMuAvailabilityDate = item.availabilityDate;
                  return CardWidget(
                    shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                    elevation: AppThemePreferences.boardPagesElevation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          showDataWidget(faveMuTitle, null),
                          showDataWidget(faveMuType, AppThemePreferences.locationCityIcon),
                          showDataWidget(faveMuAvailabilityDate, AppThemePreferences.availabilityIcon),
                          showBedAndBathData(faveMuPrice, AppThemePreferences.priceTagIcon,"$faveMuSize $faveMuSizePostfix",AppThemePreferences.areaSizeIcon),
                          showBedAndBathData(faveMuBeds, AppThemePreferences.bedIcon, faveMuBaths, AppThemePreferences.bathtubIcon),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget showDataWidget(String value, IconData? icon) {
    return value != null && value.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon != null ? Icon(icon) : Container(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GenericTextWidget(value,
                      style: icon == null
                          ? AppThemePreferences().appTheme.heading02TextStyle
                          : AppThemePreferences().appTheme.body01TextStyle),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget showBedAndBathData(
      String bed, IconData bedIcon, String bath, IconData bathIcon) {
    return bed != null && bed.isNotEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(bedIcon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GenericTextWidget(
                    bed,
                    overflow: TextOverflow.ellipsis,
                    style: AppThemePreferences().appTheme.body01TextStyle,
                  ),
                ),
              ),
              Icon(bathIcon),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: GenericTextWidget(
                    bath,
                    overflow: TextOverflow.ellipsis,
                    style: AppThemePreferences().appTheme.body01TextStyle,
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
