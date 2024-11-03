import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/property_details_related_pages/report_property.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/pages/property_details_related_pages/bottom_buttons_action_bar.dart';
import 'package:houzi_package/pages/property_details_related_pages/pd_widgets_listing.dart';
import 'package:houzi_package/widgets/custom_widgets/refresh_indicator_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/models/property_detail_page_config.dart';
import 'package:houzi_package/widgets/review_related_widgets/add_review_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailsPage extends StatefulWidget {
  final int? propertyID;
  final String? heroId;
  final Article? article;
  final String? permaLink;
  final String thumbnail;

  PropertyDetailsPage({
    this.article,
    this.propertyID,
    this.heroId,
    this.permaLink,
    required this.thumbnail
  });

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {

  Article? _article;

  double _opacity = 0.0;

  int? tempRealtorId;

  String agentDisplayOption = "";
  String tempRealtorThumbnail = '';
  String tempRealtorEmail = '';
  String tempRealtorName = '';
  String tempRealtorPhone = "";
  String tempRealtorMobile = "";
  String tempRealtorWhatsApp = "";
  String tempRealtorLink = "";
  String _articleLink = "";
  String tempRealtorLineApp = "";
  String tempRealtorTelegram = "";

  bool isLiked = false;
  bool isLoggedIn = false;
  bool isInternetConnected = true;
  bool latestArticleDataIsReady = false;
  bool isAgent = false;
  bool showBottomSpace = true;

  List<String> agentList = [];
  List<String> agencyList = [];
  List<dynamic> propertyDetailPageConfigList = [];
  List<dynamic> singleArticle = [];
  List<dynamic> _realtorInfoList = [];

  Future<dynamic>? favArticle;
  Future<List<dynamic>>? _futureSingleArticle;
  Future<List<dynamic>>? _futureAgentOrAgencyInfo;

  Map<String, dynamic> _realtorInfoMap = {};

  final PropertyBloc _propertyBloc = PropertyBloc();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getPropertyDetailPageConfigFile();

    if (Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn ?? false) {
      setState(() {
        isLoggedIn = true;
      });
    }

    _scrollController = ScrollController()..addListener(_scrollListener);

    if (widget.article != null) {
      _initializeArticleData(widget.article!);
      checkInternetAndLoadData();
      // loadData();
    }
    if(widget.article == null){
      checkInternetAndLoadData();
    }
  }

  @override
  dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppThemePreferences().appTheme.backgroundColor!.withOpacity(_opacity),
        statusBarIconBrightness: AppThemePreferences().appTheme.statusBarIconBrightness,
      ),
      child: Scaffold(
        body: isInternetConnected ?
        widget.article != null ? lazyLoadingWidget() : eagerLoadingWidget()
        : Align(
            alignment: Alignment.topCenter,
            child: NoInternetConnectionErrorWidget(onPressed: ()=> checkInternetAndLoadData()),
        ),
      ),
    );
  }

  _scrollListener() {
    if(mounted){
      setState(() {
        if (_scrollController.offset < 50.0) {
          _opacity = 0.0;
        }
        if (_scrollController.offset > 50.0 && _scrollController.offset < 100.0) {
          _opacity = 0.4;
        }
        if (_scrollController.offset > 100.0 && _scrollController.offset < 150.0) {
          _opacity = 0.8;
        }
        if (_scrollController.offset > 190.0) {
          _opacity = 1.0;
        }
      });
    }

    // print('Scroll Offset: ${_scrollController.offset}');
    // var isEnd = _scrollController.offset >= _scrollController.position.maxScrollExtent &&
    //     !_scrollController.position.outOfRange;
  }

  checkInternetAndLoadData(){
    // isInternetConnected = true;
    onRefresh();
  }

  bool isDataLoaded(){
    if (singleArticle != null && singleArticle.isNotEmpty) {
      return true;
    }
    return false;
  }

  getPropertyDetailPageConfigFile() async {
    var storedPropertyDetailPageConfig = HiveStorageManager.readPropertyDetailConfigListData();
    if (storedPropertyDetailPageConfig != null && storedPropertyDetailPageConfig.isNotEmpty) {
      if(mounted) {
        setState(() {
          propertyDetailPageConfigList = jsonDecode(storedPropertyDetailPageConfig);
        });
      }
    } else {
      String jsonString = await rootBundle.loadString(APP_CONFIG_JSON_PATH);
      var propertyDetailPageConfig = propertyDetailPageLayoutFromJson(jsonString);
      if(mounted) {
        setState(() {
          propertyDetailPageConfigList = propertyDetailPageConfig.propertyDetailPageLayout!;
        });
      }
    }
  }

  loadData(){
    if (widget.propertyID != null) {
      _futureSingleArticle = fetchSingleArticle(id: widget.propertyID!);
    }else{
      _futureSingleArticle = fetchSingleArticle(permaLink: widget.permaLink);
    }

    _futureSingleArticle!.then((value) {
      if(value.isNotEmpty && value[0] is Article){
        if(mounted) {
          setState(() {
            _article = value[0];
            latestArticleDataIsReady = true;
            agentList = _article!.propertyInfo!.agentList ?? [];
            agencyList = _article!.propertyInfo!.agencyList ?? [];
            agentDisplayOption = _article!.propertyInfo!.agentDisplayOption ?? "";

            loadRealtorInfoData(_article!);
          });
        }
        if(isLoggedIn) {
          var response = _propertyBloc.fetchIsFavProperty(widget.propertyID.toString());
          response.then((value) {
            if (value.statusCode == 200 && value.data["success"] == true && value.data["is_fav"] == true) {
              if(mounted){
                setState(() {
                  isLiked = true;
                  isInternetConnected = true;
                });
              }
            }else if(value.statusCode == null){
              if(mounted){
                setState(() {
                  isInternetConnected = false;
                });
              }
            }
            return null;
          });
        }
      }
      return null;
    });
  }

  loadRealtorInfoData(Article article){
    if (agentDisplayOption == AGENCY_INFO || agentDisplayOption == AGENT_INFO){
      if (agentDisplayOption == AGENCY_INFO) {
        isAgent = false;
        _futureAgentOrAgencyInfo = fetchAgencyInfo(agencyList);
      }
      else if (agentDisplayOption == AGENT_INFO) {
        isAgent = true;
        _futureAgentOrAgencyInfo = fetchAgentInfo(agentList);
      }
      _futureAgentOrAgencyInfo!.then((dataList) {
        if(dataList.isNotEmpty){
          var item = dataList[0];
          tempRealtorId = item.id;
          tempRealtorName = item.title ?? "";
          tempRealtorEmail = item.email ?? "";
          tempRealtorThumbnail = item.thumbnail ?? "";
          tempRealtorPhone = isAgent
              ? item.agentOfficeNumber ?? ""
              : item.agencyPhoneNumber ?? "";
          tempRealtorMobile = isAgent
              ? item.agentMobileNumber ?? ""
              : item.agencyMobileNumber ?? "";
          tempRealtorWhatsApp = isAgent
              ? item.agentWhatsappNumber ?? ""
              : item.agencyWhatsappNumber ?? "";
          tempRealtorLink = isAgent
              ? item.agentLink ?? ""
              : item.agencyLink ?? "";
          tempRealtorLineApp = item.lineApp ?? "";
          tempRealtorTelegram = item.telegram ?? "";

          _realtorInfoMap = {
            tempRealtorIdKey : tempRealtorId,
            tempRealtorEmailKey : tempRealtorEmail,
            tempRealtorThumbnailKey : tempRealtorThumbnail,
            tempRealtorNameKey : tempRealtorName,
            tempRealtorLinkKey : tempRealtorLink,
            tempRealtorMobileKey : tempRealtorMobile,
            tempRealtorWhatsAppKey : tempRealtorWhatsApp,
            tempRealtorPhoneKey : tempRealtorPhone,
            tempRealtorDisplayOption : agentDisplayOption,
            tempRealtorLineAppKey : tempRealtorLineApp,
            tempRealtorTelegramKey : tempRealtorTelegram,
          };
          if(mounted){
            setState(() {});
          }
        }
        return null;
      });
    }
    else if (agentDisplayOption == AUTHOR_INFO) {
      var realtorInfo = article.authorInfo;
      if(realtorInfo != null) {
        tempRealtorId = realtorInfo.id;
        tempRealtorEmail = realtorInfo.email ?? "";
        tempRealtorThumbnail = realtorInfo.picture ?? "";
        tempRealtorName = realtorInfo.name ?? "";
        tempRealtorPhone = realtorInfo.phone ?? "";
        tempRealtorMobile = realtorInfo.mobile ?? "";
        tempRealtorWhatsApp = realtorInfo.whatsApp ?? "";
        tempRealtorLink = "";
        tempRealtorLineApp = realtorInfo.lineApp ?? "";
        tempRealtorTelegram = realtorInfo.telegram ?? "";

        _realtorInfoMap = {
          tempRealtorIdKey: tempRealtorId,
          tempRealtorEmailKey: tempRealtorEmail,
          tempRealtorThumbnailKey: tempRealtorThumbnail,
          tempRealtorNameKey: tempRealtorName,
          tempRealtorLinkKey: tempRealtorLink,
          tempRealtorMobileKey: tempRealtorMobile,
          tempRealtorWhatsAppKey: tempRealtorWhatsApp,
          tempRealtorPhoneKey: tempRealtorPhone,
          tempRealtorDisplayOption : agentDisplayOption,
          tempRealtorLineAppKey : tempRealtorLineApp,
          tempRealtorTelegramKey : tempRealtorTelegram,
        };
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  Future<List<dynamic>> fetchSingleArticle({int? id, permaLink}) async {
    List<dynamic>? tempList = [];
    singleArticle = [];

    if(id != null){
      tempList = await _propertyBloc.fetchSingleArticle(id);
    }else{
      tempList = await _propertyBloc.fetchSingleArticleViaPermaLink(permaLink);
    }

    if(tempList == null || tempList.isEmpty || tempList[0] == null || tempList[0].runtimeType == Response){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
    }else{
      if (mounted) {
        setState(() {
          isInternetConnected = true;
          singleArticle.addAll(tempList!);
        });
      }
    }

    return singleArticle;
  }

  Future<List<dynamic>> fetchAgencyInfo(List<String> list) async {
    _realtorInfoList.clear();
    List<int> tempList01 = list.map(int.parse).toList();

    for(var element in tempList01){
      List<dynamic>? tempList = await _propertyBloc.fetchSingleAgencyInfoList(element);
      if(tempList == null || tempList.isEmpty || tempList[0] == null || tempList[0].runtimeType == Response){
        // if(mounted){
        //   setState(() {
        //     isInternetConnected = false;
        //   });
        // }
        break;
      }else {
        if (mounted) {
          setState(() {
            isInternetConnected = true;
            if(tempList.isNotEmpty){
              _realtorInfoList.add(tempList[0]);
            }
          });
        }
      }
    }

    return _realtorInfoList;
  }

  Future<List<dynamic>> fetchAgentInfo(List<String> list) async {
    _realtorInfoList.clear();
    List<int> tempList01 = list.map(int.parse).toList();

    for (var element in tempList01) {
      List<dynamic>? tempList = [];
      tempList = await _propertyBloc.fetchSingleAgentInfoList(element);
      if(tempList == null || tempList.isEmpty || tempList[0] == null || tempList[0].runtimeType == Response){
        // if (mounted) {
        //   setState(() {
        //     isInternetConnected = false;
        //   });
        // }
        break;
      } else {
        if (mounted) {
          setState(() {
            isInternetConnected = true;
            if (tempList!.isNotEmpty) {
              _realtorInfoList.add(tempList[0]);
            }
          });
        }
      }
    }
    return _realtorInfoList;
  }

  _initializeArticleData(Article article) {
    _article = article;
    if(article.link != null && article.link is String) {
      _articleLink = article.link!;
    }
  }

  Widget lazyLoadingWidget() {
    return Stack(
      children: [
        RefreshIndicatorWidget(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: propertyDetailPageConfigList.map((map) {
                    final propertyProfileItemType = map[WIDGET_TYPE_PROPERTY_PROFILE];
                    final detailsWidget = PropertyDetailsPageWidgets(
                      propertyDetailsPageData: map,
                      article: widget.article!,
                      propertyID: widget.propertyID,
                      heroId: widget.heroId!,
                      latestArticleData: _article,
                      widgetsHook: HooksConfigurations.widgetItem,
                      latestArticleDataIsReady: latestArticleDataIsReady,
                      realtorInfoMap: _realtorInfoMap,
                      realtorInfoList: _realtorInfoList,
                      thumbnail: widget.thumbnail,
                      propertyDetailsPageWidgetsListener: (Map<String, dynamic> propertyDetailsPageDataMap, bool isDataLoaded){
                        if(isDataLoaded){
                          latestArticleDataIsReady = false;
                        }
                      },
                    );
                    //TRINIDAD_CHANGE
                    if (propertyProfileItemType == IMAGES_PROPERTY_PROFILE) {
                      return detailsWidget;
                    }
                    //TRINIDAD_CHANGE
                    if (UtilityMethods.showTabletView) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 150.0),
                        child: detailsWidget,
                      );
                    } else {
                      return detailsWidget;
                    }
                  }).toList(),
                ),
                bottomSpace(),
              ],
            ),
          ),
        ),
        topBarWidget(),
        bottomActionBarWidget(),
      ],
    );
  }

  Widget eagerLoadingWidget() {
    return FutureBuilder(
      future: _futureSingleArticle,
      builder: (context, articleSnapshot) {
        Article? article;
        if (articleSnapshot.hasData) {
          if(articleSnapshot.data != null && articleSnapshot.data!.isNotEmpty){
            List<dynamic> list = articleSnapshot.data!;
            article = list[0];
          }else{
            return noResultFoundPage();
          }

          return Stack(
            children: [
              RefreshIndicatorWidget(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: propertyDetailPageConfigList.map((map) {
                          return PropertyDetailsPageWidgets(
                            propertyDetailsPageData: map,
                            article: article!,
                            propertyID: article.id,
                            heroId: widget.heroId!,
                            fromEagerLoading: true,
                            latestArticleData: _article,
                            widgetsHook: HooksConfigurations.widgetItem,
                            latestArticleDataIsReady: latestArticleDataIsReady,
                            realtorInfoMap: _realtorInfoMap,
                            realtorInfoList: _realtorInfoList,
                            thumbnail: widget.thumbnail,
                            propertyDetailsPageWidgetsListener: (Map<String, dynamic> propertyDetailsPageDataMap, bool isDataLoaded){
                              if(isDataLoaded){
                                latestArticleDataIsReady = false;
                              }
                            },
                          );
                        }).toList(),
                      ),
                      bottomSpace(),
                    ],
                  ),
                ),
              ),
              topBarWidget(),
              bottomActionBarWidget(),
            ],
          );
        } else if (articleSnapshot.hasError) {
          return noResultFoundPage();
        }
        return LoadingIndicatorWidget();
      },
    );
  }

  Future<void> onRefresh() async{
    loadData();
    GeneralNotifier().publishChange(GeneralNotifier.PROPERTY_DETAILS_RELOADED);
    return null;
  }

  void onPrintPropertyIconPressed() async {
    final url = await _propertyBloc.fetchPrintPdfPropertyResponse(
        { "propid": widget.propertyID.toString() }
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  void onSharePropertyIconPressed() {
    Share.share(
        UtilityMethods.getLocalizedString(
            "property_share_msg",
            inputWords: ["${UtilityMethods.stripHtmlIfNeeded(_article!.title!)}.",
              _article!.link!.isEmpty ? _articleLink : _article!.link],
        ),
    );
  }

  void onFavPropertyIconPressed() async {
    if (isInternetConnected) {
      if (isLoggedIn) {
        if (mounted) {
          setState(() {
            isLiked = !isLiked;
          });
        }
        Map<String, dynamic> addOrRemoveFromFavInfo = {
          "listing_id": widget.propertyID,
        };

        var response = await _propertyBloc.fetchAddOrRemoveFromFavResponse(addOrRemoveFromFavInfo);

        String tempResponseString = response.toString().split("{")[1];
        Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
        if (mounted) {
          setState(() {
            if (map['added'] == true) {
              isLiked = true;
              _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("add_to_fav"), false);
              GeneralNotifier().publishChange(GeneralNotifier.NEW_FAV_ADDED_REMOVED);
            }
            else if (map['added'] == false) {
              isLiked = false;
              _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("remove_from_fav"), false);
              GeneralNotifier().publishChange(GeneralNotifier.NEW_FAV_ADDED_REMOVED);
            }
          });
        }
      }
      else {
        _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("you_must_login") + UtilityMethods.getLocalizedString("before_adding_to_favorites"), true);
      }
    }
  }

  Widget topBarWidget() {
    return TopBarWidget(
      opacity: _opacity,
      isLiked: isLiked,
      propertyID: widget.propertyID,
      propertyTitle: _article!.title!,
      onFavPropertyIconPressed: () => onFavPropertyIconPressed(),
      onSharePropertyIconPressed: () => onSharePropertyIconPressed(),
      onPrintPropertyIconPressed: () => onPrintPropertyIconPressed(),
      onReportButtonPressed: () => onReportButtonPressed(),
    );
  }

  Widget bottomActionBarWidget() {
    return PropertyProfileBottomButtonActionBar(
      isInternetConnected: isInternetConnected,
      noInternetOnPressed: checkInternetAndLoadData,
      articleLink: _articleLink,
      agentDisplayOption: agentDisplayOption,
      article: _article,
      realtorInfoMap: _realtorInfoMap,
      profileBottomButtonActionBarListener: ({isBottomButtonActionBarDisplayed, isInternetOK}){
        if (isBottomButtonActionBarDisplayed != null && isBottomButtonActionBarDisplayed) {
          showBottomSpace = true;
        } else {
          showBottomSpace = false;
        }

        if (isInternetOK != null && mounted) {
          setState(() {
            isInternetConnected = isInternetOK;
          });
        }
      },
    );
  }

  Widget bottomSpace() {
    if (showBottomSpace) {
      return SafeArea(
        bottom: true,
        child: SizedBox(
          height: 45,
          child: Container(),
        ),
      );
    }

    return Container();
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText:
      UtilityMethods.getLocalizedString("no_properties_error_message_search_by_id"),
      showBackNavigationIcon: true,
    );
  }

  _showToastWhileDataLoading(BuildContext context, String msg, bool forLogin) {
    !forLogin
        ? ShowToastWidget(
      buildContext: context,
      text: msg,
    )
        : ShowToastWidget(
      buildContext: context,
      showButton: true,
      buttonText: UtilityMethods.getLocalizedString("login"),
      text: msg,
      toastDuration: 4,
      onButtonPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserSignIn(
                  (String closeOption) {
                if (closeOption == CLOSE) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void navigateToAddReviewPage() {
    isLoggedIn ? Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReview(
          listingId: widget.propertyID,
          listingTitle: _article!.title,
          reviewPostType: _article!.type,
          permaLink: _article!.link,
        ),
      ),
    ) : _showToastWhileDataLoading(
      context,
      UtilityMethods.getLocalizedString("you_must_login") + UtilityMethods.getLocalizedString("before_leaving_a_review"),
      true,
    );
  }

  onReportButtonPressed() {
    ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("report"),
      content: GenericTextWidget(UtilityMethods.getLocalizedString("Are you sure you want to report this?")),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:
          GenericTextWidget(UtilityMethods.getLocalizedString("cancel"), style: AppThemePreferences().appTheme.label01TextStyle,),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            isLoggedIn ?
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ReportProperty(
                      informationMap: {
                        SEND_EMAIL_APP_BAR_TITLE:
                        UtilityMethods.getLocalizedString("Report an Abuse"),
                        SEND_EMAIL_REALTOR_ID: tempRealtorId,
                        SEND_EMAIL_REALTOR_NAME: tempRealtorName,
                        SEND_EMAIL_REALTOR_EMAIL: tempRealtorEmail,
                        SEND_EMAIL_REALTOR_TYPE: agentDisplayOption,
                        SEND_EMAIL_MESSAGE: UtilityMethods.getLocalizedString(
                            "hello_i_am_interested_in",
                            inputWords: [
                              UtilityMethods.stripHtmlIfNeeded(widget.article!.title!),
                              widget.article!.link!,
                              tempRealtorLink
                            ]),
                        SEND_EMAIL_THUMBNAIL: tempRealtorThumbnail,
                        SEND_EMAIL_SITE_NAME: APP_NAME,
                        SEND_EMAIL_LISTING_ID: widget.article!.id,
                        SEND_EMAIL_LISTING_NAME: widget.article!.title,
                        SEND_EMAIL_UNIQUE_ID: widget.article!.propertyInfo!.uniqueId!,
                        SEND_EMAIL_SOURCE: PROPERTY,
                        SEND_EMAIL_LISTING_LINK: _article!.link!.isNotEmpty ? _article!.link!: widget.article!.link,
                      },
                    ),
              ),
            ) : _showToastWhileDataLoading(context, UtilityMethods.getLocalizedString("You must log in before reporting a property"), true);
          },
          child: GenericTextWidget(UtilityMethods.getLocalizedString("yes"), style: AppThemePreferences().appTheme.label01TextStyle,),
        ),
      ],
    );
  }
}

