import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef AddNewDealPageListener = void Function(bool reload , String dealOption);

class AddNewDeal extends StatefulWidget {
   final bool forEditDeal;
   final Map<String,String> dealDetailMap;
   final AddNewDealPageListener? addNewDealPageListenerPageListener;

   const AddNewDeal({super.key,
    required this.dealDetailMap,
    required this.forEditDeal,
    this.addNewDealPageListenerPageListener,
  });

  @override
  _AddNewDealState createState() => _AddNewDealState();
}

class _AddNewDealState extends State<AddNewDeal> with ValidationMixin {
  final formKey = GlobalKey<FormState>();
  final CRMRepository _crmRepository = CRMRepository();

  Future<List<dynamic>>? _futureAgentsList;

  List<dynamic> agentsList = [];
  List<dynamic> agenciesList = [];

  String displayNameId = "1";
  int perPage = 100;

  bool isInternetConnected = true;
  bool _showWaitingWidget = false;

  Future<List<dynamic>>? _futureLeadsFromBoard;
  List<dynamic> leadsFromBoardList = [];
  List<dynamic> agentsInfoList = [];
  List<Map> contactList = [];

  Map<String, String> groupOptions = {
    ACTIVE_OPTION: ACTIVE_OPTION,
    WON_OPTION: WON_OPTION,
    LOST_OPTION: LOST_OPTION,
  };

  String groupValue = ACTIVE_OPTION;

  Map<String, dynamic> addDealInfoMap = {
    DEAL_GROUP: "",
    DEAL_TITLE: "",
    DEAL_CONTACT: "",
    DEAL_VALUE: "",
    DEAL_AGENT: "",
  };

  var _selectedAgent;
  var _selectedContactName;

  @override
  void initState() {
    super.initState();
    if(widget.dealDetailMap[DEAL_GROUP] == WON_OPTION) {
      groupValue = WON_OPTION;
    } else if (widget.dealDetailMap[DEAL_GROUP] == LOST_OPTION){
      groupValue = LOST_OPTION;
    }

    loadData();
  }

  checkInternetAndLoadData() {
    loadData();
  }

  loadData() {
    _futureAgentsList = fetchAllAgentsInfo(1, 16);
    _futureAgentsList!.then((value) {
      if(value == null || (value.isNotEmpty && value[0] == null) || (value.isNotEmpty && value[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isInternetConnected = false;
          });
        }
      } else{
        if(mounted){
          setState(() {
            isInternetConnected = true;
          });
        }
        if(value.isNotEmpty){
          agentsInfoList = value[0];
          if (widget.forEditDeal) {
            var agent = agentsInfoList.firstWhere((element) {
              return element.id.toString() == widget.dealDetailMap[DEAL_AGENT_ID];
            });
            _selectedAgent = agent.id.toString();
            addDealInfoMap[DEAL_AGENT] = agent.id;
          }

        }
      }

      return null;
    });

    var userId = HiveStorageManager.getUserId();
    _futureLeadsFromBoard = fetchLeadsFromBoard(1, perPage,userId!);

    CRMDealsAndLeads dealsAndLeads;
    _futureLeadsFromBoard!.then((value) {
      if(value != null && value.isNotEmpty){
        leadsFromBoardList = value;
        for (int i = 0; i < leadsFromBoardList.length; i++) {
          Map<String, dynamic> userInfoMap = {};
          dealsAndLeads = leadsFromBoardList[i];
          userInfoMap["id"] = dealsAndLeads.resultLeadId;
          userInfoMap["displayName"] = dealsAndLeads.displayName;
          contactList.add(userInfoMap);
        }

        if (widget.forEditDeal) {

          var contactInfo = contactList.firstWhere((element) => element["id"] == widget.dealDetailMap[DEAL_CONTACT_NAME_ID]);

          addDealInfoMap[DEAL_CONTACT] = contactInfo["id"];
          _selectedContactName = contactInfo["id"];
        }
        if(mounted){
          setState(() {});
        }
      }

      return null;
    });

