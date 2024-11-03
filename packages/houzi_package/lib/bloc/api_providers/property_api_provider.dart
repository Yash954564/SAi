import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/bloc/interfaces/api_parser_interface.dart';
import 'package:houzi_package/bloc/interfaces/api_provider_interface.dart';
import 'package:houzi_package/models/api/api_request.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/api/data_models.dart';

class PropertyApiProvider{

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

  final ApiProviderInterface _apiProviderInterface;

  PropertyApiProvider(this._apiProviderInterface);

  static const int MAX_TRIES = 3;

  static const int GET = 0;
  static const int POST = 1;
  static const int PUT = 2;
  static const int DELETE = 3;


  ApiParserInterface getCurrentParser() {
    return _apiProviderInterface.getParser();
  }

  Dio getDio({bool isNonce = false, bool forceExcludeCache = false}) {
    String token = HiveStorageManager.getUserToken() ?? "";
    Map<String, dynamic> headerHookMap = HiveStorageManager.readSecurityKeyMapData() ?? {};
    Map<String, dynamic> headerMap = {};

    if (!isNonce && token.isNotEmpty) {
      headerMap["Authorization"] = "Bearer $token";
    }

    if (forceExcludeCache) {
      headerMap["Pragma"] = "no-cache";
      headerMap["Cache-Control"] = "no-cache";
      headerMap["Refresh"] = "0";
    }

    headerHookMap.removeWhere((key, value) => (value == null || value.isEmpty));
    if (headerHookMap.isNotEmpty) {
      headerMap.addAll(headerHookMap);
    }

    if (forceExcludeCache && headerMap.isNotEmpty) {
      Dio dio = Dio()
        ..options.headers = headerMap;

      return dio;
    }

    if (headerMap.isNotEmpty) {
      Dio dio = Dio()
        ..interceptors.add(DioCacheInterceptor(options: options))
        ..options.headers = headerMap;

      return dio;
    }

    Dio dio = Dio()
      ..interceptors.add(DioCacheInterceptor(options: options));

    return dio;
  }

