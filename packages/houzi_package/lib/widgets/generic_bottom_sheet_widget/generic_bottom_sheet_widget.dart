import 'package:flutter/material.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

Future genericBottomSheetWidget({
  required BuildContext context,
  required List<Widget> children,

  ShapeBorder shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
      ),
  ),

}){
  return showModelBottomSheetWidget(
      shape: shape,
      context: context,
      useSafeArea: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 30),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: children,
            ),
          ),
        );
      },
  );
}

class GenericBottomSheetTitleWidget extends StatelessWidget {
  final String title;
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;

  const GenericBottomSheetTitleWidget({
    super.key,
    required this.title,
    this.textAlign = TextAlign.center,
    this.style,
    this.padding = const EdgeInsets.all(0.0),
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GenericTextWidget(
                  title,
                  textAlign: textAlign,
                  strutStyle: StrutStyle(height: AppThemePreferences.bottomSheetMenuTitle01TextHeight),
                  style: style ?? AppThemePreferences().appTheme.bottomSheetMenuTitle01TextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class GenericBottomSheetSubTitleWidget extends StatelessWidget {
  final String subTitle;
  final TextAlign textAlign;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;
  final Decoration? decoration;

  const GenericBottomSheetSubTitleWidget({
    super.key,
    required this.subTitle,
    this.textAlign = TextAlign.center,
    this.style,
    this.padding = const EdgeInsets.all(0.0),
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GenericTextWidget(
                    subTitle,
                    textAlign: textAlign,
                    style: style ?? AppThemePreferences().appTheme.bottomSheetMenuSubTitleTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class GenericBottomSheetOptionWidget extends StatelessWidget {
  final String label;
  final TextStyle? style;
  final bool showDivider;
  final void Function() onPressed;

  const GenericBottomSheetOptionWidget({
    super.key,
    required this.label,
    this.style,
    this.showDivider = true,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Container(
        child: TextButtonWidget(
          onPressed: onPressed,
          child: GenericTextWidget(
            label,
            style: style ?? AppThemePreferences().appTheme.heading02TextStyle,
          ),
        ),
        decoration: !showDivider ? null : AppThemePreferences.dividerDecoration(),
      ),
    );
  }
}

class GenericBottomSheetTitleWidget01 extends StatelessWidget {
  final String title;

  const GenericBottomSheetTitleWidget01({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Row(
        children: [
          Expanded(flex: 0, child: Container()),
          Expanded(child: Center(
            child: GenericTextWidget(
              title,
              style: AppThemePreferences().appTheme.heading03TextStyle,
            ),
          ),
          ),
          Expanded(flex: 0, child: IconButton(
            icon: Icon(AppThemePreferences.closeIcon),
            onPressed: (){
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }
}

class GenericBottomSheetOptionsWidget01 extends StatelessWidget {
  final String label;
  final void Function() onPressed;
  final bool showDivider;

  const GenericBottomSheetOptionsWidget01({
    super.key,
    required this.label,
    required this.onPressed,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(3),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Container(
          padding: EdgeInsets.only(
            top: 25,
            left: UtilityMethods.isRTL(context) ? 0 : 20,
            right: UtilityMethods.isRTL(context) ? 20 : 0,
          ),
          decoration: !showDivider ? null : AppThemePreferences.dividerDecoration(),
          child: GenericTextWidget(
            label,
            style: AppThemePreferences().appTheme.bottomSheetOptionsTextStyle,
          ),
        ),
      ),
    );
  }
}
