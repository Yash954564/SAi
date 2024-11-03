import 'package:houzi_package/common/houzez_api_key_constants.dart';


abstract class DataModelInterface<T> {
  Map<String, dynamic> convertObjectToMap(T value);
}

/// For page packages/houzi_package/lib/pages/send_email_to_realtor.dart
class ContactRealtorRequest implements DataModelInterface<ContactRealtorRequest> {
  String agentId;
  String targetEmail;
  String mobile;
  String name;
  String email;
  String message;
  String userType;
  String agentType;
  String propertyId;
  String listingId;
  String propertyTitle;
  String propertyPermalink;
  String sourceLink;
  String source;

  ContactRealtorRequest({
    required this.agentId,
    required this.targetEmail,
    required this.mobile,
    required this.name,
    required this.email,
    required this.message,
    required this.userType,
    required this.agentType,
    required this.propertyId,
    required this.listingId,
    required this.propertyTitle,
    required this.propertyPermalink,
    required this.sourceLink,
    required this.source,
  });

  Map<String, dynamic> convertObjectToMap(ContactRealtorRequest request) {
    return {
      kContactRealtorAgentId: request.agentId,
      kContactRealtorTargetEmail: request.targetEmail,
      kContactRealtorMobile: request.mobile,
      kContactRealtorName: request.name,
      kContactRealtorEmail: request.email,
      kContactRealtorMessage: request.message,
      kContactRealtorUserType: request.userType,
      kContactRealtorAgentType: request.agentType,
      kContactRealtorPropertyId: request.propertyId,
      kContactRealtorListingId: request.listingId,
      kContactRealtorPropertyTitle: request.propertyTitle,
      kContactRealtorPropertyPermalink: request.propertyPermalink,
      kContactRealtorSourceLink: request.sourceLink,
      kContactRealtorSource: request.source,
    };
  }
}

/// For page packages/houzi_package/lib/pages/home_screen_drawer_menu_pages/my_agency_agents.dart
class AgencyAgentsModel implements DataModelInterface<AgencyAgentsModel> {
  String agentId;

  AgencyAgentsModel({
    required this.agentId,
  });

  Map<String, dynamic> convertObjectToMap(AgencyAgentsModel request) {
    return {
      kDeleteAgentId: request.agentId,
    };
  }
}