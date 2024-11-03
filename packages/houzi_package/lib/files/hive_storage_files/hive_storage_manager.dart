import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/blog_models/blog_details_page_layout.dart';

import 'package:houzi_package/models/property_meta_data.dart';

class HiveStorageManager{
  static Box hiveBox = Hive.box(HIVE_BOX);

  static Future<void> openHiveBox() async {
    WidgetsFlutterBinding.ensureInitialized();
    print("Initializing Hive...");
    await Hive.initFlutter();
    print("Checking for old Box...");
    bool isBoxExists = await Hive.boxExists(HIVE_BOX_OLD);
    if(isBoxExists){
      print("Box: $HIVE_BOX_OLD exists");
      await Hive.deleteBoxFromDisk(HIVE_BOX_OLD);
    }
    print("Opening Box...");
    await Hive.openBox(HIVE_BOX);
    print("Box is Open...");
  }

  static Future<void> closeHiveBox() async {
    if (Hive.isBoxOpen(HIVE_BOX)) {
      await Hive.close();
    }
    return null;
  }

  static saveData({required String key, dynamic data}){
    hiveBox.put(key, data);
  }

  static dynamic readData({required String key}) {
    var value = hiveBox.get(key);
    return value;
  }


  static deleteData({required String key}) {
    hiveBox.delete(key);
  }

  // static saveData({String key, dynamic data}){
  //   if(Hive.isBoxOpen(HIVE_BOX)){
  //     hiveBox.put(key, data);
  //   }else{
  //     openHiveBox().then((value) {
  //       hiveBox = Hive.box(HIVE_BOX);
  //       hiveBox.put(key, data);
  //     });
  //   }
  // }
  //
  // static readData({String key}) {
  //   if(Hive.isBoxOpen(HIVE_BOX)){
  //     var value = hiveBox.get(key);
  //     return value;
  //   }else{
  //     openHiveBox().then((value) {
  //       hiveBox = Hive.box(HIVE_BOX);
  //       var value = hiveBox.get(key);
  //       return value;
  //     });
  //   }
  //   // var value = hiveBox.get(key);
  //   // return value;
  // }
  //
  // static deleteData({String key}) {
  //   if(Hive.isBoxOpen(HIVE_BOX)){
  //     hiveBox.delete(key);
  //   }else{
  //     openHiveBox().then((value) {
  //       hiveBox = Hive.box(HIVE_BOX);
  //       hiveBox.delete(key);
  //     });
  //   }
  // }

  //////////////////////////////////////////////////////////////////////////////

  static storeUrl({required String url}){
    saveData(
      key: APP_URL,
      data: url,
    );
  }

  static deleteUrl(){
    deleteData(key: APP_URL);
  }

  static readUrl(){
    return readData(key: APP_URL);
  }

  static storeUrlAuthority({required String authority}){
    saveData(
      key: APP_AUTHORITY,
      data: authority,
    );
  }

  static deleteUrlAuthority(){
    deleteData(key: APP_AUTHORITY);
  }

  static readUrlAuthority(){
    return readData(key: APP_AUTHORITY);
  }

  static storeCommunicationProtocol({required String protocol}){
    saveData(
      key: COMMUNICATION_PROTOCOL,
      data: protocol,
    );
  }

  static deleteCommunicationProtocol(){
    deleteData(key: COMMUNICATION_PROTOCOL);
  }

  static readCommunicationProtocol(){
    return readData(key: COMMUNICATION_PROTOCOL);
  }

  static storeAppInfo({required Map<String, String> appInfo}){
    saveData(
      key: APP_INFO,
      data: appInfo,
    );
  }

  static readAppInfo(){
    Map<dynamic, dynamic> result = readData(key: APP_INFO) ?? {};
    Map<String, String> appInfo = Map<String, String>();
    if(result != null && result.isNotEmpty){
      for (dynamic type in result.keys) {
        appInfo[type.toString()] = result[type].toString();
      }
    }
    return appInfo;
  }

