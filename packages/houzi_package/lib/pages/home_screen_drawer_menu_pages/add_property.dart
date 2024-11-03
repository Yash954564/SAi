import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_address.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_details.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_features.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_floorPlans.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_media.dart';
import 'package:houzi_package/pages/add_Property_Pages/property_settings.dart';
import 'package:houzi_package/pages/add_property_pages/property_contact_information.dart';
import 'package:houzi_package/pages/add_property_pages/property_gdpr_agreement.dart';
import 'package:houzi_package/pages/add_property_pages/property_information.dart';
import 'package:houzi_package/pages/add_property_pages/property_private_note.dart';
import 'package:houzi_package/pages/add_property_pages/property_sub_listing.dart';
import 'package:houzi_package/pages/add_property_pages/property_virtual_tour_link.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_bottom_sheet_widget/generic_bottom_sheet_widget.dart';

class AddProperty extends StatefulWidget{
  final bool isPropertyForUpdate;
  final propertyDataMap;
  final bool isDraftProperty;
  final int? draftPropertyIndex;

  AddProperty({
    this.isPropertyForUpdate = false,
    this.propertyDataMap,
    this.isDraftProperty = false,
    this.draftPropertyIndex,
  });

  @override
  State<StatefulWidget> createState() => AddPropertyState();
}

class AddPropertyState extends State<AddProperty> with WidgetsBindingObserver {

  final PropertyBloc _propertyBloc = PropertyBloc();

  final formKey01 = GlobalKey<FormState>();
  final formKey02 = GlobalKey<FormState>();
  final formKey03 = GlobalKey<FormState>();
  final formKey04 = GlobalKey<FormState>();
  final formKey05 = GlobalKey<FormState>();
  final formKey06 = GlobalKey<FormState>();
  final formKey07 = GlobalKey<FormState>();
  final formKey08 = GlobalKey<FormState>();
  final formKey09 = GlobalKey<FormState>();
  final formKey10 = GlobalKey<FormState>();
  final formKey11 = GlobalKey<FormState>();

  final PageController _pageController = PageController();

  int _page = 1;

  String nonce = "";
  String imageNonce = "";
  String _userRole = '';
  String _defaultCurrency = '';
  String tempSelectedListingIDs = "";

  List<Widget> _addPropertyPages = [];
  List<dynamic> _addPropertiesDataMapsList = [];
  List<dynamic> _draftPropertiesDataMapsList = [];
  List<dynamic> _propertyFeaturesMetaDataList = [];

  static const _kCurve = Curves.ease;
  static const _kDuration = Duration(milliseconds: 300);

  bool isCancel = false;
  bool isLoggedIn = false;
  bool isAgreedOnGDPR = false;
  bool isPropertyAdded = false;
  bool showWaitingWidget = false;
  bool isInternetConnected = true;

  Map<String, dynamic> tempPropertyInformationPageMap = {};
  Map<String, dynamic> tempPropertyMediaPageMap = {};
  Map<String, dynamic> tempPropertyDetailsPageMap = {};
  Map<String, dynamic> tempPropertyFeaturesPageMap = {};
  Map<String, dynamic> tempPropertyAddressPageMap = {};
  Map<String, dynamic> tempPropertyVirtualTourLinkPageMap = {};
  List<Map<String, dynamic>> tempPropertyFloorPlansPageList = [];
  List<Map<String, dynamic>> tempPropertyMultiUnitsPageList = [];
  Map<String, dynamic> tempPropertyContactInformationPageMap = {};
  Map<String, dynamic> tempPropertyPrivateNotePageMap = {};
  Map<String, dynamic> tempPropertySettingsPageMap = {};

  Map<String, dynamic> addPropertyDataMap = {
    ADD_PROPERTY_ACTION : 'add_property',
    ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP : 'no',
    ADD_PROPERTY_MULTI_UNITS : '${0}',
    ADD_PROPERTY_FLOOR_PLANS_ENABLE : '0',
    ADD_PROPERTY_DRAFT_INDEX : -1,
  };


