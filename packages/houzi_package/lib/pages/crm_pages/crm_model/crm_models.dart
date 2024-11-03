class CRMActivity {
  String? activityId;
  String? userId;
  String? time;
  String? type;
  String? subtype;
  String? name;
  String? email;
  String? phone;
  String? message;
  String? scheduleTourType;
  String? scheduleDate;
  String? scheduleTime;
  String? title;
  int? listingId;
  String? reviewTitle;
  int? reviewId;
  String? reviewStar;
  String? reviewPostType;
  String? reviewContent;
  String? reviewLink;
  String? userName;
  String? leadPageId;

  CRMActivity({
    this.activityId,
    this.userId,
    this.time,
    this.type,
    this.subtype,
    this.name,
    this.email,
    this.phone,
    this.message,
    this.scheduleTourType,
    this.scheduleDate,
    this.scheduleTime,
    this.title,
    this.listingId,
    this.reviewPostType,
    this.userName,
    this.reviewContent,
    this.reviewId,
    this.reviewLink,
    this.reviewStar,
    this.reviewTitle,
    this.leadPageId,
  });
}

class CRMLeadsFromActivity {
  var totalRecords;
  var itemsPerPage;
  var page;
  var lastDay;
  var lastTwo;
  var lastWeek;
  var last2Week;
  var lastMonth;
  var last2Month;

  CRMLeadsFromActivity({
    this.totalRecords,
    this.itemsPerPage,
    this.page,
    this.lastDay,
    this.lastTwo,
    this.lastWeek,
    this.last2Week,
    this.lastMonth,
    this.last2Month,
  });
}

class CRMDealsFromActivity {
  String? activeCount = "";
  String? wonCount = "";
  String? lostCount = "";

  CRMDealsFromActivity({
    this.activeCount,
    this.wonCount,
    this.lostCount,
  });
}

class CRMDealsAndLeadsFromActivity {
  String? activeCount = "";
  String? wonCount = "";
  String? lostCount = "";
  var lastDay;
  var lastTwo;
  var lastWeek;
  var last2Week;
  var lastMonth;
  var last2Month;

  CRMDealsAndLeadsFromActivity({
    this.activeCount,
    this.wonCount,
    this.lostCount,
    this.lastDay,
    this.lastTwo,
    this.lastWeek,
    this.last2Week,
    this.lastMonth,
    this.last2Month,
  });
}

class CRMInquiries {
  String? enquiryId;

  CRMInquiries(
      {this.enquiryId,
      this.userId,
      this.leadId,
      this.listingId,
      this.negotiator,
      this.source,
      this.status,
      this.enquiryTo,
      this.enquiryUserType,
      this.message,
      this.enquiryType,
      this.privateNote,
      this.time,
      this.displayName,
      this.minBeds,
      this.maxBeds,
      this.minBaths,
      this.maxBaths,
      this.minPrice,
      this.maxPrice,
      this.minArea,
      this.maxArea,
      this.zipcode,
      this.propertyTypeName,
      this.propertyTypeSlug,
      this.countryTypeName,
      this.countryTypeSlug,
      this.stateTypeName,
      this.stateTypeSlug,
      this.cityTypeName,
      this.cityTypeSlug,
      this.areaTypeName,
      this.areaTypeSlug,
      this.location,
      this.leads});

  String? userId;
  String? leadId;
  String? listingId;
  String? negotiator;
  String? source;
  String? status;
  String? enquiryTo;
  String? enquiryUserType;
  String? message;
  String? enquiryType;
  String? privateNote;
  String? time;
  String? displayName;
  String? minBeds;
  String? maxBeds;
  String? minBaths;
  String? maxBaths;
  String? minPrice;
  String? maxPrice;
  String? minArea;
  String? maxArea;
  String? zipcode;
  String? propertyTypeName;
  String? propertyTypeSlug;
  String? countryTypeName;
  String? countryTypeSlug;
  String? stateTypeName;
  String? stateTypeSlug;
  String? cityTypeName;
  String? cityTypeSlug;
  String? areaTypeName;
  String? areaTypeSlug;
  String? location;
  CRMDealsAndLeads? leads;
}

