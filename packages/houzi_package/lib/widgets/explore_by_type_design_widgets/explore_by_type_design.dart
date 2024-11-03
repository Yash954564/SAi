import 'package:flutter/cupertino.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design_01.dart';
import 'package:houzi_package/widgets/explore_by_type_design_widgets/explore_by_type_design_02.dart';

class ExploreByTypeDesign{
  Widget getExploreByTypeDesign({
    required String design,
    required BuildContext buildContext,
    required List<dynamic> metaDataList,
    bool isInMenu = false,
    required Function(String, String) onTap,
    String listingView = homeScreenWidgetsListingCarouselView,
    // Function(Map<String, dynamic>) onTap,
  }){

    TermItemHook termItemHook = HooksConfigurations.termItem;
    if (termItemHook(metaDataList) != null) {
      return termItemHook(metaDataList)!;
    }

    if (design == DESIGN_01) {
      return exploreByTypeDesign01(
        context: buildContext,
        data: metaDataList,
        isInMenu: isInMenu,
        onTap: onTap,
      );
    }
    if (design == DESIGN_02) {
      return exploreByTypeDesign02(
        context: buildContext,
        data: metaDataList,
        isInMenu: isInMenu,
        onTap: onTap,
        listingView: listingView,
      );
    }

    return exploreByTypeDesign01(
      context: buildContext,
      data: metaDataList,
      isInMenu: isInMenu,
      onTap: onTap,
    );
  }

  double getExploreByTypeDesignHeight({required String design}){
    if(design == DESIGN_01){
      return 430;
    }
    if(design == DESIGN_02){
      return 210; //210
    }

    return 430;
  }
}