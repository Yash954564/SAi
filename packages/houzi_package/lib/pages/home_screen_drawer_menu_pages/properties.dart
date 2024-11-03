import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/pages/add_property_v2/add_property_utilities.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/add_property_v2/add_property_v2.dart';
import 'package:houzi_package/pages/in_app_purchase/payment_page.dart';
import 'package:houzi_package/bloc/api_providers/houzez_api_provider.dart';
import 'package:houzi_package/bloc/api_providers/property_api_provider.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_for_properties.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design_for_uploads.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/private_note_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/widgets/article_box_widgets/article_box_design_for_drafts.dart';
import 'package:houzi_package/widgets/generic_bottom_sheet_widget/generic_bottom_sheet_widget.dart';


class Properties extends StatefulWidget {
  final bool? showUploadingProgress;
  final int? uploadProgress;

  const Properties({
    Key? key,
    this.showUploadingProgress = false,
    this.uploadProgress,
  }) : super(key: key);

  @override
  _PropertiesState createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> with TickerProviderStateMixin {
  List<dynamic> allPropertiesList = [];
  Future<List<dynamic>>? _futureAllProperties;

  List<dynamic> myPropertiesList = [];
  Future<List<dynamic>>? _futureMyProperties;

  bool isInternetConnected = true;
  bool isMyPropertiesLoaded = true;
  bool isAllPropertiesLoaded = true;

  bool shouldLoadMoreMyProperties = true;
  bool isLoadingMyProperties = false;

  bool shouldLoadMoreAllProperties = true;
  bool isLoadingAllProperties = false;

  String userRole = "";
  int? userId;

  String status = "any";
  int pageForAllProperties = 1;
  int pageForMyProperties = 1;
  int perPage = 10;

  final PropertyBloc _propertyBloc = PropertyBloc();
  final PropertyApiProvider _propertyApiProvider = PropertyApiProvider(HOUZEZApiProvider());

  final RefreshController _refreshControllerForAllProperties = RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerForMyProperties = RefreshController(initialRefresh: false);
  final RefreshController _refreshControllerForDraftProperties = RefreshController(initialRefresh: false);

  TabController? _tabController;

  List<dynamic> _draftPropertiesList = [];

  int _tabControllerLength = 2;

  List<Widget> _tabsChildrenList = [];

  Map userPaymentStatusMap = {};

  VoidCallback? propertyUploadListener;

  List<dynamic> _uploadingPropertiesList = [];
  bool _foundUploadingProperties = false;
  int? _uploadingProgress;

  @override
  void initState() {
    super.initState();
    userId = HiveStorageManager.getUserId();
    userRole = HiveStorageManager.getUserRole();

    getUserPaymentStatus();
    loadData();

    if (widget.showUploadingProgress != null && widget.showUploadingProgress!) {
      if (mounted) {
        setState(() {
          _uploadingPropertiesList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
          _uploadingProgress = widget.uploadProgress;
        });
      }
    }

    /// Property Upload Listener
    propertyUploadListener = () {
      if (mounted) {
        setState(() {
          _foundUploadingProperties = !PropertyManager().isPropertyUploaderFree;
          _uploadingProgress = PropertyManager().getTotalProgress;

          if (_foundUploadingProperties) {
            _uploadingPropertiesList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
          } else {
            _uploadingPropertiesList = [];
          }

          if (_uploadingProgress == 100) {
            loadDataFromApiMyProperties();
            PropertyManager().setTotalProgress = null;
          }
        });
      }
    };
    PropertyManager().addListener(propertyUploadListener!);
  }

  getUserPaymentStatus() async {
    userPaymentStatusMap = await _propertyBloc.fetchUserPaymentStatus();
    print(userPaymentStatusMap);
  }

  checkInternetAndLoadData(){
    if(!isMyPropertiesLoaded){
      if(mounted){
        setState(() {
          shouldLoadMoreMyProperties = true;
          isLoadingMyProperties = false;
          loadDataFromApiMyProperties();
        });
      }
    }
    if(!isAllPropertiesLoaded){
      if(mounted){
        setState(() {
          shouldLoadMoreAllProperties = true;
          isLoadingAllProperties = false;
          loadDataFromApiAllProperties();
        });
      }
    }
    // loadData();
  }

  loadData(){
    /// Load Draft Properties
    _draftPropertiesList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];

    /// if Admin is Logged, Load All Properties
    if(userRole == ROLE_ADMINISTRATOR){
      loadDataFromApiAllProperties();
      if(SHOW_DRAFTS){
        if(mounted){
          setState(() {
            _tabControllerLength = 3;
          });
        }
      }
    }
    /// Load User's Properties
    loadDataFromApiMyProperties();

    _tabController = TabController(length: _tabControllerLength, vsync: this);
  }

  @override
  dispose() {

    _uploadingProgress = null;
    _uploadingPropertiesList = [];
    userPaymentStatusMap = {};
    myPropertiesList = [];
    allPropertiesList = [];
    _futureAllProperties = null;
    _futureMyProperties = null;

    if(_tabController != null){
      _tabController!.dispose();
    }

    if (propertyUploadListener != null) {
      PropertyManager().removeListener(propertyUploadListener!);
    }
    super.dispose();
  }

