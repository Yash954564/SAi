import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker extends Clusterable {
  final String id;
  final LatLng position;
  final Future<BitmapDescriptor>? icon;
  final void Function()? onTap;
  final InfoWindow infoWindow;

MapMarker({
    required this.id,
    required this.position,
    this.icon,
    // this.icon = BitmapDescriptor.defaultMarker,
    this.onTap,
    this.infoWindow = InfoWindow.noText,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
    markerId: id,
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId,
  );

  Future<Marker> toMarker() async => Marker(
    markerId: MarkerId(id),
    position: LatLng(
      position.latitude,
      position.longitude,
    ),
    // icon: icon,
    icon: (await icon) ?? BitmapDescriptor.defaultMarker,
    onTap: onTap,
    infoWindow: infoWindow,
  );
}