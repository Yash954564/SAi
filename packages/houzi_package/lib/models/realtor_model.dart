import 'dart:convert';

class Agent{
  int? id;
  String? slug;
  String? type;
  String? title;
  String? content;
  String? totalRating;
  String? thumbnail;
  String? agentPosition;
  String? agentCompany;
  String? agentMobileNumber;
  String? agentOfficeNumber;
  String? agentFaxNumber;
  String? email;
  String? agentAddress;
  String? agentTaxNumber;
  String? agentLicenseNumber;
  String? agentServiceArea;
  String? agentSpecialties;
  List<String>? agentAgencies;
  String? agentLink;
  String? agentWhatsappNumber;
  String? agentPhoneNumber;
  String? agentId;
  String? agentUserName;
  String? userAgentId;
  String? agentFirstName;
  String? agentLastName;
  String? telegram;
  String? lineApp;


  Agent({
    this.id,
    this.slug,
    this.type,
    this.title,
    this.content,
    this.totalRating,
    this.thumbnail,
    this.agentPosition,
    this.agentCompany,
    this.agentMobileNumber,
    this.agentOfficeNumber,
    this.agentFaxNumber,
    this.email,
    this.agentAddress,
    this.agentTaxNumber,
    this.agentLicenseNumber,
    this.agentAgencies,
    this.agentServiceArea,
    this.agentSpecialties,
    this.agentLink,
    this.agentWhatsappNumber,
    this.agentPhoneNumber,
    this.agentId,
    this.agentUserName,
    this.userAgentId,
    this.agentFirstName,
    this.agentLastName,
    this.telegram,
    this.lineApp,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      totalRating: json['totalRating'],
      thumbnail: json['thumbnail'],
      agentPosition: json['agentPosition'],
      agentCompany: json['agentCompany'],
      agentMobileNumber: json['agentMobileNumber'],
      agentOfficeNumber: json['agentOfficeNumber'],
      agentFaxNumber: json['agentFaxNumber'],
      email: json['email'],
      agentAddress: json['agentAddress'],
      agentTaxNumber: json['agentTaxNumber'],
      agentLicenseNumber: json['agentLicenseNumber'],
      agentAgencies: List<String>.from(json['agentAgencies']),
      agentServiceArea: json['agentServiceArea'],
      agentSpecialties: json['agentSpecialties'],
      telegram: json['telegram'],
      lineApp: json['lineApp'],

    );
  }

  static Map<String, dynamic> toMap(Agent agent) => {
    'id': agent.id,
    'slug': agent.slug,
    'type': agent.type,
    'title': agent.title,
    'content': agent.content,
    'totalRating': agent.totalRating,
    'thumbnail': agent.thumbnail,
    'agentPosition': agent.agentPosition,
    'agentCompany': agent.agentCompany,
    'agentMobileNumber': agent.agentMobileNumber,
    'agentOfficeNumber': agent.agentOfficeNumber,
    'agentFaxNumber': agent.agentFaxNumber,
    'email': agent.email,
    'agentAddress': agent.agentAddress,
    'agentTaxNumber': agent.agentTaxNumber,
    'agentLicenseNumber': agent.agentLicenseNumber,
    'agentAgencies': agent.agentAgencies,
    'agentServiceArea': agent.agentServiceArea,
    'agentSpecialties': agent.agentSpecialties,
    'telegram': agent.telegram,
    'lineApp': agent.lineApp,
  };

  static String encode(List<dynamic> agentList) => json.encode(
    agentList.map<Map<String, dynamic>>((item) => Agent.toMap(item)).toList(),
  );

  static List<dynamic> decode(String agentList) =>
      (json.decode(agentList) as List<dynamic>).map<Agent>((item) => Agent.fromJson(item)).toList();
}

class Agency{
  int? id;
  String? slug;
  String? type;
  String? title;
  String? content;
  String? thumbnail;
  String? agencyFaxNumber;
  String? agencyLicenseNumber;
  String? agencyPhoneNumber;
  String? agencyMobileNumber;
  String? email;
  String? agencyAddress;
  String? agencyMapAddress;
  String? agencyLocation;
  String? agencyTaxNumber;
  String? agencyLink;
  String? agencyWhatsappNumber;
  String? totalRating;
  String? telegram;
  String? lineApp;

  Agency({
    this.id,
    this.slug,
    this.type,
    this.title,
    this.content,
    this.thumbnail,
    this.agencyFaxNumber,
    this.agencyLicenseNumber,
    this.agencyPhoneNumber,
    this.agencyMobileNumber,
    this.email,
    this.agencyAddress,
    this.agencyMapAddress,
    this.agencyLocation,
    this.agencyTaxNumber,
    this.agencyLink,
    this.agencyWhatsappNumber,
    this.totalRating,
    this.telegram,
    this.lineApp,
  });


  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      slug: json['slug'],
      type: json['type'],
      title: json['title'],
      content: json['content'],
      thumbnail: json['thumbnail'],
      agencyFaxNumber: json['agencyFaxNumber'],
      agencyLicenseNumber: json['agencyLicenseNumber'],
      agencyMobileNumber: json['agencyMobileNumber'],
      agencyPhoneNumber: json['agencyPhoneNumber'],
      email: json['email'],
      agencyAddress: json['agencyAddress'],
      agencyMapAddress: json['agencyMapAddress'],
      agencyLocation: json['agencyLocation'],
      agencyTaxNumber: json['agencyTaxNumber'],
      telegram: json['telegram'],
      lineApp: json['lineApp'],
    );
  }

  static Map<String, dynamic> toMap(Agency agency) => {
    'id': agency.id,
    'slug': agency.slug,
    'type': agency.type,
    'title': agency.title,
    'content': agency.content,
    'thumbnail': agency.thumbnail,
    'agencyMobileNumber': agency.agencyMobileNumber,
    'agencyPhoneNumber': agency.agencyPhoneNumber,
    'agencyFaxNumber': agency.agencyFaxNumber,
    'email': agency.email,
    'agencyAddress': agency.agencyAddress,
    'agencyTaxNumber': agency.agencyTaxNumber,
    'agencyLicenseNumber': agency.agencyLicenseNumber,
    'agencyMapAddress': agency.agencyMapAddress,
    'agencyLocation': agency.agencyLocation,
    'telegram': agency.telegram,
    'lineApp': agency.lineApp,
  };

  static String encode(List<dynamic> agencyList) => json.encode(
    agencyList.map<Map<String, dynamic>>((item) => Agency.toMap(item)).toList(),
  );

  static List<dynamic> decode(String agencyList) =>
      (json.decode(agencyList) as List<dynamic>).map<Agency>((item) => Agency.fromJson(item)).toList();
}

class Author{
  int? id;
  bool? isSingle;
  String? data;
  String? email;
  String? name;
  String? phone;
  String? phoneCall;
  String? mobile;
  String? mobileCall;
  String? whatsApp;
  String? whatsAppCall;
  String? picture;
  String? link;
  String? type;
  String? telegram;
  String? lineApp;

  Author({
    this.id,
    this.isSingle,
    this.data,
    this.email,
    this.name,
    this.phone,
    this.phoneCall,
    this.mobile,
    this.mobileCall,
    this.whatsApp,
    this.whatsAppCall,
    this.picture,
    this.link,
    this.type,
    this.telegram,
    this.lineApp,
  });
}