import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';

const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

Future showModelBottomSheetWidget({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  double scrollControlDisabledMaxHeightRatio = _defaultScrollControlDisabledMaxHeightRatio,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
}) {
  return showModalBottomSheet(
    backgroundColor: backgroundColor ?? AppThemePreferences().appTheme.bottomSheetBgColor,
    shape: shape,
    context: context,
    useSafeArea: useSafeArea,
    builder: builder,
    anchorPoint: anchorPoint,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    clipBehavior: clipBehavior,
    constraints: constraints,
    elevation: elevation,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    routeSettings: routeSettings,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    showDragHandle: showDragHandle,
    transitionAnimationController: transitionAnimationController,
    useRootNavigator: useRootNavigator,
  );
}