    if(mounted){
      setState(() {});
    }

  }

  Future<List<dynamic>> fetchAllAgentsInfo(int page, int perPage) async {
    try {
      if (mounted) {
        List tempList = [];
        do{
          tempList = await _crmRepository.fetchAllAgentsInfoList(page, perPage);
          agentsList.addAll(tempList);
          page++;
        }while(tempList.length >= 16);

      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return agentsList;
  }

  Future<List<dynamic>> fetchLeadsFromBoard(int page,int perPage ,int userId) async {
    List tempList = [];
    do{
      tempList = await _crmRepository.fetchLeadsFromBoard(page,perPage);
      if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
        if(mounted){
          setState(() {
            isInternetConnected = false;
          });
        }
        break;
      }else{
        if (!isInternetConnected && mounted) {
          setState(() {
            isInternetConnected = true;
          });
        }
        leadsFromBoardList.addAll(tempList);
        page++;
      }
    }while(tempList.length >= perPage);
    return leadsFromBoardList;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: widget.forEditDeal
              ? UtilityMethods.getLocalizedString("edit_deal")
              : UtilityMethods.getLocalizedString("add_new_deal"),
        ),
        body: isInternetConnected == false
            ? Align(
                alignment: Alignment.topCenter,
                child: NoInternetConnectionErrorWidget(onPressed: () {
                  checkInternetAndLoadData();
                }),
              )
            : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        dropDownGroup(),
                        setValuesInFields(
                            UtilityMethods.getLocalizedString("title")+ " *",
                            UtilityMethods.getLocalizedString("enter_the_deal_title"),
                            DEAL_TITLE,
                            TextInputType.text,
                            widget.dealDetailMap.isEmpty ? "" : widget.dealDetailMap[DEAL_DETAIL_TITLE]),
                        dropDownContactName(),
                        dropDownAgent(),
                        setValuesInFields(
                            UtilityMethods.getLocalizedString("deal_value")+ " *",
                            UtilityMethods.getLocalizedString("enter_the_deal_value"),
                            DEAL_VALUE,
                            TextInputType.number,
                            widget.dealDetailMap.isEmpty ? "" : widget.dealDetailMap[DEAL_DETAIL_VALUE]),
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: saveButton(),
                        ),
                      ],
                    ),
                    waitingWidget(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Widget dropDownGroup() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
              UtilityMethods.getLocalizedString("group")+ " *",
            style: AppThemePreferences().appTheme.labelTextStyle
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField<String>(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(hintText: UtilityMethods.getLocalizedString("select")),
              items: groupOptions
                  .map((description, value) {
                return MapEntry(
                    description,
                    DropdownMenuItem<String>(
                      value: value,
                      child: GenericTextWidget(UtilityMethods.getLocalizedString(description)),
                    )
                );
              })
                  .values
                  .toList(),
              // value: groupValue,
              value: groupValue,
              validator: (String? value) {
                if (value?.isEmpty ?? true) {
                  return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
                }
                return null;
              },
              onSaved: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    addDealInfoMap[DEAL_GROUP] = newValue;
                  });
                }
              },
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    addDealInfoMap[DEAL_GROUP] = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget setValuesInFields(String labelText, String hintText,String key,
      TextInputType textInputType,String? initialValue) {
    return TextFormFieldWidget(
      labelText: labelText,
      hintText: hintText,
      keyboardType: textInputType,
      initialValue: initialValue ?? "",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      onSaved: (String? value) {
        setState(() {
          addDealInfoMap[key] = value;
        });
      },
    );
  }

  Widget dropDownContactName() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
              UtilityMethods.getLocalizedString("contact_name")+ " *",
            style: AppThemePreferences().appTheme.labelTextStyle
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
              icon: Icon(AppThemePreferences.dropDownArrowIcon),
              decoration: AppThemePreferences.formFieldDecoration(hintText: UtilityMethods.getLocalizedString("select")),
              items: contactList.map((map) {
                return DropdownMenuItem(
                  child: GenericTextWidget(UtilityMethods.getLocalizedString(map['displayName'] ?? "")),
                  value: map['id'],
                );
              }).toList(),
              value: _selectedContactName,
              validator: (value) {
                if (value == null) {
                  return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  addDealInfoMap[DEAL_CONTACT] = value;
                });
              },
              onSaved: (value) {
                setState(() {
                  addDealInfoMap[DEAL_CONTACT] = value;
                });
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget dropDownAgent() {
    return agentsInfoList == null || agentsInfoList.isEmpty
        ? Container()
        : Container(
            padding: const EdgeInsets.fromLTRB(20,0,20,20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GenericTextWidget(
                    UtilityMethods.getLocalizedString("agent")+ " *",//AppLocalizations.of(context).agent,
                  style: AppThemePreferences().appTheme.labelTextStyle
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: dropDownWidget(
                    value: _selectedAgent,
                    list: agentsInfoList,
                    onChanged: (val) {
                      setState(() {
                        addDealInfoMap[DEAL_AGENT] = val.toString();
                      });
                    },
                    onSaved: (val) {
                      setState(() {
                        addDealInfoMap[DEAL_AGENT] = val.toString();
                      });
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10),
                //   child: DropdownButtonFormField(
                //     decoration: AppThemePreferences.formFieldDecoration(hintText: GenericMethods.getLocalizedString("select")),//AppLocalizations.of(context).select),
                //     //value: agentNameForEdit,
                //     items: agentsInfoList.map<DropdownMenuItem<String>>((item) {
                //       return DropdownMenuItem<String>(
                //         child: genericTextWidget(
                //           item.title,
                //         ),
                //         value: item.id.toString(),
                //       );
                //     }).toList(),
                //     validator: (String value) {
                //       if (value?.isEmpty ?? true) {
                //         return GenericMethods.getLocalizedString("this_field_cannot_be_empty");//AppLocalizations.of(context).this_field_cannot_be_empty;
                //       }
                //       return null;
                //     },
                //     onChanged: (val) {
                //       setState(() {
                //         addDealInfoMap[DEAL_AGENT] = val.toString();
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          );
  }

  Widget dropDownWidget({
    required List list,
    String? value,
    void Function(String?)? onSaved,
    void Function(String?)? onChanged,

  }){
    return DropdownButtonFormField(
      dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
      value: value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
        }
        return null;
      },
      isExpanded: true,
      icon: Icon(AppThemePreferences.dropDownArrowIcon),
      decoration: AppThemePreferences.formFieldDecoration(hintText: UtilityMethods.getLocalizedString("select")),//AppLocalizations.of(context).select),
      onSaved: onSaved,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          child: GenericTextWidget(
            UtilityMethods.getLocalizedString(item.title),
          ),
          // value: item.title,
          value: item.id.toString(),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget saveButton() {
    return ButtonWidget(
        text: widget.forEditDeal
            ? UtilityMethods.getLocalizedString("edit_deal")
            : UtilityMethods.getLocalizedString("add_new_deal"),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            setState(() {
              _showWaitingWidget = true;
            });

            if (widget.forEditDeal) {
              addDealInfoMap["deal_id"] = widget.dealDetailMap[DEAL_DETAIL_ID];
            }

            final response = await _crmRepository.fetchAddDealResponse(addDealInfoMap);

            String tempResponseString = response.toString().split("{")[1];
            Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

            if(map["success"] == true){
              setState(() {
                _showWaitingWidget = false;
              });
              _showToast(context, map["msg"]);
              widget.addNewDealPageListenerPageListener!(true,addDealInfoMap[DEAL_GROUP]);
              Navigator.of(context).pop();
            }
            else {
              setState(() {
                _showWaitingWidget = false;
              });
              _showToast(context, map["msg"]);
            }

          }
        });
  }

  Widget waitingWidget() {
    return _showWaitingWidget == true
        ? Positioned(
            left: 0,
            right: 0,
            top: 0,
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

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}