  static storeFilterDataInfo({required Map<String, dynamic> map}){
    saveData(
      key: FILTER_DATA_INFORMATION,
      data: map,
    );
  }

  static deleteFilterDataInfo(){
    deleteData(key: FILTER_DATA_INFORMATION);
  }

  static readFilterDataInfo(){
    Map<String, dynamic> filterData = {};
    Map<dynamic, dynamic>? result = readData(key: FILTER_DATA_INFORMATION);

    if(result != null && result.isNotEmpty){
      for (dynamic type in result.keys) {
        filterData[type.toString()] = result[type];
      }
    }

    return filterData;
  }

  static storeRecentSearchesInfo({required List<dynamic> infoList}){
    saveData(
      key: RECENT_SEARCHES,
      data: infoList,
    );
  }

  static readRecentSearchesInfo(){
    return readData(key: RECENT_SEARCHES);
  }

  static deleteRecentSearchesInfo(){
    return deleteData(key: RECENT_SEARCHES);
  }

  static storeSelectedCityInfo({dynamic data}){
    saveData(
      key: SELECTED_CITY_INFORMATION,
      data: data,
    );
  }

  static Map<String, dynamic> readSelectedCityInfo(){
    Map result = readData(key: SELECTED_CITY_INFORMATION) ?? {};
    Map<String, dynamic> selectedCityInfo = {};
    if(result.isNotEmpty){
      for (dynamic type in result.keys) {
        selectedCityInfo[type.toString()] = result[type];
      }
    }
    return selectedCityInfo;
  }

  static deleteSelectedCityInfo(){
    deleteData(key: SELECTED_CITY_INFORMATION);
  }

  static storeMetaData(String key, List data){
    if(data != null && data.isNotEmpty){
      /// Encode data to String => (json.encode())
      String encodeList = Term.encode(data);
      /// Store data as String
      saveData(
        key: key,
        data: encodeList,
      );
    }
  }

  static readMetaData(String key){
    String tempString = readData(key: key) ?? "";
    if(tempString != null && tempString.isNotEmpty){
      /// Decode data to original Form => (json.decode())
      List decodedList = Term.decode(tempString);
      return decodedList;
    } else {
      List<Term> list = [];
      return list;
    }
  }

  static storeAgentCitiesMetaData(List data){
    storeMetaData(AGENT_CITIES_METADATA, data);
  }

  static readAgentCitiesMetaData(){
    return readMetaData(AGENT_CITIES_METADATA);
  }

  static deleteAgentCitiesMetaData(){
    deleteData(key: AGENT_CITIES_METADATA);
  }

  static storeAgentCategoriesMetaData(List data){
    storeMetaData(AGENT_CATEGORIES_METADATA, data);
  }

  static readAgentCategoriesMetaData(){
    return readMetaData(AGENT_CATEGORIES_METADATA);
  }

  static deleteAgentCategoriesMetaData(){
    deleteData(key: AGENT_CATEGORIES_METADATA);
  }

  static storeCitiesMetaData(List data){
    storeMetaData(CITIES_METADATA, data);
  }

  static readCitiesMetaData(){
    return readMetaData(CITIES_METADATA);
  }

  static deleteCitiesMetaData(){
    deleteData(key: CITIES_METADATA);
  }

  static storePropertyTypesMetaData(List data){
    storeMetaData(PROPERTY_TYPES_METADATA, data);
  }

  static readPropertyTypesMetaData(){
    return readMetaData(PROPERTY_TYPES_METADATA);
  }

  static deletePropertyTypesMetaData(){
    return deleteData(key: PROPERTY_TYPES_METADATA);
  }

  static deletePropertyTypesMapData(){
    deleteData(key: PROPERTY_TYPES_MAP_DATA);
  }

