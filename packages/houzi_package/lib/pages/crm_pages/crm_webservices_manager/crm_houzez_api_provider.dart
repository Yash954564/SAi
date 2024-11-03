import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/providers/state_providers/locale_provider.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'dart:io' show Platform;
import 'crm_interfaces/crm_api_provider_interface.dart';
import 'crm_houzez_parser.dart';

const String HOUZEZ_ACTIVITIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/activities";
// const String HOUZEZ_INQUIRIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/enquiries";
const String HOUZEZ_INQUIRIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/all-enquiries";
const String HOUZEZ_INQUIRY_MATCHED_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/enquiry-matched-listing";
const String HOUZEZ_LEAD_INQUIRIES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-details";
const String HOUZEZ_LEAD_VIEWED_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-listing-viewed";
const String HOUZEZ_INQUIRY_NOTES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/enquiry-notes";
const String HOUZEZ_LEADS_NOTES_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/lead-notes";
const String JWT_Authentication_PATH = "/wp-json/houzez-mobile-api/v1/signin";
const String HOUZEZ_SOCIAL_LOGIN_PATH = "/wp-json/houzez-mobile-api/v1/social-sign-on";
const String HOUZEZ_DEALS_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/deals";
const String HOUZEZ_LEADS_FROM_BOARD_PATH = "/wp-json/houzez-mobile-api/v1/leads";
const String HOUZEZ_ADD_DEALS_PATH = "/wp-json/houzez-mobile-api/v1/add-deal";
const String HOUZEZ_DELETE_DEALS_PATH = "/wp-json/houzez-mobile-api/v1/delete-deal";
const String HOUZEZ_ADD_INQUIRY_PATH = "/wp-json/houzez-mobile-api/v1/add-crm-enquiry";
const String HOUZEZ_ADD_CRM_NOTES_PATH = "/wp-json/houzez-mobile-api/v1/add-note";
const String HOUZEZ_SEND_CRM_EMAIL_PATH = "/wp-json/houzez-mobile-api/v1/send-matched-listing-email";
const String HOUZEZ_DELETE_INQUIRY_PATH = "/wp-json/houzez-mobile-api/v1/delete-crm-enquiry";
const String HOUZEZ_DELETE_CRM_NOTES_PATH = "/wp-json/houzez-mobile-api/v1/delete-note";
const String HOUZEZ_DELETE_LEADS_PATH = "/wp-json/houzez-mobile-api/v1/delete-lead";
const String HOUZEZ_LEAD_SAVED_SEARCHES_PATH = "/wp-json/houzez-mobile-api/v1/lead-saved-searches";
const String HOUZEZ_ADD_LEADS_PATH = "/wp-json/houzez-mobile-api/v1/add-lead";
const String HOUZEZ_UPDATE_DEAL_DETAIL_PATH = "/wp-json/houzez-mobile-api/v1/update-deal-data";
const String HOUZEZ_CREATE_NONCE_PATH = "/wp-json/houzez-mobile-api/v1/create-nonce";

class CRMHOUZEZApiProvider implements CRMApiProviderInterface {

  @override
  CRMApiParserInterface crmGetParser() {
    return CRMHouzezParser();
  }

  Uri getUri({required String unEncodedPath, Map<String, dynamic>? params}){
    Uri? uri;

    // String authority = WORDPRESS_URL_DOMAIN;
    // String communicationProtocol = WORDPRESS_URL_SCHEME;

    /// For Houzi Only (due to demo configurations)
    String authority = HiveStorageManager.readUrlAuthority() ?? WORDPRESS_URL_DOMAIN;
    String communicationProtocol = HiveStorageManager.readCommunicationProtocol() ?? WORDPRESS_URL_SCHEME;
    String urlScheme = WORDPRESS_URL_PATH;

    // String option = HiveStorageManager.readLocaleInUrl();
    DefaultLanguageCodeHook defaultLanguageCodeHook = HooksConfigurations.defaultLanguageCode;
    String defaultLanguage = defaultLanguageCodeHook();
    String tempSelectedLanguage = HiveStorageManager.readLanguageSelection() ?? defaultLanguage;
    if (currentSelectedLocaleUrlPosition == changeUrlPath) {
      urlScheme = urlScheme+"/$tempSelectedLanguage";
    } else if (currentSelectedLocaleUrlPosition == changeUrlQueryParameter) {
      params ??= {};
      params["lang"] = tempSelectedLanguage;
    }

    if(urlScheme != null && urlScheme.isNotEmpty){
      unEncodedPath = urlScheme + unEncodedPath;
    }

    Map<String, dynamic> queryParams = {};
    if(params != null && params.isNotEmpty){
      queryParams.addAll(params);
    }

    queryParams['app_version'] = getAppVersion();
    queryParams['houzi_version'] = HOUZI_VERSION;
    queryParams['app_build_number'] = getAppBuildNumber();
    queryParams['app_platform'] = getDevicePlatform();

    if(communicationProtocol == HTTP){
      uri = Uri.http(authority, unEncodedPath, queryParams);
    }else if(communicationProtocol == HTTPS){
      uri = Uri.https(authority, unEncodedPath, queryParams);
    }

    return uri!;
  }

  String getDevicePlatform(){
    String platform = "";
    if (Platform.isAndroid) {
      platform = "android";
    } else if (Platform.isIOS) {
      platform = "ios";
    }

    return platform;
  }

  String getAppBuildNumber(){
    String appBuildNumber = "";
    Map appInfoMap = HiveStorageManager.readAppInfo() ?? {};
    if(appInfoMap.isNotEmpty){
      appBuildNumber = appInfoMap[APP_INFO_APP_BUILD_NUMBER];
    }

    return appBuildNumber;
  }

