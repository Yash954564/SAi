import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/pages/map_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

typedef SlidingPanelWidgetListener = void Function({
  Map<String, String>? coordinatesMap,
  int? selectedMarkerPropertyId,
  bool? snapCameraToSelectedIndex,
  bool? showWaitingWidget,
  double? opacity,
  double? mapPropListOpacity,
  double? sliderPosition,
  bool? zoomToAllLocations,
  bool? someActivityOnMap,
});

class SlidingPanelWidget extends StatefulWidget {
  final PanelController? panelController;
  final List<dynamic> filteredArticlesList;

  final bool showWaitingWidget;
  final bool zoomToAllLocations;
  final int selectedArticleIndex;

  final bool snapCameraToSelectedIndex;

  final Widget Function(ScrollController)? panelBuilder;

  final SlidingPanelWidgetListener listener;
  final bool showMapWidget;
  SlidingPanelWidget({
    Key? key,
    required this.panelController,
    required this.filteredArticlesList,
    required this.showWaitingWidget,
    required this.zoomToAllLocations,
    required this.selectedArticleIndex,

    required this.snapCameraToSelectedIndex,

    required this.panelBuilder,
    required this.listener,
    required this.showMapWidget
  }) : super(key: key);

  @override
  State<SlidingPanelWidget> createState() => _SlidingPanelWidgetState();
}

class _SlidingPanelWidgetState extends State<SlidingPanelWidget> {
  double _panelHeightOpen = 0.0;

  double _panelHeightClosed = 45.0;
 //95.0;
  double _parallaxOffset = 0.0;

  double halfSnapPoint = 0.50;

  // double fullSnapPoint = 1.0;
  // bool zoomToAllLocations = true;

  List<dynamic> filteredArticlesList = [];

  final _googleMapsKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height;

    // if(filteredArticlesList != widget.filteredArticlesList){
    //   filteredArticlesList = widget.filteredArticlesList;
    //   zoomToAllLocations = true;
    // }

    return SlidingUpPanel(
      color: Theme.of(context).canvasColor,
      controller: widget.panelController,
      // snapPoint: halfSnapPoint,
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: _parallaxOffset,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18.0),
        topRight: Radius.circular(18.0),
      ),
      defaultPanelState: SHOW_MAP_INSTEAD_FILTER
          ? PanelState.CLOSED
          : PanelState.OPEN,

      panelBuilder: widget.panelBuilder,

      body: Stack(
        children: [
          Center(
            child: MapView(
                googleMapsKey: _googleMapsKey,
                widget.filteredArticlesList,
                showWaitingWidget: widget.showWaitingWidget,
                hideMap: !widget.showMapWidget,
                selectedArticleIndex: widget.selectedArticleIndex,
                zoomToAllLocations: widget.zoomToAllLocations,
                snapCameraToSelectedIndex: widget.snapCameraToSelectedIndex,
                mapViewListener: ({coordinatesMap, selectedMarkerPropertyId, showWaitingWidget, snapCameraToSelectedIndex, someActivityOnMap}) {
                  widget.listener(
                    coordinatesMap: coordinatesMap,
                    selectedMarkerPropertyId: selectedMarkerPropertyId,
                    showWaitingWidget: showWaitingWidget,
                    snapCameraToSelectedIndex: snapCameraToSelectedIndex,
                    //MAP_IMPROVES_BY_ADIL - if map was asked to zoom all location, and it did, now set to false
                    // so we don't force map to keep locations in zoom in re-builds.
                    zoomToAllLocations: widget.zoomToAllLocations ? false : null,
                    someActivityOnMap: someActivityOnMap,
                  );
                },
            ),
          ),
        ],
      ),
      onPanelSlide: (double pos) {
        widget.listener(sliderPosition: pos);

        if (pos <= 0.5) {
          _parallaxOffset = pos;
        }

        if (pos >= 0.4) {
          if (widget.zoomToAllLocations != true) {
            // zoomToAllLocations = true;
            widget.listener(zoomToAllLocations: true);
          }
        }

        if (pos < 0.4) {
          if (widget.zoomToAllLocations != false) {
            // zoomToAllLocations = false;
            widget.listener(zoomToAllLocations: false);
          }
        }
        widget.listener(mapPropListOpacity: 1 - pos * 2);

        if (pos > 0.45) {
          widget.listener(mapPropListOpacity: 0.0);
        }

        if (pos > 0.51 && pos < 0.8) {
          widget.listener(opacity: pos);
        }

        if (pos > 0.8) {
          widget.listener(opacity: 1.0);
        }

        if (pos < 0.51) {
          widget.listener(opacity: 0.0);
        }
      },
    );
  }
}
