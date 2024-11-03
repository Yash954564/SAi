import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:houzi_package/bloc/api_providers/property_api_provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/bloc/api_providers/houzez_api_provider.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_interfaces/crm_api_provider_interface.dart';

class CRMApiProvider{
  final options = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),
    // Default.
    policy: CachePolicy.request,
    // Returns a cached response on error but for statuses 401 & 403.
    // Also allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to [null].
    hitCacheOnErrorExcept: [401, 403],
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to [null].
    maxStale: const Duration(minutes: 10),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    // Default. Allows to cache POST requests.
    // Overriding [keyBuilder] is strongly recommended when [true].
    allowPostMethod: false,
  );

  final CRMApiProviderInterface _crmApiProviderInterface;

  CRMApiProvider(this._crmApiProviderInterface);

  static const int MAX_TRIES = 3;
  static const int GET = 0;
  static const int POST = 1;
  static const int PUT = 2;
  static const int DELETE = 3;

  CRMApiParserInterface getCurrentParser() {
    return _crmApiProviderInterface.crmGetParser();
  }

  Dio getDio(forceExcludeCache) {
    String token = HiveStorageManager.getUserToken() ?? "";
    Map<String, dynamic> headerHookMap = HiveStorageManager.readSecurityKeyMapData() ?? {};
    Map<String, dynamic> headerMap = {};

    if (token != null && token.isNotEmpty) {
      headerMap["Authorization"] = "Bearer $token";
    }

    if (forceExcludeCache) {
      headerMap["Pragma"] = "no-cache";
      headerMap["Cache-Control"] = "no-cache";
      headerMap["Refresh"] = "0";
    }

    headerHookMap.removeWhere((key, value) => value == null || value.isEmpty);
    if (headerHookMap.isNotEmpty) {
      headerMap.addAll(headerHookMap);
    }

    if (headerMap != null && headerMap.isNotEmpty) {
      Dio dio = Dio()
        ..options.headers = headerMap
        ..interceptors.add(DioCacheInterceptor(options: options));
      return dio;
    }

    Dio dio = Dio()..interceptors.add(DioCacheInterceptor(options: options));
    return dio;
  }

  refreshToken() async {
    Map userInfoMapFromStorage = HiveStorageManager.readUserCredentials();
    if(userInfoMapFromStorage != null && userInfoMapFromStorage.isNotEmpty){
      Map<String, dynamic> userInfo = userInfoMapFromStorage.map((key, value) => MapEntry(key.toString(), value));
      if(userInfo != null && userInfo.isNotEmpty){
        var response;

        if(userInfo.containsKey(USER_SOCIAL_PLATFORM)){
          response = await fetchSocialSignOnResponse(userInfo);
        }else{
          response = await fetchLoginResponse(userInfo);
        }

        if(response.statusCode == 200){
          HiveStorageManager.storeUserLoginInfoData(response.data);
        }
      }
    }
  }

  Future<Response> doRequestOnRoute(
      var uri,
      {
        Dio? dio,
        int type = GET,
        Map<String, dynamic>? dataMap,
        FormData? formData,
        String tag = "",
        String? nonce = "",
        String nonceVariable = "",
        int tries = 1,
        bool handle500 = false,
        bool handle403 = true,
        bool useCache = true,
        bool forceExcludeCache = true,
      }) async {
    try{
      dio ??= getDio(forceExcludeCache);

      print("uri: $uri");

      if(handle500){
        dio.options.responseType = ResponseType.plain;
      }
      if (type == GET) {
        
        var response = await dio.getUri(uri);
        return response;
      } else if (type == POST) {

        if(formData != null){
          var response = await dio.postUri(uri, data: formData);
          return response;
        }

        if (dataMap != null && nonce != null && nonce.isNotEmpty) {
          dataMap[nonceVariable] = nonce;
        }

        print("dataMap: $dataMap");

        var response = await dio.postUri(uri, data: FormData.fromMap(dataMap ?? {}));
        return response;
      }
    }on DioError catch (dioError) {
      if(dioError.response != null){
        if (handle500) {
          if (dioError.response != null) {


            if(tag == "add or remove from favourites"){
              var tempResponse = dioError.response.toString();
              String temp1 = '"'+'added'+'"'+':'+'true'+','+'"'+'response'+'"'+':'+'"'+'Added'+'"';
              String temp2 = '"'+'added'+'"'+':'+'false'+','+'"'+'response'+'"'+':'+'"'+'Removed'+'"';
              if(dioError.response!.statusCode == 500 && (tempResponse.contains(temp1) || tempResponse.contains(temp2))){
                return dioError.response!;
              }
            }else if(tag == "delete image from edit property" || tag == "sign-up"){
              return dioError.response!;
            }else{
              var tempResponse = dioError.response.toString();
              String temp1 = '"' + 'success' + '"' + ':' + 'true';
              if (dioError.response!.statusCode! == 500 && tempResponse.contains(temp1)) {
                return dioError.response!;
              }
            }
          }
        }
        if(handle403){
          if(dioError.response!.statusCode! == 403 || dioError.response!.statusCode! == 401){
            if (tries <= MAX_TRIES) {
              refreshToken();
              return doRequestOnRoute(uri, type:type, dataMap: dataMap, tag: tag, tries: ++tries);
            }
          }
        }
        print("$tag: error code = ${dioError.response!.statusCode}");
        print("$tag: error message = ${dioError.message}");
        return dioError.response!;
      }else{
        print('$tag Response Error: ${dioError.error}');
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusMessage: dioError.error.toString(),
          statusCode: null,
        );
      }
    }
    return Response(
      requestOptions: RequestOptions(path: ''),
      statusMessage: "",
      statusCode: null,
    );
  }



  Future<Response> fetchActivitiesFromBoardResponse(int page,int perPage,int userId, {Map<String, dynamic>? options}) async {
    var uri = _crmApiProviderInterface.provideActivitiesFromBoardApi(page,perPage,userId);
    return doRequestOnRoute(uri, tag: "CRM activities");
  }

  Future<Response> fetchInquiriesFromBoardResponse(int page, int perPage) async {
    var uri = _crmApiProviderInterface.provideInquiriesFromBoardApi(page, perPage);
    return doRequestOnRoute(uri, tag: "CRM inquiries");
  }

  Future<Response> fetchInquiryDetailMatchedFromBoardResponse(String enquiryId, int propPage) async {
    var uri = _crmApiProviderInterface.provideInquiryDetailMatchedFromBoardApi(enquiryId, propPage);
    return doRequestOnRoute(uri, tag: "CRM inquiry matched");
  }

  Future<Response> fetchLeadsInquiriesFromBoardResponse(String leadId, int propPage) async {
    var uri = _crmApiProviderInterface.provideLeadsInquiriesFromBoardApi(leadId, propPage);
    return doRequestOnRoute(uri, tag: "CRM lead inquiries");
  }

  Future<Response> fetchLeadsViewedFromBoardResponse(String leadId, int propPage) async {
    var uri = _crmApiProviderInterface.provideLeadsViewedFromBoardApi(leadId, propPage);
    return doRequestOnRoute(uri, tag: "CRM lead viewed");
  }

  Future<Response> fetchInquiryDetailNotesFromBoardResponse(String enquiryId) async {
    var uri = _crmApiProviderInterface.provideInquiryDetailNotesFromBoardApi(enquiryId);
    return doRequestOnRoute(uri, tag: "CRM inquiry notes");
  }

  Future<Response> fetchLeadsDetailNotesFromBoardResponse(String leadId) async {
    var uri = _crmApiProviderInterface.provideLeadsDetailNotesFromBoardApi(leadId);
    return doRequestOnRoute(uri, tag: "CRM leads notes");
  }

  Future<Response> fetchLeadsFromActivityResponse(int page, int userId, {Map<String, dynamic>? options}) async {
    var uri = _crmApiProviderInterface.provideLeadsFromActivityApi(page,userId);
    return doRequestOnRoute(uri, tag: "CRM leads");
  }




  Future<Response> fetchDealsFromActivityResponse(int page, int userId, {Map<String, dynamic>? options}) async {
    var uri = _crmApiProviderInterface.provideDealsFromActivityApi(page,userId);
    return doRequestOnRoute(uri, tag: "CRM activity deals");
  }

  Future<Response> fetchDealsFromBoardResponse(int page,int perPage, String tab, {Map<String, dynamic>? options}) async {
    var uri = _crmApiProviderInterface.provideDealsFromBoardApi(page,perPage,tab);
    return doRequestOnRoute(uri, tag: "CRM get deals");
  }

  Future<Response> fetchAddDealResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideAddDealResponseApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "CRM add deal", handle500: true);
  }

  Future<Response> fetchLeadsFromBoard(int page, int perPage, {Map<String, dynamic>? options}) async {
    var uri = _crmApiProviderInterface.provideLeadsFromBoardApi(page,perPage);
    return doRequestOnRoute(uri, tag: "CRM get leads");
  }

  Future<Response> fetchDeleteDeal(int id, String nonce) async {
    ApiRequest request = _crmApiProviderInterface.provideDeleteDealApi(id, nonce, kDealDeleteNonceVariable);
    return doRequestOnRoute(request.uri,type: POST, dataMap: request.params, tag: "CRM delete deals");
  }

  Future<Response> fetchAddInquiryResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideAddInquiryApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "CRM add inquiry", handle500: true);
  }

  Future<Response> fetchAddCRMNotesResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _crmApiProviderInterface.provideAddCRMNotesApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "CRM add inquiry notes",
      handle500: true,
      nonce: nonce,
      nonceVariable: kAddNoteNonceVariable,
    );
  }

  Future<Response> fetchSendCRMEmailResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideSendCRMEmailApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "send crm email", handle500: true);
  }

  Future<Response> fetchDeleteCRMNotesResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideDeleteCRMNotesApi();
    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "delete Delete CRM Notes", handle500: true);
  }

  Future<Response> fetchDeleteInquiry(int id) async {
    ApiRequest request = _crmApiProviderInterface.provideDeleteInquiryApi(id);
    return doRequestOnRoute(request.uri,type: POST,  dataMap: request.params, tag: "CRM delete inquiry");
  }

  Future<Response> fetchDealsAndLeadsFromActivityResponse() async {
    var uri = _crmApiProviderInterface.provideDealsAndLeadsFromActivityApi();
    return doRequestOnRoute(uri, tag: "CRM board leads");
  }

  Future<Response> fetchAddLeadResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideAddLeadResponseApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "CRM add lead", handle500: true);
  }

  Future<Response> fetchUpdateDealDetailResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideUpdateDealDetailResponseApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "CRM update deal detail", handle500: true);
  }

  Future<Response> fetchSocialSignOnResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideSocialLoginApi();
    Dio dio = Dio();
    return doRequestOnRoute(uri, dio: dio, type: POST, dataMap: dataMap, tag: "CRM social-login", handle403: false);
  }

  Future<Response> fetchLoginResponse(Map<String, dynamic> dataMap) async {
    var uri = _crmApiProviderInterface.provideLoginApi();
    Dio dio = Dio();
    return doRequestOnRoute(uri, dio: dio, type: POST, dataMap: dataMap, tag: "CRM login", handle403: false);
  }

  Future<Response> fetchDeleteLead(int id, String nonce) async {
    ApiRequest request = _crmApiProviderInterface.provideDeleteLeadApi(id, nonce, kLeadDeleteNonceVariable);
    return doRequestOnRoute(request.uri,type: POST, dataMap: request.params, tag: "delete lead");
  }

  /// CRM APIs nonce
  ///
  ///
  Future<ApiResponse> fetchDealDeleteNonceResponse() {
    return createNonce(kDealDeleteNonceName);
  }

  Future<ApiResponse> fetchLeadDeleteNonceResponse() {
    return createNonce(kLeadDeleteNonceName);
  }

  Future<ApiResponse> fetchAddNoteNonceResponse() {
    return createNonce(kAddNoteNonceName);
  }

  Future<ApiResponse> createNonce(String nonceName) async {
    var uri = _crmApiProviderInterface.provideCreateNonceApi();
    Map<String, dynamic> dataMap = {kCreateNonceKey: nonceName};

    Response response = await doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "Create Nonce", handle403: false);
    ApiResponse<String> nonce = PropertyApiProvider(HOUZEZApiProvider()).getCurrentParser().parseNonceResponse(response);
    return nonce;

  }

}