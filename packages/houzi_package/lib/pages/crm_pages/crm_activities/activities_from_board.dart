import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/lead_detail_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/leads_from_board.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/review_related_widgets/all_reviews_page.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';

class ActivitiesFromBoard extends StatefulWidget {
  const ActivitiesFromBoard({super.key});

  @override
  _ActivitiesFromBoardState createState() => _ActivitiesFromBoardState();
}

class _ActivitiesFromBoardState extends State<ActivitiesFromBoard> {
  final CRMRepository _crmRepository = CRMRepository();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<dynamic> activitiesFromBoardList = [];
  List<dynamic> dealsAndLeadsFromActivityList = [];

  Future<List<dynamic>>? _futureActivitiesFromBoard;
  Future<List<dynamic>>? _futureDealsAndLeadsFromActivity;

  bool isInternetConnected = true;
  int? userId;

  String activeCount = "";
  String wonCount = "";
  String lostCount = "";
  var lastDay;
  var lastTwo;
  var lastWeek;
  var last2Week;
  var lastMonth;
  var last2Month;

  var percentDay;
  String? posOrNegDay;
  var percentWeek;
  String? posOrNegWeek;
  var percentMonth;
  String? posOrNegMonth;

  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isLoading = false;
  int page = 1;
  int perPage = 10;

  double bottomPadding = 9.0;

  Map<String, double> dealStatMap = {};