  Future refreshToken() async {
    print("Refreshing token.......................");
    // get user info from storage
    Map<String, String> _userInfo = HiveStorageManager.readUserCredentials();

    if (_userInfo.isNotEmpty) {
      // fetch nonce and update it in _user info
      String nonce = "";
      ApiResponse nonceResponse = await fetchSignInNonceResponse();

      if (nonceResponse.success) {
        nonce = nonceResponse.result;
        _userInfo[API_NONCE] = nonce;

        var response;
        if (_userInfo.containsKey(USER_SOCIAL_PLATFORM)) {
          response = await fetchSocialSignOnResponse(_userInfo);
        } else {
          response = await fetchLoginResponse(_userInfo);
        }

        if (response.statusCode == 200) {
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
        bool isNonce = false,
        bool forceExcludeCache = false,
      }) async {
    try{
      dio ??= getDio(isNonce: isNonce, forceExcludeCache: forceExcludeCache);
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
        if (handle403) {
          if (dioError.response!.statusCode! == 403 
              || dioError.response!.statusCode! == 401) {
            if (tries <= MAX_TRIES) {
              await refreshToken();
              return doRequestOnRoute(uri, type:type, dataMap: dataMap, tag: tag, tries: ++tries);
            }
          }
        }
        print("$tag: error code = ${dioError.response!.statusCode}");
        print("$tag: error message = ${dioError.message}");
          return dioError.response!;
      } else {
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

  Future<Response> fetchLatestArticlesResponse(int page) async {
    var data = {
      'page': '$page',
      'per_page': '$FETCH_LATEST_PROPERTIES_PER_PAGE',
      'agent_agency_info':"yes",
    };
    var uri = _apiProviderInterface.provideLatestPropertiesApi(page);
    return doRequestOnRoute(uri, type:POST, dataMap: data, tag:"latest article");
  }

  Future<Response> fetchFilteredArticlesResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideFilteredPropertiesApi();
    return doRequestOnRoute(uri, type:POST, dataMap: dataMap, tag:"filtered article");
  }

  Future<Response> fetchFeaturedArticlesResponse(int page) async {
    var uri = _apiProviderInterface.provideFeaturedPropertiesApi(page);
    return doRequestOnRoute(uri, tag: "featured article");
  }

  Future<Response> fetchSimilarPropertiesResponse(int propertyId) async {
    var uri = _apiProviderInterface.provideSimilarPropertiesApi(propertyId);
    return doRequestOnRoute(uri, tag: "similar article");
  }

  Future<Response> fetchMultipleArticlesResponse(String propertiesId) async {
    var uri = _apiProviderInterface.provideMultiplePropertiesApi(propertiesId);
    String str = uri.toString();
    str = UtilityMethods.parseHtmlString(str);


    if(str.contains("%3F")){
      str = str.replaceAll("%3F", "?");
    }
    if(str.contains("%2C")){
      str = str.replaceAll("%2C", ",");
    }
    Uri myUri = Uri.parse(str);
    return doRequestOnRoute(myUri, tag: "multiple articles");
  }

  Future<Response> fetchSingleArticleResponse(int id, {bool forEditing = false}) async {
    var uri = _apiProviderInterface.provideSinglePropertyApi(id,forEditing: forEditing);
    return doRequestOnRoute(uri, tag: "single article");
  }

  Future<Response> fetchPropertyMetaDataApi() async {
    var uri =  _apiProviderInterface.providePropertyMetaDataApi();
    return doRequestOnRoute(uri, tag: "property meta data");
  }

  Future<Response> fetchSingleAgencyInfoApi(int id) async {
    var uri =  _apiProviderInterface.provideSingleAgencyInfoApi(id);
    return doRequestOnRoute(uri, tag: "single agency");
  }

  Future<Response> fetchSingleAgentInfoApi(int id) async {
    var uri =  _apiProviderInterface.provideSingleAgentInfoApi(id);
    return doRequestOnRoute(uri, tag: "single agent");
  }

  Future<Response> fetchAgencyAgentInfoApi(int agencyId) async {
    var uri =  _apiProviderInterface.provideAgencyAgentsInfoApi(agencyId);
    return doRequestOnRoute(uri, tag: "agency agent info");
  }

  Future<Response> fetchAgencyAllAgentListApi(int agencyId) async {
    var uri =  _apiProviderInterface.provideAgencyAllAgentListApi(agencyId);
    return doRequestOnRoute(uri, tag: "agency all agent info", forceExcludeCache: true);
  }

  Future<Response> fetchPropertiesByAgencyApi(int id, int page, int perPage) async {
    var uri =  _apiProviderInterface.providePropertiesByAgencyApi(id, page, perPage);
    return doRequestOnRoute(uri, tag: "agency properties");
  }

  Future<Response> fetchPropertiesByAgentApi(int id, int page, int perPage) async {
    var uri =  _apiProviderInterface.providePropertiesByAgentApi(id, page, perPage);
    return doRequestOnRoute(uri, tag: "agenct properties");
  }

  Future<Response> fetchAllAgentsApi(int page, int perPage) async {
    var uri =  _apiProviderInterface.provideAllAgentsInfoApi(page, perPage);
    return doRequestOnRoute(uri, tag: "all agents");
  }

  Future<Response> fetchAllAgenciesApi(int page, int perPage) async {
    var uri =  _apiProviderInterface.provideAllAgenciesInfoApi(page, perPage);
    return doRequestOnRoute(uri, tag: "all agencies");
  }

  Future<Response> fetchPropertiesInCityApi(int cityId, int page, int perPage) async {

    var uri =  _apiProviderInterface.providePropertiesInCityApi(cityId, page, perPage);
    return doRequestOnRoute(uri, tag: "city properties");
  }

  Future<Response> fetchPropertiesInCityByTypeApi(int cityId, int typeId, int page, int perPage) async {
      var uri =  _apiProviderInterface.providePropertiesInCityByTypeApi(cityId, typeId, page, perPage);
      return doRequestOnRoute(uri, tag: "city properties by type");
  }

  Future<Response> fetchPropertiesByTypeApi(int propertyTypeId, int page, int perPage) async {
      var uri =  _apiProviderInterface.providePropertiesByTypesApi(propertyTypeId, page, perPage);
      return doRequestOnRoute(uri, tag: "type properties");
  }

  Future<ApiResponse> fetchContactRealtorResponse(ContactRealtorRequest realtorRequest, String nonce) async {
    var uri = _apiProviderInterface.provideContactRealtorApi();
    Response response = await doRequestOnRoute(
      uri,
      type: POST,
      dataMap: realtorRequest.convertObjectToMap(realtorRequest),
      tag: "contact realtor",
      handle500: true,
      nonce: nonce,
      nonceVariable: kContactPropertyAgentNonceVariable,
    );

    ApiResponse apiResponse = _apiProviderInterface.getParser().parse500ApiResponse(response);
    return apiResponse;
  }

  Future<Response> fetchContactDeveloperResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideContactDeveloperApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "contact dev");

  }

  Future<Response> fetchScheduleATourResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideScheduleATourApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "schedule tour",
      handle500: true,
      nonce: nonce,
      nonceVariable: kScheduleTourNonceVariable,
    );
  }


  Future<Response> fetchAddPropertyResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideSavePropertyApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "add prop",
      nonce: nonce,
      nonceVariable: kAddPropertyNonceVariable,
    );
  }

  Future<Response> fetchLoginResponse(Map<String, dynamic> dataMap) async {
    ApiRequest request = _apiProviderInterface.provideLoginApiRequest(dataMap);
    Dio dio = Dio();
      // ..interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    return doRequestOnRoute(request.uri, dio: dio, type: POST, dataMap: request.params, tag: "login", handle403: false);

  }

  Future<Response> fetchSignUpResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideSignUpApi();
    Dio dio = Dio();
      // ..interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    return doRequestOnRoute(
      uri,
      dio: dio,
      type: POST,
      dataMap: dataMap,
      tag: "sign-up",
      handle403: false,
      handle500: true,
      nonce: nonce,
      nonceVariable: kSignUpNonceVariable,
    );
  }

  Future<Response> fetchAdminAddUserResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideAdminAddUserApi();

    String token = HiveStorageManager.getUserToken() ?? "";
    Map<String, dynamic> headerMap = {};

    if (token.isNotEmpty) {
      headerMap["Authorization"] = "Bearer $token";
    }

    late Dio dio;

    if (headerMap.isNotEmpty) {
      dio = Dio()
        ..options.headers = headerMap;
    } else {
      dio = Dio();
    }

    return doRequestOnRoute(
      uri,
      dio: dio,
      type: POST,
      dataMap: dataMap,
      tag: "admin-add-user",
      handle403: false,
      handle500: true,
      nonce: nonce,
      nonceVariable: kSignUpNonceVariable,
    );
  }

  Future<Response> fetchForgetPasswordResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideForgetPasswordApi();
    Dio dio = Dio();
      // ..interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    return doRequestOnRoute(
      uri,
      dio: dio,
      type: POST,
      dataMap: dataMap,
      tag: "forget password",
      handle403: false,
      handle500: true,
      nonce: nonce,
      nonceVariable: kResetPasswordNonceVariable,
    );
  }

  Future<Response> fetchAllProperties(String status, int page, int perPage, int? userId, {Map<String, dynamic>? options}) async {
    var uri = _apiProviderInterface.provideAllPropertiesApi(status,page,perPage, userId);
    return doRequestOnRoute(uri, tag: "all properties");
  }

  Future<Response> statusOfProperty(Map<String, dynamic> dataMap,int id) async {

    var uri = _apiProviderInterface.provideStatusOfPropertyApi(id);
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "prop status");
  }

  Future<Response> deleteProperty(int id) async {
    var uri = _apiProviderInterface.provideDeletePropertyApi(id);
    return doRequestOnRoute(uri, tag: "delete prop", forceExcludeCache: true);
  }

  Uri provideSavePropertyImagesApi() {
    var uri = _apiProviderInterface.provideSavePropertyImagesApi();
    return uri;
  }

  Future<Response> fetchMyProperties(String status, int page, int perPage,int userId, {Map<String, dynamic>? options}) async {
    var uri = _apiProviderInterface.provideMyPropertiesApi(status,page,perPage,userId);
    return doRequestOnRoute(uri, tag: "get my prop", forceExcludeCache: true);
  }

  Future<Response> fetchTermDataApi(dynamic termData) async {
    var uri =  _apiProviderInterface.provideTermDataApi(termData);
    return doRequestOnRoute(uri, tag: "get terms");
  }

  Future<Response> fetchAddOrRemoveFromFavResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideAddOrRemoveFromFavApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "add or remove from favourites", handle500: true);
  }

  Future<Uri> fetchPrintPdfPropertyResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.providePrintPdfPropertyApi(dataMap);
    return uri;
    // return doRequestOnRoute(uri, type: GET,dataMap: dataMap, tag: "PrintPdfProperty", handle500: true);
  }

  Future<Response> fetchFavProperties(int page, int perPage, String userIdStr) async {
    var uri = _apiProviderInterface.provideFavPropertiesApi(page, perPage, userIdStr);
    return doRequestOnRoute(uri, tag: "get fav prop", useCache: false, handle403: true, forceExcludeCache: true);
  }

  Future<Response> fetchUpdatePropertyResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideUpdatePropertyApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "update property",
      nonce: nonce,
      nonceVariable: kUpdatePropertyNonceVariable,
    );
  }

  Future<Response> fetchLatLongArticlesResponse(String lat,String long, String radius) async {
    var data = {
      'search_location': 'true',
      'use_radius': 'on',
      'search_lat': lat,
      'search_long': long,
      'search_radius': radius,
    };
    var uri = _apiProviderInterface.provideLatLongArticlesApi(lat,long);
    return doRequestOnRoute(uri, type:POST, dataMap: data, tag:"property on loc");
  }

  Future<Response> fetchDeleteImageFromEditProperty(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideDeleteImageFromEditPropertyApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "delete image from edit property",
      handle500: true,
      nonce: nonce,
      nonceVariable: kDeleteImageNonceVariable,
    );
  }

  Future<Response> fetchAddSavedSearch(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideAddSavedSearchApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "add saved property",
      handle500: true,
      nonce: nonce,
      nonceVariable: kSaveSearchNonceVariable,
    );
  }

  Future<Response> fetchSavedSearches(int page, int perPage, {String? leadId, bool fetchLeadSavedSearches = false}) async {
    var uri = _apiProviderInterface.provideSavedSearches(page, perPage,leadId: leadId, fetchLeadSavedSearches: fetchLeadSavedSearches);
    return doRequestOnRoute(uri, tag:"saved searches", useCache: false, forceExcludeCache: true);
  }

  Future<Response> fetchDeleteSavedSearch(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideDeleteSavedSearchApi();
    return doRequestOnRoute(uri, type:POST, dataMap: dataMap, tag:"delete saved property", handle500: true);
  }

  Future<Response> fetchSavedSearchArticlesResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideSavedSearchArticlesApi();
    return doRequestOnRoute(uri, type:POST, dataMap: dataMap, tag:"saved search articles");
  }

  Future<Response> fetchAddReviewResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideAddReviewApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "add review",
      handle500: true,
      nonce: nonce,
      nonceVariable: kAddReviewNonceVariable,
    );
  }
  Future<Response> fetchReportContentResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideReportContentApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "report content",
      nonce: nonce,
      handle403: false,
      nonceVariable: kReportContentNonceVariable,
    );
  }

  Future<Response> fetchArticlesReviewsResponse(int id, String page, String perPage) async {
    var uri = _apiProviderInterface.provideArticlesReviewsApi(id, page, perPage);
    return doRequestOnRoute(uri, tag:"article reviews");
  }

  Future<Response> fetchAgentAgencyAuthorReviewsResponse(int id, String page, String perPage, String type) async {
    var uri = _apiProviderInterface.provideAgentAgencyAuthorReviewsApi(id, page, perPage, type);
    return doRequestOnRoute(uri, tag:"agent agency author reviews");
  }

  Future<Response> fetchUserInfoResponse() async {
    var uri = _apiProviderInterface.provideUserInfoApi();
    return doRequestOnRoute(uri, tag:"user info", forceExcludeCache: true);
  }

  Future<Response> fetchUpdateUserProfileResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideUpdateUserProfileApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "update user profile",
      handle500: true,
      nonce: nonce,
      nonceVariable: kUpdateProfileNonceVariable,
    );
  }

  Future<Response> fetchUpdateUserProfileImageResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideUpdateUserProfileImageApi();
    var path = dataMap["imagepath"];
    var fileName = path.split('/').last;

    // Map data = {
    //   "houzez_file_data_name": await MultipartFile.fromFile(path, filename: fileName),
    // };
    // return doRequestOnRoute(uri, type:POST, dataMap: data, tag:"update user profile image", handle500: true);
    FormData formData = FormData.fromMap({
      "houzez_file_data_name": await MultipartFile.fromFile(path, filename: fileName),
      kUpdateProfileImageNonceVariable: nonce
    });
    return doRequestOnRoute(uri, type:POST, formData: formData, tag:"update user profile image", handle500: true);
  }

  Future<Response> fetchSearchAgentsApi(int page, int perPage,String search,String agentCity,String agentCategory) async {
    var uri =  _apiProviderInterface.provideSearchAgentsApi(page, perPage,search,agentCity,agentCategory);
    return doRequestOnRoute(uri, tag: "search agents");
  }

  Future<Response> fetchSearchAgenciesApi(int page,int perPage,String search) async {
    var uri =  _apiProviderInterface.provideSearchAgenciesApi(page, perPage,search);
    return doRequestOnRoute(uri, tag: "Search agencies");
  }

  Future<Response> fetchFixProfileImageResponse() async {
    var uri = _apiProviderInterface.provideFixProfileImageResponseApi();
    return doRequestOnRoute(uri, type: POST, tag: "update user profile", handle500: true);
  }

  Future<Response> fetchIsFavPropertyApi(String listingId) async {
    var uri =  _apiProviderInterface.provideIsFavPropertyAp(listingId);
    return doRequestOnRoute(uri, tag: "is fav property", forceExcludeCache: true);
  }

  Future<Response> fetchSocialSignOnResponse(Map<String, dynamic> dataMap) async {
    ApiRequest apiRequest = _apiProviderInterface.provideSocialLoginApi(dataMap);
    Dio dio = Dio();
      // ..interceptors.add(DioCacheManager(CacheConfig()).interceptor);
    return doRequestOnRoute(apiRequest.uri, dio: dio, type: POST, dataMap: apiRequest.params, tag: "social-login", handle403: false);

  }

  Future<Response> fetchPropertiesByTypeResponse(int page,int id,String type) async {
    var uri = _apiProviderInterface.providePropertiesByTypeApi(page, id, type);
    return doRequestOnRoute(uri, tag: "properties by type");
  }

  Future<Response> fetchRealtorInfoApi(int page, String type) async {
    var uri =  _apiProviderInterface.provideRealtorInfoApi(page, type);
    return doRequestOnRoute(uri, tag: "realtor list");
  }

  Future<Response> fetchDeleteUserAccountResponse() async {
    var uri = _apiProviderInterface.provideDeleteUserAccountApi();
    return doRequestOnRoute(uri, type:POST,tag: "delete user account",handle500: true);
  }

  Future<Response> fetchUpdateUserPasswordResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideUpdateUserPasswordApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "update password",
      handle500: true,
      nonce: nonce,
      nonceVariable: kUpdatePasswordNonceVariable,
    );
  }

  Future<Response> fetchSingleArticleViaPermaLinkResponse(String permaLink) async {
    var uri = _apiProviderInterface.provideSingleArticleViaPermaLinkApi(permaLink);
    String str = uri.toString();
    str = UtilityMethods.parseHtmlString(str);


    if(str.contains("%3A")){
      str = str.replaceAll("%3A", ":");
    }
    if(str.contains("%2F")){
      str = str.replaceAll("%2F", "/");
    }
    Uri myUri = Uri.parse(str);
    return doRequestOnRoute(myUri, tag: "single article permaLink");
  }

  Future<Response> fetchAddRequestPropertyResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideAddRequestPropertyApi();
    return doRequestOnRoute(uri, type: POST,dataMap: dataMap, tag: "request property", handle500: true);
  }

  Future<Response> fetchPropertiesAdsResponse() async {
    Uri uri = _apiProviderInterface.providePropertiesAdsResponseApi();

    return doRequestOnRoute(uri, tag: "Properties Ads");
  }

  Future<Response> fetchAddAgentResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideAddAgentResponseApi();
    return doRequestOnRoute(
        uri,
        type: POST,
        dataMap: dataMap,
        tag: "add agent",
        handle500: true,
        nonce: nonce,
        nonceVariable: kAddAgentNonceVariable,
    );
  }

  Future<Response> fetchEditAgentResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideEditAgentResponseApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "edit agent",
      handle500: true,
      nonce: nonce,
      nonceVariable: kEditAgentNonceVariable,
    );
  }

  Future<ApiResponse> fetchDeleteAgentResponse(AgencyAgentsModel dataObj, String nonce) async {
    var uri = _apiProviderInterface.provideDeleteAgentResponseApi();
    Response response = await doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataObj.convertObjectToMap(dataObj),
      tag: "delete agent",
      handle500: true,
      nonce: nonce,
      nonceVariable: kDeleteAgentNonceVariable,
    );

    ApiResponse<String> apiResponse = _apiProviderInterface.getParser().parse500ApiResponse(response);
    return apiResponse;
  }

  Future<Response> fetchUsersResponse(int page, int perPage, String search) async {
    Uri uri = _apiProviderInterface.provideUsersResponseApi(page, perPage, search);

    return doRequestOnRoute(uri, tag: "All Users");
  }

  Future<Response> fetchUserPaymentStatusResponse() {
    Uri uri = _apiProviderInterface.provideUserPaymentStatusResponseApi();

    return doRequestOnRoute(uri,type: POST, tag: "User Payment Status");
  }

  Future<ApiResponse> fetchContactRealtorNonceResponse() {
    return createNonce(kContactRealtorNonceName);
  }

  Future<ApiResponse> fetchAddAgentNonceResponse() {
    return createNonce(kAddAgentNonceName);
  }

  Future<ApiResponse> fetchEditAgentNonceResponse() {
    return createNonce(kEditAgentNonceName);
  }

  Future<ApiResponse> fetchDeleteAgentNonceResponse() {
    return createNonce(kDeleteAgentNonceName);
  }

  Future<ApiResponse> fetchScheduleATourNonceResponse() {
    return createNonce(kScheduleTourNonceName);
  }

  Future<ApiResponse> fetchContactPropertyAgentNonceResponse() {
    return createNonce(kContactPropertyAgentNonceName);
  }

  Future<ApiResponse> fetchAddPropertyNonceResponse() {
    return createNonce(kAddPropertyNonceName);
  }

  Future<ApiResponse> fetchUpdatePropertyNonceResponse() {
    return createNonce(kUpdatePropertyNonceName);
  }

  Future<ApiResponse> fetchAddImageNonceResponse() {
    return createNonce(kAddImageNonceName);
  }

  Future<ApiResponse> fetchDeleteImageNonceResponse() {
    return createNonce(kDeleteImageNonceName);
  }

  Future<ApiResponse> fetchAddReviewNonceResponse() {
    return createNonce(kAddReviewNonceName);
  }

  Future<ApiResponse> fetchSaveSearchNonceResponse() {
    return createNonce(kSaveSearchNonceName);
  }

  Future<ApiResponse> fetchSignUpNonceResponse() {
    return createNonce(kSignUpNonceName);
  }

  Future<ApiResponse> fetchResetPasswordNonceResponse() {
    return createNonce(kResetPasswordNonceName);
  }

  Future<ApiResponse> fetchUpdatePasswordNonceResponse() {
    return createNonce(kUpdatePasswordNonceName);
  }

  Future<ApiResponse> fetchUpdateProfileNonceResponse() {
    return createNonce(kUpdateProfileNonceName);
  }

  Future<ApiResponse> fetchUpdateProfileImageNonceResponse() {
    return createNonce(kUpdateProfileImageNonceName);
  }

  Future<ApiResponse> fetchSignInNonceResponse() {
    return createNonce(kSignInNonceName, isNonce: true);
  }

  Future<ApiResponse> fetchReportContentNonceResponse() {
    return createNonce(kReportContentNonceName);
  }

  Future<ApiResponse> fetchAddCommentNonceResponse() {
    return createNonce(kAddCommentNonceName);
  }

  Future<ApiResponse> fetchSendMessageNonceResponse() {
    return createNonce(kSendMessageNonceName);
  }

  Future<ApiResponse> fetchStartThreadNonceResponse() {
    return createNonce(kStartMessageThreadNonceName);
  }

  Future<ApiResponse> fetchProceedWithPaymentsResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideProceedWithPaymentsResponseApi();

    Response response = await doRequestOnRoute(uri,type: POST, dataMap: dataMap, tag: "Proceed With Payments", handle403: false);

    ApiResponse<String> apiResponse = _apiProviderInterface.getParser().parsePaymentResponse(response);
    return apiResponse;
  }

  Future<ApiResponse> fetchMakePropertyFeaturedResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideMakePropertyFeaturedResponseApi();

    Response response = await  doRequestOnRoute(uri,type: POST,dataMap: dataMap ,tag: "Make Property Featured", handle500: true);

    ApiResponse<String> apiResponse = _apiProviderInterface.getParser().parseFeaturedResponse(response);
    return apiResponse;
  }

  Future<ApiResponse> fetchRemoveFromFeaturedResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideRemoveFromFeaturedResponseApi();

    Response response = await  doRequestOnRoute(uri,type: POST,dataMap: dataMap ,tag: "Remove From Featured", handle500: true);

    ApiResponse<String> apiResponse = _apiProviderInterface.getParser().parseFeaturedResponse(response);
    return apiResponse;
  }

  Future<Response> fetchUserMembershipPackageResponse() async {
    Uri uri = _apiProviderInterface.provideUserMembershipPackageResponseApi();

    return doRequestOnRoute(uri,type: POST ,tag: "User Membership Package");
  }

  Future<ApiResponse> createNonce(String nonceName, {bool isNonce = false}) async {
    var uri = _apiProviderInterface.provideCreateNonceApi();
    Map<String, dynamic> dataMap = {kCreateNonceKey: nonceName};

    Response response = await doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "Create Nonce",
      handle403: true,
      isNonce: isNonce,
    );

    ApiResponse<String> nonce = _apiProviderInterface.getParser().parseNonceResponse(response);
    return nonce;

  }

  Future<Response> fetchPartnersListResponse() async {
    var uri = _apiProviderInterface.providePartnersListApi();
    return doRequestOnRoute(uri, tag: "Partners List");
  }

  Uri provideDirectionsApi(String platform, String lat, String lng) {
    var uri = _apiProviderInterface.provideDirectionsApi(platform, lat, lng);
    return uri;
  }

  Future<Response> fetchMembershipPackagesResponse() async {
    var uri = _apiProviderInterface.provideMembershipPackagesApi();
    return doRequestOnRoute(uri, tag: "featured article");
  }

  Future<Response> fetchApproveDisapproveResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideApproveDisapproveResponseApi();

    return doRequestOnRoute(uri,type: POST,dataMap: dataMap ,tag: "Approve Disapprove");
  }

  Future<Response> fetchToggleFeaturedResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideToggleFeaturedResponseApi();

    return doRequestOnRoute(uri,type: POST,dataMap: dataMap ,tag: "Toggle Featured");
  }

  Future<Response> fetchSetSoldStatusResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideSetSoldStatusResponseApi();

    return doRequestOnRoute(uri, type: POST, dataMap: dataMap , tag: "Set sold status");
  }

  Future<Response> fetchSetExpiredStatusResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideSetExpiredStatusResponseApi();

    return doRequestOnRoute(uri, type: POST, dataMap: dataMap , tag: "Set expire status");
  }

  Future<Response> fetchSetPendingStatusResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideSetPendingStatusResponseApi();

    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "Set pending status");
  }

  Future<Response> fetchBlogFilteredArticlesResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideBlogSearchApi();
    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "blog filtered articles");
  }

  Future<Response> fetchBlogAllCategoriesResponse(String orderBy, String order) async {
    var uri = _apiProviderInterface.provideBlogAllCategoriesApi(orderBy, order);
    return doRequestOnRoute(uri, tag: "blog categories");
  }

  Future<Response> fetchBlogAllTagsResponse(String orderBy, String order) async {
    var uri = _apiProviderInterface.provideBlogAllTagsApi(orderBy, order);
    return doRequestOnRoute(uri, tag: "blog tags");
  }

  Future<Response> fetchBlogArticleCommentsResponse(Map<String, dynamic> dataMap) async {
    var uri = _apiProviderInterface.provideBlogCommentsApi();
    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "blog article comments");
  }

  Future<Response> fetchBlogAddCommentResponse(Map<String, dynamic> dataMap, String nonce) async {
    var uri = _apiProviderInterface.provideBlogAddCommentApi();
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "blog add comment",
      nonce: nonce,
      nonceVariable: kAddCommentNonceVariable,
    );
  }

  Future<Response> fetchAllNotificationsResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideAllNotificationsApi();
    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "All Notifications");
  }

  Future<Response> fetchCheckNotificationsResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideCheckNotificationsApi();
    return doRequestOnRoute(uri, type: POST, dataMap: dataMap, tag: "Check Notifications");
  }

  Future<Response> fetchDeleteNotificationsResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideDeleteNotificationApi();
    Map<String, dynamic> map = {
      "notification_id" : dataMap[NOTIFICATION_ID_KEY],
      "notification_user_email" : dataMap[NOTIFICATION_USER_EMAIL_KEY],
    };
    return doRequestOnRoute(uri, type: POST, dataMap: map,
        tag: "Delete Notifications", forceExcludeCache: true, useCache: false,
    );
  }

  Future<Response> fetchAllMessageThreadsResponse(int page, int perPage, int? propertyId) async {
    Uri uri = _apiProviderInterface.provideAllMessageThreadsApi(page, perPage, propertyId);
    return doRequestOnRoute(uri, type: GET, tag: "All Message Threads", forceExcludeCache: true, useCache: false);
  }

  Future<Response> fetchAllThreadMessagesResponse(Map<String, dynamic> dataMap) async {
    Uri uri = _apiProviderInterface.provideAllThreadMessagesApi(dataMap);
    return doRequestOnRoute(uri, type: GET, tag: "All Thread Messages", forceExcludeCache: true, useCache: false);
  }

  Future<Response> fetchDeleteMessageThreadResponse(String threadId, String senderId, String receiverId) async {
    Uri uri = _apiProviderInterface.provideDeleteMessageThreadApi();
    Map<String, dynamic> dataMap = {
      "thread_id" : threadId,
      "sender_id" : senderId,
      "receiver_id" : receiverId,
    };
    return doRequestOnRoute(
        uri,
        type: POST,
        tag: "Delete Message Thread",
        dataMap: dataMap,
        forceExcludeCache: true,
        useCache: false,
    );
  }

  Future<Response> fetchStartMessageThreadResponse(int propertyId, String message, String nonce) async {
    var uri = _apiProviderInterface.provideStartMessageThreadApi();
    Map<String, dynamic> dataMap = {
      "property_id" : "$propertyId",
      "message" : message,
    };
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "Start Message Thread",
      nonce: nonce,
      nonceVariable: kStartMessageThreadVariable,
    );
  }

  Future<Response> fetchSendMessageResponse(String threadId, String message, String nonce) async {
    var uri = _apiProviderInterface.provideSendMessagesApi();
    Map<String, dynamic> dataMap = {
      "thread_id" : threadId,
      "message" : message,
    };
    return doRequestOnRoute(
      uri,
      type: POST,
      dataMap: dataMap,
      tag: "Send Message",
      nonce: nonce,
      nonceVariable: kSendMessageVariable,
    );
  }
}