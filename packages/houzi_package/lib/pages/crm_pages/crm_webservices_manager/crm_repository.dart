import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/bloc/repositories/property_repository.dart';

import 'crm_api_provider.dart';
import 'crm_houzez_api_provider.dart';

class CRMRepository extends PropertyRepository {
  final CRMApiProvider _crmApiProvider = CRMApiProvider(CRMHOUZEZApiProvider());

  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// CRM Activities
  Future<List> fetchActivitiesFromBoard(int page, int perPage, int userId) async {
    List<dynamic> activities = [];
    final response = await _crmApiProvider.fetchActivitiesFromBoardResponse(
        page, perPage, userId);

    if (response != null && response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data["results"];
      dynamic mapped = results.map((m) {
        return _crmApiProvider.getCurrentParser().parseActivities(m);
      });
      activities.addAll(mapped.toList());
    } else {
      if (response.statusCode == null) {
        activities = [response];
      }
    }
    return activities;
  }

  Future<List> fetchLeadsFromActivity(int page, int userId) async {
    List<dynamic> leads = [];
    final response =
    await _crmApiProvider.fetchLeadsFromActivityResponse(page, userId);

    if (response != null && response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data;
      leads.add(_crmApiProvider.getCurrentParser().parseLeads(results));
    } else {
      if (response.statusCode == null) {
        leads = [response];
      }
    }

    return leads;
  }

  Future<List> fetchDealsFromActivity(int page, int userId) async {
    List<dynamic> deals = [];
    final response =
    await _crmApiProvider.fetchDealsFromActivityResponse(page, userId);

    if (response != null && response.data != null && (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data;
      deals.add(_crmApiProvider.getCurrentParser().parseDeals(results));
    } else {
      if (response.statusCode == null) {
        deals = [response];
      }
    }

    return deals;
  }

  Future<List> fetchDealsAndLeadsFromActivity() async {
    List<dynamic> deals = [];
    final response = await _crmApiProvider.fetchDealsAndLeadsFromActivityResponse();

    if (response.data != null && (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data;
      deals.add(_crmApiProvider.getCurrentParser().parseDealsAndLeadsFromActivity(results));
    } else {
      if (response.statusCode == null) {
        deals = [response];
      }
    }
    return deals;
  }



  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// CRM Inquiries
  Future<List> fetchInquiriesFromBoard(int page, int perPage) async {
    List<dynamic> inquiries = [];

    final response =
        await _crmApiProvider.fetchInquiriesFromBoardResponse(page, perPage);

    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data["results"];
      dynamic mapped = results
          .map((m) => _crmApiProvider.getCurrentParser().parseInquiries(m));
      inquiries.addAll(mapped.toList());
    } else {
      if (response.statusCode == null) {
        inquiries = [response];
      }
    }

    return inquiries;
  }

  Future<List> fetchInquiryDetailMatchedFromBoard(
      String enquiryId, int propPage) async {
    List<dynamic> matched = [];

    final response = await _crmApiProvider
        .fetchInquiryDetailMatchedFromBoardResponse(enquiryId, propPage);

    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {

      final results = response.data["matched"];
      dynamic mapped = results.map((m) => propertyApiProvider.getCurrentParser().parseArticle(m));
      matched.addAll(mapped.toList());
    } else {
      if (response.statusCode == null) {
        matched = [response];
      }
    }

    return matched;
  }

  Future<List> fetchInquiryDetailNotesFromBoard(String enquiryId) async {
    List<dynamic> matched = [];

    final response = await _crmApiProvider.fetchInquiryDetailNotesFromBoardResponse(enquiryId);

    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data;
      dynamic mapped = results
          .map((m) => _crmApiProvider.getCurrentParser().parseInquiryNotes(m));
      matched.addAll(mapped.toList());
    } else {
      if (response.statusCode == null) {
        matched = [response];
      }
    }

    return matched;
  }

  Future<Response> fetchAddInquiryResponse(Map<String, dynamic> dataMap) async {
    final response = await _crmApiProvider.fetchAddInquiryResponse(dataMap);
    return response;
  }

  Future<Response> fetchDeleteInquiry(int id) async {
    final response = await _crmApiProvider.fetchDeleteInquiry(id);
    return response;
  }


  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// CRM Leads
  Future<List<dynamic>> fetchLeadsFromBoard(int page, int perPage) async {
      List<dynamic> dealsList = [];
      final response = await _crmApiProvider.fetchLeadsFromBoard(page, perPage);

      if (response != null &&
          response.data != null &&
          (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
        final results = response.data["results"];
        dynamic mapped = results.map((m) {
          return _crmApiProvider
              .getCurrentParser()
              .parseDealsAndLeadsFromBoard(m);
        });
        dealsList.addAll(mapped.toList());
      } else {
        if (response.statusCode == null) {
          dealsList = [response];
        }
      }

      return dealsList;
    }

  Future<List> fetchLeadsInquiriesFromBoard(String leadId, int propPage,
      {fetchLeadDetail = false}) async {
    List<dynamic> leadsInquiries = [];

    final response = await _crmApiProvider.fetchLeadsInquiriesFromBoardResponse(
        leadId, propPage);
    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      if (fetchLeadDetail) {
        leadsInquiries.add(_crmApiProvider
            .getCurrentParser()
            .parseDealsAndLeadsFromBoard(response.data));
      } else {
        final results = response.data["enquiries"];
        dynamic mapped = results
            .map((m) => _crmApiProvider.getCurrentParser().parseInquiries(m));
        leadsInquiries.addAll(mapped.toList());
      }
    } else {
      if (response.statusCode == null) {
        leadsInquiries = [response];
      }
    }

    return leadsInquiries;
  }

