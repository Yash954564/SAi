import 'dart:convert';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo_locator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houzi_package/bloc/api_providers/place_api_provider.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/address.dart';
import 'package:houzi_package/models/address_search.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:uuid/uuid.dart';


typedef PropertyAddressPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyAddressPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PropertyAddressPageState();

  final PropertyAddressPageListener? propertyAddressPageListener;
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;

  PropertyAddressPage({
    this.formKey,
    this.propertyInfoMap,
    this.propertyAddressPageListener,
  });

}

class PropertyAddressPageState extends State<PropertyAddressPage>{

  Map<String, dynamic> dataMap = {};

  final _addressTextController = TextEditingController();
  final _addressCountryTextController = TextEditingController();
  final _addressCityTextController = TextEditingController();
  final _addressZipOrPostalCodeTextController = TextEditingController();
  final _addressStateTextController = TextEditingController();
  final _addressAreaTextController = TextEditingController();

  @override
  void initState() {
    Map? tempMap = widget.propertyInfoMap;
    if (tempMap != null) {
      if (tempMap.containsKey(ADD_PROPERTY_MAP_ADDRESS)){
        _addressTextController.text = tempMap[ADD_PROPERTY_MAP_ADDRESS] ?? "";
      }

      if (tempMap.containsKey(ADD_PROPERTY_COUNTRY) && tempMap[ADD_PROPERTY_COUNTRY] != null) {
        _addressCountryTextController.text = tempMap[ADD_PROPERTY_COUNTRY];
      }

      if (tempMap.containsKey(ADD_PROPERTY_CITY) && tempMap[ADD_PROPERTY_CITY] != null) {
        _addressCityTextController.text = tempMap[ADD_PROPERTY_CITY];
      }

      if (tempMap.containsKey(ADD_PROPERTY_POSTAL_CODE) && tempMap[ADD_PROPERTY_POSTAL_CODE] != null) {
        _addressZipOrPostalCodeTextController.text = tempMap[ADD_PROPERTY_POSTAL_CODE];
      }

      if (tempMap.containsKey(ADD_PROPERTY_STATE_OR_COUNTY) && tempMap[ADD_PROPERTY_STATE_OR_COUNTY] != null) {
        _addressStateTextController.text = tempMap[ADD_PROPERTY_STATE_OR_COUNTY];
      }

      if (tempMap.containsKey(ADD_PROPERTY_AREA) && tempMap[ADD_PROPERTY_AREA] != null) {
        _addressAreaTextController.text = tempMap[ADD_PROPERTY_AREA];
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _addressTextController.dispose();
    _addressCountryTextController.dispose();
    _addressCityTextController.dispose();
    _addressZipOrPostalCodeTextController.dispose();
    _addressStateTextController.dispose();
    _addressAreaTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            CardWidget(
              child: Column(
                children: [
                  LocationFromMapWidget(
                    padding: const EdgeInsets.only(bottom: 30),
                    propertyInfoMap: widget.propertyInfoMap,
                    listener: ({currentPosition, dataInfoMap}) {
                      if (currentPosition != null) {
                        updateFormFields(currentPosition);
                      }

                      if (dataInfoMap != null) {
                        dataMap.addAll(dataInfoMap);
                        widget.propertyAddressPageListener!(dataMap);
                      }
                    },
                  ),
                ],
              ),
            ),

            CardWidget(
              child: Column(
                children: [
                  locationTextWidget(),
                  addPropertyAddress(),
                  addPropertyCountry(),
                  addPropertyStateOrCounty(),
                  addPropertyCity(),
                  addPropertyArea(),
                  addPropertyZipOrPostalCode(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationTextWidget() {
    return PropertyAddressHeaderWidget(text: UtilityMethods.getLocalizedString("location"));
  }

  Widget addPropertyAddress() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("address")+" *",
        hintText: UtilityMethods.getLocalizedString("enter_your_property_address"),
        controller: _addressTextController,
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_MAP_ADDRESS]  = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyCountry() {
    return !SHOW_COUNTRY_NAME_FIELD ? Container() : Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("country"),
        hintText: UtilityMethods.getLocalizedString("enter_the_country"),
        controller: _addressCountryTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_COUNTRY]  = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyStateOrCounty() {
    return !SHOW_STATE_COUNTY_FIELD ? Container() : Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("states"),
        hintText: UtilityMethods.getLocalizedString("enter_the_states"),
        controller: _addressStateTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_STATE_OR_COUNTY]  = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyCity() {
    return !SHOW_LOCALITY_FIELD ? Container() : Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("city"),
        hintText: UtilityMethods.getLocalizedString("enter_the_city"),
        controller: _addressCityTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_CITY]  = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyArea() {
    return !SHOW_NEIGHBOURHOOD_FIELD
        ? Container()
        : Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("area"),
        hintText: UtilityMethods.getLocalizedString("enter_the_area"),
        controller: _addressAreaTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_AREA] = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  Widget addPropertyZipOrPostalCode() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("zip_code"),
        hintText: UtilityMethods.getLocalizedString("enter_the_zip_code"),
        controller: _addressZipOrPostalCodeTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if (mounted) {
              setState(() {
                dataMap[ADD_PROPERTY_POSTAL_CODE]  = value;
              });
            }
            widget.propertyAddressPageListener!(dataMap);
          }
          return null;
        },
      ),
    );
  }

  updateFormFields(LatLng? location) async {
    if (location != null) {
      String cordLoc =  location.latitude.toString() + "," + location.longitude.toString();
      // print("location: $cordLoc");

      Map placeMap = {};
      List<PlaceAddress>? addressDataList = [];
      PlaceAddress addressItem;

      var response = await PlaceApiProvider.getPlaceGeocodeDetailsFromCoordinates(cordLoc);
      Map? tempMap = response.data;

      if (tempMap != null && tempMap.isNotEmpty &&
          tempMap.containsKey("results") && tempMap["results"] != null) {

        addressDataList = AddressFromJson(jsonEncode(tempMap["results"]));
        if (addressDataList.isNotEmpty) {
          addressItem = addressDataList[0];
          List<dynamic>? addressComponentsList = addressItem.addressComponents;
          if (addressComponentsList != null && addressComponentsList.isNotEmpty) {
            for(var item in addressComponentsList) {
              var addressComponentsItem = item.types[0];
              // print("${item.types[0]}: ${item.longName}");

              if (addressComponentsItem == "country") {
                placeMap[ADD_PROPERTY_COUNTRY] = "${item.longName}";
              }
              if (addressComponentsItem == "administrative_area_level_1") {
                placeMap[ADD_PROPERTY_STATE_OR_COUNTY] = "${item.longName}";
              }
              if (addressComponentsItem == "locality") {
                placeMap[ADD_PROPERTY_CITY] = "${item.longName}";
              }
              if (addressComponentsItem == "neighborhood") {
                placeMap[ADD_PROPERTY_AREA] = "${item.longName}";
              }
              if (addressComponentsItem == "postal_code") {
                placeMap[ADD_PROPERTY_POSTAL_CODE] = "${item.longName}";
              }
            }
          }

          placeMap[ADD_PROPERTY_MAP_ADDRESS] = addressItem.formattedAddress;
          // print("addressComponents: ${addressItem.addressComponents}");
          // print("formattedAddress: ${addressItem.formattedAddress}");
        }
      }

      // print("placeMap: $placeMap");

      if (mounted) {
        setState(() {
          _addressTextController.text = '';
          _addressCountryTextController.text = '';
          _addressStateTextController.text = '';
          _addressCityTextController.text = '';
          _addressZipOrPostalCodeTextController.text = '';
          _addressAreaTextController.text = '';

          if (placeMap.containsKey(ADD_PROPERTY_MAP_ADDRESS) &&
              placeMap[ADD_PROPERTY_MAP_ADDRESS] != null &&
              placeMap[ADD_PROPERTY_MAP_ADDRESS].isNotEmpty) {
            _addressTextController.text = placeMap[ADD_PROPERTY_MAP_ADDRESS];
          }
          if (placeMap.containsKey(ADD_PROPERTY_COUNTRY) &&
              placeMap[ADD_PROPERTY_COUNTRY] != null &&
              placeMap[ADD_PROPERTY_COUNTRY].isNotEmpty) {
            _addressCountryTextController.text = placeMap[ADD_PROPERTY_COUNTRY];
          }
          if (placeMap.containsKey(ADD_PROPERTY_STATE_OR_COUNTY) &&
              placeMap[ADD_PROPERTY_STATE_OR_COUNTY] != null &&
              placeMap[ADD_PROPERTY_STATE_OR_COUNTY].isNotEmpty) {
            _addressStateTextController.text = placeMap[ADD_PROPERTY_STATE_OR_COUNTY];
          }
          if (placeMap.containsKey(ADD_PROPERTY_CITY) &&
              placeMap[ADD_PROPERTY_CITY] != null &&
              placeMap[ADD_PROPERTY_CITY].isNotEmpty) {
            _addressCityTextController.text = placeMap[ADD_PROPERTY_CITY];
          }
          if (placeMap.containsKey(ADD_PROPERTY_POSTAL_CODE) &&
              placeMap[ADD_PROPERTY_POSTAL_CODE] != null &&
              placeMap[ADD_PROPERTY_POSTAL_CODE].isNotEmpty) {
            _addressZipOrPostalCodeTextController.text = placeMap[ADD_PROPERTY_POSTAL_CODE];
          }
          if (placeMap.containsKey(ADD_PROPERTY_AREA) &&
              placeMap[ADD_PROPERTY_AREA] != null &&
              placeMap[ADD_PROPERTY_AREA].isNotEmpty) {
            _addressAreaTextController.text = placeMap[ADD_PROPERTY_AREA];
          }
        });
      }
    }
  }
}

class PropertyAddressHeaderWidget extends StatelessWidget {
  final String text;

