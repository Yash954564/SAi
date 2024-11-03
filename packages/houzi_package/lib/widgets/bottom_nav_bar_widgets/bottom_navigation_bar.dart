import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/bottom_navy_bar.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/dot_navigation_bar.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final String? design;
  final int currentIndex;
  final void Function(int) onTap;
  final Map<String, dynamic> itemsMap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const BottomNavigationBarWidget({
    Key? key,
    required this.itemsMap,
    this.design,
    this.currentIndex = 0,
    required this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  }) : super(key: key);

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.design == DESIGN_02){
      return BottomNavyBar(
        showElevation: true,
        backgroundColor: widget.backgroundColor,
        selectedIndex: widget.currentIndex,
        onItemSelected: widget.onTap,
        items: getBottomNavyBarItemsList(widget.itemsMap),
        curve: Curves.ease,
      );
    }else if(widget.design == DESIGN_03){
      return DotNavigationBar(
        backgroundColor: widget.backgroundColor,
        dotIndicatorColor: widget.selectedItemColor,
        selectedItemColor: widget.selectedItemColor!,
        unselectedItemColor: widget.unselectedItemColor,
        currentIndex: widget.currentIndex,
        onTap: widget.onTap,
        items: getDotNavigationBarItemsList(widget.itemsMap),
        borderRadius: 0,
        marginR: EdgeInsets.zero,
      );
    }

    return BottomNavigationBar(
      backgroundColor: widget.backgroundColor,
      selectedItemColor: widget.selectedItemColor,
      unselectedItemColor: widget.unselectedItemColor,
      currentIndex: widget.currentIndex,
      onTap: widget.onTap,
      type: BottomNavigationBarType.fixed, //For 4 or more items, set the type to fixed.
      items: getBottomNavigationBarItemsList(widget.itemsMap),
    );
  }

  List<BottomNavigationBarItem> getBottomNavigationBarItemsList(Map<String, dynamic> itemsMap){
    List<BottomNavigationBarItem> list = [];
    if(itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          BottomNavigationBarItem(
            icon: Icon(value),
            label: UtilityMethods.getLocalizedString(key),
          ),
        );
      });
    }
    return list;
  }

  List<BottomNavyBarItem> getBottomNavyBarItemsList(Map<String, dynamic> itemsMap){
    List<BottomNavyBarItem> list = [];
    if(itemsMap != null && itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          BottomNavyBarItem(
            icon: Icon(value, color: value == Icons.fiber_manual_record_outlined
                ? Colors.transparent : null,),
            title: GenericTextWidget(UtilityMethods.getLocalizedString(key)),
            activeColor: widget.selectedItemColor!,
            inactiveColor: widget.unselectedItemColor,
          ),
        );
      });
    }
    return list;
  }

  List<DotNavigationBarItem> getDotNavigationBarItemsList(Map<String, dynamic> itemsMap){
    List<DotNavigationBarItem> list = [];
    if(itemsMap != null && itemsMap.isNotEmpty){
      itemsMap.forEach((key, value) {
        list.add(
          DotNavigationBarItem(
            icon: Icon(value),
            selectedColor: widget.selectedItemColor!,
            unselectedColor: widget.unselectedItemColor,
          ),
        );
      });
    }
    return list;
  }
}