  loadDataFromApiMyProperties({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoadingMyProperties) {
        return;
      }
      setState(() {
        isLoadingMyProperties = true;
      });

      pageForMyProperties = 1;
      _futureMyProperties = fetchMyProperties(pageForMyProperties);
      _refreshControllerForMyProperties.refreshCompleted();
    } else {
      if (!shouldLoadMoreMyProperties || isLoadingMyProperties) {
        _refreshControllerForMyProperties.loadComplete();
        return;
      }
      setState(() {
        // isRefreshing = false;
        shouldLoadMoreMyProperties = true;
      });
      pageForMyProperties++;
      _futureMyProperties = fetchMyProperties(pageForMyProperties);
      _refreshControllerForMyProperties.loadComplete();

    }
  }

  Future<List<dynamic>> fetchMyProperties(int page) async {
    if (page == 1) {
      setState(() {
        shouldLoadMoreMyProperties = true;
      });
    }
    List<dynamic> tempList = await _propertyBloc.fetchMyProperties(status, page, perPage, userId!);
    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isMyPropertiesLoaded = false;
          shouldLoadMoreMyProperties = false;
        });
      }
      return myPropertiesList;
    }else{
      if (mounted) {
        setState(() {
          isMyPropertiesLoaded = true;
          isInternetConnected = true;
        });
      }
      if(tempList.isEmpty || tempList.length < perPage){
        if(mounted){
          setState(() {
            shouldLoadMoreMyProperties = false;
          });
        }
      }

      if (page == 1) {
        myPropertiesList.clear();
      }
      if (tempList.isNotEmpty) {
        myPropertiesList.addAll(tempList);
      }
    }

    return myPropertiesList;
  }

  loadDataFromApiAllProperties({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoadingAllProperties) {
        return;
      }
      setState(() {
        //isRefreshing = true;
        isLoadingAllProperties = true;
      });

      pageForAllProperties = 1;
      _futureAllProperties = fetchAllProperties(pageForAllProperties);
      _refreshControllerForAllProperties.refreshCompleted();
    } else {
      if (!shouldLoadMoreAllProperties || isLoadingAllProperties) {
        _refreshControllerForAllProperties.loadComplete();
        return;
      }
      setState(() {
        // isRefreshing = false;
        shouldLoadMoreAllProperties = true;
      });
      pageForAllProperties++;
      _futureAllProperties = fetchAllProperties(pageForAllProperties);
      _refreshControllerForAllProperties.loadComplete();

    }
  }

  Future<List<dynamic>> fetchAllProperties(int page) async {
    if (page == 1) {
      setState(() {
        shouldLoadMoreAllProperties = true;
      });
    }
    List<dynamic> tempList = await _propertyBloc.fetchAllProperties(status, page, perPage, null);
    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isAllPropertiesLoaded = false;
          shouldLoadMoreAllProperties = false;
        });
      }
      return allPropertiesList;
    }else{
      if (mounted) {
        setState(() {
          isAllPropertiesLoaded = true;
          isInternetConnected = true;
        });
      }
      if(tempList.isEmpty || tempList.length < perPage){
        if(mounted){
          setState(() {
            shouldLoadMoreAllProperties = false;
          });
        }
      }

      if (page == 1) {
        allPropertiesList.clear();
      }
      if (tempList.isNotEmpty) {
        allPropertiesList.addAll(tempList);
      }
    }

    return allPropertiesList;
  }

  @override
  Widget build(BuildContext context) {
    _tabsChildrenList = (isMyPropertiesLoaded == false)
        ? [noInternetWidget()]
        : [
      PropertiesUploadingAndListingWidget(
        progress: _uploadingProgress,
        uploadingPropertiesList: _uploadingPropertiesList,
        listingWidget: showPropertiesList(_futureMyProperties!,
            fromMyProperties: true),
      )
    ];

    if (userRole == ROLE_ADMINISTRATOR) {
      isAllPropertiesLoaded == false ? _tabsChildrenList.insert(0, noInternetWidget()) :
      _tabsChildrenList.insert(0, showPropertiesList(_futureAllProperties!, fromMyProperties: false));
    }

    if (SHOW_DRAFTS) {
      _tabsChildrenList.add(draftPropertiesWidget(_draftPropertiesList));
    }

    if (widget.showUploadingProgress != null && widget.showUploadingProgress!) {
      if (_tabController != null && _tabControllerLength == 3) {
        // Animate to My Properties
        _tabController!.animateTo(1);
      }
    }

    return SHOW_DRAFTS ? propertiesWithDrafts() : propertiesWithOutDrafts();
  }

  Widget propertiesWithDrafts(){
    return DefaultTabController(
      length: _tabsChildrenList.length,
      child: Scaffold(
        appBar: appBarForDraftsWidget(), //appBarWithoutDraftsWidget()
        body: isInternetConnected == false
            ? Align(
          alignment: Alignment.topCenter,
          child: NoInternetConnectionErrorWidget(onPressed: () {
            checkInternetAndLoadData();
          }),
        )
            : TabBarView(
          controller: _tabController,
          children: _tabsChildrenList,
        ),
      ),
    );
  }

  Widget noInternetWidget(){
    return Align(
      alignment: Alignment.topCenter,
      child: NoInternetConnectionErrorWidget(
          onPressed: () {
            checkInternetAndLoadData();
          }),
    );
  }

  Widget propertiesWithOutDrafts(){
    return (userRole == ROLE_ADMINISTRATOR)
        ? DefaultTabController(
      length: _tabsChildrenList.length,
      child: propertiesWithOutDraftsBodyWidget(),
    )
        : propertiesWithOutDraftsBodyWidget();
  }

  Widget propertiesWithOutDraftsBodyWidget(){
    return Scaffold(
      appBar: appBarWithoutDraftsWidget(),
      body: isInternetConnected == false ? Align(
        alignment: Alignment.topCenter,
        child: NoInternetConnectionErrorWidget(onPressed: () {
          checkInternetAndLoadData();
        }),
      ) : (userRole == ROLE_ADMINISTRATOR) ? TabBarView(
        controller: _tabController,
        children: _tabsChildrenList,
      ) : showPropertiesList(_futureMyProperties!, fromMyProperties: true),
    );
  }

  PreferredSizeWidget appBarWithoutDraftsWidget() {
    List<Widget> _tabsList = [
      GenericTabWidget(label: UtilityMethods.getLocalizedString("all_properties")),
      GenericTabWidget(label: UtilityMethods.getLocalizedString("my_properties")),
    ];

    return AppBarWidget(
      appBarTitle: userRole == ROLE_ADMINISTRATOR ?
      UtilityMethods.getLocalizedString("properties") :
      UtilityMethods.getLocalizedString("my_properties"),
      bottom: userRole == ROLE_ADMINISTRATOR ? TabBar(
        controller: _tabController,
        indicatorColor: AppThemePreferences.tabBarIndicatorColor,
        tabs: _tabsList,
      ) : null,
    );
  }

  PreferredSizeWidget appBarForDraftsWidget() {
    List<Widget> _tabsList = [
      GenericTabWidget(label: UtilityMethods.getLocalizedString("my_properties")),
      GenericTabWidget(label: UtilityMethods.getLocalizedString("draft_properties")),
    ];
    if (userRole == ROLE_ADMINISTRATOR) {
      _tabsList.insert(0, GenericTabWidget(label: UtilityMethods.getLocalizedString("all_properties")));
    }

    return AppBarWidget(
      appBarTitle: UtilityMethods.getLocalizedString("properties"),
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: AppThemePreferences.tabBarIndicatorColor,
        tabs: _tabsList,
      ),
    );
  }

  Widget showPropertiesList(
      Future<List<dynamic>> future,
      {required bool fromMyProperties}) {
    return ShowPropertiesList(
      future: future,
      fromMyProperties: fromMyProperties,
      controller: fromMyProperties
          ? _refreshControllerForMyProperties
          : _refreshControllerForAllProperties,
      onRefresh: fromMyProperties
          ? loadDataFromApiMyProperties
          : loadDataFromApiAllProperties,
      onLoading: fromMyProperties
          ? ()=> loadDataFromApiMyProperties(forPullToRefresh: false)
          : ()=> loadDataFromApiAllProperties(forPullToRefresh: false),
      userPaymentStatusMap: userPaymentStatusMap,
      userRole: userRole,
      userId: userId,
      onDeletePressed: deleteProperty,
      onEditPressed: editProperty,
      changeStatusProperty: changeStatusProperty,
      payNow: payNow,
      removeFromFeatured: removeFromFeatured,
      setAsFeatured: setAsFeatured,
      upgradeToFeatured: upgradeToFeatured,
      adminToggleFeatured: adminToggleFeatured,
      setStatusSold: setStatusSold,
      setStatusExpire: setStatusExpire,
      setStatusPending: setStatusPending,
      shouldLoadMoreAllProperties: shouldLoadMoreAllProperties,
      shouldLoadMoreMyProperties: shouldLoadMoreMyProperties,
      listener: ({loadingAllProperties, loadingMyProperties}) {
        if (loadingAllProperties != null) {
          isLoadingAllProperties = loadingAllProperties;
        } else if (loadingMyProperties != null) {
          isLoadingMyProperties = loadingMyProperties;
        }
      },
    );
  }

  Widget genericOptionsOfBottomSheet(
      int propertyId,
      String label,
      {
        Article? article,
        int? propertyListIndex,
        Function(int?,int?)? onPressed,
        Function(int?,int?,bool)? onPressedForFeatured,
        Function(int?, int?, Article?,String?)? onPressedForStatus,
        String? changeStatusValue,
        TextStyle? style,
        bool showDivider = true,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: !showDivider? null : AppThemePreferences.dividerDecoration(),
        child: TextButtonWidget(
          child: GenericTextWidget(
            label,
            style: style ??
                AppThemePreferences().appTheme.bottomSheetOptionsTextStyle,
          ),
          onPressed: () async {
            if (label == UtilityMethods.getLocalizedString("put_on_hold") ||
                label == UtilityMethods.getLocalizedString("disapprove")||
                label == UtilityMethods.getLocalizedString("publish_property")) {
              onPressedForStatus!(
                propertyId,
                propertyListIndex,
                article,
                changeStatusValue,
              );
            } else if (label == UtilityMethods.getLocalizedString("set_featured") ||
                label == UtilityMethods.getLocalizedString("remove_featured")) {
              onPressedForFeatured!(propertyId, propertyListIndex,
                  label == UtilityMethods.getLocalizedString("set_featured")
                      ? true
                      : false);
            } else {
              onPressed!(propertyId, propertyListIndex);
            }
          },
        ),
      ),
    );
  }

  Future<void> editProperty(int? propertyId, int? propertyListIndex) async {
    final _articleResponseList =
    await _propertyBloc.fetchSingleArticle(propertyId!, forEditing: true);

    if (_articleResponseList.isEmpty) {
      print("Edit Property Error: Empty list received as response");
    } else {
      Map<String, dynamic> dataMapForUpdateProperty = {};

      dataMapForUpdateProperty[UPDATE_PROPERTY_ID] = '$propertyId';
      dataMapForUpdateProperty[ADD_PROPERTY_USER_ID] = '$userId';
      dataMapForUpdateProperty.addAll(
          AddPropertyUtilities.convertArticleToMapForEditing(
              _articleResponseList[0]));

      Navigator.pop(context);

      UtilityMethods.navigateToRouteByReplacement(
        context: context,
        builder: (context) => AddPropertyV2(
          isPropertyForUpdate: true,
          propertyDataMap: dataMapForUpdateProperty,
        ),
        // builder: (context) => AddProperty(
        //   isPropertyForUpdate: true,
        //   propertyDataMap: dataMapForUpdateProperty,
        // ),
      );
    }
  }

  Future<void> deleteProperty(int? propertyId,int? propertyListIndex) async {
    ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("delete"),
      content: GenericTextWidget(UtilityMethods.getLocalizedString("delete_confirmation")),
      actions: <Widget>[
        TextButtonWidget(
          onPressed: () => Navigator.pop(context),
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
        ),
        TextButtonWidget(
          onPressed: () async {
            final response = await _propertyBloc.deleteProperty(propertyId!);
            Navigator.pop(context);
            if (response.statusCode == 200) {
              setState(() {
                if (userRole == ROLE_ADMINISTRATOR) {
                  if (_tabController!.index == 0) {
                    allPropertiesList.removeAt(propertyListIndex!);
                    if (allPropertiesList.isEmpty) {
                      allPropertiesList.clear();
                    }
                  }
                  if (_tabController!.index == 1) {
                    myPropertiesList.removeAt(propertyListIndex!);
                    if (myPropertiesList.isEmpty) {
                      myPropertiesList.clear();
                    }
                  }
                } else {
                  myPropertiesList.removeAt(propertyListIndex!);
                  if (myPropertiesList.isEmpty) {
                    myPropertiesList.clear();
                  }
                }
              });
              Navigator.pop(context);
            }
          },
          child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
        ),
      ],
    );
  }

  Future<void>? changeStatusProperty(int? propertyId,int? propertyListIndex,Article? article,String? changeStatusValue) async {
    Map<String, dynamic> status = {
      "status": changeStatusValue,
    };
    final response = await _propertyBloc.statusOfProperty(status, propertyId!);

    if (response.statusCode == 200) {
      Article item = _propertyApiProvider.getCurrentParser().parseArticle(response.data);
      setState(() {
        article = item;
        if(userRole == ROLE_ADMINISTRATOR){
          if (_tabController!.index == 0) {
            allPropertiesList[propertyListIndex!] = article;
          }
          if (_tabController!.index == 1) {
            myPropertiesList[propertyListIndex!] = article;
          }
        } else {
          myPropertiesList[propertyListIndex!] = article;
        }

      });
      Navigator.pop(context);
    }
    getUserPaymentStatus();
  }

  Future<void> upgradeToFeatured(int? propertyId, int? propertyListIndex) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
            productIds: Platform.isAndroid ? [MAKE_FEATURED_ANDROID_PRODUCT_ID] : [MAKE_FEATURED_IOS_PRODUCT_ID],
            propId: propertyId.toString(),
            isMembership: false,
            isFeaturedForPerListing: userPaymentStatusMap[enablePaidSubmissionKey] == perListing ? true : false
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      loadDataFromApiMyProperties();
      loadDataFromApiAllProperties();
      return null;
    });
  }

  Future<void> payNow(int? propertyId, int? propertyListIndex) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          productIds: Platform.isAndroid ? [PER_LISTING_ANDROID_PRODUCT_ID] : [PER_LISTING_IOS_PRODUCT_ID],
          propId: propertyId.toString(),
          isMembership: false,
        ),
      ),
    ).then((value) {
      Navigator.pop(context);
      loadDataFromApiMyProperties();
      loadDataFromApiAllProperties();
      return null;
    });
  }

  adminToggleFeatured(int? propertyId, int? propertyListIndex, bool setFeatured) async {
    ApiResponse response = await _propertyBloc.fetchToggleFeaturedResponse({
      "listing_id": propertyId,
      "action": setFeatured ? MARK_FEATURED : REMOVE_FEATURED
    });
    setFeaturedStatus(response, propertyListIndex, setFeatured);
  }

  setFeaturedStatus(ApiResponse response, int? propertyListIndex,bool isFeatured) {
    if (response.success) {
      if(userRole == ROLE_ADMINISTRATOR){
        if (_tabController!.index == 0) {
          Article property = allPropertiesList[propertyListIndex!];
          property.propertyInfo!.isFeatured = isFeatured;
          allPropertiesList[propertyListIndex] = property;
        }
        if (_tabController!.index == 1) {
          Article property = myPropertiesList[propertyListIndex!];
          property.propertyInfo!.isFeatured = isFeatured;
          myPropertiesList[propertyListIndex] = property;
        }
      } else {
        Article property = myPropertiesList[propertyListIndex!];
        property.propertyInfo!.isFeatured = isFeatured;
        myPropertiesList[propertyListIndex] = property;
      }
      setState(() {});

    } else {
      ShowToastWidget(buildContext: context, text: response.message);
    }

    Navigator.pop(context);
    getUserPaymentStatus();
  }

  Future<void> setAsFeatured(int? propertyId,int? propertyListIndex) async {
    int featuredRemaining = int.tryParse(userPaymentStatusMap[featuredRemainingListingKey]) ?? 0;
    if (featuredRemaining > 0 ) {
      Map<String,dynamic> dataMap = {
        "propid" : propertyId,
        "prop_type": "membership"
      };
      ApiResponse response = await _propertyBloc.fetchMakePropertyFeaturedResponse(dataMap);
      if (response.success) {
        Article? article;
        if(userRole == ROLE_ADMINISTRATOR){
          if (_tabController!.index == 0) {
            article = allPropertiesList[propertyListIndex!];
          }
          if (_tabController!.index == 1) {
            article = myPropertiesList[propertyListIndex!];
          }
        } else {
          article = myPropertiesList[propertyListIndex!];
        }

        article!.propertyInfo!.isFeatured = true;


        if(userRole == ROLE_ADMINISTRATOR){
          if (_tabController!.index == 0) {
            allPropertiesList[propertyListIndex!] = article;
          }
          if (_tabController!.index == 1) {
            myPropertiesList[propertyListIndex!] = article;
          }
        } else {
          myPropertiesList[propertyListIndex!] = article;
        }

        setState(() {});

      } else {
        ShowToastWidget(buildContext: context, text: response.message);
      }
    } else {
      ShowToastWidget(buildContext: context, text: UtilityMethods.getLocalizedString("You have used all the Featured listings in your package"));
    }
    Navigator.pop(context);
    getUserPaymentStatus();

  }

  Future<void> removeFromFeatured(int? propertyId,int? propertyListIndex) async {
    ApiResponse response = await _propertyBloc.fetchRemoveFromFeaturedResponse({"propid" : propertyId,});
    if (response.success) {
      Article? article;
      if(userRole == ROLE_ADMINISTRATOR){
        if (_tabController!.index == 0) {
          article = allPropertiesList[propertyListIndex!];
        }
        if (_tabController!.index == 1) {
          article = myPropertiesList[propertyListIndex!];
        }
      } else {
        article = myPropertiesList[propertyListIndex!];
      }

      article!.propertyInfo!.isFeatured = false;


      if(userRole == ROLE_ADMINISTRATOR){
        if (_tabController!.index == 0) {
          allPropertiesList[propertyListIndex!] = article;
        }
        if (_tabController!.index == 1) {
          myPropertiesList[propertyListIndex!] = article;
        }
      } else {
        myPropertiesList[propertyListIndex!] = article;
      }

      setState(() {});

    } else {
      ShowToastWidget(buildContext: context, text: response.message);
    }

    Navigator.pop(context);
    getUserPaymentStatus();
  }


  setStatusSold(int? propertyId, int? propertyListIndex) async {
    ApiResponse response = await _propertyBloc.fetchSetSoldStatusResponse({
      "listing_id": propertyId,
      "action": MARK_AS_SOLD
    });
    if (response.success) {
      if (userRole == ROLE_ADMINISTRATOR) {
        if (_tabController!.index == 0) {
          Article property = allPropertiesList[propertyListIndex!];
          property.status = "houzez_sold";
          allPropertiesList[propertyListIndex] = property;
        }
        if (_tabController!.index == 1) {
          Article property = myPropertiesList[propertyListIndex!];
          property.status = "houzez_sold";
          myPropertiesList[propertyListIndex] = property;
        }
      } else {
        Article property = myPropertiesList[propertyListIndex!];
        property.status = "houzez_sold";
        myPropertiesList[propertyListIndex] = property;
      }
    } else {
      ShowToastWidget(buildContext: context, text: response.message);
    }

    Navigator.pop(context);
    setState(() {});
  }

  setStatusExpire(int? propertyId, int? propertyListIndex) async {
    ApiResponse response = await _propertyBloc.fetchSetExpiredStatusResponse({
      "listing_id": propertyId,
      "action": EXPIRED_LISTING
    });
    if (response.success) {
      if (userRole == ROLE_ADMINISTRATOR) {
        if (_tabController!.index == 0) {
          Article property = allPropertiesList[propertyListIndex!];
          property.status = "EXPIRED";
          allPropertiesList[propertyListIndex] = property;
        }
        if (_tabController!.index == 1) {
          Article property = myPropertiesList[propertyListIndex!];
          property.status = "EXPIRED";
          myPropertiesList[propertyListIndex] = property;
        }
      } else {
        Article property = myPropertiesList[propertyListIndex!];
        property.status = "EXPIRED";
        myPropertiesList[propertyListIndex] = property;
      }
    } else {
      ShowToastWidget(buildContext: context, text: response.message);
    }
    Navigator.pop(context);
    setState(() {});
  }

  setStatusPending(int? propertyId, int? propertyListIndex) async {
    ApiResponse response = await _propertyBloc.fetchSetPendingStatusResponse({
      "listing_id": propertyId,
      "action": STATUS_ON_PENDING
    });
    if (response.success) {
      if (userRole == ROLE_ADMINISTRATOR) {
        if (_tabController!.index == 0) {
          Article property = allPropertiesList[propertyListIndex!];
          property.status = STATUS_ON_PENDING;
          allPropertiesList[propertyListIndex] = property;
        }
        if (_tabController!.index == 1) {
          Article property = myPropertiesList[propertyListIndex!];
          property.status = STATUS_ON_PENDING;
          myPropertiesList[propertyListIndex] = property;
        }
      } else {
        Article property = myPropertiesList[propertyListIndex!];
        property.status = STATUS_ON_PENDING;
        myPropertiesList[propertyListIndex] = property;
      }
    } else {
      ShowToastWidget(buildContext: context, text: response.message);
    }
    Navigator.pop(context);
    setState(() {});
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

  Widget noResultFoundPage({
    bool hideGoBackButton = false,
    String? headerText,
    String? bodyText,
  }) {
    return NoResultErrorWidget(
      headerErrorText: headerText != null && headerText.isNotEmpty ? headerText : UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: bodyText != null && bodyText.isNotEmpty ? bodyText : UtilityMethods.getLocalizedString("no_properties_error_message"),
      hideGoBackButton: hideGoBackButton,
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

  Widget draftPropertiesWidget(List draftPropertiesList){
    return SmartRefresher(
      enablePullDown: true,
      header: const MaterialClassicHeader(),
      controller: _refreshControllerForDraftProperties,
      onRefresh: (){
        List tempList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
        setState(() {
          _draftPropertiesList = tempList;
        });
        _refreshControllerForDraftProperties.refreshCompleted();
      },
      child: draftPropertiesList == null || draftPropertiesList.isEmpty ? NoResultsFoundPage(
        hideGoBackButton: true,
        headerText: UtilityMethods.getLocalizedString("draft_properties_no_result_found_header_message"),
        bodyText: UtilityMethods.getLocalizedString("draft_properties_no_result_found_body_message"),
      ) :
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: draftPropertiesList.map((item) {
            int itemIndex = draftPropertiesList.indexOf(item);
            return ArticleBoxDesignForDraftProperties(
              article: UtilityMethods.convertUploadAndDraftMapItemToArticle(item),
              heroID: "Hero $itemIndex",
              onTap: ()=> _onEditDraftPressed(itemIndex: itemIndex, dataMap: UtilityMethods.convertMap(item)),
              onActionButtonTap: ()=> onActionButtonPressed(context: context, itemIndex: itemIndex, dataMap: item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future onActionButtonPressed({
    required BuildContext context,
    required int itemIndex,
    required Map dataMap
  }) {
    return genericBottomSheetWidget(
      context: context,
      children: <Widget>[
        GenericBottomSheetOptionWidget(
          label: UtilityMethods.getLocalizedString("edit"),
          style: AppThemePreferences().appTheme.bottomSheetOptionsTextStyle!,
          onPressed: ()=> _onEditDraftPressed(itemIndex: itemIndex, dataMap: dataMap, closeBottomSheet: true),
        ),
        GenericBottomSheetOptionWidget(
          label: UtilityMethods.getLocalizedString("delete"),
          showDivider: false,
          style: AppThemePreferences().appTheme.bottomSheetNegativeOptionsTextStyle!,
          onPressed: ()=> _onDeletePropertyPressed(itemIndex: itemIndex),
        ),
      ],
    );
  }

  _onEditDraftPressed({required int itemIndex, required Map dataMap, bool closeBottomSheet = false}){
    // Close Bottom Menu Sheet
    if(closeBottomSheet){
      Navigator.pop(context);
    }
    // Edit Property
    UtilityMethods.navigateToRoute(
      context: context,
      builder: (context) => AddPropertyV2(
        // builder: (context) => AddProperty(
        isDraftProperty: true,
        draftPropertyIndex: itemIndex,
        propertyDataMap: UtilityMethods.convertMap(dataMap),
        // propertyDataMap: dataMap,
      ),
    );
  }

  _onDeletePropertyPressed({required int itemIndex}){
    List<dynamic> _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
    _draftPropertiesDataMapsList.removeAt(itemIndex);
    setState(() {
      _draftPropertiesList = _draftPropertiesDataMapsList;
    });

    HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesList);
    // Close Bottom Menu Sheet
    Navigator.pop(context);
  }
}

class PropertiesUploadingAndListingWidget extends StatelessWidget {
  final Widget listingWidget;
  final List<dynamic> uploadingPropertiesList;
  final int? progress;

  const PropertiesUploadingAndListingWidget({
    super.key,
    required this.listingWidget,
    required this.uploadingPropertiesList,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UploadingPropertiesWidget(
          list: uploadingPropertiesList,
          progress: progress,
        ),
        Expanded(child: listingWidget),
        // listingWidget,
      ],
    );
  }
}

class UploadingPropertiesWidget extends StatelessWidget {
  final List<dynamic> list;
  final int? progress;

  const UploadingPropertiesWidget({
    super.key,
    required this.list,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list.map((propertyMap) {
        int itemIndex = list.indexOf(propertyMap);
        return UploadsArticleBox(
          article: UtilityMethods.convertUploadAndDraftMapItemToArticle(propertyMap),
          progress: progress,
          isActiveUpload: itemIndex == 0 ? true : false,
        );
      }).toList(),
    );
  }
}

typedef ShowPropertiesListListener = void Function({
bool? loadingMyProperties,
bool? loadingAllProperties,
});

class ShowPropertiesList extends StatelessWidget {
  final Future<List<dynamic>> future;
  final bool fromMyProperties;
  final bool shouldLoadMoreMyProperties;
  final bool shouldLoadMoreAllProperties;
  final int? userId;
  final String userRole;
  final ShowPropertiesListListener listener;
  final RefreshController controller;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final Function(int?, int?)? onEditPressed;
  final Function(int?, int?)? onDeletePressed;
  final Function(int?, int?)? upgradeToFeatured;
  final Function(int?, int?)? payNow;
  final Function(int?, int?)? setAsFeatured;
  final Function(int?, int?)? removeFromFeatured;
  final Function(int?, int?)? setStatusSold;
  final Function(int?, int?)? setStatusExpire;
  final Function(int?, int?)? setStatusPending;
  final Function(int?, int?, bool setFeatured)? adminToggleFeatured;
  final Function(int?, int?, Article?, String?)? changeStatusProperty;
  final Map<dynamic, dynamic> userPaymentStatusMap;

  const ShowPropertiesList({
    super.key,
    required this.future,
    this.fromMyProperties = false,
    this.shouldLoadMoreMyProperties = true,
    this.shouldLoadMoreAllProperties = true,
    required this.listener,
    this.userId,
    required this.userRole,
    required this.controller,
    required this.userPaymentStatusMap,
    this.onDeletePressed,
    this.onEditPressed,
    this.changeStatusProperty,
    this.payNow,
    this.removeFromFeatured,
    this.setAsFeatured,
    this.upgradeToFeatured,
    this.onRefresh,
    this.onLoading,
    this.setStatusSold,
    this.setStatusExpire,
    this.setStatusPending,
    this.adminToggleFeatured,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: future,
      builder: (context, articleSnapshot) {
        if (fromMyProperties) {
          listener(loadingMyProperties: false);
        } else {
          listener(loadingAllProperties: false);
        }
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return NoResultsFoundPage();
          }

          List<dynamic> list = articleSnapshot.data!;

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body = Container();
                if (mode == LoadStatus.loading) {
                  if (fromMyProperties) {
                    if (shouldLoadMoreMyProperties) {
                      body = PaginationLoadingWidget();
                    } else {
                      body = Container();
                    }
                  } else {
                    if (shouldLoadMoreAllProperties) {
                      body = PaginationLoadingWidget();
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
            controller: controller,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                Article item = list[index];
                var _propertyId = item.id;
                int? _author = item.author;
                String? _status = item.status;
                Map<String,dynamic> actionButtonMap = {
                  "item" : item,
                  "userId":userId,
                  "userRole":userRole,
                  "_status":_status,
                  "_propertyId":_propertyId,
                  "index":index,
                  "_author":_author
                };
                return PropertiesArticleBox(
                    actionButtonMap: actionButtonMap,
                    item: item,
                    onTap: () {
                      UtilityMethods.navigateToPropertyDetailPage(
                        context: context,
                        article: item,
                        propertyID: item.id,
                        heroId: item.id.toString() + RELATED,
                      );
                    },
                    propertiesArticleBoxWidgetListener: (Map<String,dynamic> actionButtonMap){
                      actionBottomSheet(
                        context: context,
                        actionButtonMap: actionButtonMap,
                        onEditPressed: onEditPressed,
                        onDeletePressed: onDeletePressed,
                        userPaymentStatusMap: userPaymentStatusMap,
                        changeStatusProperty: changeStatusProperty,
                        payNow: payNow,
                        removeFromFeatured: removeFromFeatured,
                        setAsFeatured: setAsFeatured,
                        upgradeToFeatured: upgradeToFeatured,
                        adminToggleFeatured: adminToggleFeatured,
                        setStatusSold: setStatusSold,
                        setStatusExpire: setStatusExpire,
                        setStatusPending: setStatusPending,
                      );
                    });
              },
            ),
          );
        } else if (articleSnapshot.hasError) {
          return NoResultsFoundPage();
        }
        return LoadingIndicatorWidget();
      },
    );
  }

  void actionBottomSheet({
    required BuildContext context,
    required Map<String, dynamic> actionButtonMap,
    Function(int?, int?)? onEditPressed,
    Function(int?, int?)? onDeletePressed,
    Function(int?, int?)? upgradeToFeatured,
    Function(int?, int?)? payNow,
    Function(int?, int?)? setAsFeatured,
    Function(int?, int?)? removeFromFeatured,
    Function(int?, int?)? setStatusSold,
    Function(int?, int?)? setStatusExpire,
    Function(int?, int?)? setStatusPending,
    Function(int?, int?, bool setFeatured)? adminToggleFeatured,
    Function(int?, int?, Article?, String?)? changeStatusProperty,
    required Map<dynamic, dynamic> userPaymentStatusMap,
  }) {
    Article article = actionButtonMap["item"];
    bool isFeatured = article.propertyInfo?.isFeatured ?? false;
    bool showPayNow = false;
    if (TOUCH_BASE_PAYMENT_ENABLED_STATUS == perListing && actionButtonMap["_status"] != STATUS_PUBLISH) {
      String paymentStatus = article.propertyInfo!.paymentStatus ?? "";
      if (paymentStatus == "not_paid") {
        showPayNow = true;
      }
    }
    GenericOptionOfBottomSheet? featuredOption = getFeaturedOption(isFeatured, actionButtonMap, showPayNow);
    List<Widget> list =  [
      if (actionButtonMap["_author"] == userId)
        GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("edit"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          onPressed: onEditPressed,
          icon: Icon(AppThemePreferences.editIcon),
        ),
      if (actionButtonMap["_author"] == userId &&
          article.propertyInfo!.privateNote != null &&
          article.propertyInfo!.privateNote!.isNotEmpty)
        GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("Private Note"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          icon: Icon(AppThemePreferences.descriptionOutlined),
          onPressed: (a, b) {
            Article article = actionButtonMap["item"];
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivateNoteWidget(
                  article.propertyInfo!.privateNote!,
                ),
              ),
            );
          },
        ),
      if (actionButtonMap["_author"] == userId || userRole == ROLE_ADMINISTRATOR)
        GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("delete"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          onPressed: onDeletePressed,
          icon: Icon(AppThemePreferences.deleteIcon,color: AppThemePreferences.bottomSheetNegativeOptionsTextColor,),
          style: AppThemePreferences().appTheme.bottomSheetNegativeOptionsTextStyle!,
        ),
      if (userRole == ROLE_ADMINISTRATOR)
        if (actionButtonMap["_author"] == userId && actionButtonMap["_status"] != STATUS_ON_HOLD)
          GenericOptionOfBottomSheet(
            propertyId: actionButtonMap["_propertyId"],
            label: UtilityMethods.getLocalizedString("put_on_hold"),
            propertyListIndex: actionButtonMap["index"],
            article: actionButtonMap["item"],
            onPressedForStatus: changeStatusProperty,
            changeStatusValue: STATUS_ON_HOLD,
            icon: Icon(AppThemePreferences.toggleOnOutlined),
          )
        else if(actionButtonMap["_status"] != STATUS_ON_HOLD)
          GenericOptionOfBottomSheet(
              propertyId: actionButtonMap["_propertyId"],
              label: UtilityMethods.getLocalizedString("put_on_hold"),
              propertyListIndex: actionButtonMap["index"],
              article: actionButtonMap["item"],
              onPressedForStatus: changeStatusProperty,
              changeStatusValue: STATUS_ON_HOLD,
              icon: Icon(AppThemePreferences.toggleOnOutlined)
          ),
      if (userRole == ROLE_ADMINISTRATOR &&
          (actionButtonMap["_status"] == STATUS_ON_PENDING
              || actionButtonMap["_status"] == STATUS_ON_HOLD))
        GenericOptionOfBottomSheet(
            propertyId: actionButtonMap["_propertyId"],
            label: UtilityMethods.getLocalizedString("publish_property"),
            propertyListIndex: actionButtonMap["index"],
            article: actionButtonMap["item"],
            onPressedForStatus: changeStatusProperty,
            changeStatusValue: STATUS_PUBLISH,
            icon: Icon(AppThemePreferences.checkOutlined)
        ),

      if (featuredOption != null) featuredOption,
      if (userRole == ROLE_ADMINISTRATOR && actionButtonMap["_status"] != "houzez_sold")
        GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("Mark As Sold"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          onPressed: setStatusSold,
          icon: Icon(AppThemePreferences.sellOutlined),
        ),

      if (userRole == ROLE_ADMINISTRATOR && actionButtonMap["_status"] != "expired")
        GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("Mark As Expired"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          onPressed: setStatusExpire,
          icon: Icon(AppThemePreferences.expiredOutlined),
        ) else if (userRole == ROLE_ADMINISTRATOR && (actionButtonMap["_status"] == "expired" || actionButtonMap["_status"] == "EXPIRED"))
        GenericOptionOfBottomSheet(
            propertyId: actionButtonMap["_propertyId"],
            label: UtilityMethods.getLocalizedString("Re-List"),
            propertyListIndex: actionButtonMap["index"],
            article: actionButtonMap["item"],
            onPressed: setStatusPending,
            icon: Icon(AppThemePreferences.checkOutlined)
        )
    ];

    showModelBottomSheetWidget(
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: list.length,
                itemBuilder: (context, index){
                  return list[index];
                }
            ),
          );
        }
    );
  }

  GenericOptionOfBottomSheet? getFeaturedOption(
      bool isFeatured,
      Map<String, dynamic> actionButtonMap,
      bool showPayNow) {
    if (!isFeatured) {
      if (actionButtonMap["_author"] == userId) {
        //author user and not featured and free listing paid featured.
        if (userPaymentStatusMap[enablePaidSubmissionKey] == freePaidListing
            && actionButtonMap["_status"] == STATUS_PUBLISH
        ) {
          return GenericOptionOfBottomSheet(
              propertyId: actionButtonMap["_propertyId"],
              label: UtilityMethods.getLocalizedString("upgrade_featured"),
              propertyListIndex: actionButtonMap["index"],
              article: actionButtonMap["item"],
              onPressed: upgradeToFeatured,
              icon: Icon(AppThemePreferences.upgradeOutlined)
          );
        }
        //author user and not featured and paid listing
        if (userPaymentStatusMap[enablePaidSubmissionKey] == perListing
            && actionButtonMap["_status"] == STATUS_PUBLISH
        ) {
          return GenericOptionOfBottomSheet(
              propertyId: actionButtonMap["_propertyId"],
              label: UtilityMethods.getLocalizedString("upgrade_featured"),
              propertyListIndex: actionButtonMap["index"],
              article: actionButtonMap["item"],
              onPressed: upgradeToFeatured,
              icon: Icon(AppThemePreferences.upgradeOutlined)
          );
        }
        //author user and not featured and paid listing and haven't paid
        if (userPaymentStatusMap[enablePaidSubmissionKey] == perListing
            && showPayNow) {
          return GenericOptionOfBottomSheet(
              propertyId: actionButtonMap["_propertyId"],
              label: UtilityMethods.getLocalizedString("pay_now"),
              propertyListIndex: actionButtonMap["index"],
              article: actionButtonMap["item"],
              onPressed: payNow,
              icon: Icon(AppThemePreferences.paymentsOutlined)
          );
        }
        //author user and not featured and membership
        if (userPaymentStatusMap[enablePaidSubmissionKey] == membership
            && actionButtonMap["_status"] == STATUS_PUBLISH
        )
          return GenericOptionOfBottomSheet(
              propertyId: actionButtonMap["_propertyId"],
              label: UtilityMethods.getLocalizedString("set_featured"),
              propertyListIndex: actionButtonMap["index"],
              article: actionButtonMap["item"],
              onPressed: setAsFeatured,
              icon: Icon(AppThemePreferences.starOutlinedIcon)
          );
      }
      if (userRole == ROLE_ADMINISTRATOR) {
        return GenericOptionOfBottomSheet(
            propertyId: actionButtonMap["_propertyId"],
            label: UtilityMethods.getLocalizedString("set_featured"),
            propertyListIndex: actionButtonMap["index"],
            article: actionButtonMap["item"],
            onPressedForFeatured: adminToggleFeatured,
            icon: Icon(AppThemePreferences.starOutlinedIcon)
        );
      }
    }

    if (isFeatured) {
      if (actionButtonMap["_author"] == userId
          && userPaymentStatusMap[enablePaidSubmissionKey] == membership
          && actionButtonMap["_status"] == STATUS_PUBLISH
      ) {
        return GenericOptionOfBottomSheet(
            propertyId: actionButtonMap["_propertyId"],
            label: UtilityMethods.getLocalizedString("remove_featured"),
            propertyListIndex: actionButtonMap["index"],
            article: actionButtonMap["item"],
            onPressed: removeFromFeatured,
            icon: Icon(AppThemePreferences.starHalfOutlined)
        );
      }
      if (userRole == ROLE_ADMINISTRATOR) {
        return GenericOptionOfBottomSheet(
          propertyId: actionButtonMap["_propertyId"],
          label: UtilityMethods.getLocalizedString("remove_featured"),
          propertyListIndex: actionButtonMap["index"],
          article: actionButtonMap["item"],
          onPressedForFeatured: adminToggleFeatured,
          icon: Icon(AppThemePreferences.starHalfOutlined),
        );
      }
    }

  }
}