  @override
  void initState() {
    super.initState();
    userId = HiveStorageManager.getUserId();
    loadDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("activities"),
      ),
      body: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () => loadDataFromApi(),
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget? body;
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
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  dealsAndLeadsFromActivityList.isEmpty
                      ? const SizedBox(height: 50)
                      : Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  child: ShowLeads(
                                    percentDay: percentDay,
                                    percentWeek: percentWeek,
                                    percentMonth: percentMonth,
                                    posOrNegDay: posOrNegDay,
                                    posOrNegWeek: posOrNegWeek,
                                    posOrNegMonth: posOrNegMonth,
                                    lastDay: lastDay,
                                    lastWeek: lastWeek,
                                    lastMonth: lastMonth,
                                    dealsAndLeadsFromActivityList: dealsAndLeadsFromActivityList,
                                  ),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.48,
                                  height: 220,
                                  child: ShowDeals(
                                    dealStatMap: dealStatMap,
                                    dealsAndLeadsFromActivityList: dealsAndLeadsFromActivityList,
                                  ),
                              ),
                            ],
                          ),
                      ),
                  Container(
                    child: ShowActivitiesList(
                    loadingData: isLoading,
                      futureActivitiesFromBoard: _futureActivitiesFromBoard!,
                      listener: (loadingComplete) {
                        isLoading = false;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_refreshController.isLoading)
            const CRMPaginationLoadingWidget(),
          if (isInternetConnected == false)
            InternetConnectionErrorWidget(
              onPressed: ()=> checkInternetAndLoadData(),
            ),
        ],
      ),
    );
  }

  void checkInternetAndLoadData() {
    if (mounted) {
      setState(() {
        isRefreshing = false;
        shouldLoadMore = true;
        isLoading = false;
      });
    }

    userId = HiveStorageManager.getUserId();
    loadDataFromApi();
  }

  void loadDataFromApi({bool forPullToRefresh = true}) {
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
      loadLeadAndDealData();
      _futureActivitiesFromBoard = fetchActivitiesFromBoard(page, userId!);
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
      _futureActivitiesFromBoard = fetchActivitiesFromBoard(page, userId!);
      _refreshController.loadComplete();
    }
  }

  void loadLeadAndDealData() {
    _futureDealsAndLeadsFromActivity = fetchDealsAndLeadsFromActivity();
    _futureDealsAndLeadsFromActivity!.then((value) {
      if (value != null && value.isNotEmpty) {
        if (mounted) {
          setState(() {
            dealsAndLeadsFromActivityList = value;
            CRMDealsAndLeadsFromActivity dealsAndLeadsFromActivity = dealsAndLeadsFromActivityList[0];

            activeCount = dealsAndLeadsFromActivity.activeCount!;
            wonCount = dealsAndLeadsFromActivity.wonCount!;
            lostCount = dealsAndLeadsFromActivity.lostCount!;
            lastDay = dealsAndLeadsFromActivity.lastDay;
            lastTwo = dealsAndLeadsFromActivity.lastTwo;
            lastWeek = dealsAndLeadsFromActivity.lastWeek;
            last2Week = dealsAndLeadsFromActivity.last2Week;
            lastMonth = dealsAndLeadsFromActivity.lastMonth;
            last2Month = dealsAndLeadsFromActivity.last2Month;

            lastTwo = lastTwo - lastDay;
            setPercent(lastTwo, lastDay, DAY);
            last2Week = last2Week - lastWeek;
            setPercent(last2Week, lastWeek, WEEK);
            last2Month = last2Month - lastMonth;
            setPercent(last2Month, lastMonth, MONTH);

            dealStatMap = {
              UtilityMethods.getLocalizedString("lost"): double.parse(lostCount),
              UtilityMethods.getLocalizedString("won"): double.parse(wonCount),
              UtilityMethods.getLocalizedString("active"): double.parse(activeCount),
            };

            isRefreshing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isRefreshing = false;
          });
        }
      }

      return null;
    });
  }

  void setPercent(oldNumber, newNumber, valueFor) {
    if (oldNumber != 0) {
      double percent = ((newNumber - oldNumber) / oldNumber * 100);
      if (valueFor == DAY) {
        percentDay = percent;
      } else if (valueFor == WEEK) {
        percentWeek = percent;
      } else if (valueFor == MONTH) {
        percentMonth = percent;
      }
    } else {
      if (valueFor == DAY) {
        percentDay = newNumber * 100;
      } else if (valueFor == WEEK) {
        percentWeek = newNumber * 100;
      } else if (valueFor == MONTH) {
        percentMonth = newNumber * 100;
      }
    }

    if (oldNumber > newNumber) {
      if (valueFor == DAY) {
        posOrNegDay = DANGER;
      } else if (valueFor == WEEK) {
        posOrNegWeek = DANGER;
      } else if (valueFor == MONTH) {
        posOrNegMonth = DANGER;
      }
    } else {
      if (valueFor == DAY) {
        posOrNegDay = SUCCESS;
      } else if (valueFor == WEEK) {
        posOrNegWeek = SUCCESS;
      } else if (valueFor == MONTH) {
        posOrNegMonth = SUCCESS;
      }
    }
  }

  Future<List<dynamic>> fetchActivitiesFromBoard(int page, int userId) async {
    if (page == 1) {
      if (mounted) {
        setState(() {
          shouldLoadMore = true;
        });
      }
    }

    List<dynamic> tempList = await _crmRepository.fetchActivitiesFromBoard(page, perPage, userId);
    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
          shouldLoadMore = false;
        });
      }
      return activitiesFromBoardList;
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
        activitiesFromBoardList.clear();
      }
      if (tempList.isNotEmpty) {
        activitiesFromBoardList.addAll(tempList);
      }
    }

    return activitiesFromBoardList;
  }

  Future<List<dynamic>> fetchDealsAndLeadsFromActivity() async {
    List<dynamic> tempList = await _crmRepository.fetchDealsAndLeadsFromActivity();

    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
      return dealsAndLeadsFromActivityList;
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      dealsAndLeadsFromActivityList.clear();
      dealsAndLeadsFromActivityList.addAll(tempList);
    }

    return dealsAndLeadsFromActivityList;
  }
}

typedef ShowActivitiesListListener = void Function(bool loadingComplete);
class ShowActivitiesList extends StatelessWidget {
  final bool loadingData;
  final Future<List<dynamic>> futureActivitiesFromBoard;
  final ShowActivitiesListListener listener;