  const PropertyAddressHeaderWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      text: text,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }
}


typedef LocationFromMapWidgetListener = void Function({
  LatLng? currentPosition,
  Map<String, dynamic>? dataInfoMap,
});

class LocationFromMapWidget extends StatefulWidget {

  final Map<String, dynamic>? propertyInfoMap;
  final EdgeInsetsGeometry? padding;
  final LocationFromMapWidgetListener listener;

  const LocationFromMapWidget({
    Key? key,
    this.propertyInfoMap,
    this.padding,
    required this.listener,
  }) : super(key: key);

  @override
  State<LocationFromMapWidget> createState() => _LocationFromMapWidgetState();
}

class _LocationFromMapWidgetState extends State<LocationFromMapWidget> {

  double mapZoom = 12.0;
  double mapWidgetHeight = 300;
  bool permissionGranted = false;

  String currentPositionLink = "";

  Map<String, dynamic> dataMap = {};

  LatLng? _initialPosition;
  LatLng? currentPosition;
  LatLng defaultLocation = const LatLng(37.4219999, -122.0862462);

  final TextEditingController _addressLatitudeTextController = TextEditingController();
  final TextEditingController _addressLongitudeTextController = TextEditingController();
  final TextEditingController _searchResultController = TextEditingController();

  @override
  void initState() {
    // _checkPermission();

    // _getUserLocation();



    double? latitude;
    double? longitude;
    Map? tempMap = widget.propertyInfoMap;

    if (tempMap != null) {
      if (tempMap.containsKey(ADD_PROPERTY_LATITUDE) && tempMap[ADD_PROPERTY_LATITUDE] != null) {
        var lat = tempMap[ADD_PROPERTY_LATITUDE].toString();
        latitude = double.tryParse(lat);
        _addressLatitudeTextController.text = lat;
      }

      if (tempMap.containsKey(ADD_PROPERTY_LONGITUDE) && tempMap[ADD_PROPERTY_LONGITUDE] != null) {
        var lng = tempMap[ADD_PROPERTY_LONGITUDE].toString();
        longitude = double.tryParse(lng);
        _addressLongitudeTextController.text = lng;
      }

      if (latitude != null && longitude != null) {
        _initialPosition = LatLng(latitude, longitude);
      }
    }

    if (latitude == null || longitude == null) {
      // print("_tempMapInfoMap is Empty............................");
      _getUserLocation();
    }

    super.initState();
  }

