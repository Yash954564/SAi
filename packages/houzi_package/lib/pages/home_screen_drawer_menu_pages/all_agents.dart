import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_description_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_image_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_name_widget.dart';
import 'package:houzi_package/widgets/realtor_widgets/realtor_position_widget.dart';
import 'package:houzi_package/widgets/show_dialog_for_search.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllAgents extends StatefulWidget {
  const AllAgents({super.key});

  @override
  _AllAgentsState createState() => _AllAgentsState();
}

class _AllAgentsState extends State<AllAgents> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<dynamic> agentsList = [];
  Future<List<dynamic>>? _futureAgentsList;

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
      _futureAgentsList = fetchAgentsInfo(page, forSearch, agentSearchMap);
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
      _futureAgentsList = fetchAgentsInfo(page, forSearch, agentSearchMap);
      _refreshController.loadComplete();
    }
  }

  Future<List<dynamic>> fetchAgentsInfo(int page, bool forSearch,Map? agentSearchMap) async {
    List<dynamic> tempList = [];
    if (page == 1) {
      if (mounted) {
        setState(() {
          shouldLoadMore = true;
        });
      }
    }
    if (forSearch && agentSearchMap != null) {
      List list = await _propertyBloc.fetchSearchAgentsList(
        page,
        perPage,
        agentSearchMap[SEARCH_KEYWORD],
        agentSearchMap[AGENT_SEARCH_CITY],
        agentSearchMap[AGENT_SEARCH_CATEGORY],
      );
      tempList = list[0];
    } else {
      List list = await _propertyBloc.fetchAllAgentsInfoList(page, perPage);
      tempList = list[0];
    }

    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return agentsList;
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
        agentsList.clear();
      }
      if (tempList.isNotEmpty) {
        agentsList.addAll(tempList);
      }
    }

    return agentsList;
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
        appBarTitle: UtilityMethods.getLocalizedString("agents"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: Icon(
                  AppThemePreferences.searchIcon,
                  color: AppThemePreferences().appTheme.genericAppBarIconsColor,
                ),
                onPressed: () => searchDialog(true,null),
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
              child: buildAgentsList(context, _futureAgentsList!),
            ),
          ),
          if (_refreshController.isLoading)
            paginationLoadingWidget(),
          if (showSearchDialog)
            ShowSearchDialog(
              fromAgent: true,
              searchDialogPageListener: (bool showDialog, Map<String, dynamic>? agentSearchMap) {
                searchDialog(showDialog, agentSearchMap);
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

  Widget buildAgentsList(BuildContext context, Future<List<dynamic>> futureAgentsList) {
    return FutureBuilder<List<dynamic>>(
        future: futureAgentsList,
        builder: (context, articleSnapshot) {
          isLoading = false;
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data!.isEmpty) {
              return noResultFoundPage();
            } else if (articleSnapshot.data!.isNotEmpty) {
              List agentsList = articleSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: agentsList.length,
                  itemBuilder: (context, index) {
                    var item = agentsList[index];
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
                              realtorType: AGENT_INFO,
                              realtorInfo: {
                                AGENT_DATA: item,
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
                                    tag: AGENTS_TAG,
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
                                        RealtorNameWidget(title: item.title, tag: AGENTS_TAG),
                                        RealtorPositionWidget(position: "${item.agentPosition}"),
                                        RealtorNameWidget(title: "${item.agentCompany}",tag: AGENTS_TAG),
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

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_agents_found"),
    );
  }

  void navigateToRealtorInformationDisplayPage({
    required String heroId,
    required Map<String, dynamic> realtorInfo,
    required String realtorType,
  }) {
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