  const ShowActivitiesList({
    super.key,
    required this.loadingData,
    required this.futureActivitiesFromBoard,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: futureActivitiesFromBoard,
        builder: (context, articleSnapshot) {
          listener(true);

          if (articleSnapshot.hasData) {
            if (articleSnapshot.data == null ||
                articleSnapshot.data!.isEmpty) {
              return const NoResultFoundPage();
            }
            List<dynamic> list = articleSnapshot.data!;

            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                CRMActivity activity = list[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    elevation: AppThemePreferences.boardPagesElevation,
                    child: InkWell(
                      onTap: () {
                        if (activity.type == kReview) {
                          navigateToPage(context, (context) => AllReviews(
                            id: activity.listingId,
                            fromProperty: activity.reviewPostType == "property" ? true : false,
                            reviewPostType: activity.reviewPostType,
                            title: activity.title,
                          ));
                        } else if (activity.type == kLeadContact) {
                          if (activity.leadPageId != null && activity.leadPageId!.isNotEmpty) {
                            navigateToPage(context, (context) => LeadDetailPage(
                              index: index,
                              idForFetchLead: activity.leadPageId,
                              leadDetailPageListener: (_, __) {},
                            ));
                          }
                        } else if (activity.type == kLead && activity.subtype != kScheduleTour) {
                          navigateToPage(context, (context) => const LeadsFromBoard());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CRMTypeHeadingWidget(
                              getActivityTypeHeading(activity),
                              activity.time,
                            ),
                            CRMHeadingWidget(
                              activity.type == kReview
                                  ? activity.reviewTitle
                                  : activity.title,
                            ),
                            if (activity.type == kReview)
                              StarsWidget(totalRating: "${activity.reviewStar}"),
                            CRMNormalTextWidget(
                              activity.type == kReview
                                  ? activity.reviewContent
                                  : activity.message,
                            ),
                            CRMContactDetail(
                              activity.type == kReview
                                  ? activity.userName
                                  : activity.name,
                              activity.email,
                              activity.phone,
                                  () {
                                takeActionBottomSheet(
                                    context, false, activity.email);
                              },
                                  () {
                                takeActionBottomSheet(
                                    context, true, activity.phone);
                              },
                            ),
                            // activityDetailWidget(activity),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (!loadingData && (articleSnapshot.hasError || (!articleSnapshot.hasData))) {
            return const NoResultFoundPage();
          }
          return const LoadingIndicatorWidget();
        });
  }

  void navigateToPage(BuildContext context, WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }
}

class SetLabelWidget extends StatelessWidget {
  final String label;

  const SetLabelWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 3, right: 0, bottom: 10),
          child: GenericTextWidget(
            label,
            style: AppThemePreferences().appTheme.heading02TextStyle,
          ),
        ),
      ],
    );
  }
}

class ShowDeals extends StatelessWidget {
  final Map<String, double> dealStatMap;
  final List<dynamic> dealsAndLeadsFromActivityList;
  
  const ShowDeals({
    super.key,
    required this.dealStatMap,
    required this.dealsAndLeadsFromActivityList,
  });