  @override
  void didChangeDependencies () {
    if (mounted) {
      if (currentPosition != null) {
        setState(() {
          currentPositionLink = getStaticMapURLOfPosition(currentPosition!);
          widget.listener(currentPosition: currentPosition);
        });
      } else if (_initialPosition != null) {
        setState(() {
          currentPositionLink = getStaticMapURLOfPosition(_initialPosition!);
          widget.listener(currentPosition: currentPosition);
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    dataMap = {};
    _initialPosition = null;
    currentPosition = null;
    currentPositionLink = "";
    _searchResultController.dispose();
    _addressLatitudeTextController.dispose();
    _addressLongitudeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        children: [
          googlePlaceSearchWidget(),
          mapRelatedTextWidget(),
          _getPropertyAddressFromMap(),
          addLatitude(),
          addLongitude(),
        ],
      ),
    );
  }

  Widget addLatitude() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("latitude"),
        hintText: UtilityMethods.getLocalizedString("enter_address_latitude"),
        controller: _addressLatitudeTextController,
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value != null) {
            // if (mounted) {
            //   setState(() {
            //     dataMap[ADD_PROPERTY_LATITUDE]  = value;
            //   });
            // }
            dataMap[ADD_PROPERTY_LATITUDE]  = value;
            widget.listener(dataInfoMap: dataMap);
          }
          return null;
        },
        onChanged: (value) {
          dataMap[ADD_PROPERTY_LATITUDE]  = value;
          widget.listener(dataInfoMap: dataMap);
        },
      ),
    );
  }

  Widget addLongitude() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("longitude"),
        hintText: UtilityMethods.getLocalizedString("enter_address_longitude"),
        controller: _addressLongitudeTextController,
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value != null) {
            // if (mounted) {
            //   setState(() {
            //     dataMap[ADD_PROPERTY_LONGITUDE]  = value;
            //   });
            // }
            dataMap[ADD_PROPERTY_LONGITUDE]  = value;
            widget.listener(dataInfoMap: dataMap);
          }
          return null;
        },
        onChanged: (value) {
          dataMap[ADD_PROPERTY_LONGITUDE]  = value;
          widget.listener(dataInfoMap: dataMap);
        },
      ),
    );
  }

  Widget googlePlaceSearchWidget() {
    return SHOW_SEARCH_BY_LOCATION
        ? Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.searchBarBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: TextField(
        readOnly: true,
        controller: _searchResultController,
        onTap: () async {
          ///https://developers.google.com/maps/documentation/places/web-service/session-tokens
          final sessionToken = const Uuid().v4();
          final Suggestion? result = await showSearch(
            context: context,
            delegate: AddressSearch(sessionToken),
          );
          if (result != null && result.placeId != null) {
            var response =
            await PlaceApiProvider.getPlaceDetailFromPlaceId(
                result.placeId!);
            Map? addressMap = response.data;
            if (addressMap != null && addressMap.isNotEmpty) {
              if (mounted) {
                setState(() {
                  _searchResultController.text = addressMap["result"]["formatted_address"] ?? "";
                  double? latitude = addressMap["result"]["geometry"]["location"]["lat"];
                  double? longitude = addressMap["result"]["geometry"]["location"]["lng"];
                  // _handleTap(LatLng(latitude, longitude), animateCamera: true);
                  if (latitude != null && longitude != null) {
                    currentPosition = LatLng(latitude, longitude);
                    if (currentPosition != null) {
                      currentPositionLink = getStaticMapURLOfPosition(currentPosition!);
                      updateLatLngFields(currentPosition);
                      widget.listener(currentPosition: currentPosition);
                    }
                  }
                });
              }
            }
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: AppThemePreferences().appTheme.primaryColor!,
              width: 1.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: AppThemePreferences().appTheme.primaryColor!,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: AppThemePreferences().appTheme.primaryColor!,
              width: 1.0,
            ),
          ),
          contentPadding:
          const EdgeInsets.only(top: 5, left: 15, right: 15),
          fillColor:
          AppThemePreferences().appTheme.searchBarBackgroundColor,
          filled: true,
          hintText: UtilityMethods.getLocalizedString("search"),
          hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
          ),
        ),
      ),
    )
        : PropertyAddressHeaderWidget(text: UtilityMethods.getLocalizedString("map"));

  }

  Widget mapRelatedTextWidget() {
    return Container(
      alignment: UtilityMethods.isRTL(context) ? Alignment.topRight : Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("add_property_map_additional_hint"),
        textAlign: TextAlign.start,
        style: AppThemePreferences().appTheme.hintTextStyle,
      ),
    );
  }

  Widget _getPropertyAddressFromMap() {
    return _initialPosition == null
        ? propertyAddressLoadingWidget()
        : ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(0)),
      child: GestureDetector(
        child: currentPositionLink.isEmpty
            ? Container()
            : FancyShimmerImage(
          imageUrl: currentPositionLink,
          boxFit: BoxFit.fill,
          shimmerBaseColor:
          AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor: AppThemePreferences()
              .appTheme
              .shimmerEffectHighLightColor,
          width: MediaQuery.of(context).size.width,
          height: mapWidgetHeight,
          errorWidget: ShimmerEffectErrorWidget(),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressFromMap(
                initialLatLng: currentPosition ?? _initialPosition,
                zoomLevel: mapZoom,
                addressFromMapListener:
                    (LatLng position, double zoomLevel) {
                  if (mounted) {
                    setState(() {
                      currentPosition = position;
                      if (currentPosition != null) {
                        currentPositionLink = getStaticMapURLOfPosition(currentPosition!);
                        updateLatLngFields(currentPosition);
                        widget.listener(currentPosition: currentPosition);
                        _searchResultController.text = "";
                      }

                      if (zoomLevel != mapZoom) {
                        mapZoom = zoomLevel;
                      }
                    });
                  }
                },
              ),
            ),
          );
        },
      ),
    );
    // Container(
    //   padding: const EdgeInsets.only(top: 10),
    //       width: MediaQuery.of(context).size.width,
    //       height: mapWidgetHeight,
    //       child: GoogleMap(
    //         // Do Not take any suggestions
    //         // Don not covert to Set literal
    //         // Leave it as it is
    //         // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
    //         //   new Factory<OneSequenceGestureRecognizer>(
    //         //           () => new EagerGestureRecognizer()),
    //         // ].toSet(),
    //         // onTap: _handleTap,
    //         compassEnabled: false,
    //         markers: _markers,
    //         initialCameraPosition: CameraPosition(
    //           target: _initialPosition!,
    //           zoom: 12.0,
    //         ),
    //         scrollGesturesEnabled: false,
    //         myLocationButtonEnabled: false,
    //         zoomGesturesEnabled: false,
    //         tiltGesturesEnabled: false,
    //         zoomControlsEnabled: false,
    //         onMapCreated: (controller) {
    //           _googleMapController = controller;
    //           //_googleMapController.showMarkerInfoWindow(MarkerId("marker"));
    //           // return _googleMapController;
    //         },
    //         // myLocationEnabled: true,
    //         onTap: (position) {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(builder: (context) => AddressFromMap(
    //                 initialLatLng: currentPosition ?? _initialPosition,
    //                 addressFromMapListener: (LatLng position) {
    //                   if (position != null) {
    //                     currentPosition = position;
    //                     _markers = {};
    //                     _handleTap(position, animateCamera: true);
    //                   }
    //                 },
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     );
  }

  Widget propertyAddressLoadingWidget() {
    return Container(
      color: AppThemePreferences()
          .appTheme.shimmerEffectBaseColor,
          // .appTheme.shimmerEffectHighLightColor,
      alignment: Alignment.center,
      child: SizedBox(
        width: 40, //70
        height: mapWidgetHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BallBeatLoadingWidget()),
      ),
    );
  }

  void _getUserLocation() async {
    permissionGranted = await UtilityMethods.locationPermissionsHandling(permissionGranted);
    if (permissionGranted) {
      geo_locator.Position position = await geo_locator.Geolocator
          .getCurrentPosition(
        desiredAccuracy: geo_locator.LocationAccuracy.high,
      );
      // final coordinates = new Coordinates(position.latitude, position.longitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      // var first = addresses.first;
      if (mounted) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);

          _initialPosition ??= defaultLocation;

          currentPositionLink = getStaticMapURLOfPosition(_initialPosition!);

          /// if (_initialPosition == null) {
          ///   _initialPosition = defaultLocation;
          /// } == _initialPosition ??= defaultLocation;

        });
      }
    } else {
      if (mounted) {
        setState(() {
          _initialPosition = defaultLocation;
          currentPositionLink = getStaticMapURLOfPosition(_initialPosition!);
        });
      }
    }
  }

  String getStaticMapURLOfPosition(LatLng position) {
    String staticMapURL = "";
    String _latitude = position.latitude.toString();
    String _longitude = position.longitude.toString();
    staticMapURL = UtilityMethods.getStaticMapUrl(
      lat: _latitude,
      lng: _longitude,
      height: mapWidgetHeight,
      width: MediaQuery.of(context).size.width,
      zoomValue: mapZoom,
    );

    // print("staticMapURL: $staticMapURL");

    return staticMapURL;

  }

  updateLatLngFields(LatLng? location) async {
    if (location != null) {
      if (mounted) {
        setState(() {
          _addressLatitudeTextController.text = '';
          _addressLongitudeTextController.text = '';

          if (location.latitude.toString().isNotEmpty) {
            _addressLatitudeTextController.text = location.latitude.toString();
          }
          if (location.longitude.toString().isNotEmpty) {
            _addressLongitudeTextController.text = location.longitude.toString();
          }
        });
      }
    }
  }
}


