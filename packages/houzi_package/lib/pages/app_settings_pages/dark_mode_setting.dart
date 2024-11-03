import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/files/theme_service_files/theme_storage_manager.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/generic_radio_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class DarkModeSettings extends StatefulWidget {
  final bool? showBackButton;

  const DarkModeSettings({
    super.key,
    this.showBackButton = true,
  });


  @override
  State<StatefulWidget> createState() => DarkModeSettingsState();
}

class DarkModeSettingsState extends State<DarkModeSettings> {

  int _darkModeSelectedOption = 1;

  @override
  void initState() {
    super.initState();

    String themeMode = LIGHT_THEME_MODE;

    if (ThemeStorageManager.readData(THEME_MODE_INFO) == null) {
      // if user has not selected any theme mode, first read theme mode from the
      // hook if available, else assign LIGHT THEME MODE as default mode.
      DefaultAppThemeModeHook defaultAppThemeModeHook = HooksConfigurations.defaultAppThemeModeHook;
      if (defaultAppThemeModeHook != null) {
        String? themeModeHook = defaultAppThemeModeHook();
        if (themeModeHook == 'dark') {
          themeMode = DARK_THEME_MODE;
        } else if (themeModeHook == 'system') {
          themeMode = SYSTEM_THEME_MODE;
        } else {
          themeMode = LIGHT_THEME_MODE;
        }
      }
    } else {
      themeMode = ThemeStorageManager.readData(THEME_MODE_INFO);
    }


    if (mounted) {
      setState(() {
        if (themeMode == DARK_THEME_MODE) {
          _darkModeSelectedOption = 0;
        } else if (themeMode == SYSTEM_THEME_MODE) {
          _darkModeSelectedOption = 2;
        }  else {
          _darkModeSelectedOption = 1;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, theme, child) {
      return Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("dark_mode_settings"),
          automaticallyImplyLeading: widget.showBackButton != null && widget.showBackButton! ? true : false,
        ),
        body: Column(
          children: [
            GenericRadioListTile(
              title: UtilityMethods.getLocalizedString("on"),
              value: 0,
              groupValue: _darkModeSelectedOption,
              onChanged: (value) => setTheme(theme, value),
            ),
            GenericRadioListTile(
              title: UtilityMethods.getLocalizedString("off"),
              value: 1,
              groupValue: _darkModeSelectedOption,
              onChanged: (value) => setTheme(theme, value),
            ),
            GenericRadioListTile(
              title: UtilityMethods.getLocalizedString("use_system_settings"),
              subtitle: UtilityMethods.getLocalizedString("we_ll_adjust_your_appearance_based_on_your_device_system_settings"),
              value: 2,
              groupValue: _darkModeSelectedOption,
              onChanged: (value) => setTheme(theme, value),
            ),
          ],
        ),
      );
    });
  }

  void setTheme(ThemeNotifier theme, dynamic value){
    if (value == 0) {
      theme.setDarkMode();
    } else if (value == 1) {
      theme.setLightMode();
    } else if (value == 2) {
      theme.setSystemThemeMode();
    }

    if (mounted) {
      setState(() {
        _darkModeSelectedOption = value;
      });
    }
  }
}