class TopBarWidget extends StatelessWidget {
  final double opacity;
  final String propertyTitle;
  final bool isLiked;
  final int? propertyID;
  final void Function() onPrintPropertyIconPressed;
  final void Function() onSharePropertyIconPressed;
  final void Function() onFavPropertyIconPressed;
  final void Function() onReportButtonPressed;

  const TopBarWidget({
    super.key,
    this.propertyID,
    required this.opacity,
    required this.propertyTitle,
    required this.isLiked,
    required this.onPrintPropertyIconPressed,
    required this.onSharePropertyIconPressed,
    required this.onFavPropertyIconPressed,
    required this.onReportButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        //height: 90,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppThemePreferences().appTheme.backgroundColor!.withOpacity(opacity),
          border: Border(
            bottom: BorderSide(
              width: AppThemePreferences.propertyDetailsPageTopBarDividerBorderWidth,
              color: AppThemePreferences().appTheme.propertyDetailsPageTopBarDividerColor!.withOpacity(opacity),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppThemePreferences().appTheme.propertyDetailsPageTopBarShadowColor!.withOpacity(opacity),
              offset: const Offset(0.0, 4.0), //(x,y)
              blurRadius: 3.0,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          /// Background Container() Widget
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// Back Page Navigation Widget
                // widget.propertyID == null
                //     ? Container()
                //     :
                Expanded(
                    flex: 2,
                    child: TopBarButtonWidget(
                      iconData: AppThemePreferences.arrowBackIcon,
                      onPressed: () => Navigator.of(context).pop(),
                    )
                ),

                /// Property Title Widget
                Expanded(
                  flex: 6,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: GenericTextWidget(
                        UtilityMethods.stripHtmlIfNeeded(propertyTitle),
                        overflow: TextOverflow.ellipsis,
                        style: AppThemePreferences().appTheme.propertyDetailsPageTopBarTitleTextStyle,
                      ),
                    ),
                  ),
                ),

                /// Favourite Property Widget
                Expanded(
                  flex: 2,
                  child: TopBarButtonWidget(
                    iconData: isLiked
                        ? AppThemePreferences.favouriteIconFilled
                        : AppThemePreferences.favouriteBorderIcon,
                    iconColor: isLiked
                        ? AppThemePreferences.favouriteIconColor : null,
                    onPressed: () => onFavPropertyIconPressed(),
                  ),
                ),

                /// Share Widget
                Expanded(
                  flex: 2,
                  child: TopBarButtonWidget(
                    iconData: AppThemePreferences.shareIcon,
                    onPressed: () => onSharePropertyIconPressed(),
                  ),
                ),

                /// Share Widget
                if (SHOW_PRINT_PROPERTY_BUTTON && propertyID != null)
                  Expanded(
                    flex: 2,
                    child: TopBarButtonWidget(
                      iconData: AppThemePreferences.printIcon,
                      onPressed: () => onPrintPropertyIconPressed(),
                    ),
                  ),

                if (propertyID != null)
                  Expanded(
                    flex: 2,
                    child: TopBarButtonWidget(
                      iconData: AppThemePreferences.flagOutlined,
                      onPressed: () => onReportButtonPressed(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopBarButtonWidget extends StatelessWidget {
  final IconData iconData;
  final Color? iconColor;
  final Color? bgColor;
  final double? iconSize;
  final double? circularRadius;
  final void Function()? onPressed;

  const TopBarButtonWidget({
    super.key,
    required this.iconData,
    this.iconColor,
    this.iconSize,
    this.circularRadius,
    this.bgColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: bgColor ?? AppThemePreferences().appTheme.propertyDetailsPageTopBarIconsBackgroundColor,
      radius: circularRadius ?? AppThemePreferences.propertyDetailsPageTopBarCircularAvatarRadius,
      child: IconButton(
        icon: Icon(
          iconData,
          color: iconColor ?? AppThemePreferences().appTheme.propertyDetailsPageTopBarIconsColor,
          size: iconSize ?? AppThemePreferences.propertyDetailsPageTopBarIconsIconSize,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 80,
        height: 20,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          colors: [AppThemePreferences().appTheme.primaryColor!],
        ),
      ),
    );
  }
}


