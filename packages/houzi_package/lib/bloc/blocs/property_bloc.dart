import 'package:dio/dio.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/api/data_models.dart';
import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/models/blog_models/blog_comments_data.dart';
import 'package:houzi_package/models/blog_models/blog_tags_data.dart';
import 'package:houzi_package/models/blog_models/blogs_categories_data.dart';
import 'package:houzi_package/models/messages/all_message_threads.dart';
import 'package:houzi_package/models/messages/all_thread_messages.dart';
import 'package:houzi_package/models/notifications/check_notifications.dart';
import 'package:houzi_package/models/notifications/notifications.dart';
import 'package:houzi_package/models/user_membership_package.dart';
import 'package:houzi_package/bloc/repositories/property_repository.dart';

class PropertyBloc{
  final PropertyRepository _propertyRepository = PropertyRepository();

  Future<List> fetchLatestArticles(int page) async {
    final List<dynamic> latestArticles = await _propertyRepository.fetchLatestArticlesList(page);
    return latestArticles;
  }

  Future<Map<String, dynamic>> fetchFilteredArticles(Map<String, dynamic> dataMap) async {
    final Map<String, dynamic> filteredArticles = await _propertyRepository.fetchFilteredArticlesList(dataMap);
    return filteredArticles;
  }

  Future<List> fetchFeaturedArticles(int page) async {
    final List<dynamic> featuredArticles = await _propertyRepository.fetchFeaturedArticlesList(page);
    return featuredArticles;
  }

  Future<List> fetchSimilarArticles(int propertyId) async {
    final List<dynamic> similarArticles = await _propertyRepository.fetchSimilarArticlesList(propertyId);
    return similarArticles;
  }

  Future<List> fetchMultipleArticles(String propertiesId) async {
    final List<dynamic> multipleArticles = await _propertyRepository.fetchMultipleArticles(propertiesId);
    return multipleArticles;
  }

  Future<List> fetchSingleArticle(int id, {bool forEditing = false}) async {
    final List<dynamic> singleArticleDetails = await _propertyRepository.fetchSingleArticleList(id, forEditing: forEditing);
    return singleArticleDetails;
  }

  Future<Map<String, dynamic>> fetchPropertyMetaData() async {
    final Map<String, dynamic> propertyMetaDataMap = await _propertyRepository.fetchPropertyMetaData();
    return propertyMetaDataMap;
  }

  Future<List> fetchSingleAgencyInfoList(int id) async {
    final List<dynamic> singleAgencyInfoList = await _propertyRepository.fetchSingleAgencyInfoList(id);
    return singleAgencyInfoList;
  }

  Future<List> fetchSingleAgentInfoList(int id) async {
    final List<dynamic> singleAgentInfoList = await _propertyRepository.fetchSingleAgentInfoList(id);
    return singleAgentInfoList;
  }

  Future<List> fetchAgencyAgentInfoList(int id) async {
    final List<dynamic> agencyAgentInfoList = await _propertyRepository.fetchAgencyAgentInfoList(id);
    return agencyAgentInfoList;
  }

  Future<List> fetchAgencyAllAgentList(int id) async {
    final List<dynamic> agencyAgentInfoList = await _propertyRepository.fetchAgencyAllAgentList(id);
    return agencyAgentInfoList;
  }

  Future<List> fetchPropertiesByAgencyList(int id, int page, int perPage) async {
    final List<dynamic> propertiesByAgencyList = await _propertyRepository.fetchPropertiesByAgencyList(id, page, perPage);
    return propertiesByAgencyList;
  }

  Future<List> fetchPropertiesByAgentList(int id, int page, int perPage) async {
    final List<dynamic> propertiesByAgentList = await _propertyRepository.fetchPropertiesByAgentList(id, page, perPage);
    return propertiesByAgentList;
  }

  // Future<List> fetchLatestRelatedArticles(int postId) async {
  //   final List<dynamic> relatedArticles = await _propertyRepository.fetchLatestRelatedArticlesList(postId);
  //   return relatedArticles;
  // }
  //
  // Future<List> fetchFeaturedRelatedArticles(int postId) async {
  //   final List<dynamic> relatedArticles = await _propertyRepository.fetchFeaturedRelatedArticlesList(postId);
  //   return relatedArticles;
  // }

