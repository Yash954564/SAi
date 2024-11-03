import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/generic_bottom_sheet_widget/generic_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:url_launcher/url_launcher.dart';

class FullScreenMapViewArticle extends StatefulWidget {
  final Article article;

  const FullScreenMapViewArticle(this.article, {Key? key}) : super(key: key);

  @override
  State<FullScreenMapViewArticle> createState() =>
      _FullScreenMapViewArticleState();
}

class _FullScreenMapViewArticleState extends State<FullScreenMapViewArticle>
    with AutomaticKeepAliveClientMixin<FullScreenMapViewArticle> {
  bool showSearchInThisArea = false;

  double mapZoom = 11;
  bool showMap = true;

  Set<Marker> googleMapMarkers = {};

  List<String> addressCoordinatesList = [];

  var _initialCameraPosition = const CameraPosition(
    target: LatLng(37.4219999, -122.0862462),
    zoom: 11,
  );
  GoogleMapController? _googleMapController;

  int counter = 0;

  bool mapViewAll = true;

  double? x0, x1, y0, y1;
  GoogleMap? map, tempMap;

  bool isUserLoggedIn = false;

  LatLng? _propertyLatLng;

  @override
  void initState() {
    super.initState();
    if (Provider.of<UserLoggedProvider>(context, listen: false).isLoggedIn!) {
      isUserLoggedIn = true;
    }
    setupMarkersIfPossible();
  }

  setupMarkersIfPossible() {

    Article item = widget.article;
    final heroId = item.id.toString() + "-marker";
    final propId = item.id;
    var address = item.address!.coordinates.toString();
    if ((address != null) && (address.isNotEmpty) && (address != ',')) {
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

      Marker marker = Marker(
          markerId: MarkerId(heroId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
              title: item.title.toString(),
              onTap: () {
                if (item.propertyInfo!.requiredLogin) {
                  isUserLoggedIn
                      ? UtilityMethods.navigateToPropertyDetailPage(
                    context: context,
                    propertyID: item.id!,
                    heroId: heroId,
                  )
                      : UtilityMethods.navigateToLoginPage(context, false);
                } else {
                  UtilityMethods.navigateToPropertyDetailPage(
                    context: context,
                    propertyID: item.id!,
                    heroId: heroId,
                  );
                }
              }),
      );
      if (mounted) {
        setState(() {
          googleMapMarkers.add(marker);
          _initialCameraPosition = CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16,
          );
          _propertyLatLng = LatLng(lat, lng);
        });
      }
    }


  }

  @override
  void dispose() {
    _googleMapController!.dispose();
    super.dispose();
  }

  GoogleMapController getController() {
    return _googleMapController!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);


    map = GoogleMap(
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,

      onMapCreated: (controller) {
        _googleMapController = controller;
        // return _googleMapController!;
      },
      onCameraMove: (CameraPosition cameraPosition) {
        mapZoom = cameraPosition.zoom;
      },

      markers: googleMapMarkers,
      initialCameraPosition: _initialCameraPosition,
    );

//     if (_googleMapController != null) {
//       // if (widget.article != null) {
//       //
//       //   var item = widget.article;
//       //
//       //   final heroId = item.id.toString() + "-marker";
//       //   var address = item.address.coordinates.toString();
//       //   if ((address != null) && (address.isNotEmpty) && (address != ',')) {
//       //     _googleMapController.hideMarkerInfoWindow(MarkerId(heroId));
//       //   }
//       // }
//
//       //if (widget.article != null) {
//         var item = widget.article;
//         final heroId = item.id.toString() + "-marker";
//
//         var address = item.address.coordinates.toString();
//         if ((address != null) && (address.isNotEmpty) && (address != ',')) {
//           _googleMapController.showMarkerInfoWindow(MarkerId(heroId));
//           var temp = address.split(",");
//           var location = CameraPosition(
//               target: LatLng(double.parse(temp[0]), double.parse(temp[1])), zoom: mapZoom);
//           _googleMapController.animateCamera(CameraUpdate.newCameraPosition(location));
//         }
//
//       }
// //    }
//
//     // if (showMap == true) {
//       if(x1 != null && x0 != null && y1 != null && x0 != null){
//         LatLngBounds latLngBounds = LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
//         if (_googleMapController != null) {
//           CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(latLngBounds, 190.0);
//           // _googleMapController.moveCamera(cameraUpdate);
//           _googleMapController.animateCamera(cameraUpdate);
//         }
//       }
    //}

    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: widget.article.title ?? "",
      ),
      body: Stack(
        children: [
          map!,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: showArticle(),
            ),
          ),
          if (_propertyLatLng != null)
            DirectionsWidget(propertyLatLng: _propertyLatLng!),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget showArticle() {
    ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
    return SizedBox(
      height: 170,
      child: _articleBoxDesign.getArticleBoxDesign(
        article: widget.article,
        heroId: widget.article.id.toString() + CAROUSEL,
        buildContext: context,
        design: DESIGN_01,
        onTap: () {},
      ),
    );
  }

}

class DirectionsWidget extends StatelessWidget {
  final LatLng propertyLatLng;

  const DirectionsWidget({
    super.key,
    required this.propertyLatLng,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: InkWell(
        onTap: () {
          if (Platform.isIOS) {
            genericBottomSheetWidget(
              context: context,
              children: [
                GenericBottomSheetTitleWidget(
                  title: UtilityMethods.getLocalizedString("Choose application"),
                  padding: EdgeInsets.only(bottom: 20),
                ),
                GenericBottomSheetOptionWidget(
                  label: UtilityMethods.getLocalizedString("Maps"),
                  onPressed: () {
                    navigateToDirections(platform: PLATFORM_APPLE_MAPS);
                    Navigator.pop(context);
                  },
                ),
                GenericBottomSheetOptionWidget(
                  label: UtilityMethods.getLocalizedString("Google Maps"),
                  showDivider: false,
                  onPressed: () {
                    navigateToDirections(platform: PLATFORM_GOOGLE_MAPS);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          } else {
            navigateToDirections(
              platform: PLATFORM_GOOGLE_MAPS,
            );
          }
        },
        child: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: AppThemePreferences().appTheme.backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(Icons.directions, color: Colors.blue, size: 30),
        ),
      ),
    );
  }

  navigateToDirections({required String platform}) async {
    Uri uri = PropertyBloc().provideDirectionsApi(
      platform: platform,
      destinationLatitude: propertyLatLng.latitude.toString(),
      destinationLongitude: propertyLatLng.longitude.toString(),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
