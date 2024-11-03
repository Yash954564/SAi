import 'dart:ui';

import 'package:fluster/fluster.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/map_marker.dart';
import 'package:houzi_package/models/map_marker_data.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/article.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'package:houzi_package/widgets/search_result_widgets/label_marker.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

typedef MapViewListener = void Function({
  Map<String,String>? coordinatesMap,
  int? selectedMarkerPropertyId,
  bool? snapCameraToSelectedIndex,
  bool? showWaitingWidget,
  bool? someActivityOnMap,
});

class MapView extends StatefulWidget {

  final List<dynamic> listArticles;
  final MapViewListener? mapViewListener;
  final bool showWaitingWidget;
  final bool zoomToAllLocations;
  final int selectedArticleIndex;

  final bool snapCameraToSelectedIndex;

  final Key googleMapsKey;
  final bool hideMap;
  const MapView(
    this.listArticles, {
    Key? key,
    this.mapViewListener,
    required this.showWaitingWidget,
    required this.zoomToAllLocations,
    required this.selectedArticleIndex,
    required this.snapCameraToSelectedIndex,
    required this.googleMapsKey,
    required this.hideMap,
  }): super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with AutomaticKeepAliveClientMixin<MapView> {

  bool isUserLoggedIn = false;
  bool showSearchInThisArea = false;

  int counter = 0;

  //MAP_IMPROVES_BY_ADIL - Keep the first ever camera center, and last ever camera center, it'll help us in distance counting.
  double? cameraStartLat = null;
  double? cameraStartLng = null;
  double? cameraEndLat = null;
  double? cameraEndLng = null;
  
  double mapZoom = 3;
  double? x0, x1, y0, y1;

  Map<int, Marker> markerCache = {};

  List<String> addressCoordinatesList = [];

  String lastProcessedHash = "";

  LatLng? _lastMapPosition;


  GoogleMap? map, tempMap;

  GoogleMapController? _googleMapController;

  MarkerTitleHook markerTitleHook = HooksConfigurations.markerTitle;
  MarkerIconHook markerIconHook = HooksConfigurations.markerIcon;
  CustomMarkerHook customMarkerHook = HooksConfigurations.customMapMarker;

  EdgeInsets mapPaddingActive = EdgeInsets.only(left: 5, right: 5, top: 150, bottom: 200);
  List<MapMarker> markers = [];
  Set<Marker> googleMapMarkers = {};
  int minZoomCluster = 1; //5
  int maxZoomCluster = 18;
  late Fluster<MapMarker> fluster;
  List<Marker> googleMarkers = [];
  Map<int, MapMarker> mapMarkerCache = {};
  MapMarker? _selectedMarker = null;
  String? _selectedHeroId = null;

  ClusterMarkerIconHook clusterMarkerIconHook = HooksConfigurations.clusterMarkerIconHook;
  CustomClusterMarkerIconHook customClusterMarkerIconHook = HooksConfigurations.customClusterMarkerIconHook;

  String CLUSTER_COLOR = "clusterColor";
  String CLUSTER_TEXT_COLOR = "clusterTextColor";
  String CLUSTER_BORDER_COLOR = "clusterBorderColor";
  String CLUSTER_WIDTH = "clusterWidth";
  String CLUSTER_BORDER_WIDTH = "clusterBorderWidth";

  bool hideMap = false;
  final _initialCameraPosition = CameraPosition(
    target: LatLng(37.4219999, -122.0862462),
    zoom: 8,
  );

  bool lock = false;
  int lastSelectedIndex = -1;

  bool _isFlusterInitialized = false;
  bool _zoomingToOneCluster = false;
  @override
  void initState() {
    super.initState();
    if (Provider.of<UserLoggedProvider>(context, listen: false).isLoggedIn!) {
      isUserLoggedIn = true;
    }

    setupMarkersIfPossible();

  }

  Future<BitmapDescriptor> setCustomImageIcons(Article article) async {
    String? iconStr = markerIconHook(context, article);

    BitmapDescriptor? icon;
    if (iconStr != null && iconStr.isNotEmpty) {
      icon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 3.2), iconStr);
      return icon;
    }
    double height = MediaQuery.of(context).size.height;
    MapMarkerData? markerData = customMarkerHook(context, article);
    if (markerData != null) {
      Color textColor = markerData.textColor == null ?  Colors.white : markerData.textColor!;
      TextStyle style = markerData.textStyle ?? TextStyle(
        fontSize: height * 5/100.0,
        color: textColor,
      );
      icon = await createCustomMarkerBitmap(
        markerData.text,
        backgroundColor: markerData.backgroundColor,
        textStyle: style,
      );
      return icon;
    }

