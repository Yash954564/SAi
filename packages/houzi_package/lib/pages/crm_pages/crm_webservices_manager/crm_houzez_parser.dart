import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/saved_search.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'crm_interfaces/crm_api_provider_interface.dart';

class CRMHouzezParser implements CRMApiParserInterface {

  @override
  CRMActivity parseActivities(Map<String, dynamic> json) {
    return CRMHouzezParser.parseActivitiesMap(json);
  }

  @override
  CRMInquiries parseInquiries(Map<String, dynamic> json) {
    return CRMHouzezParser.parseInquiriesMap(json);
  }

  @override
  CRMNotes parseInquiryNotes(Map<String, dynamic> json) {
    return CRMHouzezParser.parseInquiryNotesMap(json);
  }

  @override
  CRMLeadsFromActivity parseLeads(Map<String, dynamic> json) {
    return CRMHouzezParser.parseLeadsMap(json);
  }

  @override
  CRMDealsFromActivity parseDeals(Map<String, dynamic> json) {
    return CRMHouzezParser.parseDealsFromActivityMap(json);
  }

  @override
  CRMDealsAndLeads parseDealsAndLeadsFromBoard(Map<String, dynamic> json) {
    return CRMHouzezParser.parseDealsFromBoardMap(json);
  }

  @override
  SavedSearch parseSavedSearch(Map<String, dynamic> json) {
    return CRMHouzezParser.parseSavedSearchMap(json);
  }

  @override
  CRMDealsAndLeadsFromActivity parseDealsAndLeadsFromActivity(Map<String, dynamic> json) {
    return CRMHouzezParser.parseDealsAndLeadsFromActivityMap(json);
  }