  @override
  void initState() {
    super.initState();
    // Add the observer.
    WidgetsBinding.instance.addObserver(this);

    fetchTermsData();

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

    _propertyFeaturesMetaDataList = HiveStorageManager.readPropertyFeaturesMetaData() ?? [];

    _addPropertyPages = [
      PropertyInformationPage(
        propertyInfoMap: addPropertyDataMap,
        formKey: formKey01,
        propertyInformationPageListener: (Map<String, dynamic> map){
          if (mounted) {
            setState(() {
              tempPropertyInformationPageMap = map;
              addPropertyDataMap.addAll(tempPropertyInformationPageMap);
            });
          }
        },
      ),
      PropertyMedia(
        propertyInfoMap: addPropertyDataMap,
        formKey: formKey02,
        isPropertyForUpdate: widget.isPropertyForUpdate,
        propertyMediaPageListener: (Map<String, dynamic> map){
          if(mounted) setState(() {
            tempPropertyMediaPageMap = map;
            addPropertyDataMap.addAll(tempPropertyMediaPageMap);
          });
        },
      ),
      PropertyDetails(
        propertyInfoMap: addPropertyDataMap,
        formKey: formKey03,
        propertyDetailsPageListener: (Map<String, dynamic> map){
          if(mounted) setState(() {
            tempPropertyDetailsPageMap = map;
            addPropertyDataMap.addAll(tempPropertyDetailsPageMap);
          });
        },
      ),
      PropertyAddressPage(
        propertyInfoMap: addPropertyDataMap,
        formKey: formKey04,
        propertyAddressPageListener: (Map<String, dynamic> map){
          if(mounted) setState(() {
            tempPropertyAddressPageMap = map;
            addPropertyDataMap.addAll(tempPropertyAddressPageMap);
          });
        },
      ),
      PropertyVirtualTourLinkPage(
        propertyInfoMap: addPropertyDataMap,
        formKey: formKey05,
        propertyVirtualTourLinkPageListener: (Map<String, dynamic> map){
          if(mounted) setState(() {
            tempPropertyVirtualTourLinkPageMap = map;
            addPropertyDataMap.addAll(tempPropertyVirtualTourLinkPageMap);
          });
        },
      ),
      PropertyFloorPlansPage(
        formKey: formKey06,
        propertyInfoMap: addPropertyDataMap,
        isPropertyForUpdate: widget.isPropertyForUpdate,
        propertyFloorPlansPageListener: (List<Map<String, dynamic>> floorPlansList){
          if(mounted) setState(() {
            tempPropertyFloorPlansPageList = floorPlansList;

            if(tempPropertyFloorPlansPageList.isNotEmpty){
              addPropertyDataMap[ADD_PROPERTY_FLOOR_PLANS_ENABLE] = '${1}';
              addPropertyDataMap[ADD_PROPERTY_FLOOR_PLANS] = tempPropertyFloorPlansPageList;
            }
          });
        },
      ),
      PropertySubListingPage(
        formKey: formKey07,
        propertyInfoMap: addPropertyDataMap,
        propertySubListingPageListener: (List<Map<String, dynamic>> multiUnitsList, String selectedListingIDs){
          if(mounted) setState(() {
            tempPropertyMultiUnitsPageList = multiUnitsList;
            tempSelectedListingIDs = selectedListingIDs;

            if(tempPropertyMultiUnitsPageList.isNotEmpty){
              addPropertyDataMap[ADD_PROPERTY_MULTI_UNITS] = '${1}';
              addPropertyDataMap[ADD_PROPERTY_FAVE_MULTI_UNITS] = tempPropertyMultiUnitsPageList;
            }

            addPropertyDataMap[ADD_PROPERTY_FAVE_MULTI_UNITS_IDS] = tempSelectedListingIDs;
          });
        },
      ),

      PropertyPrivateNotePage(
        formKey: formKey09,
        propertyInfoMap: addPropertyDataMap,
        propertyPrivateNotePageListener: (Map<String, dynamic> map){
          if(mounted) setState(() {
            tempPropertyPrivateNotePageMap = map;
            addPropertyDataMap.addAll(tempPropertyPrivateNotePageMap);
          });
        },
      ),
    ];

    if (_userRole == ROLE_ADMINISTRATOR ||
        _userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
      if(mounted) setState(() {
        _addPropertyPages.insert(
          7,
          PropertyContactInformationPage(
            formKey: formKey08,
            propertyInfoMap: addPropertyDataMap,
            propertyContactInformationPageListener: (Map<String, dynamic> map) {
              tempPropertyContactInformationPageMap = map;
              addPropertyDataMap.addAll(tempPropertyContactInformationPageMap);
            },
          ),
        );
      });
    }

    if (_userRole == ROLE_ADMINISTRATOR) {
      if(mounted) setState(() {
        _addPropertyPages.insert(
          8,
          PropertySettingsPage(
            formKey: formKey10,
            propertyInfoMap: addPropertyDataMap,
            propertySettingsPageListener: (Map<String, dynamic> map) {
              tempPropertySettingsPageMap = map;
              addPropertyDataMap.addAll(tempPropertySettingsPageMap);
            },
          ),
        );
      });
    }

    if(_propertyFeaturesMetaDataList.isNotEmpty){
      if(mounted) setState(() {
        _addPropertyPages.insert(
          3,
          PropertyFeatures(
            propertyInfoMap: addPropertyDataMap,
            propertyFeaturesPageListener: (Map<String, dynamic> map) {
              if(mounted) setState(() {
                tempPropertyFeaturesPageMap = map;
                if (tempPropertyFeaturesPageMap.containsKey(ADD_PROPERTY_FEATURES_LIST)) {
                  addPropertyDataMap[ADD_PROPERTY_FEATURES_LIST] = tempPropertyFeaturesPageMap[ADD_PROPERTY_FEATURES_LIST];
                }
              });
            },
          ),
        );
      });
    }

    if(ADD_PROP_GDPR_ENABLED == "1"){
      if(mounted) setState(() {
        _addPropertyPages.add(
          PropertyGDPRAgreementPage(
            formKey: formKey11,
            isPropertyForUpdate: widget.isPropertyForUpdate
          ),
        );
      });
    }

    fetchNonce();

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
    super.dispose();
    _pageController.dispose();
    _addPropertyPages = [];
    _addPropertiesDataMapsList = [];
    _propertyFeaturesMetaDataList = [];
    tempPropertyInformationPageMap = {};
    tempPropertyMediaPageMap = {};
    tempPropertyDetailsPageMap = {};
    tempPropertyFeaturesPageMap = {};
    tempPropertyAddressPageMap = {};
    tempPropertyVirtualTourLinkPageMap = {};
    tempPropertyFloorPlansPageList = [];
    tempPropertyMultiUnitsPageList = [];
    tempPropertyContactInformationPageMap = {};

    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
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
    addDataInPropertyMap();

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
                      Expanded(
                        flex: 1,
                        child: LightButtonWidget(
                          buttonHeight: 40.0,
                          text: _page == 1 ? UtilityMethods.getLocalizedString("cancel") :
                          UtilityMethods.getLocalizedString("back"),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            bool _isPageValidated = true;
                            /// Get Current Page Type
                            Type _currentPageType = _addPropertyPages[(_page - 1)].runtimeType;

                            if(_currentPageType == PropertyMedia){
                              if(formKey02.currentState!.validate()){

                              }
                            }else if(_currentPageType == PropertyDetails){
                              if(formKey03.currentState!.validate()){

                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyAddressPage){
                              if(formKey04.currentState!.validate()){
                                formKey04.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyVirtualTourLinkPage){
                              if(formKey05.currentState!.validate()){
                                formKey05.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyContactInformationPage){
                              if(formKey08.currentState!.validate()){
                                formKey08.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            } else if(_currentPageType == PropertyPrivateNotePage){
                              if(formKey09.currentState!.validate()) {}
                            } else if(_currentPageType == PropertySettingsPage){
                              if(formKey10.currentState!.validate()) {}
                            }

                            if(_isPageValidated){
                              previousPage();
                            }
                          },
                        ),
                      ),

                      Expanded(flex: 2, child: pageIndicators()),
                      /// Done / Next Button:
                      Expanded(
                        flex: 1,
                        child: ButtonWidget(
                          text: _page == _addPropertyPages.length ? UtilityMethods.getLocalizedString("done") :
                          UtilityMethods.getLocalizedString("next"),
                          buttonHeight: 40.0,
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bool _isPageValidated = true;
                            /// Get Current Page Type
                            Type _currentPageType = _addPropertyPages[(_page - 1)].runtimeType;

                            if(_currentPageType == PropertyInformationPage){
                              if(formKey01.currentState!.validate()){

                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyMedia){
                              if(formKey02.currentState!.validate()){

                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyDetails){
                              if(formKey03.currentState!.validate()){

                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyAddressPage){
                              if(formKey04.currentState!.validate()){
                                formKey04.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyVirtualTourLinkPage){
                              if(formKey05.currentState!.validate()){
                                formKey05.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyContactInformationPage){
                              if(formKey08.currentState != null && formKey08.currentState!.validate()){
                                formKey08.currentState!.save();
                              }else{
                                _isPageValidated = false;
                              }
                            } else if(_currentPageType == PropertyPrivateNotePage){
                              if(formKey09.currentState!.validate()) {
                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertySettingsPage){
                              if(formKey10.currentState!.validate()) {

                              }else{
                                _isPageValidated = false;
                              }
                            }else if(_currentPageType == PropertyGDPRAgreementPage){
                              if(formKey11.currentState!.validate()) {

                              }else{
                                _isPageValidated = false;
                              }
                            }


                            if(_isPageValidated) {
                              if (_currentPageType == _addPropertyPages.last.runtimeType) {
                                if (HooksConfigurations.addPropertyActionHook != null) {
                                  HooksConfigurations.addPropertyActionHook(
                                    context: context,
                                    addPropertyNonce: nonce,
                                    uploadImagesNonce: imageNonce,
                                    addPropertyDataMap: addPropertyDataMap,
                                    defaultAddPropertyFunc: () => startAddPropertyProcess(),
                                  );
                                } else {
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
            if(!isInternetConnected) internetConnectionErrorWidget(),
          ],
        ),
      ),
    );
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

    if(isLoggedIn == true){
      /// Assigning the Login and Pending status to the Property.
      if(mounted) setState(() {
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
      /// Pop() the page and go back to Home Page.
      Navigator.of(context).pop();
    }else if(isLoggedIn == false){
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

    addDataInPropertyMap();

    addPropertyDataMap[ADD_PROPERTY_DRAFT_PROGRESS_KEY] = ADD_PROPERTY_DRAFT_SAVED;

    if(addPropertyDataMap[ADD_PROPERTY_TITLE] != null && addPropertyDataMap[ADD_PROPERTY_TITLE].isNotEmpty){
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
    }else{
      formKey01.currentState!.validate();
      _showToast(context, UtilityMethods.getLocalizedString("draft_properties_toast_error_text"));
      Navigator.pop(context);
    }
  }

  void addDataInPropertyMap(){
    Type _currentPageType = _addPropertyPages[(_page - 1)].runtimeType;

    if(_currentPageType == PropertyInformationPage){
      formKey01.currentState!.validate();
      addPropertyDataMap.addAll(tempPropertyInformationPageMap);
    }

    else if(_currentPageType == PropertyMedia) {
      formKey02.currentState!.validate();
      addPropertyDataMap.addAll(tempPropertyMediaPageMap);
    }

    else if(_currentPageType == PropertyDetails){
      formKey03.currentState!.validate();
      addPropertyDataMap.addAll(tempPropertyDetailsPageMap);
    }

    else if(_currentPageType == PropertyAddressPage) {
      formKey04.currentState!.validate();
      formKey04.currentState!.save();
      addPropertyDataMap.addAll(tempPropertyAddressPageMap);
    }

    else if(_currentPageType == PropertyVirtualTourLinkPage) {
      formKey05.currentState!.validate();
      formKey05.currentState!.save();
      addPropertyDataMap.addAll(tempPropertyVirtualTourLinkPageMap);
    }

    else if(_currentPageType == PropertyContactInformationPage) {
      formKey08.currentState!.validate();
      formKey08.currentState!.save();
      addPropertyDataMap.addAll(tempPropertyContactInformationPageMap);
    }

    else if(_currentPageType == PropertyFloorPlansPage){
      formKey06.currentState!.validate();
      addPropertyDataMap[ADD_PROPERTY_FLOOR_PLANS_ENABLE] = '${1}';
      addPropertyDataMap[ADD_PROPERTY_FLOOR_PLANS] = tempPropertyFloorPlansPageList;
      addPropertyDataMap[ADD_PROPERTY_FAVE_MULTI_UNITS] = tempPropertyMultiUnitsPageList;
    }

    else if(_currentPageType == PropertySubListingPage){
      formKey07.currentState!.validate();
      addPropertyDataMap[ADD_PROPERTY_MULTI_UNITS] = '${1}';
      addPropertyDataMap[ADD_PROPERTY_FAVE_MULTI_UNITS] = tempPropertyMultiUnitsPageList;
    }

    else if(_currentPageType == PropertyPrivateNotePage){
      formKey09.currentState!.validate();
      addPropertyDataMap.addAll(tempPropertyPrivateNotePageMap);
    }

    else if(_currentPageType == PropertySettingsPage){
      formKey10.currentState!.validate();
      addPropertyDataMap.addAll(tempPropertySettingsPageMap);
    }
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
    if(tempTermData == null || (tempTermData.isNotEmpty && tempTermData[0] == null) || (tempTermData.isNotEmpty && tempTermData[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return termData;
    }else{
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if(tempTermData.isNotEmpty){
        termData.addAll(tempTermData);
      }
    }

    return termData;
  }

  onUpdateNowPressed(){
    addDataInPropertyMap();
    startAddPropertyProcess();
  }
}