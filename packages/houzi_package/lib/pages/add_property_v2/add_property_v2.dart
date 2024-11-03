import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/pages/in_app_purchase/membership_plan_page.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_page_widget.dart';

import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:houzi_package/widgets/generic_bottom_sheet_widget/generic_bottom_sheet_widget.dart';

class AddPropertyV2 extends StatefulWidget {
  final bool isPropertyForUpdate;
  final propertyDataMap;
  final bool isDraftProperty;
  final int? draftPropertyIndex;

  const AddPropertyV2({
    Key? key,
    this.isPropertyForUpdate = false,
    this.propertyDataMap,
    this.isDraftProperty = false,
    this.draftPropertyIndex,
  }) : super(key: key);

  @override
  State<AddPropertyV2> createState() => _AddPropertyV2State();
}

class _AddPropertyV2State extends State<AddPropertyV2> with WidgetsBindingObserver {

  List<HouziFormPage> formPagesList = [];
  List<HouziFormItem> formItemsList = [];
  List<GlobalKey<FormState>> formStateKeysList = [];

  Map<String, dynamic> addPropertyDataMap = {
    ADD_PROPERTY_ACTION : 'add_property',
    ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP : 'no',
    ADD_PROPERTY_MULTI_UNITS : '${0}',
    ADD_PROPERTY_FLOOR_PLANS_ENABLE : '0',
    ADD_PROPERTY_DRAFT_INDEX : -1,
  };

  int _page = 1;

  String nonce = "";
  String imageNonce = "";
  String _userRole = '';
  String _defaultCurrency = '';

  List<Widget> _addPropertyPages = [];
  List<dynamic> _addPropertiesDataMapsList = [];
  List<dynamic> _draftPropertiesDataMapsList = [];

  static const _kCurve = Curves.ease;
  static const _kDuration = Duration(milliseconds: 300);

  bool isCancel = false;
  bool isLoggedIn = false;
  bool isInternetConnected = true;
  bool showUpgradePackageDialog = false;

  final PropertyBloc _propertyBloc = PropertyBloc();
  final PageController _pageController = PageController();

  late Future _userPaymentStatusFuture;

  @override
  void initState() {
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);
    //
    _userPaymentStatusFuture = fetchUserPaymentStatus();
    fetchNonce();

    // fetchTermsData();

    _userRole = HiveStorageManager.getUserRole();
    _defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? '\$';
    addPropertyDataMap[ADD_PROPERTY_CURRENCY] = _defaultCurrency;

    if(widget.isPropertyForUpdate){
      addPropertyDataMap.clear();
      addPropertyDataMap = widget.propertyDataMap;
    }

