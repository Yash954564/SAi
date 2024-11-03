import 'package:houzi_package/bloc/interfaces/api_parser_interface.dart';
import 'package:houzi_package/models/api/api_request.dart';

abstract class ApiProviderInterface {
  Uri provideLatestPropertiesApi(int page);

  Uri provideFilteredPropertiesApi();

  Uri provideFeaturedPropertiesApi(int page);

  Uri provideSinglePropertyApi(int id, {bool forEditing});

  Uri provideSimilarPropertiesApi(int propertyId);

  Uri providePropertyMetaDataApi();

  Uri provideSingleAgentInfoApi(int id);

  Uri provideSingleAgencyInfoApi(int id);

  Uri provideAgencyAgentsInfoApi(int agencyId);

  Uri provideAllAgentsInfoApi(int page, int perPage);

  Uri provideAllAgenciesInfoApi(int page, int perPage);

  Uri providePropertiesByAgentApi(int agentId, int page, int perPage);

  Uri providePropertiesByAgencyApi(int agencyId, int page, int perPage);

  Uri providePropertiesInCityApi(int cityId, int page, int perPage);

  Uri providePropertiesByTypesApi(int propertyTypeId, int page, int perPage);

  Uri providePropertiesInCityByTypeApi(
      int cityId, int typeId, int page, int perPage);

  Uri provideContactRealtorApi();

  Uri provideContactDeveloperApi();

  Uri provideScheduleATourApi();

  Uri provideSavePropertyApi();

  Uri provideSavePropertyImagesApi();

  ApiRequest provideLoginApiRequest(Map<String,dynamic> postData);

  Uri provideSignUpApi();

  Uri provideAdminAddUserApi();

  Uri provideForgetPasswordApi();

  Uri provideAllPropertiesApi(String status, int page, int perPage, int? userId);

  Uri provideMyPropertiesApi(String status, int page, int perPage, int userId);

  Uri provideStatusOfPropertyApi(int id);

  Uri provideDeletePropertyApi(int id);

  Uri provideTermDataApi(dynamic termData);

  Uri provideAddOrRemoveFromFavApi();

  Uri provideFavPropertiesApi(int page, int perPage, String userIdStr);

  Uri provideUpdatePropertyApi();

  Uri provideImagesForUpdateArticleApi();

  Uri provideLatLongArticlesApi(String lat, String long);

  Uri provideDeleteImageFromEditPropertyApi();

  Uri provideAddSavedSearchApi();

  Uri provideSavedSearches(int page, int perPage,
      {String? leadId, bool fetchLeadSavedSearches = false});

  Uri provideDeleteSavedSearchApi();

  Uri provideSavedSearchArticlesApi();

  Uri provideAddReviewApi();

  Uri provideReportContentApi();

  Uri provideArticlesReviewsApi(int id, String page, String perPage);

  Uri provideAgentAgencyAuthorReviewsApi(
      int id, String page, String perPage, String type);

  Uri provideUserInfoApi();

  Uri provideUpdateUserProfileApi();

  Uri provideUpdateUserProfileImageApi();

  Uri provideFixProfileImageResponseApi();

  Uri provideSearchAgentsApi(int page, int perPage, String search,
      String agentCity, String agentCategory);

  Uri provideSearchAgenciesApi(int page, int perPage, String search);

  Uri provideIsFavPropertyAp(String listingId);

  ApiRequest provideSocialLoginApi(Map<String, dynamic> params);

  Uri providePropertiesByTypeApi(int page, int id, String type);

  Uri provideRealtorInfoApi(int page, String type);

  Uri provideDeleteUserAccountApi();

  Uri provideUpdateUserPasswordApi();

  Uri provideSingleArticleViaPermaLinkApi(String permaLink);

  Uri provideAddRequestPropertyApi();

  Uri providePropertiesAdsResponseApi();

  Uri provideAddAgentResponseApi();

  Uri provideAgencyAllAgentListApi(int agencyId);

  Uri provideEditAgentResponseApi();

  Uri provideDeleteAgentResponseApi();

  Uri provideMultiplePropertiesApi(String propertiesId);

  Uri provideUsersResponseApi(int page, int perPage, String search);

  Uri provideUserPaymentStatusResponseApi();

  Uri provideCreateNonceApi();

  Uri providePrintPdfPropertyApi(Map<String, dynamic> dataMap);

  Uri providePartnersListApi();

  Uri provideDirectionsApi(String platform, String latitude, String longitude);

  Uri provideMembershipPackagesApi();

  Uri provideProceedWithPaymentsResponseApi();

  Uri provideMakePropertyFeaturedResponseApi();

  Uri provideRemoveFromFeaturedResponseApi();

  Uri provideUserMembershipPackageResponseApi();

  Uri provideApproveDisapproveResponseApi();

  Uri provideToggleFeaturedResponseApi();

  Uri provideSetSoldStatusResponseApi();

  Uri provideSetExpiredStatusResponseApi();

  Uri provideSetPendingStatusResponseApi();

  Uri provideBlogSearchApi();

  Uri provideBlogAllCategoriesApi(String orderBy, String order);

  Uri provideBlogAllTagsApi(String orderBy, String order);

  Uri provideBlogCommentsApi();

  Uri provideBlogAddCommentApi();

  Uri provideAllNotificationsApi();

  Uri provideCheckNotificationsApi();

  Uri provideDeleteNotificationApi();

  Uri provideAllMessageThreadsApi(int page, int perPage, int? propertyId);

  Uri provideDeleteMessageThreadApi();

  Uri provideStartMessageThreadApi();

  Uri provideAllThreadMessagesApi(Map<String, dynamic> dataMap);

  Uri provideSendMessagesApi();

  ApiParserInterface getParser();

}