  static CRMActivity parseActivitiesMap(Map<String, dynamic> json) {
    int? tempListingId;
    int? reviewId;
    String activityId = "";
    String userId = "";
    String time = "";
    String type = "";
    String subtype = "";
    String name = "";
    String email = "";
    String phone = "";
    String message = "";
    String scheduleTourType = "";
    String scheduleDate = "";
    String scheduleTime = "";
    String title = "";
    String reviewTitle = "";
    String reviewStar = "";
    String reviewPostType = "";
    String reviewContent = "";
    String reviewLink = "";
    String userName = "";
    String leadPageId = "";

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    activityId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "activity_id") ?? "";
    userId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "meta") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      type = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "type") ?? "";
      subtype = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "subtype") ?? "";
      name = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "name") ?? "";
      email = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "email") ?? "";
      phone = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "phone") ?? "";
      message = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "message") ?? "";
      scheduleTourType = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "schedule_tour_type") ?? "";
      scheduleDate = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "schedule_date") ?? "";
      scheduleTime = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "schedule_time") ?? "";
      title = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "title") ?? "";

      tempListingId = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "listing_id");
      reviewId = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "review_id");

      reviewTitle = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "review_title") ?? "";
      reviewStar = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "review_stars") ?? "";
      reviewPostType = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "review_post_type") ?? "";
      reviewContent = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "review_content") ?? "";
      reviewLink = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "review_link") ?? "";
      userName = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "username") ?? "";

      leadPageId = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "lead_page_id") ?? "";
    }

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      time = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return CRMActivity(
      activityId: activityId,
      userId: userId,
      time: time,
      type: type,
      subtype: subtype,
      name: name,
      email: email,
      phone: phone,
      message: message,
      scheduleTourType: scheduleTourType,
      scheduleDate: scheduleDate,
      scheduleTime: scheduleTime,
      title: title,
      listingId: tempListingId,
      reviewPostType: reviewPostType,
      userName: userName,
      reviewContent: reviewContent,
      reviewId: reviewId,
      reviewLink: reviewLink,
      reviewStar: reviewStar,
      reviewTitle: reviewTitle,
      leadPageId: leadPageId,
    );
  }

  static CRMInquiries parseInquiriesMap(Map<String, dynamic> json) {
    String enquiryId = "";
    String userId = "";
    String leadId = "";
    String listingId = "";
    String negotiator = "";
    String source = "";
    String status = "";
    String enquiryTo = "";
    String enquiryUserType = "";
    String message = "";
    String enquiryType = "";
    String privateNote = "";
    String time = "";
    String? displayName = "";
    String minBeds = "";
    String maxBeds = "";
    String minBaths = "";
    String maxBaths = "";
    String minPrice = "";
    String maxPrice = "";
    String minArea = "";
    String maxArea = "";
    String zipcode = "";
    String propertyTypeName = "";
    String propertyTypeSlug = "";
    String countryTypeName = "";
    String countryTypeSlug = "";
    String stateTypeName = "";
    String stateTypeSlug = "";
    String cityTypeName = "";
    String cityTypeSlug = "";
    String areaTypeName = "";
    String areaTypeSlug = "";
    String location = "";
    String leadEmail = "";
    List<dynamic> matchList = [];

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};





    enquiryId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_id") ?? "";
    userId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";
    leadId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "lead_id") ?? "";
    listingId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "listing_id") ?? "";
    negotiator = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "negotiator") ?? "";
    source = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "source") ?? "";
    status = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "status") ?? "";
    enquiryTo = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_to") ?? "";
    enquiryUserType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_user_type") ?? "";
    message = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "message") ?? "";
    enquiryType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_type") ?? "";
    privateNote = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "private_note") ?? "";

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      time = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    displayName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "display_name") ?? "";

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "enquiry_meta") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      minBeds = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "min_beds") ?? "";
      maxBeds = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "max_beds") ?? "";
      minBaths = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "min_baths") ?? "";
      maxBaths = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "max_baths") ?? "";
      minPrice = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "min_price") ?? "";
      maxPrice = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "max_price") ?? "";
      minArea = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "min_area") ?? "";
      maxArea = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "max_area") ?? "";
      zipcode = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "zipcode") ?? "";

      dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: mapDataHolder, key: "property_type") ?? {};
      if(dataHolder.isNotEmpty){
        propertyTypeName = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "name") ?? "";
        propertyTypeSlug = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "slug") ?? "";
      }

      dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: mapDataHolder, key: "country") ?? {};
      if(dataHolder.isNotEmpty){
        countryTypeName = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "name") ?? "";
        countryTypeSlug = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "slug") ?? "";
      }

      dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: mapDataHolder, key: "state") ?? {};
      if(dataHolder.isNotEmpty){
        stateTypeName = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "name") ?? "";
        stateTypeSlug = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "slug") ?? "";
      }

      dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: mapDataHolder, key: "city") ?? {};
      if(dataHolder.isNotEmpty){
        cityTypeName = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "name") ?? "";
        cityTypeSlug = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "slug") ?? "";
      }

      dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: mapDataHolder, key: "area") ?? {};
      if(dataHolder.isNotEmpty){
        areaTypeName = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "name") ?? "";
        areaTypeSlug = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "slug") ?? "";
      }

      location = "$countryTypeName $stateTypeName $cityTypeName $areaTypeName $zipcode";

    }

    // if (json.containsKey("matched")) {
    //   dataHolder = UtilityMethods.getListItemValueFromMap(inputMap: json, key: "matched") ?? [];
    //   if(dataHolder.isNotEmpty && dataHolder[0] is Map){
    //     List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(dataHolder);
    //     matchList = getParsedDataInList(inputList: list, function: parseInquiriesMatchMap);
    //   }
    // }

    CRMDealsAndLeads leads = parseDealsFromBoardMap(json);
   

    // dataHolder = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "lead") ?? {};
    // dataHolder = UtilityMethods.convertMap(dataHolder);
    // leadEmail = UtilityMethods.getStringItemValueFromMap(inputMap: dataHolder, key: "email") ?? "";

    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return CRMInquiries(
      enquiryId: enquiryId,
      userId: userId,
      leadId: leadId,
      listingId: listingId,
      negotiator: negotiator,
      source: source,
      status: status,
      enquiryTo: enquiryTo,
      enquiryUserType: enquiryUserType,
      message: message,
      enquiryType: enquiryType,
      privateNote: privateNote,
      time: time,
      minBeds: minBeds,
      maxBeds: maxBeds,
      minBaths: minBaths,
      maxBaths: maxBaths,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minArea: minArea,
      maxArea: maxArea,
      zipcode: zipcode,
      propertyTypeName: propertyTypeName,
      propertyTypeSlug: propertyTypeSlug,
      countryTypeName: countryTypeName,
      countryTypeSlug: countryTypeSlug,
      stateTypeName: stateTypeName,
      stateTypeSlug: stateTypeSlug,
      cityTypeName: cityTypeName,
      cityTypeSlug: cityTypeSlug,
      areaTypeName: areaTypeName,
      areaTypeSlug: areaTypeSlug,
      displayName: displayName,
      location: location,
      leads: leads
    );
  }

  static CRMNotes parseInquiryNotesMap(Map<String, dynamic> json) {
    String noteId  = "";
    String userId = "";
    String belongTo = "";
    String note = "";
    String type = "";
    String time = "";
    
    dynamic dataHolder;

    noteId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "note_id") ?? "";
    userId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";
    belongTo = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "belong_to") ?? "";
    note = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "note") ?? "";
    type = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "type") ?? "";

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      time = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;

    return CRMNotes(
      belongTo: belongTo,
      note: note,
      noteId: noteId,
      time: time,
      type: type,
      userId: userId
    );
  }

  static CRMLeadsFromActivity parseLeadsMap(Map<String, dynamic> json) {
    String totalRecords = "";
    int? itemsPerPage;
    int? page;
    int? lastDay;
    int? lastTwo;
    int? lastWeek;
    int? last2Week;
    int? lastMonth;
    int? last2Month;

    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    totalRecords = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "total_records") ?? "";

    itemsPerPage = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "items_per_page");
    page = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "page");

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "stats") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      lastDay = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastday");
      lastTwo = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lasttwo");
      lastWeek = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastweek");
      last2Week = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "last2week");
      lastMonth = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastmonth");
      last2Month = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "last2month");
    }

    // Dis-allocating the variables
    mapDataHolder = {};
    tempMap = {};

    return CRMLeadsFromActivity(
      totalRecords: totalRecords,
      itemsPerPage: itemsPerPage,
      page: page,
      lastDay: lastDay,
      lastTwo: lastTwo,
      lastWeek: lastWeek,
      last2Week: last2Week,
      lastMonth: lastMonth,
      last2Month: last2Month,
    );
  }

  static CRMDealsFromActivity parseDealsFromActivityMap(Map<String, dynamic> json) {
    String activeCount = "";
    String wonCount = "";
    String lostCount = "";

    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "deals") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      activeCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "active_count") ?? "";
      wonCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "won_count") ?? "";
      lostCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "lost_count") ?? "";
    }

    // Dis-allocating the variables
    mapDataHolder = {};
    tempMap = {};

    return CRMDealsFromActivity(
      lostCount : lostCount,
      wonCount :wonCount,
      activeCount:activeCount,
    );
  }

  static CRMDealsAndLeads parseDealsFromBoardMap(Map<String, dynamic> json) {
    String dealId = "";
    String userId = "";
    String title = "";
    String listingId = "";
    String resultLeadId = "";
    String agentId = "";
    String agentType = "";
    String leadStatus = "";
    String nextAction = "";
    String actionDueDate = "";
    String dealValue = "";
    String lastContactDate = "";
    String resultPrivateNote = "";
    String dealGroup = "";
    String resultTime = "";
    String agentName = "";
    String leadLeadId = "";
    String leadUserId = "";
    String prefix = "";
    String displayName = "";
    String firstName = "";
    String lastName = "";
    String email = "";
    String mobile = "";
    String homePhone = "";
    String workPhone = "";
    String address = "";
    String city = "";
    String state = "";
    String country = "";
    String zipcode = "";
    String type = "";
    String resultStatus = "";
    String source = "";
    String sourceLink = "";
    String enquiryTo = "";
    String enquiryUserType = "";
    String twitterUrl = "";
    String linkedinUrl = "";
    String facebookUrl = "";
    String leadPrivateNote = "";
    String message = "";
    String leadTime = "";
    String leadAgentName = "";
    String leadAgentEmail = "";

    dynamic dataHolder;
    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    dealId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "deal_id") ?? "";
    userId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";
    title = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "title") ?? "";
    listingId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "listing_id") ?? "";
    resultLeadId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "lead_id") ?? "";
    agentId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "agent_id") ?? "";
    agentType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "agent_type") ?? "";
    resultStatus = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "status") ?? "";
    nextAction = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "next_action") ?? "";
    actionDueDate = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "action_due_date") ?? "";
    dealValue = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "deal_value") ?? "";
    lastContactDate = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "last_contact_date") ?? "";
    resultPrivateNote = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "private_note") ?? "";
    dealGroup = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "deal_group") ?? "";
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      resultTime = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    agentName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "agent_name") ?? "";

    leadLeadId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "lead_id") ?? "";
    leadUserId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "user_id") ?? "";
    prefix = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "prefix") ?? "";
    displayName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "display_name") ?? "";
    firstName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "first_name") ?? "";
    lastName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "last_name") ?? "";
    email = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "email") ?? "";
    mobile = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "mobile") ?? "";
    homePhone = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "home_phone") ?? "";
    workPhone = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "work_phone") ?? "";
    address = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "address") ?? "";
    city = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "city") ?? "";
    state = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "state") ?? "";
    country = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "country") ?? "";
    zipcode = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "zipcode") ?? "";
    type = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "type") ?? "";
    leadStatus = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "status") ?? "";
    source = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "source") ?? "";
    sourceLink = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "source_link") ?? "";
    enquiryTo = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_to") ?? "";
    enquiryUserType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "enquiry_user_type") ?? "";
    twitterUrl = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "twitter_url") ?? "";
    linkedinUrl = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "linkedin_url") ?? "";
    facebookUrl = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "facebook_url") ?? "";
    leadPrivateNote = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "private_note") ?? "";
    message = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "message") ?? "";

    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      leadTime = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "agent_info") ?? {};
    mapDataHolder = UtilityMethods.convertMap(tempMap);
    leadAgentName = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "name") ?? "";
    leadAgentEmail = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "email") ?? "";

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "lead") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      leadLeadId = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "lead_id") ?? "";
      leadUserId = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "user_id") ?? "";
      prefix = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "prefix") ?? "";
      displayName = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "display_name") ?? "";
      firstName = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "first_name") ?? "";
      lastName = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "last_name") ?? "";
      email = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "email") ?? "";
      mobile = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "mobile") ?? "";
      homePhone = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "home_phone") ?? "";
      workPhone = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "work_phone") ?? "";
      address = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "address") ?? "";
      city = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "city") ?? "";
      state = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "state") ?? "";
      country = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "country") ?? "";
      zipcode = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "zipcode") ?? "";
      type = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "type") ?? "";
      leadStatus = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "status") ?? "";
      source = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "source") ?? "";
      sourceLink = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "source_link") ?? "";
      enquiryTo = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "enquiry_to") ?? "";
      enquiryUserType = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "enquiry_user_type") ?? "";
      twitterUrl = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "twitter_url") ?? "";
      linkedinUrl = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "linkedin_url") ?? "";
      facebookUrl = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "facebook_url") ?? "";
      leadPrivateNote = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "private_note") ?? "";
      message = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "message") ?? "";
      dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "time") ?? "";
      if(dataHolder.isNotEmpty){
        leadTime = UtilityMethods.getTimeAgoFormat(time: dataHolder);
      }

    }



    // Dis-allocating the variables
    dataHolder = null;
    mapDataHolder = {};
    tempMap = {};

    return CRMDealsAndLeads(
        dealId: dealId,
        userId: userId,
        title: title,
        listingId: listingId,
        resultLeadId: resultLeadId,
        agentId: agentId,
        agentType: agentType,
        leadStatus: leadStatus,
        nextAction: nextAction,
        actionDueDate: actionDueDate,
        dealValue: dealValue,
        lastContactDate: lastContactDate,
        resultPrivateNote: resultPrivateNote,
        dealGroup: dealGroup,
        resultTime: resultTime,
        agentName: agentName,
        leadLeadId: leadLeadId,
        leadUserId: leadUserId,
        prefix: prefix,
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        email: email,
        mobile: mobile,
        homePhone: homePhone,
        workPhone: workPhone,
        address: address,
        city: city,
        state: state,
        country: country,
        zipcode: zipcode,
        type: type,
        resultStatus: resultStatus,
        source: source,
        sourceLink: sourceLink,
        enquiryTo: enquiryTo,
        enquiryUserType: enquiryUserType,
        twitterUrl: twitterUrl,
        linkedinUrl: linkedinUrl,
        facebookUrl: facebookUrl,
        leadPrivateNote: leadPrivateNote,
        message: message,
        leadTime: leadTime,
        leadAgentName: leadAgentName,
        leadAgentEmail: leadAgentEmail,
    );
  }

  static CRMMatched parseInquiriesMatchMap(Map<String, dynamic> json) {
    int? matchedId;
    int? postParent;
    int? menuOrder;
    
    String postAuthor = "";
    String postDate = "";
    String postDateGmt = "";
    String postContent = "";
    String postTitle = "";
    String postExcerpt = "";
    String postStatus = "";
    String commentStatus = "";
    String pingStatus = "";
    String postPassword = "";
    String postName = "";
    String toPing = "";
    String pinged = "";
    String postModified = "";
    String postModifiedGmt = "";
    String postContentFiltered = "";
    String guid = "";
    String postType = "";
    String postMimeType = "";
    String commentCount = "";
    String filter = "";

    matchedId = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "ID");
    postParent = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "post_parent");
    menuOrder = UtilityMethods.getIntegerItemValueFromMap(inputMap: json, key: "menu_order");

    postAuthor = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_author") ?? "";
    postDate = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_date") ?? "";
    postDateGmt = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_date_gmt") ?? "";
    postContent = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_content") ?? "";
    postTitle = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_title") ?? "";
    postExcerpt = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_excerpt") ?? "";
    postStatus = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_status") ?? "";
    commentStatus = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "comment_status") ?? "";
    pingStatus = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "ping_status") ?? "";
    postPassword = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_password") ?? "";
    postName = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_name") ?? "";
    toPing = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "to_ping") ?? "";
    pinged = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "pinged") ?? "";
    postModified = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_modified") ?? "";
    postModifiedGmt = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_modified_gmt") ?? "";
    postContentFiltered = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_content_filtered") ?? "";
    guid = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "guid") ?? "";
    postType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_type") ?? "";
    postMimeType = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "post_mime_type") ?? "";
    commentCount = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "comment_count") ?? "";
    filter = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "filter") ?? "";

    CRMMatched matched = CRMMatched(
      matchedId: matchedId,
      commentCount: commentCount,
      commentStatus: commentStatus,
      filter: filter,
      guid: guid,
      menuOrder: menuOrder,
      pinged: pinged,
      pingStatus: pingStatus,
      postAuthor: postAuthor,
      postContent: postContent,
      postContentFiltered: postContentFiltered,
      postDate: postDate,
      postDateGmt: postDateGmt,
      postExcerpt: postExcerpt,
      postMimeType: postMimeType,
      postModified: postModified,
      postModifiedGmt: postModifiedGmt,
      postName: postName,
      postParent: postParent,
      postPassword: postPassword,
      postStatus: postStatus,
      postTitle: postTitle,
      postType: postType,
      toPing: toPing,
    );

    return matched;
  }

  static SavedSearch parseSavedSearchMap(Map<String, dynamic> json) {
    String id = "";
    String autherId = "";
    String query = "";
    String email = "";
    String url = "";
    String time = "";

    dynamic dataHolder;

    id = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "id") ?? "";
    autherId = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "auther_id") ?? "";
    query = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "query") ?? "";
    email = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "email") ?? "";
    url = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "url") ?? "";
    dataHolder = UtilityMethods.getStringItemValueFromMap(inputMap: json, key: "time") ?? "";
    if(dataHolder.isNotEmpty){
      time = UtilityMethods.getTimeAgoFormat(time: dataHolder);
    }

    // Dis-allocating the variables
    dataHolder = null;

    return SavedSearch(
      id: id,
      autherId: autherId,
      email: email,
      query: query,
      time: time,
      url: url,
    );
  }

  static CRMDealsAndLeadsFromActivity parseDealsAndLeadsFromActivityMap(Map<String, dynamic> json) {

    String activeCount = "";
    String wonCount = "";
    String lostCount = "";

    int? lastDay;
    int? lastTwo;
    int? lastWeek;
    int? last2Week;
    int? lastMonth;
    int? last2Month;

    Map<String, dynamic> mapDataHolder = {};
    Map tempMap = {};

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "deals") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      activeCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "active_count") ?? "";
      wonCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "won_count") ?? "";
      lostCount = UtilityMethods.getStringItemValueFromMap(inputMap: mapDataHolder, key: "lost_count") ?? "";
    }

    tempMap = UtilityMethods.getMapItemValueFromMap(inputMap: json, key: "stats") ?? {};
    if(tempMap.isNotEmpty) {
      mapDataHolder = UtilityMethods.convertMap(tempMap);

      lastDay = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastday");
      lastTwo = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lasttwo");
      lastWeek = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastweek");
      last2Week = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "last2week");
      lastMonth = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "lastmonth");
      last2Month = UtilityMethods.getIntegerItemValueFromMap(inputMap: mapDataHolder, key: "last2month");
    }

    // Dis-allocating the variables
    mapDataHolder = {};
    tempMap = {};

    return CRMDealsAndLeadsFromActivity(
      activeCount: activeCount,
      wonCount: wonCount,
      lostCount: lostCount,
      lastDay: lastDay,
      lastTwo: lastTwo,
      lastWeek: lastWeek,
      last2Week: last2Week,
      lastMonth: lastMonth,
      last2Month: last2Month,
    );
  }

  static List<dynamic> getParsedDataInList({required List<dynamic> inputList, required Function(Map<String, dynamic>) function}){
    List<dynamic> outputList = inputList.map((item) => function(item)).toList();
    return outputList;
  }
}
