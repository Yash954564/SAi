import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';

import '../../../../models/api/api_request.dart';

abstract class CRMApiProviderInterface {
  Uri provideActivitiesFromBoardApi(int page, int perPage, int userId);

  Uri provideInquiriesFromBoardApi(int page, int perPage);

  Uri provideLeadsFromActivityApi(int page, int userId);

  Uri provideDealsFromActivityApi(int page, int userId);

  Uri provideDealsFromBoardApi(int page, int perPage, String tab);

  Uri provideLeadsFromBoardApi(int page, int perPage);

  Uri provideAddDealResponseApi();

  ApiRequest provideDeleteDealApi(int id, String nonce, String nonceVariable);

  ApiRequest provideDeleteInquiryApi(int id);

  Uri provideAddInquiryApi();

  ApiRequest provideDeleteLeadApi(id, String nonce, String nonceVariable);

  Uri provideDealsAndLeadsFromActivityApi();

  Uri provideAddLeadResponseApi();

  Uri provideInquiryDetailMatchedFromBoardApi(String enquiryId, int propPage);

  Uri provideInquiryDetailNotesFromBoardApi(String enquiryId);

  Uri provideAddCRMNotesApi();

  Uri provideDeleteCRMNotesApi();

  Uri provideSendCRMEmailApi();

  Uri provideLeadsDetailNotesFromBoardApi(String leadId);

  Uri provideLeadsInquiriesFromBoardApi(String leadId, int propPage);

  Uri provideLeadsViewedFromBoardApi(String leadId, int propPage);

  Uri provideUpdateDealDetailResponseApi();

  Uri provideSocialLoginApi();

  Uri provideLoginApi();

  Uri provideCreateNonceApi();

  CRMApiParserInterface crmGetParser();
}

abstract class CRMApiParserInterface {
  CRMActivity parseActivities(Map<String, dynamic> json);

  CRMInquiries parseInquiries(Map<String, dynamic> json);

  CRMLeadsFromActivity parseLeads(Map<String, dynamic> json);

  CRMDealsFromActivity parseDeals(Map<String, dynamic> json);

  CRMDealsAndLeads parseDealsAndLeadsFromBoard(Map<String, dynamic> json);

  CRMDealsAndLeadsFromActivity parseDealsAndLeadsFromActivity(
      Map<String, dynamic> json);

  CRMNotes parseInquiryNotes(Map<String, dynamic> json);
}
