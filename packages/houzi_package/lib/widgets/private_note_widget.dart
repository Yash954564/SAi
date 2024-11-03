import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'app_bar_widget.dart';

class PrivateNoteWidget extends StatelessWidget {
  final String privateNote;

  const PrivateNoteWidget(this.privateNote, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("Private Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GenericTextWidget(
            privateNote,
            strutStyle: StrutStyle(height: 2.0, forceStrutHeight: true),
            style: AppThemePreferences().appTheme.privateNoteTextStyle,
          ),
        ),
      ),
    );
  }
}