  String getAppVersion(){
    String appVersion = "";
    Map appInfoMap = HiveStorageManager.readAppInfo() ?? {};
    if(appInfoMap.isNotEmpty){
      appVersion = appInfoMap[APP_INFO_APP_VERSION];
    }

    return appVersion;
  }

  @override
  Uri provideLoginApi() {
    var uri = getUri(
      unEncodedPath: JWT_Authentication_PATH,
    );
    return uri;
  }

  @override
  Uri provideActivitiesFromBoardApi(int page, int perPage,int userId) {
    var queryParameters = {
      'user_id': "$userId",
      'cpage': "$page",
      'per_page': "$perPage",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: queryParameters,
    );
    return uri;
  }

  @override
  Uri provideInquiriesFromBoardApi(int page,int perPage) {
    var queryParameters = {
      'cpage': "$page",
      'per_page': "$perPage",
    };
    var uri;

    uri = getUri(
      unEncodedPath: HOUZEZ_INQUIRIES_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideInquiryDetailMatchedFromBoardApi(String enquiryId, int propPage) {
    var queryParameters = {
      'enquiry-id': enquiryId,
      'prop_page': "$propPage",
    };

    Uri uri = getUri(
      unEncodedPath: HOUZEZ_INQUIRY_MATCHED_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideLeadsInquiriesFromBoardApi(String leadId, int propPage) {
    var queryParameters = {
      'lead-id': leadId,
      'prop_page': "$propPage",
    };

    Uri uri = getUri(
      unEncodedPath: HOUZEZ_LEAD_INQUIRIES_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideLeadsViewedFromBoardApi(String leadId, int propPage) {
    var queryParameters = {
      'lead-id': leadId,
      'cpage': "$propPage",
    };

    Uri uri = getUri(
      unEncodedPath: HOUZEZ_LEAD_VIEWED_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideInquiryDetailNotesFromBoardApi(String enquiryId) {
    var queryParameters = {
      'enquiry-id': enquiryId,
    };

    Uri uri = getUri(
      unEncodedPath: HOUZEZ_INQUIRY_NOTES_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideLeadsDetailNotesFromBoardApi(String leadId) {
    var queryParameters = {
      'lead-id': leadId,
    };

    Uri uri = getUri(
      unEncodedPath: HOUZEZ_LEADS_NOTES_FROM_BOARD_PATH,
      params: queryParameters,
    );

    return uri;
  }

  @override
  Uri provideLeadsFromActivityApi(int page, int userId) {
    var queryParameters = {
      'user_id': "$userId",
      'cpage': "${1}",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: queryParameters,
    );
    return uri;
  }

  @override
  Uri provideDealsFromActivityApi(int page, int userId) {
    var queryParameters = {
      'user_id': "$userId",
      'cpage': "${1}",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
      params: queryParameters,
    );
    return uri;
  }

  @override
  Uri provideDealsFromBoardApi(int page,int perPage, String tab) {
    var queryParameters = {
      'tab': tab,
      'cpage': "$page",
      'per_page': "$perPage",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_DEALS_FROM_BOARD_PATH,
      params: queryParameters,
    );
    return uri;
  }

  @override
  Uri provideAddDealResponseApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_ADD_DEALS_PATH,
    );
    return uri;
  }
  @override
  Uri provideLeadsFromBoardApi(int page,int perPage) {
    var queryParameters = {
      'cpage': "$page",
      'per_page': "$perPage",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_LEADS_FROM_BOARD_PATH,
      params: queryParameters,
    );
    return uri;
  }

  @override
  ApiRequest provideDeleteDealApi(int id, String nonce, String nonceVariable) {
    var params = {
      'deal_id': "$id",
      nonceVariable: nonce
    };

    var uri = getUri(
      unEncodedPath: HOUZEZ_DELETE_DEALS_PATH,
    );
    return ApiRequest(uri, params);
  }

  @override
  Uri provideAddInquiryApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_ADD_INQUIRY_PATH,
    );
    return uri;
  }

  @override
  Uri provideAddCRMNotesApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_ADD_CRM_NOTES_PATH,
    );
    return uri;
  }

  @override
  Uri provideSendCRMEmailApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_SEND_CRM_EMAIL_PATH,
    );
    return uri;
  }

  @override
  Uri provideDeleteCRMNotesApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_DELETE_CRM_NOTES_PATH,
    );
    return uri;
  }

  @override
  ApiRequest provideDeleteInquiryApi(int id) {
    var params = {
      'ids': "$id",
    };
    var uri = getUri(
      unEncodedPath: HOUZEZ_DELETE_INQUIRY_PATH,

    );
    return ApiRequest(uri, params);
  }

  @override
  ApiRequest provideDeleteLeadApi(id, String nonce, String nonceVariable) {
    var params = {
      'lead_id': "$id",
      nonceVariable: nonce
    };

    var uri = getUri(
      unEncodedPath: HOUZEZ_DELETE_LEADS_PATH,
    );
    return ApiRequest(uri, params);
  }

  @override
  Uri provideDealsAndLeadsFromActivityApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_ACTIVITIES_FROM_BOARD_PATH,
    );
    return uri;
  }



  @override
  Uri provideAddLeadResponseApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_ADD_LEADS_PATH,
    );
    return uri;
  }

  @override
  Uri provideSocialLoginApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_SOCIAL_LOGIN_PATH,
    );
    return uri;
  }

  @override
  Uri provideUpdateDealDetailResponseApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_UPDATE_DEAL_DETAIL_PATH,
    );
    return uri;
  }

  @override
  Uri provideCreateNonceApi() {
    var uri = getUri(
      unEncodedPath: HOUZEZ_CREATE_NONCE_PATH,
    );
    return uri;
  }
}