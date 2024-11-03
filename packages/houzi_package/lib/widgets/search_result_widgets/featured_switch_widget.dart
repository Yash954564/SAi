import 'package:flutter/cupertino.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef FeaturedSwitchDialogListener = void Function(bool switchValue);

class FeaturedSwitchDialog extends StatefulWidget{

  final String title;
  final bool showFeatured;
  final FeaturedSwitchDialogListener listener;

  const FeaturedSwitchDialog({
    Key? key,
    required this.title,
    required this.showFeatured,
    required this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FeaturedSwitchDialogState();

}

class FeaturedSwitchDialogState extends State<FeaturedSwitchDialog> {

  bool _showFeatured = false;

  @override
  void initState() {
    super.initState();
    _showFeatured = widget.showFeatured;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialogWidget(
      title: GenericTextWidget(widget.title),
      titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppThemePreferences().appTheme.dividerColor!,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: UtilityMethods.isRTL(context) ? 0 : 8,
                        right: UtilityMethods.isRTL(context) ? 8 : 0,
                      ),
                      child: GenericTextWidget(
                        "Show Featured Listings",
                        style: AppThemePreferences().appTheme.filterPageHeadingTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: CupertinoSwitch(
                      value: _showFeatured,
                      activeColor: AppThemePreferences().appTheme.primaryColor,
                      onChanged: (bool value) => onUpdateValue(value),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.fromLTRB(
          UtilityMethods.isRTL(context) ? 15 : 5, 5, 5, 10),
      actions: <Widget>[
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          onPressed: ()=> Navigator.pop(context),
        ),
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("ok")),
          onPressed: () {
            widget.listener(_showFeatured);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void onUpdateValue(bool value) {
    if (mounted) {
      setState(() {
        _showFeatured = !_showFeatured;
      });
    }
  }
}