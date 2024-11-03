import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class NoInternetBottomActionBarWidget extends StatelessWidget {
  final void Function()? onPressed;
  final bool showRetryButton;

  const NoInternetBottomActionBarWidget({
    Key? key,
    this.onPressed,
    this.showRetryButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showRetryButton){
      return WidgetWithRetryButton(onPressed: onPressed);
    }else{
      return WidgetWithoutRetryButton();
    }
  }
}

class WidgetWithoutRetryButton extends StatelessWidget {
  const WidgetWithoutRetryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      color: AppThemePreferences.noInternetBottomActionBarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("no_internet_connection_error_message_02"),
                style: AppThemePreferences().appTheme.toastTextTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WidgetWithRetryButton extends StatelessWidget {
  final void Function()? onPressed;

  const WidgetWithRetryButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      width: MediaQuery.of(context).size.width,
      color: AppThemePreferences.noInternetBottomActionBarBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("no_internet_connection_error_message_02"),
                style: AppThemePreferences().appTheme.toastTextTextStyle,
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString("retry"),
                    textAlign: TextAlign.center,
                    style: AppThemePreferences().appTheme.toastTextTextStyle,
                  ),
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: AppThemePreferences.noInternetBottomActionBarBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(width: 2, color: Colors.white.withOpacity(0.4)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