  static storePropertyTypesMapData(Map data){
    if(data != null && data.isNotEmpty){
      Map<String, dynamic> encodedMap = {};
      for (String key in data.keys) {
        encodedMap[key] = Term.encode(data[key]);
      }
      saveData(
        key: PROPERTY_TYPES_MAP_DATA,
        data: encodedMap,
      );
    }
  }

  static readPropertyTypesMapData(){
    Map encodedMap = readData(key: PROPERTY_TYPES_MAP_DATA) ?? {};
    if(encodedMap != null && encodedMap.isNotEmpty){
      Map<String, dynamic> decodedMap = {};
      for (String key in encodedMap.keys) {
        decodedMap[key] = Term.decode(encodedMap[key]);
      }
      return decodedMap;
    }
  }

  static storePropertyLabelsMetaData(List data){
    storeMetaData(PROPERTY_LABELS_METADATA, data);
  }

  static readPropertyLabelsMetaData(){
    return readMetaData(PROPERTY_LABELS_METADATA);
  }

  static deletePropertyLabelsMetaData(){
    return deleteData(
      key: PROPERTY_LABELS_METADATA,
    );
  }

  static storePropertyCountriesMetaData(List data){
    storeMetaData(PROPERTY_COUNTRIES_METADATA, data);
  }

  static readPropertyCountriesMetaData(){
    return readMetaData(PROPERTY_COUNTRIES_METADATA);
  }

  static deletePropertyCountriesMetaData(){
    deleteData(key: PROPERTY_COUNTRIES_METADATA);
  }

  static storePropertyStatesMetaData(List data){
    storeMetaData(PROPERTY_STATES_METADATA, data);
  }

  static readPropertyStatesMetaData(){
    return readMetaData(PROPERTY_STATES_METADATA);
  }

  static deletePropertyStatesMetaData(){
    return deleteData(
      key: PROPERTY_STATES_METADATA,
    );
  }

  static storePropertyAreaMetaData(List data){
    storeMetaData(PROPERTY_AREA_METADATA, data);
  }

  static readPropertyAreaMetaData(){
    return readMetaData(PROPERTY_AREA_METADATA);
  }

  static deletePropertyAreaMetaData(){
    return deleteData(
      key: PROPERTY_AREA_METADATA,
    );
  }

  static storeAgentCityMetaData(dynamic data){
    saveData(
      key: AGENT_CITY_METADATA,
      data: data,
    );
  }

  static readAgentCityMetaData(){
    return readData(
      key: AGENT_CITY_METADATA,
    );
  }

  static storeAgentCategoryMetaData(dynamic data){
    saveData(
      key: AGENT_CATEGORY_METADATA,
      data: data,
    );
  }

  static readAgentCategoryMetaData(){
    return readData(
      key: AGENT_CATEGORY_METADATA,
    );
  }

  static storePropertyStatusMetaData(List data){
    storeMetaData(PROPERTY_STATUS_METADATA, data);
  }

  static readPropertyStatusMetaData(){
    return readMetaData(PROPERTY_STATUS_METADATA);
  }

  static deletePropertyStatusMetaData(){
    deleteData(key: PROPERTY_STATUS_METADATA);
  }

  static storePropertyStatusMapData(Map data){
    if(data != null && data.isNotEmpty){
      Map<String, dynamic> encodedMap = {};
      for (String key in data.keys) {
        encodedMap[key] = Term.encode(data[key]);
      }
      saveData(
        key: PROPERTY_STATUS_MAP_DATA,
        data: encodedMap,
      );
    }
  }

  static readPropertyStatusMapData(){
    Map encodedMap = readData(key: PROPERTY_STATUS_MAP_DATA) ?? {};
    if(encodedMap != null && encodedMap.isNotEmpty){
      Map<String, dynamic> decodedMap = {};
      for (String key in encodedMap.keys) {
        decodedMap[key] = Term.decode(encodedMap[key]);
      }
      return decodedMap;
    }
  }

  static storePropertyFeaturesMetaData(List data){
    storeMetaData(PROPERTY_FEATURES_METADATA, data);
  }