class GenericOptionOfBottomSheet extends StatelessWidget {
  final int propertyId;
  final String label;
  final bool showDivider;
  final TextStyle? style;
  final Article? article;
  final int? propertyListIndex;
  final Widget icon;
  final Function(int?, int?)? onPressed;
  final Function(int?, int?, bool)? onPressedForFeatured;
  final Function(int?, int?, Article?, String?)? onPressedForStatus;
  final String? changeStatusValue;

  const GenericOptionOfBottomSheet({
    super.key,
    required this.label,
    required this.propertyId,
    this.showDivider = true,
    this.style,
    this.article,
    this.propertyListIndex,
    this.onPressed,
    this.onPressedForStatus,
    this.onPressedForFeatured,
    this.changeStatusValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: InkWell(
        onTap: () async {
          if (label == UtilityMethods.getLocalizedString("put_on_hold") ||
              label == UtilityMethods.getLocalizedString("publish_property")) {
            onPressedForStatus!(
              propertyId,
              propertyListIndex,
              article,
              changeStatusValue,
            );
          } else if (label == UtilityMethods.getLocalizedString("set_featured") ||
              label == UtilityMethods.getLocalizedString("remove_featured")) {
            if (onPressedForFeatured != null) {
              onPressedForFeatured!(
                propertyId,
                propertyListIndex,
                label == UtilityMethods.getLocalizedString("set_featured")
                    ? true
                    : false,
              );
            } else {
              onPressed!(propertyId, propertyListIndex);
            }
          } else {
            onPressed!(propertyId, propertyListIndex);
          }
        },
        child: Container(
          decoration: AppThemePreferences.dividerDecoration(right: true,bottom: true),
          // decoration: BoxDecoration(
          //
          //   // color: isSelected
          //   //     ? AppThemePreferences().appTheme.primaryColor
          //   //     : AppThemePreferences().appTheme.containerBackgroundColor,
          //   borderRadius: const BorderRadius.all(Radius.circular(5)),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              GenericTextWidget(
                label,
                textAlign: TextAlign.center,
                style: style ??
                    AppThemePreferences().appTheme.bottomSheetOptionsTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GenericTabWidget extends StatelessWidget {
  final String label;

  const GenericTabWidget({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: GenericTextWidget(
        label,
        style: AppThemePreferences().appTheme.genericTabBarTextStyle,
      ),
    );
  }
}

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class NoResultsFoundPage extends StatelessWidget {
  final bool? hideGoBackButton;
  final String? headerText;
  final String? bodyText;

  const NoResultsFoundPage({
    super.key,
    this.hideGoBackButton = false,
    this.headerText,
    this.bodyText,
  });

  @override
  Widget build(BuildContext context) {
    return NoResultErrorWidget(
      headerErrorText: headerText ?? UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: bodyText ?? UtilityMethods.getLocalizedString("no_properties_error_message"),
      hideGoBackButton: hideGoBackButton ?? false,
    );
  }
}