    return icon ?? BitmapDescriptor.defaultMarker;
  }

  Future<BitmapDescriptor> getClusterMarker({
    required int clusterSize,
    Color clusterColor = Colors.blue,
    Color textColor = Colors.white,
    int width = 80,
    Color borderColor = Colors.white,
    double borderWidth = 10.0,
  }) async {

    if (customClusterMarkerIconHook(context, clusterSize) != null) {
      return customClusterMarkerIconHook(context, clusterSize)!;
    }

    if (clusterMarkerIconHook() != null) {
      Map<String, dynamic>? clusterMarkerIconData = clusterMarkerIconHook()!;
      if (clusterMarkerIconData[CLUSTER_COLOR] != null &&
          clusterMarkerIconData[CLUSTER_COLOR] is Color) {
        clusterColor = clusterMarkerIconData[CLUSTER_COLOR];
      }
      if (clusterMarkerIconData[CLUSTER_TEXT_COLOR] != null &&
          clusterMarkerIconData[CLUSTER_TEXT_COLOR] is Color) {
        textColor = clusterMarkerIconData[CLUSTER_TEXT_COLOR];
      }
      if (clusterMarkerIconData[CLUSTER_BORDER_COLOR] != null &&
          clusterMarkerIconData[CLUSTER_BORDER_COLOR] is Color) {
        borderColor = clusterMarkerIconData[CLUSTER_BORDER_COLOR];
      }
      if (clusterMarkerIconData[CLUSTER_WIDTH] != null &&
          clusterMarkerIconData[CLUSTER_WIDTH] is int) {
        width = clusterMarkerIconData[CLUSTER_WIDTH];
      }
      if (clusterMarkerIconData[CLUSTER_BORDER_WIDTH] != null &&
          clusterMarkerIconData[CLUSTER_BORDER_WIDTH] is double) {
        borderWidth = clusterMarkerIconData[CLUSTER_BORDER_WIDTH];
      }
    }

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paintBorder = Paint()..color = borderColor;
    final Paint paintCluster = Paint()..color = clusterColor;
    final double radius = width / 2;

    // Draw the border circle
    canvas.drawCircle(
      Offset(radius + borderWidth, radius + borderWidth), // Adjust the Offset for the border
      radius + borderWidth,
      paintBorder,
    );

    // Draw the actual cluster circle
    canvas.drawCircle(
      Offset(radius + borderWidth, radius + borderWidth), // Adjust the Offset for the border
      radius,
      paintCluster,
    );

    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
    textPainter.layout();

    // Draw the text on the cluster circle
    textPainter.paint(
      canvas,
      Offset(
        radius + borderWidth - textPainter.width / 2, // Adjust the Offset for the border
        radius + borderWidth - textPainter.height / 2, // Adjust the Offset for the border
      ),
    );

    final image = await pictureRecorder.endRecording().toImage(
      ((radius + borderWidth) * 2).toInt(), // Adjust the image size to account for the border
      ((radius + borderWidth) * 2).toInt(), // Adjust the image size to account for the border
    );

    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }


  setupMarkersIfPossible() async {
    widget.listArticles.removeWhere((element) => element is AdWidget);
    String hash = computeHash(widget.listArticles);

    if(lastProcessedHash == hash) {
      //if they're same, then return.. so we don't need to compute things in each cycle.
      //just update the clusters from Fluster
      updateGoogleMapMarkers();
      return;
    }
    _isFlusterInitialized = false;

    googleMapMarkers.clear();
    markers.clear();


    x0 = null;
    x1 = null;
    y0 = null;
    y1 = null;

    widget.listArticles.forEach((mapItem) async {
      Article item = mapItem;

      final heroId = item.id.toString() + "-marker";
      var tempAddress = item.address;
      if(tempAddress != null) {
        var address = tempAddress.coordinates.toString();
        if ((address.isNotEmpty) && (address != ',')) {
          var temp = address.split(",");

          double lat = double.parse(temp[0]);
          double lng = double.parse(temp[1]);

          if (x0 == null) {
            x0 = x1 = lat;
            y0 = y1 = lng;
          } else {
            if (lat > x1!) x1 = lat;
            if (lat < x0!) x0 = lat;
            if (lng > y1!) y1 = lng;
            if (lng < y0!) y0 = lng;
          }
          //MAP_IMPROVES_BY_ADIL - when we do something on ui, it clears markers for no reason,
          // Lets cache this based on heroId and fill from cache on next update.
          if (mapMarkerCache.containsKey(item.id)) {
            markers.add(mapMarkerCache[item.id]!);
            return;
          }

          MapMarker mapMarker = MapMarker(
            id: heroId,
            position: LatLng(lat, lng),
            icon: setCustomImageIcons(item),
            onTap: () {
              widget.mapViewListener!(
                  selectedMarkerPropertyId: item.id,
                  snapCameraToSelectedIndex: true
              );
            },
            infoWindow: InfoWindow(
                title: markerTitleHook(context, item),
                onTap: () {
                  bool requireLogin = item.propertyInfo!.requiredLogin;
                  if (!requireLogin || (requireLogin && isUserLoggedIn)) {
                    UtilityMethods.navigateToPropertyDetailPage(
                      context: context,
                      propertyID: item.id!,
                      heroId: heroId,
                    );
                  } else {
                    UtilityMethods.navigateToLoginPage(context, false);
                  }
                }),
          );

          mapMarkerCache[item.id!] = mapMarker;
          markers.add(mapMarker);
        }
      }

    });

    if (markers.isNotEmpty) {
      _isFlusterInitialized = true;
      fluster = Fluster<MapMarker>(
        minZoom: minZoomCluster,
        // The min zoom at clusters will show
        maxZoom: maxZoomCluster,
        // The max zoom at clusters will show
        radius: 150,
        // Cluster radius in pixels
        extent: 2048,
        // Tile extent. Radius is calculated with it.
        nodeSize: 64,
        // Size of the KD-tree leaf node.
        points: markers,
        createCluster: (BaseCluster? cluster, double? lng, double? lat) {
          return MapMarker(
              id: cluster?.id.toString() ?? '',
              position: LatLng(lat ?? 0, lng ?? 0),
              icon: getClusterMarker(
                clusterSize: cluster?.pointsSize ?? 0,
                clusterColor: AppThemePreferences.appPrimaryColor,
              ),
            isCluster: cluster?.isCluster ?? false,
              clusterId: cluster?.id ?? 0,
              pointsSize: cluster?.pointsSize ?? 0,
              childMarkerId: cluster?.childMarkerId ?? 0,
            onTap: () {
                String? childMarkerId = cluster?.childMarkerId;
                if (childMarkerId != null) {
                  zoomInOnChildMarker(childMarkerId);
                }
            },
          );
        },
      );

      updateGoogleMapMarkers();
    }
  }

  void zoomInOnChildMarker(String childMarkerId) {
    // Find the child marker with the specified ID
    MapMarker targetMarker = findMarkerById(childMarkerId);

    // Check if the marker is found
    if (targetMarker != null) {
      // Zoom in on the target marker
      if (mapZoom < maxZoomCluster && mapZoom >= 8) {
        mapZoom = 13;
      } else if (mapZoom >= minZoomCluster && mapZoom < 8) {
        mapZoom = 11;
      }
      _zoomingToOneCluster = true;
      // mapZoom = 14.0;
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(targetMarker.position, mapZoom),
        // CameraUpdate.newLatLngZoom(targetMarker.position, 11.0),
      );



    }
  }

  MapMarker findMarkerById(String markerId) {
    return markers.firstWhere(
          (marker) => marker.id == markerId,
      orElse: () => MapMarker(id: '', position: LatLng(0, 0)), // Default if not found
    );
  }

  updateGoogleMapMarkers() async {
    if (!_isFlusterInitialized) return;
    LatLngBounds bounds = await _googleMapController!.getVisibleRegion();

    List<MapMarker> _tempMapMarkersList = fluster.clusters([bounds.southwest.longitude, bounds.southwest.latitude,
      bounds.northeast.longitude, bounds.northeast.latitude], mapZoom.toInt());
    List<Marker> _tempMarkersList = [];
    print("updateGoogleMapMarkers():: got cluster with count: ${_tempMapMarkersList.length}");
    bool addedSelectedMarker = false;
    for(MapMarker item in _tempMapMarkersList) {
      Marker marker = await item.toMarker();

      _tempMarkersList.add(marker);
      if (_selectedMarker != null && _selectedMarker!.position == item.position) {
        addedSelectedMarker = true;
      }
    }

    googleMarkers  = _tempMarkersList;
    if (_selectedHeroId != null && _selectedMarker != null) {
      if (!addedSelectedMarker) {
      LatLngBounds bounds = generateBoundingBox(_selectedMarker!.position);
      List<MapMarker> _tempMapMarkersList = fluster.clusters([bounds.southwest.longitude, bounds.southwest.latitude,
        bounds.northeast.longitude, bounds.northeast.latitude], mapZoom.toInt());

      print("animateCameraToSelectedProperty():: got cluster with count: ${_tempMapMarkersList.length}");
        MapMarker? clusterMarker =  null;
        for(MapMarker item in _tempMapMarkersList) {
          if (item.position == _selectedMarker!.position) {
            clusterMarker = item;
          }
        }

        googleMarkers.add(await _selectedMarker!.toMarker());
      }
      var markerId = MarkerId(_selectedHeroId!);
      _googleMapController?.isMarkerInfoWindowShown(markerId).then((shown) {
        if (!shown) {
          _googleMapController!.showMarkerInfoWindow(MarkerId(_selectedHeroId!));
        }
      });
    }
    // Release the memory:
    _tempMapMarkersList = [];
    _tempMarkersList = [];
  }

  animateCameraToSelectedProperty() async {
    if (_googleMapController != null) {
      if (widget.selectedArticleIndex != lastSelectedIndex &&
          lastSelectedIndex != -1 &&
          widget.listArticles.isNotEmpty &&
          widget.listArticles.length > lastSelectedIndex) {
        var item = widget.listArticles[lastSelectedIndex];
        //print("animateCameraToSelectedProperty():: hiding marker for: " +item.title);
        final heroId = item.id.toString() + "-marker";
        var markerId = MarkerId(heroId);
        // _googleMapController?.isMarkerInfoWindowShown(markerId).then((shown) {
        //   if (shown) {
        //     _googleMapController!.hideMarkerInfoWindow(markerId);
        //   }
        // });
        lastSelectedIndex = -1;
        _selectedMarker = null;
        _selectedHeroId = null;
      }
    }

    if (widget.snapCameraToSelectedIndex &&
        widget.selectedArticleIndex >= 0 &&
        widget.listArticles.isNotEmpty &&
        widget.listArticles.length > widget.selectedArticleIndex) {
      var item = widget.listArticles[widget.selectedArticleIndex];
      //print("animateCameraToSelectedProperty():: showing marker for: " +item.title);
      final heroId = item.id.toString() + "-marker";

      if (mapMarkerCache.containsKey(item.id)) {
        MapMarker marker = mapMarkerCache[item.id]!;

        //if we are already showing this position
        if (_selectedMarker != null && _selectedMarker!.position == marker.position) {
          return;
        }


        _selectedMarker = marker;
        print("animateCameraToSelectedProperty():: added new marker: ${_selectedMarker}");


        _zoomingToOneCluster = true;
        var location = CameraPosition(
          target: marker.position,
          zoom: 20,
        );
        _googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(location));
        _selectedHeroId = heroId;

      }
      lastSelectedIndex = widget.selectedArticleIndex;
    }
  }

  attemptZoomToAllProperties(){
    if (widget.showWaitingWidget) {
      //print("attemptZoomToAllProperties():: something in progress, bailing");
      //if we're doing some web service work, don't attempt zoom.
      return;
    }
    if (widget.selectedArticleIndex != -1 && widget.listArticles.isNotEmpty &&
        widget.listArticles.length > widget.selectedArticleIndex) {
      //print("attemptZoomToAllProperties():: selectedArticleIndex available:: ${widget.selectedArticleIndex}");
      //if we're focusing on a single property, we should not zoom on all properties.
      return;
    }

    if(widget.zoomToAllLocations && _googleMapController != null
        && (x1 != null && x0 != null && y1 != null && x0 != null)){
      LatLngBounds latLngBounds = LatLngBounds(
        northeast: LatLng(x1!, y1!),
        southwest: LatLng(x0!, y0!),
      );

      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(latLngBounds, 50.0); // 190.0
      // _googleMapController!.animateCamera(cameraUpdate);
      _googleMapController!.animateCamera(cameraUpdate).then((value) {
        //print("calling  widget.mapViewListener" );
        widget.mapViewListener!();
      });
    }
    //MAP_IMPROVES_BY_ADIL - the first ever publishing should record the bounds center as start position
    if (x1 != null && x0 != null && y1 != null && x0 != null) {
      if (cameraStartLat == null || cameraStartLng == null) {
        LatLng centerLatLng = LatLng(
          (x1! + x0!) / 2,
          (y1! + y0!) / 2,
        );
        cameraStartLat = centerLatLng.latitude;
        cameraStartLng = centerLatLng.longitude;
      }
    }


  }

  @override
  void dispose() {

    if(_googleMapController != null){
      _googleMapController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    setupMarkersIfPossible();

    attemptZoomToAllProperties();

    animateCameraToSelectedProperty();



    return WillPopScope(
      onWillPop: () {
        setState(() {
          //A dirty hack for map showing when exiting back to
          hideMap = true;
        });

        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            //MAP_IMPROVES_BY_ADIL - Wrap Map in Listener widget to only get notified with map change made by user.
            //
            Listener(
              onPointerUp: (e) {
                widget.mapViewListener!(someActivityOnMap: true);

                //MAP_IMPROVES_BY_ADIL - we don't want to deal with nulls.
                if (cameraStartLat == null || cameraStartLng == null || cameraEndLat == null || cameraEndLng == null) return;

                //MAP_IMPROVES_BY_ADIL - calculate distance from start point to end point.
                double distance = findDistance(cameraStartLat!, cameraStartLng!, cameraEndLat!, cameraEndLng!);
                //MAP_IMPROVES_BY_ADIL - the minimum distance that should show Search In this Area button
                double threshold = 1;
                //MAP_IMPROVES_BY_ADIL - hide or show only when we pass or fail this threshold
                //MAP_IMPROVES_BY_ADIL - don't cause the set state to be called too much. only when threshold crossed
                if (distance < threshold && showSearchInThisArea){
                  if(mounted) {
                    setState(() {
                      showSearchInThisArea = false;
                    });
                  }
                }
                if (distance > threshold && !showSearchInThisArea){
                  if(mounted) {
                    setState(() {
                      showSearchInThisArea = true;
                    });
                  }
                }
              },
              child: (hideMap || widget.hideMap) ? Container() : GoogleMap(
                key: widget.googleMapsKey,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: googleMarkers.toSet(),
                // markers: googleMapMarkers,
                initialCameraPosition: _initialCameraPosition,
                padding: _googleMapController == null
                    ? EdgeInsets.zero
                //MAP_IMPROVES_BY_ADIL - the padding for map marker should consider available real estate of screen
                : const EdgeInsets.only(left: 20, right: 20, top: 140, bottom: 250),
                onMapCreated: (controller) {
                  _googleMapController = controller;
                  if (mounted) setState(() {});
                },
                onCameraMove: (CameraPosition cameraPosition) async {
                  mapZoom = cameraPosition.zoom;
                  // print("mapZoom: $mapZoom..........");

                  _lastMapPosition = cameraPosition.target;
                  double targetLat = cameraPosition.target.latitude;
                  double targetLon = cameraPosition.target.longitude;

                  //MAP_IMPROVES_BY_ADIL - every camera move can be last, so keep it recorded.
                  cameraEndLat = targetLat;
                  cameraEndLng = targetLon;

                  updateGoogleMapMarkers();
                },
                onTap: (LatLng latLng) {
                  //when we get this event, it means, we're not tapping a marker.
                  //So if there's any marker showing window right now, hide that.
                  //print("map tapped");
                  widget.mapViewListener!(
                      selectedMarkerPropertyId: -1,
                      snapCameraToSelectedIndex: false,
                      showWaitingWidget: false
                  );
                },
                onCameraIdle: () {
                  // if(mounted){
                  //   setState(() {});
                  // }
                  if(mounted && _zoomingToOneCluster) {
                    _zoomingToOneCluster = false;
                    setState(() {
                      updateGoogleMapMarkers();
                    });
                  }
                },

                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                ),

              ),
            ),
            if(showSearchInThisArea)
              Container(
                    margin: EdgeInsets.only(top: 120),
                    alignment: Alignment.topCenter,
                    child: FloatingActionButton.extended(
                      elevation: 0.0,
                      backgroundColor: AppThemePreferences().appTheme.searchBarBackgroundColor,
                      onPressed: () {
                        var visibleRegion = _googleMapController!.getVisibleRegion();
                        visibleRegion.then((value) {
                          var distance = Geolocator.distanceBetween(
                              value.northeast.latitude,
                              value.northeast.longitude,
                              value.southwest.latitude,
                              value.southwest.longitude,
                          );
                          //MAP_IMPROVES_BY_ADIL - save current center as start point for next camera move distance
                          cameraStartLat = _lastMapPosition!.latitude;
                          cameraStartLng = _lastMapPosition!.longitude;

                          double distanceInKiloMeters = distance / 1000;
                          double roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));

                          Map<String, String> coordinatesMap = {
                            LATITUDE: _lastMapPosition!.latitude.toString(),
                            LONGITUDE: _lastMapPosition!.longitude.toString(),
                            RADIUS: roundDistanceInKM.toString(),
                          };
                          if(mounted) {
                            setState(() {
                              showSearchInThisArea = false;
                            });
                          }
                          widget.mapViewListener!(

                              coordinatesMap: coordinatesMap,
                              showWaitingWidget: true
                          );
                        });
                      },
                      label: GenericTextWidget(
                          UtilityMethods.getLocalizedString("search_in_this_area"),
                          style: AppThemePreferences().appTheme.filterPageChoiceChipTextStyle,
                      ),
                    ),
                  ),

            if (widget.showWaitingWidget)
              Container(
                margin: const EdgeInsets.only(top: 160),
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: BallBeatLoadingWidget(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  static double findDistance(double lat1, double lon1, double lat2, double lon2){
    double distance = Geolocator.distanceBetween(
        lat1,
        lon1,
        lat2,
        lon2
    );
    return distance / 1000;
  }
  // Function to compute SHA-256 hash of a list of articles
  String computeHash(List<dynamic> articles) {
    List<String> articleStrings = articles.map((article) => article.id.toString()).toList();
    String concatenatedData = articleStrings.join();
    Digest hash = sha256.convert(utf8.encode(concatenatedData));
    return hash.toString();
  }
  LatLngBounds generateBoundingBox(LatLng center) {
    // Earth's radius in meters
    const double earthRadius = 6371000.0;

    // Buffer distance in meters
    const double bufferDistance = 50.1;

    // Calculate the latitude and longitude offset for the buffer distance
    double latOffset = bufferDistance / earthRadius * (180.0 / pi);
    double lonOffset = bufferDistance / (earthRadius * cos(pi * center.latitude / 180.0)) * (180.0 / pi);

    // Calculate the northeast and southwest coordinates for the bounding box
    double neLat = center.latitude + latOffset;
    double neLon = center.longitude + lonOffset;
    double swLat = center.latitude - latOffset;
    double swLon = center.longitude - lonOffset;

    // Ensure latitude values are within valid bounds
    neLat = neLat.clamp(-90.0, 90.0);
    swLat = swLat.clamp(-90.0, 90.0);

    // Ensure longitude values are within valid bounds
    neLon = (neLon + 180) % 360 - 180;
    swLon = (swLon + 180) % 360 - 180;

    return LatLngBounds(northeast: LatLng(neLat, neLon), southwest: LatLng(swLat, swLon));

  }

}