  static readPropertyFeaturesMetaData(){
    return readMetaData(PROPERTY_FEATURES_METADATA);
  }

  static deletePropertyFeaturesMetaData(){
    deleteData(key: PROPERTY_FEATURES_METADATA);
  }

  static storeScheduleTimeSlotsInfoData(dynamic data){
    saveData(
      key: SCHEDULE_TIME_SLOTS,
      data: data,
    );
  }

  static readScheduleTimeSlotsInfoData(){
    return readData(
      key: SCHEDULE_TIME_SLOTS,
    );
  }

  static deleteScheduleTimeSlotsInfoData(){
    deleteData(key: SCHEDULE_TIME_SLOTS);
  }

  static storeDefaultCurrencyInfoData(dynamic data){
    saveData(
      key: DEFAULT_CURRENCY,
      data: data,
    );
  }

  static readDefaultCurrencyInfoData(){
    return readData(
      key: DEFAULT_CURRENCY,
    );
  }

  static deleteDefaultCurrencyInfoData(){
    deleteData(key: DEFAULT_CURRENCY);
  }

  static storeInquiryTypeInfoData(dynamic data){
    saveData(
      key: INQUIRY_TYPE,
      data: data,
    );
  }

  static readInquiryTypeInfoData(){
    return readData(
      key: INQUIRY_TYPE,
    );
  }

  static deleteInquiryTypeInfoData(){
    return deleteData(
      key: INQUIRY_TYPE,
    );
  }

  static storeLeadPrefixInfoData(dynamic data){
    saveData(
      key: LEAD_PREFIX_STORE_KEY,
      data: data,
    );
  }

  static readLeadPrefixInfoData(){
    return readData(
      key: LEAD_PREFIX_STORE_KEY,
    );
  }

  static deleteLeadPrefixInfoData(){
    return deleteData(
      key: LEAD_PREFIX_STORE_KEY,
    );
  }

  static storeLeadSourceInfoData(dynamic data){
    saveData(
      key: LEAD_SOURCE_STORE_KEY,
      data: data,
    );
  }

  static readLeadSourceInfoData(){
    return readData(
      key: LEAD_SOURCE_STORE_KEY,
    );
  }

  static deleteLeadSourceInfoData(){
    return deleteData(
      key: LEAD_SOURCE_STORE_KEY,
    );
  }

  static storeDealStatusInfoData(dynamic data){
    saveData(
      key: DEAL_STATUS_STORE_KEY,
      data: data,
    );
  }

  static readDealStatusInfoData(){
    return readData(
      key: DEAL_STATUS_STORE_KEY,
    );
  }

  static deleteDealStatusInfoData(){
    return deleteData(
      key: DEAL_STATUS_STORE_KEY,
    );
  }

  static storeDealNextActionInfoData(dynamic data){
    saveData(
      key: DEAL_NEXT_ACTION_STORE_KEY,
      data: data,
    );
  }

  static readNDealNextActionInfoData(){
    return readData(
      key: DEAL_NEXT_ACTION_STORE_KEY,
    );
  }

  static deleteDealNextActionInfoData(){
    return deleteData(
      key: DEAL_NEXT_ACTION_STORE_KEY,
    );
  }

  static storeUserRoleListData(dynamic data){
    saveData(
      key: USER_ROLE_LIST,
      data: data,
    );
  }

  static readUserRoleListData(){
    return readData(
      key: USER_ROLE_LIST,
    );
  }

  static deleteUserRoleListData(){
    return deleteData(
      key: USER_ROLE_LIST,
    );
  }

  static storeAdminUserRoleListData(dynamic data){
    saveData(
      key: ADMIN_USER_ROLE_LIST,
      data: data,
    );
  }

  static readAdminUserRoleListData(){
    return readData(
      key: ADMIN_USER_ROLE_LIST,
    );
  }

  static storePropertyMetaData(dynamic data){
    saveData(
      key: PROPERTY_META_DATA,
      data: data,
    );
  }

