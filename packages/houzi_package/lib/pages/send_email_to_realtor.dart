import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/api/data_models.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';

class SendEmailToRealtor extends StatefulWidget {
  final Map<String, dynamic> informationMap;

  @override
  State<StatefulWidget> createState() => SendEmailToRealtorState();

  const SendEmailToRealtor({
    super.key,
    required this.informationMap,
  });
}

class SendEmailToRealtorState extends State<SendEmailToRealtor>
    with ValidationMixin {

  int? agentAgencyId;
  int? listingId;

  String? appBarTitle;
  String realtorName = '';
  String agentAgencyEmail = '';
  String agentAgencyType = '';
  String thumbnail = '';
  String siteName = '';
  String messageContent = '';
  String propertyName = '';
  String propertyLink = '';

  final PropertyBloc _propertyBloc = PropertyBloc();

  bool isAgree = false;
  bool isInternetConnected = true;
  bool _showWaitingWidget = false;

  final formKey = GlobalKey<FormState>();

  String nonce = "";
  String name = '';
  String email = '';
  String phone = '';
  String message = '';
  String buyerType = '';
  String? _selectedCustomerType;

  List<Map<String,dynamic>> customerTypes = [
    {
      "value": "buyer",
      "option": "I am a Buyer",
    },{
      "value": "tennant",
      "option": "I am a Tenant",
    },{
      "value": "agent",
      "option": "I am a Agent",
    },
    {
      "value": "other",
      "option": "Others",
    },
  ];

  TextEditingController textEditingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadData();
    fetchNonce();
  }

  loadData() async {
    name = HiveStorageManager.getUserName() ?? "";
    email = HiveStorageManager.getUserEmail() ?? "";

    if(widget.informationMap.containsKey(SEND_EMAIL_SITE_NAME)){ siteName = widget.informationMap[SEND_EMAIL_SITE_NAME];}
    if(widget.informationMap.containsKey(SEND_EMAIL_THUMBNAIL)){ thumbnail = widget.informationMap[SEND_EMAIL_THUMBNAIL];}
    if(widget.informationMap.containsKey(SEND_EMAIL_LISTING_ID)){ listingId = widget.informationMap[SEND_EMAIL_LISTING_ID];}
    if(widget.informationMap.containsKey(SEND_EMAIL_APP_BAR_TITLE)){ appBarTitle = widget.informationMap[SEND_EMAIL_APP_BAR_TITLE];}
    if(widget.informationMap.containsKey(SEND_EMAIL_REALTOR_ID)){ agentAgencyId = widget.informationMap[SEND_EMAIL_REALTOR_ID];}
    if(widget.informationMap.containsKey(SEND_EMAIL_MESSAGE)){ messageContent = widget.informationMap[SEND_EMAIL_MESSAGE];}
    if(widget.informationMap.containsKey(SEND_EMAIL_LISTING_LINK)){ propertyLink = widget.informationMap[SEND_EMAIL_LISTING_LINK];}
    if(widget.informationMap.containsKey(SEND_EMAIL_LISTING_NAME)){ propertyName = widget.informationMap[SEND_EMAIL_LISTING_NAME];}
    if(widget.informationMap.containsKey(SEND_EMAIL_REALTOR_NAME)){
      realtorName = widget.informationMap[SEND_EMAIL_REALTOR_NAME];
      if(appBarTitle!.isEmpty){
        appBarTitle = realtorName;
      }
    }
    if(widget.informationMap.containsKey(SEND_EMAIL_REALTOR_TYPE)){ agentAgencyType = widget.informationMap[SEND_EMAIL_REALTOR_TYPE];}
    if(widget.informationMap.containsKey(SEND_EMAIL_REALTOR_EMAIL)){ agentAgencyEmail = widget.informationMap[SEND_EMAIL_REALTOR_EMAIL];}

    textEditingController.text = messageContent;
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchContactPropertyAgentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: appBarTitle ?? UtilityMethods.getLocalizedString("help"),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      agentAgencyInfo(),
                      addName(context),
                      addPhone(context),
                      addEmail(context),
                      addMessage(context),
                      customerType(),
                      agreeToTermsAndConditions(),
                      submitButtonWidget(context),
                    ],
                  ),
                  waitingWidget(),
                  bottomActionBarWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }



  Widget agentAgencyInfo(){
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: CardWidget(
              shape: AppThemePreferences.roundedCorners(AppThemePreferences.realtorPageRoundedCornersRadius),
              color: Colors.transparent,
              child: SizedBox(
                height: 90,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FancyShimmerImage(
                    imageUrl: thumbnail,
                    boxFit: BoxFit.cover,
                    shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                    shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                    errorWidget: ShimmerEffectErrorWidget(iconSize: 50.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  const Icon(Icons.person),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GenericTextWidget(
                        realtorName,
                        style: AppThemePreferences().appTheme.heading01TextStyle,
                        strutStyle: const StrutStyle(height: 1.5, forceStrutHeight: true),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addName(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 15),
      labelText: UtilityMethods.getLocalizedString("your_name"),
      hintText: UtilityMethods.getLocalizedString("enter_your_name"),
      keyboardType: TextInputType.name,
      initialValue: name,
      validator: (value) => validateTextField(value!),
      onSaved: (value) {
        setState(() {
          name = value!;
        });
      },
    );
  }

  Widget addPhone(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 10.0),
      labelText: UtilityMethods.getLocalizedString("phone"),
      hintText: UtilityMethods.getLocalizedString("enter_your_phone_number"),
      keyboardType: TextInputType.phone,
      validator: (value) => validatePhoneNumber(value!),
      onSaved: (value) {
        setState(() {
          phone = value!;
        });
      },
    );
  }

  Widget addEmail(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 10.0),
      labelText: UtilityMethods.getLocalizedString("email"),
      hintText: UtilityMethods.getLocalizedString("enter_email_address"),
      keyboardType: TextInputType.emailAddress,
      initialValue: email,
      validator: (value) => validateEmail(value!),
      onSaved: (value) {
        setState(() {
          email = value!;
        });
      },
    );
  }

  Widget addMessage(BuildContext context) {
    return TextFormFieldWidget(
      padding: const EdgeInsets.only(top: 20.0),
      labelText: UtilityMethods.getLocalizedString("message"),
      hintText: UtilityMethods.getLocalizedString("enter_your_msg"),
      controller: textEditingController,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      validator: (value) => validateTextField(value!),
      onSaved: (value) {
        setState(() {
          message = value!;
        });
      },
    );
  }

  Widget customerType() {
    return Container(
      margin: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelWidget(UtilityMethods.getLocalizedString("type")),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(
                  hintText: UtilityMethods.getLocalizedString("select")),
              // items: roleOptions.map((description, value) {
              //       return MapEntry(description,
              //           DropdownMenuItem<String>(
              //             value: value,
              //             child: genericTextWidget(description),
              //           ));
              //     }).values.toList(),
              items: customerTypes.map((map) {
                return DropdownMenuItem(
                  child: GenericTextWidget(UtilityMethods.getLocalizedString(map['option'])),
                  value: map['value'],
                );
              }).toList(),
              value: _selectedCustomerType,
              onChanged: (value) {
                _selectedCustomerType = value.toString();
              },
              validator: (value) {
                if (value == null) {
                  return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
                }
                return null;
              },
              // onChanged: (String newValue) {
              //   if (newValue != null) {
              //     setState(() {
              //       _roleValue = newValue;
              //     });
              //   }
              // },
            ),
          ),
        ],
      ),
    );
  }

  // Widget customerType() {
  //   return customerTypes == null || customerTypes.isEmpty ? Container() :
  //   genericDropDownWidget(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     labelText: GenericMethods.getLocalizedString("type"),
  //     hintText: GenericMethods.getLocalizedString("select"),
  //     value: _selectedCustomerType,
  //     items: customerTypes.map<DropdownMenuItem<String>>((item) {
  //       return DropdownMenuItem<String>(
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 10.0),
  //           child: genericTextWidget(GenericMethods.getLocalizedString(item)),
  //         ),
  //         value: item,
  //       );
  //     }).toList(),
  //     onChanged: (val) {
  //       setState(() {
  //         _selectedCustomerType = val;
  //         buyerType = val;
  //       });
  //     },
  //   );
  // }

  Widget agreeToTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isAgree,
                    activeColor: AppThemePreferences().appTheme.primaryColor,
                    onChanged: (val) {
                      setState(() {
                        isAgree = val!;
                        state.didChange(val);
                      });
                    },
                  ),
                  Expanded(
                    child: GenericInlineLinkWidget(
                        text: UtilityMethods.getLocalizedString("term_and_agreement_message",inputWords: [UtilityMethods.getLocalizedString("terms_and_conditions")]),
                        linkText: UtilityMethods.getLocalizedString("terms_and_conditions"),
                        onLinkPressed: (){
                          UtilityMethods.navigateToRoute(context: context,
                              builder: (context) => WebPage(APP_TERMS_OF_USE_URL, UtilityMethods.getLocalizedString("terms_of_use")));
                        }
                    ),
                  ),
                ],
              ),
              state.errorText != null && isAgree == false ? Padding(
                padding: const EdgeInsets.only(top: 10,left: 20.0),
                child: GenericTextWidget(
                  state.errorText!,
                  style: TextStyle(
                    color: AppThemePreferences.errorColor,
                  ),
                ),
              ) : Container(),
            ],
          );
        },
        validator: (value) {
          if (!isAgree) {
            return UtilityMethods.getLocalizedString("please_accept_terms_of_use");
          }
          return null;
        },
      ),
    );
  }

  Widget submitButtonWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
      child: Center(
        child: ButtonWidget(
          text: UtilityMethods.getLocalizedString("submit"),
          onPressed: () => onSubmitPressed(),
        ),
      ),
    );
  }

  onSubmitPressed(){
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if(mounted){
        setState(() {
          _showWaitingWidget = true;
        });
      }

      String listingId = widget.informationMap[SEND_EMAIL_LISTING_ID].toString();
      Map<String, dynamic> currentInfoMap = {
        "email": email,
        "listing_id": listingId,
      };

      String key = widget.informationMap[SEND_EMAIL_LISTING_ID].toString() + email;

      var infoMap = HiveStorageManager.readPropertyEmailContactInfo(key);
      if (infoMap != null && infoMap.isNotEmpty) {
        if(infoMap["email"] == email && infoMap["listing_id"] == listingId){
          _showToast(context, UtilityMethods.getLocalizedString("message_already_sent"));
          if(mounted){
            setState(() {
              _showWaitingWidget = false;
            });
          }
        }
        // if (mapEquals(infoMap, currentInfoMap)) {
        //   _showToast(context, GenericMethods.getLocalizedString("error_occurred")message_already_sent);
        // }
        else {
          sendEmail(currentInfoMap);
        }
      }
      else {
        sendEmail(currentInfoMap);
      }
    }
  }

  sendEmail(Map<String, dynamic> currentInfoMap) async {
    ContactRealtorRequest contactRealtorRequest = ContactRealtorRequest(
      agentId: widget.informationMap[SEND_EMAIL_REALTOR_ID].toString(),
      targetEmail: widget.informationMap[SEND_EMAIL_REALTOR_EMAIL],
      name: name,
      email: email,
      mobile: phone,
      message: message,
      userType: _selectedCustomerType!,
      agentType: widget.informationMap[SEND_EMAIL_REALTOR_TYPE],
      propertyId: widget.informationMap[SEND_EMAIL_UNIQUE_ID].toString(),
      listingId: widget.informationMap[SEND_EMAIL_LISTING_ID].toString(),
      propertyTitle: widget.informationMap[SEND_EMAIL_LISTING_NAME] ?? "",
      propertyPermalink: widget.informationMap[SEND_EMAIL_LISTING_LINK],
      sourceLink: widget.informationMap[SEND_EMAIL_LISTING_LINK],
      source: widget.informationMap[SEND_EMAIL_SOURCE],
    );

    final response = await _propertyBloc.fetchContactRealtorResponse(contactRealtorRequest, nonce);

    if (mounted) {
      setState(() {
        _showWaitingWidget = false;
      });
    }

    if (response.success) {
      String key = widget.informationMap[SEND_EMAIL_LISTING_ID].toString() + email;
      _showToast(context, response.message);
      HiveStorageManager.storePropertyEmailContactInfo(currentInfoMap, key);
      Navigator.of(context).pop();
    } else {
      if (response.message.isNotEmpty) {
        _showToast(context, response.message);
      } else {
        _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
      }
    }
  }

  Widget bottomActionBarWidget() {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(
              onPressed: ()=> onSubmitPressed(),
            ),
          ],
        ),
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Widget waitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 90,
            bottom: 0,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 80,
                  height: 20,
                  child: BallBeatLoadingWidget(),
                ),
              ),
            ),
          )
        : Container();
  }
}