  // Future<List> fetchRelatedPropertiesByAgencyList(int agencyId, int postId, int page, int perPage) async {
  //   final List<dynamic> relatedPropertiesByAgencyList = await _propertyRepository.fetchRelatedPropertiesByAgencyList(agencyId, postId, page, perPage);
  //   return relatedPropertiesByAgencyList;
  // }
  //
  // Future<List> fetchRelatedPropertiesByAgentList(int agentId, int postId, int page, int perPage) async {
  //   final List<dynamic> relatedPropertiesByAgentList = await _propertyRepository.fetchRelatedPropertiesByAgentList(agentId, postId, page, perPage);
  //   return relatedPropertiesByAgentList;
  // }

  // Future<List> fetchRelatedPropertiesInCityList(int cityId, int postId, int page, int perPage) async {
  //   final List<dynamic> relatedPropertiesInCityList = await _propertyRepository.fetchRelatedPropertiesInCityList(cityId, postId, page, perPage);
  //   return relatedPropertiesInCityList;
  // }

  // Future<List> fetchRelatedPropertiesByTypeList(int propertyTypeId, int postId, int page, int perPage) async {
  //   final List<dynamic> relatedPropertiesByTypeList = await _propertyRepository.fetchRelatedPropertiesByTypeList(propertyTypeId, postId, page, perPage);
  //   return relatedPropertiesByTypeList;
  // }

  Future<List> fetchAllAgentsInfoList(int page, int perPage) async {
    final List<dynamic> allAgentsInfoList = await _propertyRepository.fetchAllAgentsInfoList(page, perPage);
    return allAgentsInfoList;
  }

  Future<List> fetchAllAgenciesInfoList(int page, int perPage) async {
    final List<dynamic> allAgenciesInfoList = await _propertyRepository.fetchAllAgenciesInfoList(page, perPage);
    return allAgenciesInfoList;
  }

  Future<List> fetchPropertiesInCityList(int id, int page, int perPage) async {
    final List<dynamic> propertiesInCityList = await _propertyRepository.fetchPropertiesInCityList(id, page, perPage);
    return propertiesInCityList;
  }

  Future<List> fetchPropertiesByTypeList(int id, int page, int perPage) async {
    final List<dynamic> propertiesByTypeList = await _propertyRepository.fetchPropertiesByTypeList(id, page, perPage);
    return propertiesByTypeList;
  }

  Future<List> fetchPropertiesInCityByTypeList(int cityId, int typeId, int page, int perPage) async {
    final List<dynamic> propertiesInCityByTypeList = await _propertyRepository.fetchPropertiesInCityByTypeList(
        cityId, typeId, page, perPage);
    return propertiesInCityByTypeList;
  }

  Future<ApiResponse> fetchContactRealtorResponse(ContactRealtorRequest realtorRequest, String nonce) async {
    final  response = await _propertyRepository.fetchContactRealtorResponse(realtorRequest, nonce);
    return response;
  }

  Future<Response> fetchContactDeveloperResponse(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchContactDeveloperResponse(dataMap);
    return response;
  }

  Future<Response> fetchLoginResponse(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchLoginResponse(dataMap);
    return response;
  }

