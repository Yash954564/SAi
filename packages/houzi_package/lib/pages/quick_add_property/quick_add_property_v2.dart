import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_page_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/models/api/api_response.dart';


class QuickAddPropertyV2 extends StatefulWidget {

  @override
  _QuickAddPropertyV2State createState() => _QuickAddPropertyV2State();
}

class _QuickAddPropertyV2State extends State<QuickAddPropertyV2> {

  bool isLoggedIn = false;

  String nonce = "";
  String imageNonce = "";
  String _defaultCurrency = '';
  final formKey = GlobalKey<FormState>();

  List<HouziFormItem> _formItemsList = [];
  List<dynamic> _addPropertyDataMapsList = [];

  final PropertyBloc _propertyBloc = PropertyBloc();

  Map<String, dynamic> addPropertyDataMap = {
    ADD_PROPERTY_ACTION: 'add_property',
    ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP: 'no',
    ADD_PROPERTY_MULTI_UNITS: '${0}',
    ADD_PROPERTY_FLOOR_PLANS_ENABLE: '0',
  };

  @override
  void initState() {
    super.initState();
    _formItemsList = readQuickAddPropertyConfigFile();
    _defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? '\$';
    addPropertyDataMap[ADD_PROPERTY_CURRENCY] = _defaultCurrency;
    fetchNonce();
  }

  @override
  void dispose() {
    nonce = "";
    imageNonce = "";
    _defaultCurrency = '';
    _formItemsList = [];
    _addPropertyDataMapsList = [];
    addPropertyDataMap = {};

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Consumer<UserLoggedProvider>(builder: (context,login,child) {
          isLoggedIn = login.isLoggedIn!;

          return Scaffold(
            appBar: AppBarWidget(
              appBarTitle: UtilityMethods.getLocalizedString("add_property"),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  AddPropertyFormWidget(
                    formStateKey: formKey,
                    formSectionFieldsList: [],
                    formItemsFieldsList: _formItemsList,
                    infoDataMap: addPropertyDataMap,
                    listener: (dataMap) {
                      if (mounted) {
                        setState(() {
                          addPropertyDataMap.addAll(dataMap);
                        });
                      }
                    },
                  ),
                  AddPropertyButtonWidget(
                    onPressed: (){
                      if (HooksConfigurations.addPropertyActionHook != null) {
                        HooksConfigurations.addPropertyActionHook(
                          context: context,
                          addPropertyNonce: nonce,
                          uploadImagesNonce: imageNonce,
                          addPropertyDataMap: addPropertyDataMap,
                          defaultAddPropertyFunc: () => startAddPropertyProcess(context),
                        );
                      } else {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          startAddPropertyProcess(context);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  List<HouziFormItem> readQuickAddPropertyConfigFile() {
    List<HouziFormItem> configList = [];
    String addPropertyConfigData = HiveStorageManager.readQuickAddPropertyConfigurations() ?? "";
    if (addPropertyConfigData.isNotEmpty) {
      List<dynamic> tempList = jsonDecode(addPropertyConfigData) ?? [];
      if (tempList.isNotEmpty) {
        configList = HouziFormItem.decode(tempList);
      }
    }
    return configList;
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchAddPropertyNonceResponse();
    if (response.success) {
      nonce = response.result;
    }

    response = await _propertyBloc.fetchAddImageNonceResponse();
    if (response.success) {
      imageNonce = response.result;
    }
  }

  startAddPropertyProcess(BuildContext context) {
    /// Assigning current time in milliseconds as Local Id to the Property.
    if (mounted) {
      setState(() {
        addPropertyDataMap[ADD_PROPERTY_LOCAL_ID] = '${DateTime.now().millisecondsSinceEpoch}';
      });
    }

    if (isLoggedIn == true) {
      /// Assigning the Nonces, Login and Pending status to the Property.
      if(mounted) {
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_NONCE] = nonce;
          addPropertyDataMap[ADD_PROPERTY_IMAGE_NONCE] = imageNonce;
          addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_true';
          addPropertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] = ADD_PROPERTY_UPLOAD_STATUS_PENDING;
        });
      }

      /// Storing Property Data Map to Storage:
      // print("addPropertyDataMap:$addPropertyDataMap");
      _addPropertyDataMapsList.add(addPropertyDataMap);
      HiveStorageManager.storeAddPropertiesDataMaps(_addPropertyDataMapsList);

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
      if (mounted) {
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_false';
        });
      }

      /// Storing Property Data Map to Storage:
      _addPropertyDataMapsList.add(addPropertyDataMap);
      HiveStorageManager.storeAddPropertiesDataMaps(_addPropertyDataMapsList);

      _userNotLoggedInDialog(context);
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Future _userNotLoggedInDialog(BuildContext context) {
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
}

class AddPropertyButtonWidget extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final void Function() onPressed;

  const AddPropertyButtonWidget({
    super.key,
    required this.onPressed,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: ButtonWidget(
        text: UtilityMethods.getLocalizedString("add_property"),
        onPressed: onPressed,
      ),
    );
  }
}

