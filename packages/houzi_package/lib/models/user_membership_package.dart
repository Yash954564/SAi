// To parse this JSON data, do
//
//     final userMembershipPackage = userMembershipPackageFromJson(jsonString);

import 'dart:convert';

UserMembershipPackage userMembershipPackageFromJson(String str) => UserMembershipPackage.fromJson(json.decode(str));

String userMembershipPackageToJson(UserMembershipPackage data) => json.encode(data.toJson());

class UserMembershipPackage {
  bool success;
  String? remainingListings;
  String? packFeaturedRemainingListings;
  String? packageId;
  String? packagesPageLink;
  String? packTitle;
  String? packListings;
  dynamic packUnlimitedListings;
  String? packFeaturedListings;
  String? packBillingPeriod;
  String? packBillingFrequency;
  int? packDate;
  String? expiredDate;

  UserMembershipPackage({
    required this.success,
    required this.remainingListings,
    required this.packFeaturedRemainingListings,
    required this.packageId,
    required this.packagesPageLink,
    required this.packTitle,
    required this.packListings,
    this.packUnlimitedListings,
    required this.packFeaturedListings,
    required this.packBillingPeriod,
    required this.packBillingFrequency,
    required this.packDate,
    required this.expiredDate,
  });

  factory UserMembershipPackage.fromJson(Map<String, dynamic> json) => UserMembershipPackage(
    success: json["success"],
    remainingListings: json["remaining_listings"],
    packFeaturedRemainingListings: json["pack_featured_remaining_listings"],
    packageId: json["package_id"],
    packagesPageLink: json["packages_page_link"],
    packTitle: json["pack_title"],
    packListings: json["pack_listings"],
    packUnlimitedListings: json["pack_unlimited_listings"],
    packFeaturedListings: json["pack_featured_listings"],
    packBillingPeriod: json["pack_billing_period"],
    packBillingFrequency: json["pack_billing_frequency"],
    packDate: json["pack_date"],
    expiredDate: json["expired_date"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "remaining_listings": remainingListings,
    "pack_featured_remaining_listings": packFeaturedRemainingListings,
    "package_id": packageId,
    "packages_page_link": packagesPageLink,
    "pack_title": packTitle,
    "pack_listings": packListings,
    "pack_unlimited_listings": packUnlimitedListings,
    "pack_featured_listings": packFeaturedListings,
    "pack_billing_period": packBillingPeriod,
    "pack_billing_frequency": packBillingFrequency,
    "pack_date": packDate,
    "expired_date": expiredDate,
  };
}
