import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_description_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_image_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_name_widget.dart';
import 'package:houzi_package/widgets/show_dialog_for_search.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllAgency extends StatefulWidget {
  @override
  _AllAgencyState createState() => _AllAgencyState();
}

class _AllAgencyState extends State<AllAgency> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<dynamic>>? _futureAgenciesList;
  List<dynamic> agenciesList = [];

  bool isLoading = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool showSearchDialog = false;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 10;

  @override
  void initState() {
    super.initState();
    loadDataFromApi(false, null);
  }

  checkInternetAndLoadData() {
    loadDataFromApi(false, null);
  }

  loadDataFromApi(bool forSearch,Map? agentSearchMap,{bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      if (mounted) {
        setState(() {
          isRefreshing = true;
          isLoading = true;
        });
      }

      page = 1;
      _futureAgenciesList = fetchAllAgenciesInfo(page, forSearch, agentSearchMap);
      _refreshController.refreshCompleted();
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
      if (mounted) {
        setState(() {
          isRefreshing = false;
          isLoading = true;
        });
      }
      page++;
      _futureAgenciesList = fetchAllAgenciesInfo(page, forSearch, agentSearchMap);
      _refreshController.loadComplete();
    }
  }


  Future<List<dynamic>> fetchAllAgenciesInfo(int page, bool forSearch,Map? searchMap) async {
    List<dynamic> tempList = [];
    if (page == 1) {
      if (mounted) {
        setState(() {
          shouldLoadMore = true;
        });
      }
    }
    if (forSearch && searchMap != null) {
      List list = await _propertyBloc.fetchSearchAgenciesList(
        page,
        perPage,
        searchMap[SEARCH_KEYWORD],
      );
      tempList = list[0];
    } else {
      List list = await _propertyBloc.fetchAllAgenciesInfoList(page, perPage);
      tempList = list[0];
    }

    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return agenciesList;
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }

      if (tempList.isEmpty || tempList.length < perPage) {
        if (mounted) {
          setState(() {
            shouldLoadMore = false;
          });
        }
      }

      if (page == 1) {
        agenciesList.clear();
      }
      if (tempList.isNotEmpty) {
        agenciesList.addAll(tempList);
      }
    }

    return agenciesList;
  }

  void searchDialog(bool showDialog, Map? searchMap) {
    setState(() {
      showSearchDialog = showDialog;
    });

    if (searchMap != null) {
      loadDataFromApi(true, searchMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("agency"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(
                AppThemePreferences.searchIcon,
                color: AppThemePreferences().appTheme.genericAppBarIconsColor,
              ),
              onPressed: () => searchDialog(true, null),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () => loadDataFromApi(false, null),
            onLoading: () => loadDataFromApi(false, null, forPullToRefresh: false),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget? body;
                if (mode == LoadStatus.loading) {
                  if (shouldLoadMore) {
                    body = paginationLoadingWidget();
                  } else {
                    body = Container();
                  }
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: buildAgenciesList(context, _futureAgenciesList!),
            ),
          ),
          if (_refreshController.isLoading)
            paginationLoadingWidget(),
          if (showSearchDialog)
            ShowSearchDialog(
              fromAgent: false,
              searchDialogPageListener: (bool showDialog, Map<String, dynamic>? searchMap) {
                searchDialog(showDialog, searchMap);
              },
            ),
          if (isInternetConnected == false) Align(
            alignment: Alignment.topCenter,
            child: NoInternetConnectionErrorWidget(onPressed: () {
              checkInternetAndLoadData();
            }),
          )
        ],
      ),
    );
  }

  Widget buildAgenciesList(BuildContext context, Future<List<dynamic>> futureAgenciesList) {
    return FutureBuilder<List<dynamic>>(
      future: futureAgenciesList,
      builder: (context, articleSnapshot) {
        isLoading = false;
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          } else if (articleSnapshot.data!.isNotEmpty) {
            List agenciesList = articleSnapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: agenciesList.length,
                itemBuilder: (context, index) {
                  var item = agenciesList[index];
                  String stringContent = UtilityMethods.stripHtmlIfNeeded(item.content);
                  String heroId = HERO + item.id.toString() + "al";
                  return Container(
                    padding: const EdgeInsets.only(bottom: 10, right: 5),
                    child: CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.realtorPageRoundedCornersRadius),
                      elevation: AppThemePreferences.agentAgencyPageElevation,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onTap: () {
                          navigateToRealtorInformationDisplayPage(
                            heroId: heroId,
                            realtorType: AGENCY_INFO,
                            realtorInfo: {
                              AGENCY_DATA : item,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: RealtorImageWidget(
                                  tag: AGENCIES_TAG,
                                  heroId: heroId,
                                  imageUrl: item.thumbnail,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RealtorNameWidget(title: item.title, tag: AGENCIES_TAG),
                                      RealtorDescriptionWidget(description: stringContent.replaceFirst("\n", "")),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }
        return loadingIndicatorWidget();
      },
    );
  }

  Widget loadingIndicatorWidget() {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }


  void navigateToRealtorInformationDisplayPage(
      {required String heroId,
      required Map<String, dynamic> realtorInfo,
      required String realtorType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealtorInformationDisplayPage(
          heroId: heroId,
          realtorInformation: realtorInfo,
          agentType: realtorType,
        ),
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_agencies_found"),
    );
  }

  Widget paginationLoadingWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const SizedBox(
        width: 60,
        height: 50,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }

}
