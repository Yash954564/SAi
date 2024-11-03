import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'add_new_deal_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'deal_detail_page.dart';

class DealsFromBoard extends StatefulWidget {
  @override
  _DealsFromBoardState createState() => _DealsFromBoardState();
}

class _DealsFromBoardState extends State<DealsFromBoard> with TickerProviderStateMixin {
  final CRMRepository _crmRepository = CRMRepository();

  List<dynamic> activeDealsFromBoardList = [];
  List<dynamic> wonDealsFromBoardList = [];
  List<dynamic> lostDealsFromBoardList = [];

  Future<List<dynamic>>? _futureActiveDealsFromBoard;
  Future<List<dynamic>>? _futureWonDealsFromBoard;
  Future<List<dynamic>>? _futureLostDealsFromBoard;

  final RefreshController _refreshActiveController = RefreshController(initialRefresh: false);
  final RefreshController _refreshWonController = RefreshController(initialRefresh: false);
  final RefreshController _refreshLostController = RefreshController(initialRefresh: false);

  TabController? _tabController;

  bool isActiveDealsLoaded = true;
  bool isWonDealsLoaded = true;
  bool isLostDealsLoaded = true;
  bool isRefreshing = false;
  bool activeDealShouldLoadMore = true;
  bool wonDealShouldLoadMore = true;
  bool lostDealShouldLoadMore = true;
  bool activeDealIsLoading = false;
  bool wonDealIsLoading = false;
  bool lostDealIsLoading = false;

  int activeDealPage = 1;
  int wonDealPage = 1;
  int lostDealPage = 1;
  int perPage = 10;

  String tab = ACTIVE_OPTION;
  String action = "";
  String status = "";

  double bottomPadding = 9.0;

  @override
  void initState() {
    super.initState();
    // checkInternetAndLoadData();
    _tabController = TabController(length: 3, vsync: this);
    loadActiveDealDataFromApi();
    loadWonDealDataFromApi();
    loadLostDealDataFromApi();
  }

  checkInternetAndLoadData() {
    if (mounted) {
      setState(() {
        if (!isActiveDealsLoaded) {
          activeDealIsLoading = false;
          loadActiveDealDataFromApi();
        }
        if (!isWonDealsLoaded) {
          wonDealIsLoading = false;
          loadWonDealDataFromApi();
        }
        if (!isLostDealsLoaded) {
          lostDealIsLoading = false;
          loadLostDealDataFromApi();
        }
      });
    }
  }

  loadActiveDealDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (activeDealIsLoading) {
        return;
      }
      if(mounted){
        setState(() {
          activeDealIsLoading = true;
        });
      }

