import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'add_new_lead_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'lead_detail_page.dart';

class LeadsFromBoard extends StatefulWidget {
  const LeadsFromBoard({super.key});

  @override
  _LeadsFromBoardState createState() => _LeadsFromBoardState();
}

class _LeadsFromBoardState extends State<LeadsFromBoard> {
  final CRMRepository _crmRepository = CRMRepository();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<dynamic> leadsFromBoardList = [];
  Future<List<dynamic>>? _futureLeadsFromBoard;

  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isLoading = false;
  bool isInternetConnected = true;

  int? userId;
  int page = 1;
  int perPage = 10;

  double bottomPadding = 9.0;

  @override
  void initState() {
    super.initState();
    isRefreshing = true;
    loadDataFromApi();
  }

  checkInternetAndLoadData(){
    // InternetConnectionChecker().checkInternetConnection().then((value){
    //   if(value){
    //     setState(() {
    //       isInternetConnected = true;
    //     });
    //     isRefreshing = true;
    //     loadDataFromApi();
    //   }else{
    //     setState(() {
    //       isInternetConnected = false;
    //     });
    //   }
    //   return null;
    // });

    if(mounted){
      setState(() {
        isRefreshing = true;
        isLoading = false;
        shouldLoadMore = true;
      });
    }

    loadDataFromApi();
  }

  loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      setState(() {
        isRefreshing = true;
        isLoading = true;
      });

      page = 1;
      _futureLeadsFromBoard = fetchLeadsFromBoard(page);
      _refreshController.refreshCompleted();
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
      setState(() {
        isRefreshing = false;
        isLoading = true;
      });
      page++;
      _futureLeadsFromBoard = fetchLeadsFromBoard(page);
      _refreshController.loadComplete();

    }
  }

  Future<List<dynamic>> fetchLeadsFromBoard(int page) async {
    if (page == 1) {
      setState(() {
        shouldLoadMore = true;
      });
    }

    List<dynamic> tempList = await _crmRepository.fetchLeadsFromBoard(page, perPage);
    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
          shouldLoadMore = false;
        });
      }
      return leadsFromBoardList;
    }else{
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if(tempList.isEmpty || tempList.length < perPage){
        if(mounted){
          setState(() {
            shouldLoadMore = false;
          });
        }
      }

      if (page == 1) {
        leadsFromBoardList.clear();
      }
      if (tempList.isNotEmpty) {
        leadsFromBoardList.addAll(tempList);
      }
    }

    return leadsFromBoardList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isInternetConnected == false ? AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("leads"),
      ): widgetAppBar(),
      body: isInternetConnected == false ? Align(
        alignment: Alignment.topCenter,
        child: NoInternetConnectionErrorWidget(onPressed: (){
          checkInternetAndLoadData();
        }),
      ):Stack(
        children: [
          showLeadsList(context, _futureLeadsFromBoard!),
          if (_refreshController.isLoading)
            const CRMPaginationLoadingWidget(),
        ],
      ),
    );
  }

  PreferredSizeWidget widgetAppBar(){
    return AppBarWidget(
      appBarTitle: UtilityMethods.getLocalizedString("leads"),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            icon: Icon(
              AppThemePreferences.addIcon,
              color: AppThemePreferences.backgroundColorLight,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewLeadPage(addNewLeadPageListener: (bool refresh) {
                    if (refresh) {
                      loadDataFromApi();
                    }
                  }),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget showLeadsList(
      BuildContext context, Future<List<dynamic>> futureLeadsFromBoard) {
    return FutureBuilder<List<dynamic>>(
      future: futureLeadsFromBoard,
      builder: (context, articleSnapshot) {
        isLoading = false;
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          }

          List<dynamic> list = articleSnapshot.data!;
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body = Container();
                if (mode == LoadStatus.loading) {
                  if (shouldLoadMore) {
                    body = const CRMPaginationLoadingWidget();
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
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: loadDataFromApi,
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                CRMDealsAndLeads lead = list[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    elevation: AppThemePreferences.boardPagesElevation,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeadDetailPage(
                              index: index,
                              lead: lead,
                              leadDetailPageListener: (int? index, bool refresh) {
                                if (index != null) {
                                  list.removeAt(index);
                                  setState(() {});
                                } else if (refresh) {
                                  loadDataFromApi();
                                }
                              },
                            ),
                          ),
                        );
                        // _takeActionBottomSheet(context, lead.leadLeadId!, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CRMTypeHeadingWidget("lead", lead.leadTime),
                            CRMHeadingWidget(lead.type),
                            CRMNormalTextWidget(lead.message),
                            CRMContactDetail(lead.displayName, lead.email, lead.mobile, () {
                                takeActionBottomSheet(context, false, lead.email);
                            }, () {
                              takeActionBottomSheet(context, true, lead.mobile);
                            })

                            // leadDetailWidget(lead),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (articleSnapshot.hasError) {
          return noResultFoundPage();
          // return Container();
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
      bodyErrorText: UtilityMethods.getLocalizedString("oops_leads_not_exist"),
    );
  }
}