class CRMNotes {
  CRMNotes({
    this.noteId,
    this.userId,
    this.belongTo,
    this.note,
    this.type,
    this.time,
  });

  String? noteId;
  String? userId;
  String? belongTo;
  String? note;
  String? type;
  String? time;

// factory EnquiryNotes.fromJson(Map<String, dynamic> json) => EnquiryNotes(
//   noteId: json["note_id"],
//   userId: json["user_id"],
//   belongTo: json["belong_to"],
//   note: json["note"],
//   type: json["type"],
//   time: DateTime.parse(json["time"]),
// );
//
// Map<String, dynamic> toJson() => {
//   "note_id": noteId,
//   "user_id": userId,
//   "belong_to": belongTo,
//   "note": note,
//   "type": type,
//   "time": time.toIso8601String(),
// };
}

class CRMMatched {
  CRMMatched({
    this.matchedId,
    this.postAuthor,
    this.postDate,
    this.postDateGmt,
    this.postContent,
    this.postTitle,
    this.postExcerpt,
    this.postStatus,
    this.commentStatus,
    this.pingStatus,
    this.postPassword,
    this.postName,
    this.toPing,
    this.pinged,
    this.postModified,
    this.postModifiedGmt,
    this.postContentFiltered,
    this.postParent,
    this.guid,
    this.menuOrder,
    this.postType,
    this.postMimeType,
    this.commentCount,
    this.filter,
  });

  int? matchedId;
  String? postAuthor;
  String? postDate;
  String? postDateGmt;
  String? postContent;
  String? postTitle;
  String? postExcerpt;
  String? postStatus;
  String? commentStatus;
  String? pingStatus;
  String? postPassword;
  String? postName;
  String? toPing;
  String? pinged;
  String? postModified;
  String? postModifiedGmt;
  String? postContentFiltered;
  int? postParent;
  String? guid;
  int? menuOrder;
  String? postType;
  String? postMimeType;
  String? commentCount;
  String? filter;
}

class CRMDealsAndLeads {
  String? totalRecords;
  int? itemsPerPage;
  int? page;
  String? resultStatus;
  String? actions;
  String? activeCount;
  String? wonCount;
  String? lostCount;
  String? dealId;
  String? userId;
  String? title;
  String? listingId;
  String? resultLeadId;
  String? agentId;
  String? agentType;
  String? leadStatus;
  String? nextAction;
  String? actionDueDate;
  String? dealValue;
  String? lastContactDate;
  String? resultPrivateNote;
  String? dealGroup;
  String? resultTime;
  String? agentName;
  String? leadLeadId;
  String? leadUserId;
  String? prefix;
  String? displayName;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? homePhone;
  String? workPhone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? type;
  String? status;
  String? source;
  String? sourceLink;
  String? enquiryTo;
  String? enquiryUserType;
  String? twitterUrl;
  String? linkedinUrl;
  String? facebookUrl;
  String? leadPrivateNote;
  String? message;
  String? leadTime;
  String? leadAgentName;
  String? leadAgentEmail;

  CRMDealsAndLeads({
    this.totalRecords,
    this.itemsPerPage,
    this.page,
    this.resultStatus,
    this.actions,
    this.activeCount,
    this.wonCount,
    this.lostCount,
    this.dealId,
    this.userId,
    this.title,
    this.listingId,
    this.resultLeadId,
    this.agentId,
    this.agentType,
    this.leadStatus,
    this.nextAction,
    this.actionDueDate,
    this.dealValue,
    this.lastContactDate,
    this.resultPrivateNote,
    this.dealGroup,
    this.resultTime,
    this.agentName,
    this.leadLeadId,
    this.leadUserId,
    this.prefix,
    this.displayName,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.homePhone,
    this.workPhone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
    this.type,
    this.status,
    this.source,
    this.sourceLink,
    this.enquiryTo,
    this.enquiryUserType,
    this.twitterUrl,
    this.linkedinUrl,
    this.facebookUrl,
    this.leadPrivateNote,
    this.message,
    this.leadTime,
    this.leadAgentName,
    this.leadAgentEmail,
  });
}