typedef AddressFromMapListener = void Function(LatLng locationLatLng, double zoomLevel);

class AddressFromMap extends StatefulWidget {
  final LatLng? initialLatLng;
  final double? zoomLevel;
  final AddressFromMapListener? addressFromMapListener;
  const AddressFromMap({
    Key? key,
    this.initialLatLng,
    this.zoomLevel,
    this.addressFromMapListener,
  }) : super(key: key);

  @override
  State<AddressFromMap> createState() => _AddressFromMapState();
}

class _AddressFromMapState extends State<AddressFromMap> {

  Set<Marker> _markers = {};

  LatLng? _initialPosition;
  LatLng? _userSelectedPosition;

  double zoomLevel = 12.0;

  final _searchResultController = TextEditingController();

  GoogleMapController? _googleMapController;


  @override
  void initState() {
    _initialPosition = widget.initialLatLng;

    if (_initialPosition != null) {
      _markers.add(Marker(
        markerId: const MarkerId("marker"),
        position: _initialPosition!,
        // infoWindow: InfoWindow(
        //   title: address,
        // ),
      ));
    }

    if (widget.zoomLevel != null) {
      zoomLevel = widget.zoomLevel!;
    }

    super.initState();
  }

  @override
  void dispose() {
    if (_googleMapController != null) {
      _googleMapController!.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("choose_location"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 23, left: 20, right: 20),
            child: GestureDetector(
              onTap: () {
                if (_userSelectedPosition != null) {
                  widget.addressFromMapListener!(_userSelectedPosition!, zoomLevel);
                }else{
                  widget.addressFromMapListener!(_initialPosition!, zoomLevel);
                }
                Navigator.pop(context);
              },
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("done"),
                style: AppThemePreferences().appTheme.appBarActionWidgetsTextStyle,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _getPropertyAddressFromMap(),
          pageHeaderWidgets(),
        ],
      ),
    );
  }

  Widget pageHeaderWidgets() {
    return Container(
      height: 110,
      width: double.infinity,
      child: CardWidget(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            googlePlaceSearchWidget(),
            mapRelatedTextWidget(),
          ],
        ),
      ),
    );
  }

  Widget googlePlaceSearchWidget() {
    return SHOW_SEARCH_BY_LOCATION
        ? Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.searchBarBackgroundColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: TextField(
        readOnly: true,
        controller: _searchResultController,
        onTap: () async {
          ///https://developers.google.com/maps/documentation/places/web-service/session-tokens
          final sessionToken = const Uuid().v4();
          final Suggestion? result = await showSearch(
            context: context,
            delegate: AddressSearch(sessionToken),
          );
          if (result != null) {
            var response =
            await PlaceApiProvider.getPlaceDetailFromPlaceId(
                result.placeId!);
            Map? addressMap = response.data;
            if (addressMap != null && addressMap.isNotEmpty) {
              if (mounted) {
                setState(() {
                  _searchResultController.text =
                      addressMap["result"]["formatted_address"] ?? "";
                  double? latitude =
                  addressMap["result"]["geometry"]["location"]["lat"];
                  double? longitude =
                  addressMap["result"]["geometry"]["location"]["lng"];

                  if (latitude != null && longitude != null) {
                    _userSelectedPosition = LatLng(latitude, longitude);
                  }
                });
              }

              if (_userSelectedPosition != null) {
                _handleTap(_userSelectedPosition!, animateCamera: true);
              }


              // _handleTap(LatLng(latitude, longitude), animateCamera: true);
              // widget.addressFromMapListener!(LatLng(latitude, longitude), zoomLevel);
            }
          }
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: AppThemePreferences().appTheme.primaryColor!,
              width: 1.0,
            ),
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              // color: AppThemePreferences().appTheme.searchBarBackgroundColor,
              color: AppThemePreferences().appTheme.primaryColor!,
              width: 1.0,
            ),
          ),
          contentPadding:
          const EdgeInsets.only(top: 5, left: 15, right: 15),
          fillColor:
          AppThemePreferences().appTheme.searchBarBackgroundColor,
          filled: true,
          hintText: UtilityMethods.getLocalizedString("search"),
          //AppLocalizations.of(context).search,
          hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
          ),
        ),
      ),
    )
        : PropertyAddressHeaderWidget(text: UtilityMethods.getLocalizedString("map"));
  }

  Widget mapRelatedTextWidget() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("add_property_map_additional_hint"),
        textAlign: TextAlign.left,
        style: AppThemePreferences().appTheme.hintTextStyle,
      ),
    );
  }

  Widget _getPropertyAddressFromMap() {
    return _initialPosition == null
        ? _loading()
        : Container(
      padding: const EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        onTap: _handleTap,
        compassEnabled: true,
        markers: _markers,
        initialCameraPosition: CameraPosition(
          target: _initialPosition!,
          zoom: zoomLevel,
        ),
        scrollGesturesEnabled: true,
        myLocationButtonEnabled: true,
        zoomGesturesEnabled: true,
        tiltGesturesEnabled: true,
        zoomControlsEnabled: true,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        onCameraMove: (position) {
          if (position.zoom != zoomLevel) {
            if (mounted) {
              setState(() {
                zoomLevel = position.zoom;
              });
            }
          }
        },
        myLocationEnabled: true,
      ),
    );
  }

  Widget _loading() {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 70,
        // height: mapWidgetHeight,
        // height: MediaQuery.of(context).size.height - 340,
        child: BallBeatLoadingWidget(),
      ),
    );
  }

  _handleTap(LatLng location,{bool animateCamera = false}) async {
    if (mounted) {
      setState(() {
        _markers.add(Marker(
          markerId: const MarkerId("marker"),
          position: location,
        ));
        _googleMapController!.showMarkerInfoWindow(const MarkerId("marker"));
        if (animateCamera) {
          CameraUpdate cameraUpdate = CameraUpdate.newLatLng(location);
          _googleMapController!.animateCamera(cameraUpdate);
        }

        if (location != _userSelectedPosition) {
          _userSelectedPosition = location;
        }
      });
    }
  }
}