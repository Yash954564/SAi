import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';

class SavedSearchNoResultFoundWidget extends StatelessWidget {
  final bool showAppBar;

  const SavedSearchNoResultFoundWidget({
    Key? key,
    required this.showAppBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_saved_searches_found"),
      hideGoBackButton: !showAppBar,
    );
  }
}