  static readPropertyMetaData(){
    return readData(
      key: PROPERTY_META_DATA,
    );
  }

  static deletePropertyMetaData(){
    deleteData(key: PROPERTY_META_DATA);
  }

  static storeUserCredentials(dynamic data){
    saveData(
      key: USER_CREDENTIALS,
      data: data,
    );
  }

  static Map<String, String> readUserCredentials() {
    Map<String, String> map = {};
    Map<dynamic, dynamic>? result = readData(key: USER_CREDENTIALS);

    if (result != null) {
      map = result.map((key, value) => MapEntry(key.toString(), value.toString()));
    }

    return map;
  }

  static storeUserLoginInfoData(dynamic data){
    saveData(
      key: USER_LOGIN_INFO_DATA,
      data: data,
    );
  }

  static readUserLoginInfoData(){
    return readData(
      key: USER_LOGIN_INFO_DATA,
    );
  }

  static deleteUserLoginInfoData(){
    deleteData(key: USER_LOGIN_INFO_DATA);
  }

  static storeAddPropertiesDataMaps(dynamic data){
    saveData(
      key: ADD_PROPERTIES_DATA_MAPS_LIST_KEY,
      data: data,
    );
  }

  static readAddPropertiesDataMaps(){
    return readData(key: ADD_PROPERTIES_DATA_MAPS_LIST_KEY);
  }

  static deleteAddPropertiesDataMaps(){
    deleteData(key: ADD_PROPERTIES_DATA_MAPS_LIST_KEY);
  }

  static storeDraftPropertiesDataMapsList(dynamic data){
    saveData(
      key: DRAFT_PROPERTIES_DATA_MAPS_LIST_KEY + HiveStorageManager.getUserId().toString(),
      data: data,
    );
  }

  static readDraftPropertiesDataMapsList(){
    return readData(key: DRAFT_PROPERTIES_DATA_MAPS_LIST_KEY  + HiveStorageManager.getUserId().toString());
  }

  static deleteDraftPropertiesDataMapsList(){
    deleteData(key: DRAFT_PROPERTIES_DATA_MAPS_LIST_KEY  + HiveStorageManager.getUserId().toString());
  }

