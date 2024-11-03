import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class DemoExpired extends StatefulWidget {
  DemoExpired();

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<DemoExpired> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        body: noResultFoundPage(),
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      showBackNavigationIcon: false,
      hideGoBackButton: true,
      headerErrorText: UtilityMethods.getLocalizedString("demo_version_expired"),
      bodyErrorText: UtilityMethods.getLocalizedString("contact_developer_for_latest_version"),
    );
  }
}
