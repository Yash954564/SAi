import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/user_membership_package.dart';
import 'package:houzi_package/pages/in_app_purchase/payment_page.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MembershipPlanPage extends StatefulWidget {
  final bool fetchMembershipDetail;

  const MembershipPlanPage({
    this.fetchMembershipDetail = false,
    Key? key,
  }) : super(key: key);

  @override
  State<MembershipPlanPage> createState() => _MembershipPlanPageState();
}

class _MembershipPlanPageState extends State<MembershipPlanPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<dynamic> membershipPackageList = [];
  Future<List<dynamic>>? _futureMembershipPackage;
  UserMembershipPackage? userMembershipPackage;

  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isLoading = false;
  bool loadMembershipDetail = false;
  int perPage = 10;

  MembershipPlanHook membershipPlanHook = HooksConfigurations.membershipPlanHook;
  MembershipPayWallDesignHook membershipPayWallDesignHook = HooksConfigurations.membershipPayWallDesignHook;

  String payWallDesign = "PageView";

  @override
  void initState() {
    super.initState();
    isRefreshing = true;
    payWallDesign = membershipPayWallDesignHook(context);
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

      _futureMembershipPackage = fetchMembershipPackages();
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
      _futureMembershipPackage = fetchMembershipPackages();
      _refreshController.loadComplete();
    }
  }

  Future<List<dynamic>> fetchMembershipPackages() async {
    List<dynamic> tempList = [];
    if (widget.fetchMembershipDetail) {
      tempList = [await PropertyBloc().fetchUserMembershipPackageResponse()];
    } else {
      tempList = await PropertyBloc().fetchMembershipPackages();
    }

    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          shouldLoadMore = false;
        });
      }
      return membershipPackageList;
    } else {
      if (tempList.isEmpty || tempList.length < perPage) {
        if (mounted) {
          setState(() {
            shouldLoadMore = false;
          });
        }
      }

      if (tempList.isNotEmpty) {
        membershipPackageList.addAll(tempList);
      }
    }

    return membershipPackageList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("Membership Plan"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureMembershipPackage,
        builder: (context, articleSnapshot) {
          isLoading = false;
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data!.isEmpty) {
              return noResultFoundPage();
            }

            List<dynamic> list = articleSnapshot.data!;

            if (widget.fetchMembershipDetail) {
              UserMembershipPackage userMembershipPackage = list[0];
              return Column(
                children: [
                  UserMembershipPackageWidget(userMembershipPackage),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all( 18.0),
                    child: ButtonWidget(
                      text: UtilityMethods.getLocalizedString("Change Membership Plan"),
                      onPressed: () {
                        UtilityMethods.navigateToRoute(
                          context: context,
                          builder: (context) => MembershipPlanPage(),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {

              list.removeWhere((element) => element.membershipPlanDetails!.packageVisible == "no");

              final membershipPlan = membershipPlanHook(context, list);

              if (membershipPlan != null) {
                return membershipPlan;
              }

              if (payWallDesign == "ListView") {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    Article article = list[index];
                    return Padding(
                      padding: (UtilityMethods.showTabletView)
                          ? const EdgeInsets.symmetric(horizontal: 150)
                          : const EdgeInsets.all(0),
                      child: MembershipPlanWidget(article, payWallDesign),
                    );
                  },
                );
              } else {
                return PageView.builder(
                  itemCount: list.length,
                  controller: PageController(viewportFraction: 0.9),
                  itemBuilder: (context, index) {
                    Article article = list[index];
                    return MembershipPlanWidget(article, payWallDesign);
                  },
                );
              }
            }
          } else if (articleSnapshot.hasError) {
            return noResultFoundPage();
          }
          return loadingIndicatorWidget();
        },
      ),
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
      bodyErrorText: UtilityMethods.getLocalizedString("oops_membership_not_exist"),
    );
  }
}

class UserMembershipPackageWidget extends StatefulWidget {
  final UserMembershipPackage userMembershipPackage;
  const UserMembershipPackageWidget(this.userMembershipPackage, {Key? key}) : super(key: key);

  @override
  State<UserMembershipPackageWidget> createState() => _UserMembershipPackageWidgetState();
}

class _UserMembershipPackageWidgetState extends State<UserMembershipPackageWidget> {
  double? totalListing = 1;
  double? remainingListing;
  bool isUnlimitedListing = false;
  Map<String, double> listingDataMap = {"": 1};
  String listingCenterText = "";

  double gap = 15;

  double? totalFeature = 1;
  double? remainingFeature;
  bool isUnlimitedFeature = false;
  Map<String, double> featureDataMap = {"": 1};
  String featureCenterText = "";

  @override
  void initState() {
    super.initState();
    _initializeListingData();
    _initializeFeatureData();
  }

  void _initializeListingData() {
    String remainingListingStr = widget.userMembershipPackage.remainingListings ?? "0.0";
    if (remainingListingStr == "-1") {
      isUnlimitedListing = true;
    } else {
      totalListing = double.tryParse(widget.userMembershipPackage.packListings ?? "0.0");
      remainingListing = double.tryParse(remainingListingStr) ?? 0.0;
      listingDataMap = {
        UtilityMethods.getLocalizedString("Listings Remaining"): remainingListing ?? 0.0,
      };
    }

    listingCenterText = (isUnlimitedListing ? UtilityMethods.getLocalizedString("Unlimited") : "${remainingListing!.round()}/${totalListing!.round()}")!;
  }

