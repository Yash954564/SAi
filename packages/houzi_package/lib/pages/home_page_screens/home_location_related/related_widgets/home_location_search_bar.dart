import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/bloc/api_providers/place_api_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/address_search.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:uuid/uuid.dart';

class HomeLocationSearchBarWidget extends StatefulWidget{

  const HomeLocationSearchBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeLocationSearchBarWidgetState();
}

class HomeLocationSearchBarWidgetState extends State<HomeLocationSearchBarWidget> {

  Map<String, dynamic> _filterDataMap = {};
  Map<String, dynamic> _searchDataMap = {};
  String _selectedLocation = '';
  String _latitude = '';
  String _longitude = '';

  @override
  void initState() {
    super.initState();
    _filterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};
    if(_filterDataMap.isNotEmpty){
      if(_filterDataMap.containsKey(SELECTED_LOCATION)){
        _selectedLocation = _filterDataMap[SELECTED_LOCATION] ?? "";
        _searchDataMap[SELECTED_LOCATION] = _selectedLocation;
      }
      if(_filterDataMap.containsKey(LATITUDE)){
        _latitude = _filterDataMap[LATITUDE] ?? "";
        _searchDataMap[LATITUDE] = _latitude;
      }
      if(_filterDataMap.containsKey(LONGITUDE)){
        _longitude = _filterDataMap[LONGITUDE] ?? "";
        _searchDataMap[LONGITUDE] = _longitude;
      }



      // print("_selectedLocation: $_selectedLocation");
      // print("_latitude: $_latitude");
      // print("_longitude: $_longitude");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: locationBarWidget(),
          ),),

        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: searchIconButtonWidget(),
            // child: searchButtonWidget(),
          ),),
      ],
    );
  }

  Widget locationBarWidget(){
    return GestureDetector(
      onTap: () async{
        final sessionToken = const Uuid().v4();
        final Suggestion? result = await showSearch(
          context: context,
          delegate: AddressSearch(sessionToken),
          query: _selectedLocation,
        );
        if (result != null) {
          var response = await PlaceApiProvider.getPlaceDetailFromPlaceId(result.placeId!);
          Map addressMap = response.data ?? {};
          try {
            if(addressMap.isNotEmpty){
              var lat = addressMap["result"]["geometry"]["location"]["lat"];
              var lng = addressMap["result"]["geometry"]["location"]["lng"];
              setState(() {
                _selectedLocation = addressMap["result"]["formatted_address"] ?? "";
                if(lat != null) {
                  _latitude = lat.toString();
                }
                if(lng != null) {
                  _longitude = lng.toString();
                }
              });

              _searchDataMap[SELECTED_LOCATION] = _selectedLocation;
              _searchDataMap[LATITUDE] = _latitude;
              _searchDataMap[LONGITUDE] = _longitude;

              // _filterDataMap[SELECTED_LOCATION] = _selectedLocation;
              // _filterDataMap[LATITUDE] = _latitude;
              // _filterDataMap[LONGITUDE] = _longitude;
            }
          } catch (e) {
            e.toString();
          }
        }
      },
      child: SizedBox(
        height: 36.0,
        child: TextFormField(
          readOnly: true,
          strutStyle: const StrutStyle(forceStrutHeight: true),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabled: false,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor!),
            ),
              // disabledBorder: InputBorder.none,
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12.0),
            //   borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor),
            // ),
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12.0),
            //   borderSide: BorderSide(color: AppThemePreferences().appTheme.searchBarBackgroundColor),
            // ),
            contentPadding: const EdgeInsets.only(top: 5, left: 0, right: 0),
            // contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            fillColor: AppThemePreferences().appTheme.searchBarBackgroundColor,
            filled: true,
            hintText: (_selectedLocation.isEmpty) ?
                    UtilityMethods.getLocalizedString("location") : _selectedLocation,
            hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),//10
              child: Icon(
                AppThemePreferences.gpsLocationIcon,
                size: AppThemePreferences.homeScreenSearchBarIconSize,
                color: AppThemePreferences().appTheme.homeScreenSearchBarIconColor,
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              maxWidth: 50,
            )
          ),
        ),
      ),
    );
  }

  Widget searchButtonWidget(){
    return ButtonWidget(
      text: UtilityMethods.getLocalizedString("search"),
      fontSize: 10,
      buttonHeight: 36,
      buttonStyle: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: AppThemePreferences.actionButtonBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppThemePreferences.actionButtonBackgroundColor)
        ),
      ),
      onPressed: ()=> onSearchPressed(),
    );
  }

  Widget searchIconButtonWidget(){
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: AppThemePreferences.actionButtonBackgroundColor,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: ()=> onSearchPressed(),
        icon: Icon(
          UtilityMethods.isRTL(context) ?
          AppThemePreferences.homeScreenSearchArrowIconRTL :
          AppThemePreferences.homeScreenSearchArrowIconLTR,
          color: AppThemePreferences().appTheme.homeScreenSearchArrowIconBackgroundColor,
        ),
      ),
    );
  }

  onSearchPressed(){
    if(_searchDataMap.isNotEmpty){
      _searchDataMap[USE_RADIUS] = "on";
      _searchDataMap[SEARCH_LOCATION] = "true";
      _searchDataMap[RADIUS] = "50";
      HiveStorageManager.storeFilterDataInfo(map: _searchDataMap);
      GeneralNotifier().publishChange(GeneralNotifier.FILTER_DATA_LOADING_COMPLETE);
    }

    UtilityMethods.storeOrUpdateRecentSearches(_searchDataMap);

    // print(HiveStorageManager.readFilterDataInfo());

    UtilityMethods.navigateToSearchResultScreen(
        context: context,
        dataInitializationMap: _searchDataMap,
        // dataInitializationMap: HiveStorageManager.readFilterDataInfo() ?? {},
        navigateToSearchResultScreenListener: ({filterDataMap}){

        }
    );

    // Reset the Fields for next Search
    // setState(() {
    //   _selectedLocation = '';
    //   _latitude = '';
    //   _longitude = '';
    //   _filterDataMap = {};
    // });
  }
}