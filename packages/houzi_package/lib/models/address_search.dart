import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/api_providers/place_api_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  AddressSearch(this.sessionToken, {this.forKeyWordSearch = false})
      : super(keyboardType: TextInputType.text) {
    if (!forKeyWordSearch) {
      apiClient = PlaceApiProvider(sessionToken);
    }
  }

  @override
  TextInputAction get textInputAction {
    return forKeyWordSearch ? TextInputAction.search : TextInputAction.done;
  }

  final sessionToken;
  final bool forKeyWordSearch;
  PlaceApiProvider? apiClient;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: UtilityMethods.getLocalizedString("delete"),
        icon: Icon(AppThemePreferences.closeIcon),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: UtilityMethods.getLocalizedString("back"),
      icon: Icon(AppThemePreferences.arrowBackIcon),
      onPressed: () {
        close(context,
            forKeyWordSearch ? Suggestion(query, query) : Suggestion("", ""));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: ListTile(
        title: GestureDetector(
          onTap: () {
            if (forKeyWordSearch) {
              close(context, Suggestion(query, query));
            }
          },
          child: GenericTextWidget(query,
              style: AppThemePreferences().appTheme.heading01TextStyle),
        ),
      ),
    );
    // return null;
  }

  @override
  void showResults(BuildContext context) {
    if (forKeyWordSearch) {
      close(context, Suggestion(query, query));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return forKeyWordSearch
        ? Container()
        : FutureBuilder(
            future: query == "" ? null : apiClient!.fetchSuggestions(query),
            builder: (context, snapshot) {
              return query == ''
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                    )
                  : snapshot.hasData
                      ? ListView.builder(
                          itemBuilder: (context, index) => ListTile(
                            title: GenericTextWidget(
                                (snapshot.data![index]).description!),
                            onTap: () {
                              close(context, snapshot.data![index]);
                            },
                          ),
                          itemCount: snapshot.data!.length,
                        )
                      : Container();
            },
          );
  }
}