  @override
  Widget build(BuildContext context) {
    if (dealsAndLeadsFromActivityList.isEmpty) {
      return Container();
    }
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
      elevation: AppThemePreferences.boardPagesElevation,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericTextWidget(
              UtilityMethods.getLocalizedString("deals"),
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DealRowWidget(color: const Color(0xFF56eec5), text: "active"),
                      DealRowWidget(color: const Color(0xFF74b8ff), text: "won"),
                      DealRowWidget(color: const Color(0xFFff7674), text: "lost"),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: PieChart(
                      dataMap: dealStatMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 50,
                      chartRadius: MediaQuery.of(context).size.width / 6.2,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 20,
                      legendOptions: const LegendOptions(
                          showLegendsInRow: true,
                          legendPosition: LegendPosition.top,
                          showLegends: false,
                          legendTextStyle: TextStyle(fontSize: 9)),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValueBackground: false,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DealRowWidget extends StatelessWidget {
  final Color color;
  final String text;
  
  const DealRowWidget({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          AppThemePreferences.dotIcon,
          size: 15,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: GenericTextWidget(
            UtilityMethods.getLocalizedString(text),
            style: AppThemePreferences().appTheme.activitySubTitleTextStyle,
          ),
        )
      ],
    );
  }
}

class ShowLeads extends StatelessWidget {
  final dynamic percentDay;
  final dynamic percentWeek;
  final dynamic percentMonth;
  final String? posOrNegDay;
  final String? posOrNegWeek;
  final String? posOrNegMonth;
  final dynamic lastDay;
  final dynamic lastWeek;
  final dynamic lastMonth;
  final List<dynamic> dealsAndLeadsFromActivityList;

  const ShowLeads({
    super.key,
    required this.percentDay,
    required this.percentWeek,
    required this.percentMonth,
    required this.posOrNegDay,
    required this.posOrNegWeek,
    required this.posOrNegMonth,
    required this.lastDay,
    required this.lastWeek,
    required this.lastMonth,
    required this.dealsAndLeadsFromActivityList,
  });

  @override
  Widget build(BuildContext context) {
    if (dealsAndLeadsFromActivityList.isEmpty) {
      return Container();
    }
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
      elevation: AppThemePreferences.boardPagesElevation,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GenericTextWidget(
              UtilityMethods.getLocalizedString("leads"),
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  SetLeadDataWidget(percent: percentDay, posOrNeg: posOrNegDay!, time: "last_24_hours", value: lastDay),
                  const Divider(),
                  SetLeadDataWidget(percent: percentWeek, posOrNeg: posOrNegWeek!, time: "last_7_days", value: lastWeek),
                  const Divider(),
                  SetLeadDataWidget(percent: percentMonth, posOrNeg: posOrNegMonth!, time: "last_30_days", value: lastMonth),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetLeadDataWidget extends StatelessWidget {
  final dynamic percent;
  final String posOrNeg;
  final String time;
  final dynamic value;

  const SetLeadDataWidget({
    super.key,
    required this.percent,
    required this.posOrNeg,
    required this.time,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PercentWidget(
                textValue: percent.toStringAsFixed(0) + "%",
                posNegValue: posOrNeg,
              ),
              GenericTextWidget(
                UtilityMethods.getLocalizedString(time),
                style: AppThemePreferences().appTheme.activitySubTitleTextStyle,
              )
            ],
          ),
          const Spacer(),
          GenericTextWidget(
            value.toString(),
            style: AppThemePreferences().appTheme.activityHeadingTextStyle,
          )
          // percentWidget(percentDay.toStringAsFixed(0) + "%", posOrNegDay!),
        ],
      ),
    );
  }
}

class PercentWidget extends StatelessWidget {
  final String textValue;
  final String posNegValue;

  const PercentWidget({
    super.key,
    required this.textValue,
    required this.posNegValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GenericTextWidget(
          textValue,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: posNegValue == 'text-success'
              ? AppThemePreferences().appTheme.risingLeadsTextStyle
              : AppThemePreferences().appTheme.fallingLeadsTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Icon(
            posNegValue == 'text-success'
                ? AppThemePreferences.upArrowIcon
                : AppThemePreferences.downArrowIcon,
            color: posNegValue == 'text-success'
                ? AppThemePreferences.risingLeadsColor
                : AppThemePreferences.fallingLeadsColor,
            size: 20,
          ),
        )
      ],
    );
  }
}

class InternetConnectionErrorWidget extends StatelessWidget {
  final void Function() onPressed;

  const InternetConnectionErrorWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SafeArea(
        top: false,
        child: NoInternetBottomActionBarWidget(
          onPressed: ()=> onPressed(),
        ),
      ),
    );
  }
}

class StarsWidget extends StatelessWidget {
  final String? totalRating;
  const StarsWidget({
    super.key,
    required this.totalRating,
  });

  @override
  Widget build(BuildContext context) {
    if (totalRating == null) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 9.0),
      child: RatingBar.builder(
        initialRating: double.parse(totalRating!),
        minRating: 1,
        itemSize: 20,
        direction: Axis.horizontal,
        allowHalfRating: true,
        ignoreGestures: true,
        itemCount: 5,
        // itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: AppThemePreferences.ratingWidgetStarsColor,
        ),
        onRatingUpdate: (rating) {},
      ),
    );
  }
}

class NoResultFoundPage extends StatelessWidget {
  const NoResultFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText:
      UtilityMethods.getLocalizedString("oops_activities_not_exist"),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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