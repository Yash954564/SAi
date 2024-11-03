import 'dart:convert';

List<PlaceAddress> AddressFromJson(String str) => List<PlaceAddress>.from(json.decode(str).map((x) => PlaceAddress.fromJson(x)));

String AddressToJson(List<PlaceAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaceAddress {
  PlaceAddress({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.plusCode,
    this.types,
  });

  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  PlusCode? plusCode;
  List<String>? types;

  factory PlaceAddress.fromJson(Map<String, dynamic> json) => PlaceAddress(
    addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    placeId: json["place_id"],
    plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
    "formatted_address": formattedAddress,
    "geometry": geometry!.toJson(),
    "place_id": placeId,
    "plus_code": plusCode == null ? null : plusCode!.toJson(),
    "types": List<dynamic>.from(types!.map((x) => x)),
  };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String? longName;
  String? shortName;
  List<String>? types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types!.map((x) => x)),
  };
}

class Geometry {
  Geometry({
    this.location,
    this.locationType,
    this.viewport,
    this.bounds,
  });

  Location? location;
  String? locationType;
  Viewport? viewport;
  Viewport? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    locationType: json["location_type"],
    viewport: Viewport.fromJson(json["viewport"]),
    bounds: json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location!.toJson(),
    "location_type": locationType,
    "viewport": viewport!.toJson(),
    "bounds": bounds == null ? null : bounds!.toJson(),
  };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location? northeast;
  Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast!.toJson(),
    "southwest": southwest!.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double? lat;
  double? lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String? compoundCode;
  String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );

  Map<String, dynamic> toJson() => {
    "compound_code": compoundCode,
    "global_code": globalCode,
  };
}