  void _initializeFeatureData() {
    String remainingFeatureStr = widget.userMembershipPackage.packFeaturedRemainingListings ?? "0.0";
    if (remainingFeatureStr == "-1") {
      isUnlimitedFeature = true;
    } else {
      totalFeature = double.tryParse(widget.userMembershipPackage.packFeaturedListings ?? "0.0");
      remainingFeature = double.tryParse(remainingFeatureStr) ?? 0.0;
      featureDataMap = {
        UtilityMethods.getLocalizedString("Featured Remaining"): remainingFeature ?? 0.0,
      };
    }
    featureCenterText = (isUnlimitedFeature ? UtilityMethods.getLocalizedString("Unlimited") : "${remainingFeature!.round()}/${totalFeature!.round()}")!;
  }

  Widget _buildCardWidget(Map<String, double> dataMap, String centerText, double? totalValue, String heading) {
    return Expanded(
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
        elevation: AppThemePreferences.globalCardElevation,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GenericTextWidget(
                UtilityMethods.getLocalizedString(heading),
                style: const TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: PieChart(
                  dataMap: dataMap,
                  colorList: [AppThemePreferences().appTheme.primaryColor!],
                  baseChartColor: Colors.grey,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  chartType: ChartType.ring,
                  centerText: centerText,
                  totalValue: totalValue,
                  centerTextStyle: AppThemePreferences().appTheme.heading01TextStyle!,
                  degreeOptions: DegreeOptions(initialAngle: -90),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget("Your Current Package", style: const TextStyle(color: Colors.grey)),
          SizedBox(height: gap),
          GenericTextWidget(
            widget.userMembershipPackage.packTitle ?? "",
            style: AppThemePreferences().appTheme.membershipPackageNameTextStyle,
          ),
          SizedBox(height: gap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                AppThemePreferences.scheduleIcon,
                color: Colors.grey,
                size: 20,
              ),
              SizedBox(width: 3),
              GenericTextWidget(
                widget.userMembershipPackage.expiredDate ?? "",
                style: AppThemePreferences().appTheme.membershipExpireTextStyle,
              ),
            ],
          ),
          SizedBox(height: gap),
          Row(
            children: [
              _buildCardWidget(
                listingDataMap,
                listingCenterText,
                totalListing,
                "Listings Remaining",
              ),
              SizedBox(width: gap),
              _buildCardWidget(
                featureDataMap,
                featureCenterText,
                totalFeature,
                "Featured Remaining",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MembershipPlanWidget extends StatelessWidget {
  final Article article;
  final String payWallDesign;

  const MembershipPlanWidget(
      this.article,
      this.payWallDesign, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: payWallDesign == "PageView"
          ? EdgeInsets.symmetric(vertical: 38.0, horizontal: 5)
          : EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      // width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MembershipPlanTitle(article.title!),
          MembershipPlanPrice(article.membershipPlanDetails!.packagePrice!),
          const SizedBox(
            height: 20,
          ),
          CardWidget(
            elevation: AppThemePreferences.zeroElevation,
            shape: AppThemePreferences.roundedCorners(
                AppThemePreferences.propertyDetailPageRoundedCornersRadius),
            color: AppThemePreferences().appTheme.containerBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  MembershipPlanDetail(
                    label: "Duration:",
                    title:
                    "${article.membershipPlanDetails!.billingUnit!} ${article.membershipPlanDetails!.billingTimeUnit!}",
                  ),
                  const Divider(),
                  MembershipPlanDetail(
                    title:
                    article.membershipPlanDetails!.unlimitedListings == "1"
                        ? "Unlimited"
                        : article.membershipPlanDetails!.packageListings!,
                    label: "Properties",
                  ),
                  const Divider(),
                  MembershipPlanDetail(
                    title:
                    "${article.membershipPlanDetails!.packageFeaturedListings}",
                    label: "Featured Listings:",
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ButtonWidget(
              text: UtilityMethods.getLocalizedString("Get Started"),
              onPressed: () async {
                final price = double.tryParse(
                    article.membershipPlanDetails!.packagePrice!);
                if (price != null && price > 0.0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        productIds: Platform.isAndroid
                            ? [
                          article
                              .membershipPlanDetails!.androidIAPProductId!
                        ]
                            : [article.membershipPlanDetails!.iosIAPProductId!],
                        packageId: article.id.toString(),
                        isMembership: true,
                      ),
                    ),
                  );
                } else {
                  Map<String, dynamic> dataMap = {
                    "iap": Platform.isAndroid ? "GooglePlay" : "AppStore",
                    "iap_response": "",
                    "pack_id": article.id.toString(),
                    "prop_id": "",
                    "is_prop_featured": 0,
                  };

                  ApiResponse apiResponse = await PropertyBloc()
                      .fetchProceedWithPaymentsResponse(dataMap);
                  ShowToastWidget(
                      buildContext: context, text: apiResponse.message);
                  if (apiResponse.success) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                            (Route<dynamic> route) => false);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class MembershipPlanTitle extends StatelessWidget {
  final String title;

  const MembershipPlanTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0, top: 10),
      child: GenericTextWidget(
        title,
        style: AppThemePreferences().appTheme.membershipTitleTextStyle,
      ),
    );
  }
}

class MembershipPlanPrice extends StatelessWidget {
  final String price;

  const MembershipPlanPrice(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GenericTextWidget(
          HiveStorageManager.readDefaultCurrencyInfoData(),
          style: AppThemePreferences().appTheme.membershipTitleTextStyle,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 38.0),
          child: GenericTextWidget(
            price,
            style: AppThemePreferences().appTheme.membershipPriceTextStyle,
          ),
        ),
      ],
    );
  }
}

class MembershipPlanDetail extends StatelessWidget {
  final String? title;
  final String? label;

  const MembershipPlanDetail({
    required this.title,
    this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString(label ?? ""),
            ),
          ),
          Expanded(
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString(title ?? ""),
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