  Future<List> fetchLeadsViewedFromBoard(String leadId, int propPage) async {
    List<dynamic> leadsViewedList = [];
    final response = await _crmApiProvider.fetchLeadsViewedFromBoardResponse(
        leadId, propPage);
    if (response != null &&
        response.data != null &&
        response.data.isNotEmpty &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      leadsViewedList = response.data["data"]["results"];
    } else {
      if (response.statusCode == null) {
        leadsViewedList = [response];
      }
    }

    return leadsViewedList;
  }

  Future<List> fetchLeadsDetailNotesFromBoard(String leadId) async {
    List<dynamic> matched = [];

    final response =
        await _crmApiProvider.fetchLeadsDetailNotesFromBoardResponse(leadId);

    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data;
      dynamic mapped = results
          .map((m) => _crmApiProvider.getCurrentParser().parseInquiryNotes(m));
      matched.addAll(mapped.toList());
    } else {
      if (response.statusCode == null) {
        matched = [response];
      }
    }

    return matched;
  }

  Future<Response> fetchAddLeadResponse(Map<String, dynamic> dataMap) async {
    final response = await _crmApiProvider.fetchAddLeadResponse(dataMap);
    return response;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// CRM Deals
  Future<Map<String, dynamic>> fetchDealsFromBoard(
      int page, int perPage, String tab) async {
    List<dynamic> dealsList = [];
    Map<String, dynamic> map = {};
    final response =
        await _crmApiProvider.fetchDealsFromBoardResponse(page, perPage, tab);

    if (response != null &&
        response.data != null &&
        (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.notModified)) {
      final results = response.data["results"];
      dynamic mapped = results.map((m) {
        return _crmApiProvider
            .getCurrentParser()
            .parseDealsAndLeadsFromBoard(m);
      });
      dealsList.addAll(mapped.toList());
      map["list"] = dealsList;
      map["status"] = response.data["status"];
      map["actions"] = response.data["actions"];
    } else {
      if (response.statusCode == null) {
        dealsList = [response];
        map["list"] = [response];
        map["status"] = "";
        map["actions"] = "";
      }
    }

    return map;
  }

  Future<Response> fetchAddDealResponse(Map<String, dynamic> dataMap) async {
    final response = await _crmApiProvider.fetchAddDealResponse(dataMap);
    return response;
  }

  Future<Response> fetchDeleteDeal(int id, String nonce) async {
    final response = await _crmApiProvider.fetchDeleteDeal(id, nonce);
    return response;
  }

  Future<Response> fetchUpdateDealDetailResponse(Map<String, dynamic> dataMap) async {
    final response =
    await _crmApiProvider.fetchUpdateDealDetailResponse(dataMap);
    return response;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// Additional Webservices
  Future<Response> fetchAddCRMNotesResponse(Map<String, dynamic> dataMap, String nonce) async {
    final response = await _crmApiProvider.fetchAddCRMNotesResponse(dataMap, nonce);
    return response;
  }

  Future<Response> fetchSendCRMEmailResponse(Map<String, dynamic> dataMap) async {
    final response = await _crmApiProvider.fetchSendCRMEmailResponse(dataMap);
    return response;
  }

  Future<Response> fetchDeleteCRMNotesResponse(Map<String, dynamic> dataMap) async {
    final response = await _crmApiProvider.fetchDeleteCRMNotesResponse(dataMap);
    return response;
  }

  Future<Response> fetchDeleteLead(int id, String nonce) async {
    final response = await _crmApiProvider.fetchDeleteLead(id, nonce);
    return response;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// Houzez webservices
  Future<List<dynamic>> fetchSavedSearch(int page, int perPage,
      {String? leadId, bool fetchLeadSavedSearches = false}) async {
    List<dynamic> savedSearchList = [];
    savedSearchList = await super.fetchSavedSearches(page, perPage,leadId: leadId,fetchLeadSavedSearches: fetchLeadSavedSearches);

    return savedSearchList;
  }

  @override
  Future<List> fetchAllAgentsInfoList(int page, int perPage) async {
    List<dynamic> allAgentsInfo = [];
    allAgentsInfo = await super.fetchAllAgentsInfoList(page, perPage);

    return allAgentsInfo;
  }

  @override
  Future<List> fetchTermData(dynamic termData) async {
    List<dynamic> metaDataList = [];
    metaDataList = await super.fetchTermData(termData);

    return metaDataList;
  }

  /// /////////////////////////////////////////////////////////////////////////
  ///
  ///
  /// CRM Nonce webservices
  Future<ApiResponse> fetchDealDeleteNonceResponse() {
    var response =  _crmApiProvider.fetchDealDeleteNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchLeadDeleteNonceResponse() {
    var response =  _crmApiProvider.fetchLeadDeleteNonceResponse();
    return response;
  }

  Future<ApiResponse> fetchAddNoteNonceResponse() {
    var response =  _crmApiProvider.fetchAddNoteNonceResponse();
    return response;
  }

}
