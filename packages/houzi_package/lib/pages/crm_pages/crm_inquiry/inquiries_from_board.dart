
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'add_new_inquiry_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'inquiry_detail_page.dart';

class InquiriesFromBoard extends StatefulWidget {
  @override
  _InquiriesFromBoardState createState() => _InquiriesFromBoardState();
}

class _InquiriesFromBoardState extends State<InquiriesFromBoard> {
  final CRMRepository _crmRepository = CRMRepository();

  //ScrollController _controller = new ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<dynamic>>? _futureInquiriesFromBoard;
  List<dynamic> inquiriesFromBoardList = [];

  bool shouldLoadMore = true;
  bool isLoading = false;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 10;

  // double bottomPadding = 9.0;

  String defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? "\$";

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
    // checkInternetAndLoadData();
  }

  checkInternetAndLoadData() {
    // InternetConnectionChecker().checkInternetConnection().then((value) {
    //   if (value) {
    //     setState(() {
    //       isInternetConnected = true;
    //     });
    //     userId = HiveStorageManager.getUserId();
    //     loadDataFromApi();
    //   } else {
    //     setState(() {
    //       isInternetConnected = false;
    //     });
    //   }
    //   return null;
    // });

    if(mounted){
      setState(() {
        shouldLoadMore = true;
        isLoading = false;
      });
    }

    loadDataFromApi();
  }

  loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
    }

    setState(() {
      if (forPullToRefresh) {
        page = 1;
      } else {
        page++;
      }
      isLoading = true;
    });

    _futureInquiriesFromBoard = fetchInquiriesFromBoard(page);
    if (forPullToRefresh) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<List<dynamic>> fetchInquiriesFromBoard(int page) async {
    if (page == 1) {
      setState(() {
        shouldLoadMore = true;
      });
    }
    List<dynamic> tempList = await _crmRepository.fetchInquiriesFromBoard(page, perPage);
    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return inquiriesFromBoardList;
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
        inquiriesFromBoardList.clear();
      }
      if (tempList.isNotEmpty) {
        inquiriesFromBoardList.addAll(tempList);
      }
    }
    return inquiriesFromBoardList;
  }

  @override
  void dispose() {
    //_bannerAd.dispose();
    super.dispose();

    // _controller.removeListener(_scrollListener);
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isInternetConnected == false
          ? AppBarWidget(
              appBarTitle: UtilityMethods.getLocalizedString("inquiries"),
            )
          : widgetAppBar(),
      body: isInternetConnected == false
          ? Align(
        alignment: Alignment.topCenter,
        child: NoInternetConnectionErrorWidget(onPressed: () {
          checkInternetAndLoadData();
        }),
      )
          : Stack(
            children: [
              showInquiriesList(context, _futureInquiriesFromBoard!),
              if (_refreshController.isLoading)
                const CRMPaginationLoadingWidget(),
            ],
          ),
    );
  }

  PreferredSizeWidget widgetAppBar() {
    return AppBarWidget(
      appBarTitle: UtilityMethods.getLocalizedString("inquiries"),
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
                  builder: (context) => AddNewInquiry(forInquiryEdit: false,addNewInquiryPageListener: (bool refresh) {
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

  Widget showInquiriesList(
      BuildContext context, Future<List<dynamic>> futureInquiriesFromBoard) {
    return FutureBuilder<List<dynamic>>(
      future: futureInquiriesFromBoard,
      builder: (context, articleSnapshot) {
        isLoading = false;

        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          }
          // if (articleSnapshot.data.length < perPage) {
          //   shouldLoadMore = false;
          //   _refreshController.loadNoData();
          // }

          List<dynamic> list = articleSnapshot.data!;

          // if (isRefreshing) {
          //   //need to clear the list if refreshing.
          //   inquiriesFromBoardList.clear();
          // }
          //inquiriesFromBoardList.addAll(list);

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
                CRMInquiries inquiry = list[index];
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
                            builder: (context) => InquiryDetailPage(
                              inquiryDetail: inquiry,
                              index: index,
                              inquiryDetailPageListener: ({int? index, bool refresh = false}) {
                                if (refresh) {
                                  loadDataFromApi();
                                }
                                if (index !=null) {
                                  setState(() {
                                    list.removeAt(index);
                                  });
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
                            CRMTypeHeadingWidget("inquiry", inquiry.time),
                            CRMHeadingWidget(inquiry.propertyTypeName, secondHeading: inquiry.enquiryType),
                            CRMContactDetail(
                              inquiry.leads!.displayName,
                              inquiry.leads!.email!,
                              inquiry.leads!.mobile,
                              () {
                                takeActionBottomSheet(context, false, inquiry.leads!.email!);
                              },
                              () {
                                takeActionBottomSheet(context, true, inquiry.leads!.mobile!);
                              },
                              addBottomPadding: true,
                            ),
                            CRMFeatures(inquiry.minBeds, inquiry.minBaths, inquiry.minArea, inquiry.minPrice),
                            // inquiryDetailWidget(inquiry),
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
        }
        return loadingIndicatorWidget();
      },
    );
  }

  // Widget bannerAdWidget() {
  //   //setUpBannerAd();
  //   return StatefulBuilder(
  //     builder: (context, setState) => Container(
  //       height: _bannerAd.size.height.toDouble(),
  //       width: _bannerAd.size.width.toDouble(),
  //       child: AdWidget(ad: _bannerAd),
  //       // child: AdWidget(ad: _bannerAd),
  //       // width: _bannerAd.size.width.toDouble(),
  //       // height: 100.0,
  //       // alignment: Alignment.center,
  //     ),
  //   );
  // }

  //  BannerAd getBannerAd(){
  //   BannerAd _bannerAd = new BannerAd(size: AdSize.banner, adUnitId: , listener: BannerAdListener(
  //       onAdClosed: (Ad ad){
  //         //print("Ad Closed");
  //       },
  //       onAdFailedToLoad: (Ad ad,LoadAdError error){
  //         print("Failed to Load A Banner Ad: ${error.message}");
  //         ad.dispose();
  //       },
  //       onAdLoaded: (Ad ad){
  //         //print('Ad Loaded');
  //       },
  //       onAdOpened: (Ad ad){
  //         //print('Ad opened');
  //       }
  //   ), request: AdRequest());
  //   return _bannerAd;
  // }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("oops_inquiries_not_exist"),
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
}