    if(widget.isDraftProperty){
      addPropertyDataMap.clear();
      addPropertyDataMap = widget.propertyDataMap;
      if(widget.draftPropertyIndex != null && widget.draftPropertyIndex != -1){
        addPropertyDataMap[ADD_PROPERTY_DRAFT_INDEX] = widget.draftPropertyIndex;
      }
      if(addPropertyDataMap.containsKey(ADD_PROPERTY_DRAFT_PROGRESS_KEY)){
        addPropertyDataMap.remove(ADD_PROPERTY_DRAFT_PROGRESS_KEY);
        _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
        /// For Updating Draft in storage
        if (widget.draftPropertyIndex != null) {
          _draftPropertiesDataMapsList[widget.draftPropertyIndex!] = addPropertyDataMap;
        } else {
          _draftPropertiesDataMapsList.add(addPropertyDataMap);
        }

        // Update Storage
        HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);
      }
    }

    _addPropertiesDataMapsList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];

    if(Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn!){
      if(mounted) setState(() {
        isLoggedIn = true;
      });
    }

    if (!widget.isPropertyForUpdate && !widget.isDraftProperty &&
        _userRole == USER_ROLE_HOUZEZ_AGENT_VALUE) {
      Map realtorIdStr = HiveStorageManager.readUserLoginInfoData() ?? {};
      if (realtorIdStr.isNotEmpty && realtorIdStr.containsKey("fave_author_agent_id")
          && realtorIdStr["fave_author_agent_id"] != null) {
        String realtorId = realtorIdStr["fave_author_agent_id"];
        addPropertyDataMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION] = AGENT_INFO;
        addPropertyDataMap[ADD_PROPERTY_FAVE_AGENT] = [realtorId];
      } else {
        int? realtorId = HiveStorageManager.getUserId();
        if (realtorId != null){
          addPropertyDataMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION] = AUTHOR_INFO;
          addPropertyDataMap[ADD_PROPERTY_FAVE_AGENT] = [realtorId.toString()];
        }
      }
    }

    integrateConfigurations();

    super.initState();
  }

  fetchUserPaymentStatus() async {
    if (!widget.isPropertyForUpdate) {
      Map map = await _propertyBloc.fetchUserPaymentStatus();
      if (map.isNotEmpty) {
        print("User Payment Status: $map");

        HiveStorageManager.storeUserPaymentStatus(map);
        showUpgradePackageDialog = UtilityMethods.showUpgradePlanPage();
        return showUpgradePackageDialog;
      }
    }
    return false;
  }

  fetchNonce() async {
    ApiResponse response;
    if (widget.isPropertyForUpdate) {
      response = await _propertyBloc.fetchUpdatePropertyNonceResponse();
    } else {
      response = await _propertyBloc.fetchAddPropertyNonceResponse();
    }

    if (response.success) {
      nonce = response.result;
    }

    response = await _propertyBloc.fetchAddImageNonceResponse();
    if (response.success) {
      imageNonce = response.result;
    }
  }

  fetchTermsData(){
    fetchTermData(propertyCountryDataType);
    fetchTermData(propertyStateDataType);
    fetchTermData(propertyCityDataType);
    fetchTermData(propertyAreaDataType);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _addPropertyPages = [];
    _addPropertiesDataMapsList = [];

    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // These are the callbacks
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResume();
        // widget is resumed
        break;
      case AppLifecycleState.inactive:
      // widget is inactive
        break;
      case AppLifecycleState.paused:
        onAppPause();
        break;
      case AppLifecycleState.detached:
      // widget is detached
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void onAppResume(){
    // print("App is resume......................");
    _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
    if(_draftPropertiesDataMapsList.isNotEmpty){
      if(addPropertyDataMap.containsKey(ADD_PROPERTY_TITLE) &&
          addPropertyDataMap[ADD_PROPERTY_TITLE] != null &&
          addPropertyDataMap[ADD_PROPERTY_TITLE].isNotEmpty) {

        // print("addPropertyDataMap Title: ${addPropertyDataMap[ADD_PROPERTY_TITLE]}......................");

        /// For Updating Draft in storage
        if (widget.draftPropertyIndex == null) {
          // print("No Pre-Defined Draft Index......................");
          Map draftItem = _draftPropertiesDataMapsList.last;
          if(draftItem[ADD_PROPERTY_TITLE] == addPropertyDataMap[ADD_PROPERTY_TITLE]){
            // print("Draft with Title: ${draftItem[ADD_PROPERTY_TITLE]} Found......................");
            _draftPropertiesDataMapsList.removeLast();
            // print("Removed Draft from Last index......................");
            // Update Storage
            HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);
            // print("Draft Storage Updated......................");
          }
        }else{
          // print("Draft Index: ${widget.draftPropertyIndex} defined......................");
          Map draftItem = _draftPropertiesDataMapsList[widget.draftPropertyIndex!];
          if(draftItem[ADD_PROPERTY_TITLE] == addPropertyDataMap[ADD_PROPERTY_TITLE]){
            // print("Same draft found......................");
            // print("Draft with Title: ${draftItem[ADD_PROPERTY_TITLE]} Found......................");
            _draftPropertiesDataMapsList.removeAt(widget.draftPropertyIndex!);
            // print("Removed Draft from index: ${widget.draftPropertyIndex}......................");
            // Update Storage
            HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);

            // print("Draft Storage Updated......................");
          }
        }
      }
    }
  }

  void onAppPause(){
    // print("App is paused......................");
    validateCurrentPage();

    if(addPropertyDataMap.containsKey(ADD_PROPERTY_TITLE) &&
        addPropertyDataMap[ADD_PROPERTY_TITLE] != null && addPropertyDataMap[ADD_PROPERTY_TITLE].isNotEmpty) {

      // print("Draft Found......................");

      addPropertyDataMap[ADD_PROPERTY_DRAFT_PROGRESS_KEY] = ADD_PROPERTY_DRAFT_IN_PROGRESS;

      // print("Key: $ADD_PROPERTY_DRAFT_IN_PROGRESS Added in Map......................");

      _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];

      // print("_draftPropertiesDataMapsList.isNotEmpty: ${_draftPropertiesDataMapsList.isNotEmpty}.........................");
      // print("widget.draftPropertyIndex: ${widget.draftPropertyIndex}.........................");
      /// For Updating Draft in storage
      if(_draftPropertiesDataMapsList.isNotEmpty){
        if (widget.draftPropertyIndex != null) {
          _draftPropertiesDataMapsList[widget.draftPropertyIndex!] = addPropertyDataMap;
        } else {
          _draftPropertiesDataMapsList.add(addPropertyDataMap);
        }
      } else {
        _draftPropertiesDataMapsList.add(addPropertyDataMap);
      }

      // print("Storing Draft at index: ${_draftPropertiesDataMapsList.indexOf(addPropertyDataMap)}......................");

      // Update Storage
      HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);

      // print("Draft Stored in Storage......................");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: widget.isPropertyForUpdate
              ? UtilityMethods.getLocalizedString("edit_property")
              : UtilityMethods.getLocalizedString("add_property"),
          onBackPressed: SHOW_DRAFTS
              ? () => onBackPressedBottomSheet(context)
              : null,
          actions: widget.isPropertyForUpdate
              ? [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: Icon(
                  AppThemePreferences.editDoneIcon,
                  color: AppThemePreferences()
                      .appTheme
                      .genericAppBarIconsColor,
                ),
                onPressed: () => onUpdateNowPressed(),
              ),
            ),
          ]
              : null,
        ),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                Flexible(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: _addPropertyPages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _addPropertyPages[index];
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: AppThemePreferences().appTheme.dividerColor!,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      /// Back / Cancel Button:
                      Flexible(
                        flex: 4,
                        child: LightButtonWidget(

                          buttonHeight: 40.0,
                          text: _page == 1
                              ? UtilityMethods.getLocalizedString("cancel")
                              : UtilityMethods.getLocalizedString("back"),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            previousPage();
                          },
                        ),
                      ),

                      Expanded(flex: 7, child : pageIndicators()),
                      /// Done / Next Button:
                      Flexible(
                        flex: 4,
                        child: ButtonWidget(
                          text: _page == _addPropertyPages.length
                              ? UtilityMethods.getLocalizedString("done")
                              : UtilityMethods.getLocalizedString("next"),
                          buttonHeight: 40.0,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            int _currentPage = _page - 1;
                            if(formStateKeysList[(_currentPage)].currentState!.validate()) {
                              if (_page == _addPropertyPages.length) {
                                // print("Starting uploading property................................");
                                if (HooksConfigurations.addPropertyActionHook != null) {
                                  HooksConfigurations.addPropertyActionHook(
                                    context: context,
                                    addPropertyNonce: nonce,
                                    uploadImagesNonce: imageNonce,
                                    addPropertyDataMap: addPropertyDataMap,
                                    defaultAddPropertyFunc: () => startAddPropertyProcess(),
                                  );
                                } else {
                                  print ("Calling startAddPropertyProcess()...");
                                  startAddPropertyProcess();
                                }
                              } else {
                                nextPage();
                              }
                            }
                          },
                        ),

                      ),
                    ],
                  ),
                )
              ],
            ),

            FutureBuilder(
              future: _userPaymentStatusFuture,
              builder: (context, snapshot) {
                if (showUpgradePackageDialog) {
                  upgradePackageDialog();
                  return Container();
                } else {
                  return Container();
                }
              },
            ),

            if(!isInternetConnected) internetConnectionErrorWidget(),
          ],
        ),
      ),
    );
  }

  upgradePackageDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ShowDialogBoxWidget(
        context,
        barrierDismissible: false,
        title: UtilityMethods.getLocalizedString("error_occurred"),
        style: AppThemePreferences().appTheme.heading02TextStyle!,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GenericTextWidget("You cannot add a property in your current membership plan."),
            SizedBox(height: 10,),
            ButtonWidget(text: "Upgrade Plan", onPressed: () {
              UtilityMethods.navigateToRoute(
                context: context,
                builder: (context) => MembershipPlanPage(),
              );
            }),
            SizedBox(height: 10,),
            ButtonWidget(text: "back", onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // onBackPressedBottomSheet(context);
            }),
          ],
        ),
      );
    });

  }

  Future<void> integrateConfigurations() async {
    if (mounted) {
      setState(() {
        formPagesList = UtilityMethods.readAddPropertyConfigFile();
        if (formPagesList.isNotEmpty) {
          for (HouziFormPage page in formPagesList) {
            if (isFormPageAllowedForCurrentUser(page)) {
              GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
              formStateKeysList.add(formStateKey);
              _addPropertyPages.add(
                AddPropertyFormWidget(
                  formStateKey: formStateKey,
                  formSectionFieldsList: page.pageFields ?? [],
                  infoDataMap: addPropertyDataMap,
                  isPropertyForUpdate: widget.isPropertyForUpdate,
                  listener: (dataMap) {
                    if (mounted) {
                      setState(() {
                        addPropertyDataMap.addAll(dataMap);
                      });
                    }
                  },
                ),
              );
            }
          }
        }
      });
    }
  }

  bool isFormPageAllowedForCurrentUser(HouziFormPage formPage) {
    String currentUserRole = HiveStorageManager.getUserRole();
    if (formPage.enable) {
      if (formPage.allowedRoles != null &&
          formPage.allowedRoles!.isNotEmpty) {
        if (formPage.allowedRoles!.contains(currentUserRole)) {
          return true;
        } else {
          return false;
        }
      } else {
        // show publicly
        return true;
      }
    }

    return false;

    // if(formPage.enable && formPage.allowedRoles != null &&
    //     formPage.allowedRoles!.isNotEmpty &&
    //     formPage.allowedRoles!.contains(currentUserRole)) {
    //   return true;
    // }
    // return false;
  }

  Widget internetConnectionErrorWidget(){
    return Positioned(
        bottom: 0,
        child: SafeArea(
            top: false,
            child: NoInternetBottomActionBarWidget(onPressed: ()=> fetchTermsData())));
  }

  startAddPropertyProcess(){
    /// Assigning current time in milliseconds as Local Id to the Property.
    if(mounted){
      setState(() {
        addPropertyDataMap[ADD_PROPERTY_LOCAL_ID] = '${DateTime.now().millisecondsSinceEpoch}';
      });
    }

    if (isLoggedIn == true) {
      /// Assigning the Login and Pending status to the Property.
      if (mounted) setState(() {
        addPropertyDataMap[ADD_PROPERTY_NONCE] = nonce;
        addPropertyDataMap[ADD_PROPERTY_IMAGE_NONCE] = imageNonce;
        addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_true';
        addPropertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] = ADD_PROPERTY_UPLOAD_STATUS_PENDING;
      });

      /// Storing Property Data Map to Storage:
      // print("addPropertyDataMap:$addPropertyDataMap");
      _addPropertiesDataMapsList.add(addPropertyDataMap);
      HiveStorageManager.storeAddPropertiesDataMaps(_addPropertiesDataMapsList);

      /// Upload Property:
      PropertyManager().uploadProperty();

      /// Your Property is being uploaded Toast:
      _showToast(context, UtilityMethods.getLocalizedString("your_property_is_being_uploaded"));

      // /// Pop() the page and go back to Home Page.
      // Navigator.of(context).pop();

      /// Replace() the page with Properties and show uploading progress.
      UtilityMethods.navigateToRouteByReplacement(
        context: context,
        builder: (context) => Properties(showUploadingProgress: true),
      );

    } else if (isLoggedIn == false) {
      print("Logged in value: $isLoggedIn");
      /// Assigning the Login status to the Property.
      if(mounted) setState(() {
        addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_false';
      });

      /// Storing Property Data Map to Storage:
      _addPropertiesDataMapsList.add(addPropertyDataMap);
      HiveStorageManager.storeAddPropertiesDataMaps(_addPropertiesDataMapsList);

      _userNotLoggedInDialog(context);
    }
  }

  Future<bool> onWillPop() {
    if(SHOW_DRAFTS){
      onBackPressedBottomSheet(context);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget pageIndicators() {
    return Center(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: _addPropertyPages.length > 1
            ? SmoothPageIndicator(
          controller: _pageController,
          count: _addPropertyPages.length,
          effect: SlideEffect(
            dotHeight: 8.0,
            dotWidth: 8.0,
            spacing: 5,
            dotColor: AppThemePreferences.countIndicatorsColor!,
            activeDotColor: AppThemePreferences().appTheme.primaryColor!,
          ),
        )
            : Container(),
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    if(mounted) setState(() {
      _page = page;
    });
  }

  void nextPage() {
    if(isInternetConnected){
      _pageController.nextPage(duration: _kDuration, curve: _kCurve);
      if (_page < _addPropertyPages.length) {
        if(mounted) setState(() {
          _page = _page + 1;
        });
      }
    }
  }

  void previousPage(){
    _pageController.previousPage(duration: _kDuration, curve: _kCurve);
    if(mounted) setState(() {
      _page = _page - 1;
    });

    if(_page < 1){
      isCancel = true;
    }

    if(isCancel){
      Navigator.pop(context);
    }
  }

  Future _userNotLoggedInDialog(BuildContext context){
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("you_are_not_logged_in"),
      textAlign: TextAlign.center,
      content: ButtonWidget(
        text: UtilityMethods.getLocalizedString("login"),
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (context) => UserSignIn(
                  (String closeOption) {
                if (closeOption == CLOSE) {
                  Navigator.pop(context);
                }
              },
            ),
          );
          Navigator.pushReplacement(context, route);
        },
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 5,
    );
  }

  Future onBackPressedBottomSheet(context) {
    return genericBottomSheetWidget(
      context: context,
      children: <Widget>[
        GenericBottomSheetTitleWidget(
          title: UtilityMethods.getLocalizedString("draft_properties_exit_menu_title_text"),
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
        ),
        GenericBottomSheetSubTitleWidget(
          subTitle: UtilityMethods.getLocalizedString("draft_properties_exit_menu_subtitle_text"),
          decoration: AppThemePreferences.dividerDecoration(),
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
        ),
        GenericBottomSheetOptionWidget(
          label: UtilityMethods.getLocalizedString("draft_properties_exit_menu_option_save"),
          style: AppThemePreferences().appTheme.bottomSheetOptionsTextStyle!,
          onPressed: _onSaveDraftPressed,
        ),
        GenericBottomSheetOptionWidget(
          label: UtilityMethods.getLocalizedString("draft_properties_exit_menu_option_discard"),
          style: AppThemePreferences().appTheme.bottomSheetNegativeOptionsTextStyle!,
          onPressed: _onDiscardPropertyPressed,
        ),
        GenericBottomSheetOptionWidget(
          label: UtilityMethods.getLocalizedString("draft_properties_exit_menu_option_keep_editing"),
          style: AppThemePreferences().appTheme.bottomSheetEmphasisOptionsTextStyle!,
          onPressed: _onKeepEditingPressed,
          showDivider: false,
        ),
      ],
    );
  }

  _onSaveDraftPressed(){
    FocusScope.of(context).requestFocus(FocusNode());

    validateCurrentPage();

    addPropertyDataMap[ADD_PROPERTY_DRAFT_PROGRESS_KEY] = ADD_PROPERTY_DRAFT_SAVED;

    if (addPropertyDataMap[ADD_PROPERTY_TITLE] != null && addPropertyDataMap[ADD_PROPERTY_TITLE].isNotEmpty) {
      _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
      // print("Draft Properties DataMaps List Length: ${_draftPropertiesDataMapsList.length}");
      /// For Updating Draft in storage
      if(_draftPropertiesDataMapsList.isNotEmpty){
        // print("_draftPropertiesDataMapsList is Not Empty..................");
        // print("_draftPropertiesDataMapsList: $_draftPropertiesDataMapsList..................");
        if(widget.draftPropertyIndex != null){
          // print("widget.draftPropertyIndex is Not-Null");
          // print("Storing Draft at index: ${widget.draftPropertyIndex}");
          _draftPropertiesDataMapsList[widget.draftPropertyIndex!] = addPropertyDataMap;
        }else{
          // print("widget.draftPropertyIndex is Null");
          _draftPropertiesDataMapsList.add(addPropertyDataMap);
          // print("Storing Draft at index: ${_draftPropertiesDataMapsList.indexOf(addPropertyDataMap)}");
        }
      }else{
        // print("_draftPropertiesDataMapsList is Empty..................");
        _draftPropertiesDataMapsList.add(addPropertyDataMap);
        // print("Storing Draft at index: ${_draftPropertiesDataMapsList.indexOf(addPropertyDataMap)}");
      }


      // print("Draft Property Index: ${widget.draftPropertyIndex}");
      // print("Draft Property DataMap: $addPropertyDataMap");
      // print("Draft Properties DataMaps List: $_draftPropertiesDataMapsList");
      // print("Storing Draft Properties DataMaps List...");

      // Update Storage
      HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);

      // print("Storage Updated.......................");

      // Show Toast
      _showToast(context, UtilityMethods.getLocalizedString("draft_properties_your_draft_is_saved"));

      // Close Bottom Menu Sheet
      Navigator.pop(context);
      // Close Page
      Navigator.pop(context);
    } else {
      validateCurrentPage();
      _showToast(context, UtilityMethods.getLocalizedString("draft_properties_toast_error_text"));
      Navigator.pop(context);
    }
  }

  validateCurrentPage() {
    int _currentPage = _page - 1;
    formStateKeysList[(_currentPage)].currentState!.validate();
  }

  _onDiscardPropertyPressed(){
    _draftPropertiesDataMapsList = HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
    if(widget.isDraftProperty){
      if(widget.draftPropertyIndex != null){
        if(_draftPropertiesDataMapsList.isNotEmpty){
          _draftPropertiesDataMapsList.removeAt(widget.draftPropertyIndex!);
        }
        HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);
      }else{
        if(_draftPropertiesDataMapsList.isNotEmpty){
          _draftPropertiesDataMapsList.removeLast();
        }
        // _draftPropertiesDataMapsList.clear();
        // HiveStorageManager.deleteDraftPropertiesDataMapsList();
        // print("_draftPropertiesDataMapsList.isEmpty");
        HiveStorageManager.storeDraftPropertiesDataMapsList(_draftPropertiesDataMapsList);
        // print("Draft Properties: ${HiveStorageManager.readDraftPropertiesDataMapsList() ?? []}");
      }
    }

    // _showToast(context, "discarding draft...");

    // Close Bottom Menu Sheet
    Navigator.pop(context);
    // Close Page
    Navigator.pop(context);
  }

  _onKeepEditingPressed(){
    // Do nothing
    Navigator.pop(context);
  }

  Future<List<dynamic>> fetchTermData(String term) async {
    List<dynamic> termData = [];
    List<dynamic> tempTermData = await _propertyBloc.fetchTermData(term);
    if ((tempTermData.isNotEmpty && tempTermData[0] == null) ||
        (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)) {
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return termData;
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempTermData.isNotEmpty) {
        termData.addAll(tempTermData);
      }
    }

    return termData;
  }

  onUpdateNowPressed(){
    // validateCurrentPage();
    // startAddPropertyProcess();
    int _currentPage = _page - 1;
    if (formStateKeysList[(_currentPage)].currentState!.validate()) {
      startAddPropertyProcess();
    }

  }
}