  static bool isUserLoggedIn(){
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('token') &&
        (map['token'] != null && map['token'].isNotEmpty)){
      return true;
    }
    return false;
  }

  static getUserToken(){
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('token') &&
        (map['token'] != null && map['token'].isNotEmpty)){
      return map['token'];
    }
    return "";
  }

  static int? getUserId(){
    int? id;
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('user_id') &&
        (map['user_id'] != null)){
      id =  map['user_id'];
    }
    return id;
  }

  static getUserAvatar(){
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('avatar') &&
        (map['avatar'] != null && map['avatar'] is String && map['avatar'].isNotEmpty)){
      return map['avatar'];
    }
    return "";
  }
  static setUserAvatar(String url){
    Map map = readUserLoginInfoData() ?? {};
    map['avatar'] = url;
    storeUserLoginInfoData(map);
  }


  static String getUserRole() {
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('user_role') &&
        (map['user_role'] != null && map['user_role'].isNotEmpty)){
      return map['user_role'][0] ?? "";
    }
    return "";
  }

  static setUserRole(String data){
    Map map = readUserLoginInfoData() ?? {};
    map['user_role'] = data;
    storeUserLoginInfoData(map);
  }
  static getUserName(){
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('user_display_name') &&
        (map['user_display_name'] != null && map['user_display_name'].isNotEmpty)){
      return map['user_display_name'];
    }
    return "";
  }

  static setUserDisplayName(String data){
    Map map = readUserLoginInfoData() ?? {};
    map['user_display_name'] = data;
    storeUserLoginInfoData(map);
  }

  static getUserEmail(){
    Map map = readUserLoginInfoData() ?? {};
    if(map.isNotEmpty && map.containsKey('user_email') &&
        (map['user_email'] != null && map['user_email'].isNotEmpty)){
      return map['user_email'];
    }
    return "";
  }
  static setUserEmail(String data){
    Map map = readUserLoginInfoData() ?? {};
    map['user_email'] = data;
    storeUserLoginInfoData(map);
  }

  static storeLanguageSelection({required Locale locale}){
    String tempLocale = locale.toLanguageTag() ?? "en";
    // print("Store Locale: $tempLocale");
    saveData(
      key: SELECTED_LANGUAGE,
      data: tempLocale,
    );

    String languageCode = locale.languageCode;
    String? scriptCode = locale.scriptCode;
    String? countryCode = locale.countryCode;

    saveData(
      key: SELECTED_LANGUAGE_CODE,
      data: languageCode,
    );

    if (scriptCode != null && scriptCode!.isNotEmpty) {
      saveData(
        key: SELECTED_LANGUAGE_SCRIPT,
        data: scriptCode,
      );
    }

    if (countryCode != null && countryCode.isNotEmpty) {
      saveData(
        key: SELECTED_LANGUAGE_COUNTRY,
        data: countryCode,
      );
    }

  }

  static deleteLanguageSelection(){
    deleteData(key: SELECTED_LANGUAGE);
  }

  static String? readLanguageSelection(){
    return readData(key: SELECTED_LANGUAGE);
  }

  static Locale? readLanguageSelectionLocale(){
    String? savedLanguageCode = readData(key: SELECTED_LANGUAGE_CODE);
    if (savedLanguageCode != null && savedLanguageCode.isNotEmpty) {
      String? savedLanguageScript = readData(key: SELECTED_LANGUAGE_SCRIPT);
      String? savedLanguageCountry = readData(key: SELECTED_LANGUAGE_COUNTRY);
      if (savedLanguageScript != null && savedLanguageScript.isNotEmpty) {
        if (savedLanguageCountry != null && savedLanguageCountry.isNotEmpty) {
          return Locale.fromSubtags(languageCode: savedLanguageCode, scriptCode: savedLanguageScript, countryCode: savedLanguageCountry);
        }
        return Locale.fromSubtags(languageCode: savedLanguageCode, scriptCode: savedLanguageScript);
      }
      if (savedLanguageCountry != null && savedLanguageCountry.isNotEmpty) {
        return Locale.fromSubtags(languageCode: savedLanguageCode, countryCode: savedLanguageCountry);
      }

      return Locale(savedLanguageCode);
    }
    //fallback to old
    String? savedLocale = readData(key: SELECTED_LANGUAGE);
    if (savedLocale != null && savedLocale.isNotEmpty) {
        if (savedLocale.contains("-")) {
          List<String> tokens = savedLocale.split("-");
          if (tokens.length == 3) {
            return Locale.fromSubtags(languageCode: tokens[0], scriptCode: tokens[1], countryCode: tokens[2]);
          }
          if (tokens.length == 2) {
            return Locale.fromSubtags(languageCode: tokens[0], scriptCode: tokens[1]);
          }
          return Locale(tokens.first);
        }
        return Locale(savedLocale);
    }
    return null;
  }

  static storePropertyEmailContactInfo(data,key){
    saveData(
      key: PROPERTY_EMAIL_CONTACT_DATA+key.toString(),
      data: data,
    );
  }

  static readPropertyEmailContactInfo(key){
    return readData(key: PROPERTY_EMAIL_CONTACT_DATA+key.toString());
  }

  static storeCustomFieldsDataMaps(dynamic data){
    saveData(
      key: CUSTOM_FIELDS,
      data: data,
    );
  }

  static readCustomFieldsDataMaps(){
    return readData(key: CUSTOM_FIELDS);
  }

  static storeHomeConfigListData(dynamic data){
    saveData(
      key: HOME_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readHomeConfigListData(){
    return readData(key: HOME_CONFIG_DATA_LIST);
  }

  static storeFilterConfigListData(dynamic data){
    saveData(
      key: FILTER_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readFilterConfigListData(){
    return readData(key: FILTER_CONFIG_DATA_LIST);
  }

  static storeDrawerConfigListData(dynamic data){
    saveData(
      key: DRAWER_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readDrawerConfigListData(){
    return readData(key: DRAWER_CONFIG_DATA_LIST);
  }

  static storeSecurityKeyMapData(dynamic data){
    saveData(
      key: HEADER_SECURITY_KEY,
      data: data,
    );
  }

  static readSecurityKeyMapData(){
    return readData(key: HEADER_SECURITY_KEY);
  }

  static storePropertyDetailConfigListData(dynamic data){
    saveData(
      key: PROPERTY_DETAIL_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readPropertyDetailConfigListData(){
    return readData(key: PROPERTY_DETAIL_CONFIG_DATA_LIST);
  }

  static storeNavbarConfigData(dynamic data){
    saveData(
      key: NAVBAR_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readNavbarConfigData(){
    return readData(key: NAVBAR_CONFIG_DATA_LIST);
  }

  static storeSortFirstByConfigData(dynamic data){
    saveData(
      key: SORT_FIRST_BY_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static readSortFirstByConfigData(){
    return readData(key: SORT_FIRST_BY_CONFIG_DATA_LIST);
  }

  static void storeBlogDetailConfigListData(String data){
    saveData(
      key: BLOG_DETAIL_CONFIG_DATA_LIST,
      data: data,
    );
  }

  static List<BlogDetailPageLayout> readBlogDetailConfigListData() {
    BlogDetailsPageLayout? blogDetailsPageLayout = BlogDetailsPageLayout.fromRawJson(readData(key: BLOG_DETAIL_CONFIG_DATA_LIST));
    return blogDetailsPageLayout.blogDetailPageLayout ?? [];
  }

  static deleteAllData(){
    deleteData(key: APP_URL);
    deleteData(key: APP_AUTHORITY);
    deleteData(key: COMMUNICATION_PROTOCOL);
    deleteData(key: PROPERTY_META_DATA);
    deleteData(key: SCHEDULE_TIME_SLOTS);
    deleteData(key: PROPERTY_TYPES_METADATA);
    deleteData(key: PROPERTY_LABELS_METADATA);
    deleteData(key: PROPERTY_COUNTRIES_METADATA);
    deleteData(key: PROPERTY_STATES_METADATA);
    deleteData(key: PROPERTY_AREA_METADATA);
    deleteData(key: PROPERTY_STATUS_METADATA);
    deleteData(key: PROPERTY_FEATURES_METADATA);
    deleteData(key: PROPERTY_TYPES_DATA_MAP);
    deleteData(key: CITIES_METADATA);
    deleteData(key: SELECTED_CITY_INFORMATION);
    deleteData(key: FILTER_DATA_INFORMATION);
    // deleteData(key: DEFAULT_CURRENCY);
    deleteData(key: INQUIRY_TYPE);
    deleteData(key: PROPERTY_TYPES_MAP_DATA);
    deleteData(key: RECENT_SEARCHES);
  }
  
  
  static clearData(){
    deleteCitiesMetaData();
    // deleteFilterDataInfo();
    deletePropertyMetaData();
    // deleteRecentSearchesInfo();
    deletePropertyAreaMetaData();
    deletePropertyTypesMapData();
    deletePropertyTypesMetaData();
    deletePropertyStatesMetaData();
    deletePropertyStatusMetaData();
    deletePropertyLabelsMetaData();
    // deleteDefaultCurrencyInfoData();
    deletePropertyFeaturesMetaData();
    deleteScheduleTimeSlotsInfoData();
    deletePropertyCountriesMetaData();
  }

  static storeTasksIdsList(List taskIdsList){
    saveData(
      key: TASKS_IDS_LIST,
      data: taskIdsList,
    );
  }

  static readTasksIdsList(){
    return readData(key: TASKS_IDS_LIST);
  }

  static deleteTasksIdsList(){
    deleteData(key: TASKS_IDS_LIST);
  }

  static storeAppConfigurations(dynamic appConfigJson){
    saveData(
      key: APP_CONFIGURATIONS_STORE_KEY,
      data: appConfigJson,
    );
  }

  static readAppConfigurations(){
    return readData(key: APP_CONFIGURATIONS_STORE_KEY);
  }

  static deleteAppConfigurations(){
    deleteData(key: APP_CONFIGURATIONS_STORE_KEY);
  }

  static storeHouzezVersion(dynamic houzez_version){
    saveData(
      key: HOUZEZ_VERSION_STORE_KEY,
      data: houzez_version,
    );
  }

  static readHouzezVersion(){
    return readData(key: HOUZEZ_VERSION_STORE_KEY);
  }

  static deleteHouzezVersion(){
    deleteData(key: HOUZEZ_VERSION_STORE_KEY);
  }

  static storeSelectedHomeOption(String homeOption){
    saveData(
      key: SELECTED_HOME_OPTION_KEY,
      data: homeOption,
    );
  }

  static readSelectedHomeOption(){
    return readData(key: SELECTED_HOME_OPTION_KEY);
  }

  static deleteSelectedHomeOption(){
    deleteData(key: SELECTED_HOME_OPTION_KEY);
  }

  static storeHouziVersion(int houzi_version){
    saveData(
      key: HOUZI_VERSION_STORE_KEY,
      data: houzi_version,
    );
  }

  static readHouziVersion(){
    return readData(key: HOUZI_VERSION_STORE_KEY);
  }

  static deleteHouziVersion(){
    deleteData(key: HOUZI_VERSION_STORE_KEY);
  }

  static storeAddPropertyConfigurations(dynamic config) {
    saveData(
      key: ADD_PROPERTY_CONFIGURATIONS_STORE_KEY,
      data: config,
    );
  }

  static readAddPropertyConfigurations() {
    return readData(key: ADD_PROPERTY_CONFIGURATIONS_STORE_KEY);
  }

  static deleteAddPropertyConfigurations() {
    deleteData(key: ADD_PROPERTY_CONFIGURATIONS_STORE_KEY);
  }

  static storeQuickAddPropertyConfigurations(dynamic config) {
    saveData(
      key: QUICK_ADD_PROPERTY_CONFIGURATIONS_STORE_KEY,
      data: config,
    );
  }

  static readQuickAddPropertyConfigurations() {
    return readData(key: QUICK_ADD_PROPERTY_CONFIGURATIONS_STORE_KEY);
  }

  static deleteQuickAddPropertyConfigurations() {
    deleteData(key: QUICK_ADD_PROPERTY_CONFIGURATIONS_STORE_KEY);
  }

  static storeUserPaymentStatus(Map map) {
    saveData(
      key: USER_PAYMENT_STATUS_KEY,
      data: map,
    );
  }

  static readUserPaymentStatus() {
    return readData(key: USER_PAYMENT_STATUS_KEY) ?? {};
  }

  static storeSequentialLocation(Map<String, dynamic> map) {
    saveData(
      key: sequential_location_key,
      data: map,
    );
  }

  static readSequentialLocation() {
    return readData(key: sequential_location_key) ?? {};
  }

  static deleteUserPaymentStatus() {
    deleteData(key: USER_PAYMENT_STATUS_KEY);
  }

  static storeSelectedCountry({dynamic data}){
    saveData(
      key: SELECTED_COUNTRY_INFO_KEY,
      data: data,
    );
  }

  static Map<String, dynamic> readSelectedCountry(){
    Map result = readData(key: SELECTED_COUNTRY_INFO_KEY) ?? {};
    Map<String, dynamic> map = {};
    if(result.isNotEmpty){
      for (dynamic type in result.keys) {
        map[type.toString()] = result[type];
      }
    }
    return map;
  }

}