      activeDealPage = 1;
      _futureActiveDealsFromBoard = fetchDealsFromBoard(activeDealPage, ACTIVE_OPTION);
      _refreshActiveController.refreshCompleted();
    } else {
      if (!activeDealShouldLoadMore || activeDealIsLoading) {
        _refreshActiveController.loadComplete();
        return;
      }
      if(mounted){
        setState(() {
          activeDealIsLoading = true;
        });
      }

      activeDealPage++;
      _futureActiveDealsFromBoard = fetchDealsFromBoard(activeDealPage, ACTIVE_OPTION);
      _refreshActiveController.loadComplete();

    }
  }

  loadWonDealDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (wonDealIsLoading) {
        return;
      }
      if(mounted){
        setState(() {
          wonDealIsLoading = true;
        });
      }

      wonDealPage = 1;
      _futureWonDealsFromBoard = fetchDealsFromBoard(wonDealPage, WON_OPTION);
      _refreshWonController.refreshCompleted();
    } else {
      if (!wonDealShouldLoadMore || wonDealIsLoading) {
        _refreshWonController.loadComplete();
        return;
      }
      if(mounted){
        setState(() {
          wonDealIsLoading = true;
        });
      }
      wonDealPage++;
      _futureWonDealsFromBoard = fetchDealsFromBoard(wonDealPage, WON_OPTION);
      _refreshWonController.loadComplete();

    }
  }

  loadLostDealDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (lostDealIsLoading) {
        return;
      }
      if(mounted){
        setState(() {
          lostDealIsLoading = true;
        });
      }

      lostDealPage = 1;
      _futureLostDealsFromBoard = fetchDealsFromBoard(lostDealPage, LOST_OPTION);
      _refreshLostController.refreshCompleted();
    } else {
      if (!lostDealShouldLoadMore || lostDealIsLoading) {
        _refreshLostController.loadComplete();
        return;
      }
      if(mounted){
        setState(() {
          lostDealIsLoading = true;
        });
      }
      lostDealPage++;
      _futureLostDealsFromBoard = fetchDealsFromBoard(lostDealPage, LOST_OPTION);
      _refreshLostController.loadComplete();

    }
  }

  Future<List<dynamic>> fetchDealsFromBoard(int page, String tab) async {
    if (tab == ACTIVE_OPTION) {
      if (page == 1) {
        setState(() {
          activeDealShouldLoadMore = true;
        });
      }
      Map<String, dynamic> map = await _crmRepository.fetchDealsFromBoard(page, perPage, tab);
      List<dynamic>? tempList = map["list"];
      if (map["actions"] != null && map["actions"].isNotEmpty) {
        action = map["actions"];
      }
      if (map["status"] != null && map["status"].isNotEmpty) {
        status = map["status"];
      }
      if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isActiveDealsLoaded = false;
          });
        }
        return activeDealsFromBoardList;
      }else{
        if(mounted){
          setState(() {
            isActiveDealsLoaded = true;
          });
        }
        if(tempList.isEmpty || tempList.length < perPage){
          if(mounted){
            setState(() {
              activeDealShouldLoadMore = false;
            });
          }
        }

        if (page == 1) {
          activeDealsFromBoardList.clear();
        }
        if (tempList.isNotEmpty) {
          activeDealsFromBoardList.addAll(tempList);
        }
      }
      return activeDealsFromBoardList;
    } else if (tab == WON_OPTION) {
      if (page == 1) {
        setState(() {
          wonDealShouldLoadMore = true;
        });
      }
      Map<String, dynamic> map = await _crmRepository.fetchDealsFromBoard(page, perPage, tab);

      List<dynamic>? tempList = map["list"];
      // if (map["action"] != null && map["action"].isNotEmpty) {
      //   action = map["action"];
      // }
      // if (map["status"] != null && map["status"].isNotEmpty) {
      //   action = map["action"];
      // }

      if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isWonDealsLoaded = false;
          });
        }
        return wonDealsFromBoardList;
      }else {
        if (mounted) {
          setState(() {
            isWonDealsLoaded = true;
          });
        }
        if(tempList.isEmpty || tempList.length < perPage){
          if(mounted){
            setState(() {
              wonDealShouldLoadMore = false;
            });
          }
        }

        if (page == 1) {
          wonDealsFromBoardList.clear();
        }
        if (tempList.isNotEmpty) {
          wonDealsFromBoardList.addAll(tempList);
        }
      }
      return wonDealsFromBoardList;
    } else  {
      if (page == 1) {
        setState(() {
          lostDealShouldLoadMore = true;
        });
      }
      Map<String, dynamic> map = await _crmRepository.fetchDealsFromBoard(page, perPage, tab);
      List<dynamic>? tempList = map["list"];
      // if (map["action"] != null && map["action"].isNotEmpty) {
      //   action = map["action"];
      // }
      // if (map["status"] != null && map["status"].isNotEmpty) {
      //   action = map["action"];
      // }
      if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isLostDealsLoaded = false;
          });
        }
        return lostDealsFromBoardList;
      }else {
        if (mounted) {
          setState(() {
            isLostDealsLoaded = true;
          });
        }
        if(tempList.isEmpty || tempList.length < perPage){
          if(mounted){
            setState(() {
              lostDealShouldLoadMore = false;
            });
          }
        }

        if (page == 1) {
          lostDealsFromBoardList.clear();
        }
        if (tempList.isNotEmpty) {
          lostDealsFromBoardList.addAll(tempList);
        }
      }

      return lostDealsFromBoardList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: widgetAppBar(),
        body: TabBarView(
          controller: _tabController,
          children: [
            isActiveDealsLoaded == false
                ? noInternetWidget()
                : Stack(
                  children: [
                    showDealsList(
                        context,
                        _futureActiveDealsFromBoard!,
                        ACTIVE_OPTION,
                        _refreshActiveController,
                        loadActiveDealDataFromApi,
                    ),
                    if (_refreshActiveController.isLoading)
                      const CRMPaginationLoadingWidget(),
                  ],
                ),
            isWonDealsLoaded == false
                ? noInternetWidget()
                : Stack(
                    children: [
                      showDealsList(
                        context,
                        _futureWonDealsFromBoard!,
                        WON_OPTION,
                        _refreshWonController,
                        loadWonDealDataFromApi,
                      ),
                      if (_refreshWonController.isLoading)
                        const CRMPaginationLoadingWidget(),
                    ],
                  ),
            isLostDealsLoaded == false
                ? noInternetWidget()
                : Stack(
                    children: [
                      showDealsList(
                        context,
                        _futureLostDealsFromBoard!,
                        LOST_OPTION,
                        _refreshLostController,
                        loadLostDealDataFromApi,
                      ),
                      if (_refreshLostController.isLoading)
                        const CRMPaginationLoadingWidget(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget noInternetWidget(){
    return Align(
      alignment: Alignment.topCenter,
      child: NoInternetConnectionErrorWidget(onPressed: (){
        checkInternetAndLoadData();
      }),
    );
  }

  Widget showDealsList(
    BuildContext context,
    Future<List<dynamic>> futureDealsFromBoard,
    String option,
    RefreshController refreshController,
    void Function({bool forPullToRefresh}) loadData,
  ) {
    return FutureBuilder<List<dynamic>>(
      future: futureDealsFromBoard,
      builder: (context, articleSnapshot) {
        if (option == ACTIVE_OPTION) {
          activeDealIsLoading = false;
        } else if (option == WON_OPTION) {
          wonDealIsLoading = false;
        } else {
          lostDealIsLoading = false;
        }

        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          }

          List<dynamic> list = articleSnapshot.data!;
          return Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body = Container();
                  if (mode == LoadStatus.loading) {
                    if (option == ACTIVE_OPTION) {
                      if (activeDealShouldLoadMore) {
                        body = paginationLoadingWidget();
                      } else {
                        body = Container();
                      }
                    } else if (option == WON_OPTION) {
                      if (wonDealShouldLoadMore) {
                        body = paginationLoadingWidget();
                      } else {
                        body = Container();
                      }
                    } else {
                      if (lostDealShouldLoadMore) {
                        body = paginationLoadingWidget();
                      } else {
                        body = Container();
                      }
                    }
                  }
                  return SizedBox(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              header: const MaterialClassicHeader(),
              controller: refreshController,
              onRefresh: loadData,
              onLoading: () => loadData(forPullToRefresh: false),
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  CRMDealsAndLeads deal = list[index];

                  Map<String, String> dealDetailMap = {
                    DEAL_DETAIL_TITLE: "${list[index].title}",
                    DEAL_GROUP: "${list[index].dealGroup}",
                    DEAL_DETAIL_ID: "${list[index].dealId}",
                    DEAL_DETAIL_DISPLAY_NAME: "${list[index].displayName}",
                    DEAL_AGENT_ID: "${list[index].agentId}",
                    DEAL_CONTACT_NAME_ID: "${list[index].resultLeadId}",
                    DEAL_DETAIL_AGENT_NAME: "${list[index].agentName}",
                    DEAL_DETAIL_ACTION_DUE_DATE: "${list[index].actionDueDate}",
                    DEAL_DETAIL_VALUE: "${list[index].dealValue}",
                    DEAL_DETAIL_EMAIL: "${list[index].email}",
                    DEAL_DETAIL_LAST_CONTACT_DATE: "${list[index].lastContactDate}",
                    DEAL_DETAIL_NEXT_ACTION: "${list[index].nextAction}",
                    DEAL_DETAIL_PHONE: "${list[index].mobile}",
                    DEAL_DETAIL_STATUS: "${list[index].resultStatus}",
                  };

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      elevation: AppThemePreferences.boardPagesElevation,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DealDetailPage(
                                index: index,
                                deal: deal,
                                status: status,
                                action: action,
                                dealDetailMap: dealDetailMap,
                                dealDetailPageListener: (
                                    {int? index,
                                      bool? refresh,
                                      String? dealOption}) {
                                  if (refresh!) {
                                    if (dealOption == "active") {
                                      loadActiveDealDataFromApi();
                                    } else if (dealOption == "won") {
                                      loadWonDealDataFromApi();
                                    } else {
                                      loadLostDealDataFromApi();
                                    }
                                  } else {
                                    if (index != null) {
                                      list.removeAt(index);
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CRMTypeHeadingWidget("deal", deal.resultTime),
                              CRMHeadingWidget(deal.title),
                              CRMContactDetail(
                                deal.displayName,
                                deal.email,
                                deal.mobile,
                                () => takeActionBottomSheet(
                                  context, false, deal.email,
                                ),
                                () => takeActionBottomSheet(
                                  context, true, deal.mobile,
                                ),
                              ),
                              CRMIconAndText(AppThemePreferences.agentsIcon, deal.agentName),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
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
      child: SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("oops_deals_not_exist"),
    );
  }

  PreferredSizeWidget widgetAppBar() {
    return AppBarWidget(
      appBarTitle: UtilityMethods.getLocalizedString("deals"),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        tabs: [
          Tab(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("active"),
              style:  AppThemePreferences().appTheme.genericTabBarTextStyle,
            ),
          ),
          Tab(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("won"),
              style:  AppThemePreferences().appTheme.genericTabBarTextStyle,
            ),
          ),
          Tab(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("lost"),
              style:  AppThemePreferences().appTheme.genericTabBarTextStyle,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(
              AppThemePreferences.addIcon,
              color: AppThemePreferences.genericAppBarIconsColorLight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewDeal(
                    forEditDeal: false,
                    dealDetailMap: const {},
                    addNewDealPageListenerPageListener:
                        (bool refresh, String option) {
                      if (refresh) {
                        if (option == "active") {
                          loadActiveDealDataFromApi();
                        } else if (option == "won") {
                          loadWonDealDataFromApi();
                        } else {
                          loadLostDealDataFromApi();
                        }
                      }
                    },
                  ),
                ),
              );
            },
          ),
        )
      ],
    );

  }

  Widget paginationLoadingWidget() {
    return Container(
      color: Theme.of(context).canvasColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 50,
            child: BallRotatingLoadingWidget(),
          ),
        ],
      ),
    );
  }

}
