import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PaginationLoadingWidget extends StatelessWidget {
  final bool infiniteStop;
  final bool isAtBottom;
  final bool hasBottomNavigationBar;

  const PaginationLoadingWidget({
    Key? key,
    required this.infiniteStop,
    required this.isAtBottom,
    required this.hasBottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (!infiniteStop) && isAtBottom ? Container(
      color: AppThemePreferences().appTheme.backgroundColor,
      padding: EdgeInsets.only(top: 20, bottom: hasBottomNavigationBar ? 60 : 10),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: AppThemePreferences.paginationLoadingWidgetWidth,
        height: AppThemePreferences.paginationLoadingWidgetHeight,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [AppThemePreferences().appTheme.primaryColor!],
        ),
      ),
    ) : Container();
  }
}