  Future<Response> fetchScheduleATourResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchScheduleATourResponse(dataMap,nonce);
    return response;
  }


  Future<Response> fetchAddPropertyResponse(Map<String, dynamic> dataMap, String nonce) async {
  // Future<Response> fetchAddPropertyResponse(Map<dynamic, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchAddPropertyResponse(dataMap, nonce);
    // print("Bloc Response: ${response.data}");
    return response;
  }

  Future<Response> fetchSigupResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchSigupResponse(dataMap, nonce);
    return response;
  }

  Future<Response> fetchAdminAddUserResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchAdminAddUserResponse(dataMap, nonce);
    return response;
  }

  Future<List> fetchAllProperties(String status, int page, int perPage, int? userId) async {
    final List<dynamic> propertiesByUserList = await _propertyRepository.fetchAllProperties(status, page, perPage, userId);
    return propertiesByUserList;
  }

  Future<Response> statusOfProperty(Map<String, dynamic> dataMap,int id) async {
    final  response = await _propertyRepository.statusOfProperty(dataMap,id);
    return response;
  }

  Future<Response> deleteProperty(int id) async {
    final  response = await _propertyRepository.deleteProperty(id);
    return response;
  }

  Uri provideSavePropertyImagesApi() {
    var uri = _propertyRepository.provideSavePropertyImagesApi();
    return uri;
  }

  Future<List> fetchMyProperties(String status, int page, int perPage,int userId) async {
    final List<dynamic> myPropertiesByUserList = await _propertyRepository.fetchMyProperties(status, page, perPage,userId);
    return myPropertiesByUserList;
  }

  Future<Response> fetchForgetPasswordResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchForgetPasswordResponse(dataMap, nonce);
    return response;
  }

  Future<List> fetchTermData(dynamic termData) async {
    final List<dynamic> propertyMetaDataMap = await _propertyRepository.fetchTermData(termData);
    return propertyMetaDataMap;
  }
  // }Future<Map<String, dynamic>> fetchTermData(String termData) async {
  //   final Map<String, dynamic> propertyMetaDataMap = await _propertyRepository.fetchTermData(termData);
  //   return propertyMetaDataMap;
  // }

  Future<Response> fetchAddOrRemoveFromFavResponse(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchAddOrRemoveFromFavResponse(dataMap);
    return response;
  }

  Future<Uri> fetchPrintPdfPropertyResponse(Map<String, dynamic> dataMap) {
    final  response = _propertyRepository.fetchPrintPdfPropertyResponse(dataMap);
    return response;
  }

  Future<List> fetchFavProperties(int page, int perPage, String userIdStr) async {
    final List<dynamic> myPropertiesByUserList = await _propertyRepository.fetchFavProperties(page, perPage, userIdStr);
    return myPropertiesByUserList;
  }

  Future<Response> fetchUpdatePropertyResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchUpdatePropertyResponse(dataMap, nonce);
    return response;
  }

  // Future<Response> fetchImagesForUpdateArticle(Map<String, dynamic> dataMap) async {
  //   final  response = await _propertyRepository.fetchImagesForUpdateArticle(dataMap);
  //   return response;
  // }

  Future<List> fetchLatLongArticles(String lat,String long, String radius) async {
    final List<dynamic> latestArticles = await _propertyRepository.fetchLatLongArticles(lat,long,radius);
    return latestArticles;
  }

  Future<Response> fetchDeleteImageFromEditProperty(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchDeleteImageFromEditProperty(dataMap, nonce);
    return response;
  }

  Future<Response> fetchAddSavedSearch(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchAddSavedSearch(dataMap, nonce);
    return response;
  }

  Future<List> fetchSavedSearches(int page, int perPage, {String? leadId, bool fetchLeadSavedSearches = false}) async{
    final List<dynamic> featuredDeals = await _propertyRepository.fetchSavedSearches(page, perPage,leadId:leadId, fetchLeadSavedSearches: fetchLeadSavedSearches);
    return featuredDeals;
  }

  Future<Response> fetchDeleteSavedSearch(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchDeleteSavedSearch(dataMap);
    return response;
  }

  Future<List> fetchSavedSearchArticles(Map<String, dynamic> dataMap) async {
    final List<dynamic> savedSearchArticles = await _propertyRepository.fetchSavedSearchArticles(dataMap);
    return savedSearchArticles;
  }


  Future<Response> fetchAddReviewResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchAddReviewResponse(dataMap, nonce);
    return response;
  }
  Future<Response> fetchReportContentResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchReportContentResponse(dataMap,nonce);
    return response;
  }

  Future<List<dynamic>> fetchArticlesReviews(int id,String page, String perPage) async {
    final List<dynamic> articlesReviews = await _propertyRepository.fetchArticlesReviews(id,page,perPage);
    return articlesReviews;
  }

  Future<List<dynamic>> fetchAgentAgencyAuthorReviews(int id,String page, String perPage,String type) async {
    final List<dynamic> articlesReviews = await _propertyRepository.fetchAgentAgencyAuthorReviews(id, page, perPage, type);
    return articlesReviews;
  }

  Future<List<dynamic>> fetchUserInfo() async {
    final List<dynamic> userInfoList = await _propertyRepository.fetchUserInfo();
    return userInfoList;
  }

  Future<Response> fetchUpdateUserProfileResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchUpdateUserProfileResponse(dataMap, nonce);
    return response;
  }

  Future<Response> fetchUpdateUserProfileImageResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchUpdateUserProfileImageResponse(dataMap, nonce);
    return response;
  }

  Future<List> fetchSearchAgentsList(int page, int perPage,String search,String agentCity,String agentCategory) async {
    final List<dynamic> searchAgentsList = await _propertyRepository.fetchSearchAgentsList(page, perPage,search,agentCity,agentCategory);
    return searchAgentsList;
  }

  Future<List> fetchSearchAgenciesList(int page, int perPage,String search) async {
    final List<dynamic> allAgentsInfoList = await _propertyRepository.fetchSearchAgenciesList(page, perPage,search);
    return allAgentsInfoList;
  }

  Future<Response> fetchFixProfileImageResponse() async {
    final  response = await _propertyRepository.fetchFixProfileImageResponse();
    return response;
  }

  Future<Response> fetchIsFavProperty(String listingId) async {
    final  response = await _propertyRepository.fetchIsFavProperty(listingId);
    return response;
  }

  Future<Response> fetchSocialSignOnResponse(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchSocialSignOnResponse(dataMap);
    return response;
  }

  Future<List> fetchPropertiesByType(int page,int id,String type) async {
    final List<dynamic> featuredArticles = await _propertyRepository.fetchPropertiesByType(page, id, type);
    return featuredArticles;
  }

  Future<List> fetchRealtorInfoList(int page, String type) async {
    final List<dynamic> allAgentsInfoList = await _propertyRepository.fetchRealtorInfoList(page, type);
    return allAgentsInfoList;
  }

  Future<Response> fetchDeleteUserAccountResponse() async {
    final  response = await _propertyRepository.fetchDeleteUserAccountResponse();
    return response;
  }

  Future<Response> fetchUpdateUserPasswordResponse(Map<String, dynamic> dataMap, String nonce) async {
    final  response = await _propertyRepository.fetchUpdateUserPasswordResponse(dataMap, nonce);
    return response;
  }

  Future<List> fetchSingleArticleViaPermaLink(String permaLink) async {
    final List<dynamic> singleArticleDetails = await _propertyRepository.fetchSingleArticleViaPermaLink(permaLink);
    return singleArticleDetails;
  }

  Future<Response> fetchAddRequestPropertyResponse(Map<String, dynamic> dataMap) async {
    final  response = await _propertyRepository.fetchAddRequestPropertyResponse(dataMap);
    return response;
  }

  Future<Response> fetchAddAgentResponse(Map<String, dynamic> dataMap, String nonce) async {
    final response = await _propertyRepository.fetchAddAgentResponse(dataMap, nonce);
    return response;
  }

  Future<Response> fetchEditAgentResponse(Map<String, dynamic> dataMap, String nonce) async {
    final response = await _propertyRepository.fetchEditAgentResponse(dataMap, nonce);
    return response;
  }

  Future<ApiResponse> fetchDeleteAgentResponse(AgencyAgentsModel dataObj, String nonce) async {
    final response = await _propertyRepository.fetchDeleteAgentResponse(dataObj, nonce);
    return response;
  }

  Future<List> fetchUsers(int page, int perPage, String search) async {
    final List<dynamic> usersList = await _propertyRepository.fetchUsers(page, perPage, search);
    return usersList;
  }

  Future<Map> fetchUserPaymentStatus() async {
    final Map userPaymentStatusMap = await _propertyRepository.fetchUserPaymentStatus();
    return userPaymentStatusMap;
  }

  Future<ApiResponse> fetchContactRealtorNonceResponse() async {
    final response = await _propertyRepository.fetchContactRealtorNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddAgentNonceResponse() async {
    final response = await _propertyRepository.fetchAddAgentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchEditAgentNonceResponse() async {
    final response = await _propertyRepository.fetchEditAgentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchDeleteAgentNonceResponse() async {
    final response = await _propertyRepository.fetchDeleteAgentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchScheduleATourNonceResponse() async {
    final response = await _propertyRepository.fetchScheduleATourNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchContactPropertyAgentNonceResponse() async {
    final response = await _propertyRepository.fetchContactPropertyAgentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddPropertyNonceResponse() async {
    final response = await _propertyRepository.fetchAddPropertyNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchUpdatePropertyNonceResponse() async {
    final response = await _propertyRepository.fetchUpdatePropertyNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddImageNonceResponse() async {
    final response = await _propertyRepository.fetchAddImageNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchDeleteImageNonceResponse() async {
    final response = await _propertyRepository.fetchDeleteImageNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddReviewNonceResponse() async {
    final response = await _propertyRepository.fetchAddReviewNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchSaveSearchNonceResponse() async {
    final response = await _propertyRepository.fetchSaveSearchNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchSignUpNonceResponse() async {
    final response = await _propertyRepository.fetchSignUpNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchResetPasswordNonceResponse() async {
    final response = await _propertyRepository.fetchResetPasswordNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchUpdatePasswordNonceResponse() async {
    final response = await _propertyRepository.fetchUpdatePasswordNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchUpdateProfileNonceResponse() async {
    final response = await _propertyRepository.fetchUpdateProfileNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchUpdateProfileImageNonceResponse() async {
    final response = await _propertyRepository.fetchUpdateProfileImageNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchSignInNonceResponse() async {
    final response = await _propertyRepository.fetchSignInNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchReportContentNonceResponse() async {
    final response = await _propertyRepository.fetchReportContentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddCommentNonceResponse() async {
    final response = await _propertyRepository.fetchAddCommentNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchSendMessageNonceResponse() async {
    final response = await _propertyRepository.fetchSendMessageNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchStartThreadNonceResponse() async {
    final response = await _propertyRepository.fetchStartThreadNonceResponse();
    return response;
  }


  Future<List> fetchPartnersList() async {
    final List<dynamic> partnersList = await _propertyRepository.fetchPartnersList();
    return partnersList;
  }

  Future<List> fetchMembershipPackages() async {
    final List<dynamic> featuredArticles = await _propertyRepository.fetchMembershipPackages();
    return featuredArticles;
  }

  Future<ApiResponse> fetchProceedWithPaymentsResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchProceedWithPaymentsResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchMakePropertyFeaturedResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchMakePropertyFeaturedResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchRemoveFromFeaturedResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchRemoveFromFeaturedResponse(dataMap);
    return response;
  }

  Future<UserMembershipPackage> fetchUserMembershipPackageResponse() async {
    final response = await _propertyRepository.fetchUserMembershipPackageResponse();
    return response;
  }

  Uri provideDirectionsApi({
    required String platform,
    required String destinationLatitude,
    required String destinationLongitude,
  }) {
    var uri = _propertyRepository.provideDirectionsApi(
      platform, destinationLatitude, destinationLongitude);
    return uri;
  }

  Future<ApiResponse> fetchApproveDisapproveResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchApproveDisapproveResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchToggleFeaturedResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchToggleFeaturedResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchSetSoldStatusResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchSetSoldStatusResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchSetExpiredStatusResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchSetExpiredStatusResponse(dataMap);
    return response;
  }

  Future<ApiResponse> fetchSetPendingStatusResponse(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchSetPendingStatusResponse(dataMap);
    return response;
  }

  Future<(bool, bool, BlogArticlesData?)> fetchBlogArticles(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchBlogArticlesData(dataMap);
    return response;
  }

  Future<(bool, BlogCategoriesData?)> fetchBlogAllCategories(String orderBy, String order) async {
    final response = await _propertyRepository.fetchBlogAllCategoriesData(orderBy, order);
    return response;
  }

  Future<(bool, BlogTagsData?)> fetchBlogAllTags(String orderBy, String order) async {
    final response = await _propertyRepository.fetchBlogAllTagsData(orderBy, order);
    return response;
  }

  Future<(bool, bool, BlogCommentsData?)> fetchBlogAllComments(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchBlogAllCommentsData(dataMap);
    return response;
  }

  Future<ApiResponse> fetchBlogAddCommentResponse(Map<String, dynamic> dataMap, String nonce) async {
    final response = await _propertyRepository.fetchBlogAddCommentResponse(dataMap, nonce);
    return response;
  }

  Future<(bool, bool, AllNotifications?)> fetchAllNotifications(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchAllNotificationsResponse(dataMap);
    return response;
  }

  Future<(bool, bool, CheckNotifications?)> checkNewNotifications(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchCheckNotificationsResponse(dataMap);
    return response;
  }

  Future<ApiResponse> deleteNotification(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchDeleteNotificationResponse(dataMap);
    return response;
  }

  Future<(bool, bool, AllMessageThreads?)> fetchAllMessageThreads(int page, int perPage, int? propertyId) async {
    final response = await _propertyRepository.fetchAllMessageThreads(page, perPage, propertyId);
    return response;
  }

  Future<(bool, bool, AllThreadMessages?)> fetchAllThreadMessages(Map<String, dynamic> dataMap) async {
    final response = await _propertyRepository.fetchAllThreadMessages(dataMap);
    return response;
  }

  Future<ApiResponse> fetchDeleteMessageThreadResponse(String threadId, String senderId, String receiverId) async {
    final response = await _propertyRepository.fetchDeleteMessageThreadResponse(threadId, senderId, receiverId);
    return response;
  }

  Future<ApiResponse> fetchStartMessageThreadResponse(int propertyId, String message, String nonce) async {
    final response = await _propertyRepository.fetchStartMessageThreadResponse(propertyId, message, nonce);
    return response;
  }

  Future<ApiResponse> fetchSendMessageResponse(String threadId, String message, String nonce) async {
    final response = await _propertyRepository.fetchSendMessageResponse(threadId, message, nonce);
    return response;
  }
}