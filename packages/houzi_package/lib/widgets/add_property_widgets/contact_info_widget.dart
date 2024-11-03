import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/pages/add_property_pages/property_contact_information.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef ContactInformationWidgetListener = Function({
  Map<String, dynamic>? updatedDataMap,
  bool? showWaitingWidget,
});

class ContactInformationWidget extends StatefulWidget {
  final Map<String, dynamic>? propertyInfoMap;
  final ContactInformationWidgetListener listener;
  final EdgeInsetsGeometry? padding;

  const ContactInformationWidget({
    Key? key,
    this.propertyInfoMap,
    required this.listener,
    this.padding = const EdgeInsets.all(20),
  }) : super(key: key);

  @override
  State<ContactInformationWidget> createState() => _ContactInformationWidgetState();
}

class _ContactInformationWidgetState extends State<ContactInformationWidget> {

  bool _showWaitingWidget = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactInformationLabelWidget(),
          ContactInformationBodyWidget(
            propertyInfoMap: widget.propertyInfoMap,
            listener: widget.listener,
            // padding: widget.padding,
          ),
        ],
      ),
    );
  }
}

class ContactInformationLabelWidget extends StatelessWidget {
  const ContactInformationLabelWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: UtilityMethods.isRTL(context) ? Alignment.topRight : Alignment.topLeft,
      child: GenericTextWidget(
        UtilityMethods.getLocalizedString("what_information_do_you_want_to_display_in_agent_data_container"),
        textAlign: UtilityMethods.isRTL(context) ? TextAlign.right : TextAlign.left,
        style: AppThemePreferences().appTheme.body01TextStyle,
      ),
    );
  }
}

class ContactInformationBodyWidget extends StatefulWidget {
  final Map<String, dynamic>? propertyInfoMap;
  final ContactInformationWidgetListener listener;

  const ContactInformationBodyWidget({
    Key? key,
    this.propertyInfoMap,
    required this.listener,
  }) : super(key: key);

  @override
  State<ContactInformationBodyWidget> createState() => _ContactInformationBodyWidgetState();
}

class _ContactInformationBodyWidgetState extends State<ContactInformationBodyWidget> {

  bool useAuthorInfo = false;

  String _userRole = '';
  String? selectedValue;
  String? _selectedAgent;
  String? _selectedAgency;

  List<String> realtorsList = [];
  List<dynamic> agentsInfoList = [];
  List<dynamic> agenciesInfoList = [];
  List<dynamic> agentsList = [];
  List<dynamic> agenciesList = [];

  Map<String, dynamic> dataMap = {};

  int? realtorId;
  Map realtorIdStr = {};

  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {

    _userRole = HiveStorageManager.getUserRole();

    if (_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
      realtorIdStr = HiveStorageManager.readUserLoginInfoData() ?? {};
      if (realtorIdStr.isNotEmpty && realtorIdStr.containsKey(FAVE_AUTHOR_AGENCY_ID)) {
        realtorId = int.tryParse(realtorIdStr[FAVE_AUTHOR_AGENCY_ID]);
      } else {
        realtorId = HiveStorageManager.getUserId();
        useAuthorInfo = true;
      }
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    realtorsList = [
      UtilityMethods.getLocalizedString("author_info"),
      UtilityMethods.getLocalizedString("agent_info_choose_list"),
      UtilityMethods.getLocalizedString("agency_info_choose_list"),
      UtilityMethods.getLocalizedString("do_not_display"),
    ];

    if(_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
      selectedValue = realtorsList[2];
    } else {
      selectedValue = realtorsList[0];
    }

    loadRemainingData();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contactInformationDataWidget(),
        errorWidget(),
      ],
    );
  }

  Widget contactInformationDataWidget() {
    if (realtorsList.isNotEmpty) {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: realtorsList.length,
          itemBuilder: (context, index) {
            var item = realtorsList;
            if (_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE && index == 0) {
              return Container();
            } else if (index == 1 && (agentsInfoList.isEmpty)) {
              return Container();
            } else {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenericTextWidget(
                      item[index],
                      style: AppThemePreferences().appTheme.body02TextStyle,
                    ),
                    selectedValue == item[1] && index == 1 && agentsInfoList.isNotEmpty
                        ? chooseAgent()
                        : Container(),
                    selectedValue == item[2] && index == 2 && agenciesInfoList.isNotEmpty
                        ? chooseAgency()
                        : Container(),
                  ],
                ),
                activeColor: AppThemePreferences().appTheme.primaryColor,
                value: selectedValue == item[index] ? true : false,
                onChanged: (bool? value) {
                  setState(() {
                    String displayOption;
                    selectedValue = item[index];
                    if (selectedValue == item[0]) {
                      displayOption = AUTHOR_INFO;
                    } else if (selectedValue == item[1]) {
                      displayOption = AGENT_INFO;
                    } else if (selectedValue == item[2]) {
                      displayOption = AGENCY_INFO;
                    } else {
                      displayOption = "";
                    }

                    if (useAuthorInfo && displayOption == AGENCY_INFO) {
                      displayOption = AUTHOR_INFO;
                    }
                    // if(displayOption == AGENT_INFO && (agentsInfoList == null || agentsInfoList.isEmpty)) {
                    //   displayOption = AGENCY_INFO;
                    //   if(useAuthorInfo) {
                    //     displayOption = AUTHOR_INFO;
                    //   }
                    // }
                    if(mounted) setState(() {
                      dataMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION] = displayOption;
                    });
                  });
                  widget.listener(updatedDataMap: dataMap);
                },
              );
            }
          },
        ),
      );
    }

    return Container();
  }

  Widget chooseAgency() {
    return ContactInformationDropDownWidget(
      value: _selectedAgency,
      list: agenciesInfoList,
      onSaved: (value) => onAgencyChosen(value),
      onChanged: (value) => onAgencyChosen(value),
    );
  }

  Widget chooseAgent() {
    return ContactInformationDropDownWidget(
      value: _selectedAgent,
      list: agentsInfoList,
      onSaved: (value) => onAgentChosen(value),
      onChanged: (value) => onAgentChosen(value),
    );
  }

  Widget errorWidget() {
    return FormField<bool>(
      builder: (state) {
        if (state.errorText != null && agentsInfoList.isNotEmpty && selectedValue == realtorsList[1]){
          if (_selectedAgent == null || _selectedAgent!.isEmpty) {
            return errorMsgWidget(state.errorText!);
          }
        }
        if (state.errorText != null && agenciesInfoList.isNotEmpty && selectedValue == realtorsList[2]){
          if (_selectedAgency == null || _selectedAgency!.isEmpty) {
            return errorMsgWidget(state.errorText!);
          }
        }

        return Container();
      },
      validator: (value) {
        if (agentsInfoList.isNotEmpty && selectedValue == realtorsList[1]) {
          if (_selectedAgent == null || _selectedAgent!.isEmpty) {
            return UtilityMethods.getLocalizedString("select_agent");
          }
        }
        if (agenciesInfoList.isNotEmpty && selectedValue == realtorsList[2]) {
          if (_selectedAgency == null || _selectedAgency!.isEmpty) {
            return UtilityMethods.getLocalizedString("select_agency");
          }
        }
        return null;
      },
    );
  }

  Widget errorMsgWidget(String errorText){
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        left: UtilityMethods.isRTL(context) ? 0 : 25,
        right: UtilityMethods.isRTL(context) ? 25 : 0,
      ),
      child: GenericTextWidget(
        errorText,
        style: TextStyle(
          color: AppThemePreferences.errorColor,
        ),
      ),
    );
  }

  void loadRemainingData() {
    fetchAllAgentsInfo(1, 16).then((value) {
      if (mounted && value.isNotEmpty) {
        setState(() {
          agentsInfoList = value[0];
        });
      }

      if(_userRole != USER_ROLE_HOUZEZ_AGENCY_VALUE) {
        fetchAllAgenciesInfo(1, 16).then((value) {
          if (mounted && value.isNotEmpty) {
            agenciesInfoList = value[0];
            assignValues();
          }

          return null;
        });
      } else {
        assignValues();
      }
      return null;
    });

    widget.listener(showWaitingWidget: false);
  }

  assignValues() {
    Map? tempMap = widget.propertyInfoMap;

    if (tempMap != null) {
      if (tempMap.containsKey(ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION)) {

        String? value = tempMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION];
        if (value != null) {
          if (value == AGENCY_INFO) {
            if (mounted) {
              setState(() {
                selectedValue = realtorsList[2];
                widget.listener(showWaitingWidget: false);
              });
            }
          } else if (value == AGENT_INFO) {
            if (mounted) {
              setState(() {
                selectedValue = realtorsList[1];
                widget.listener(showWaitingWidget: false);
              });
            }
          } else if (value == AUTHOR_INFO) {
            if (mounted) {
              setState(() {
                selectedValue = realtorsList[0];
                widget.listener(showWaitingWidget: false);
              });
            }
          } else if (value.isEmpty) {
            if (mounted) {
              setState(() {
                selectedValue = realtorsList[3];
                widget.listener(showWaitingWidget: false);
              });
            }
          }
        }
      }

      if (selectedValue == realtorsList[1]) {
        if (tempMap.containsKey(ADD_PROPERTY_FAVE_AGENT) &&
            tempMap[ADD_PROPERTY_FAVE_AGENT] != null &&
            tempMap[ADD_PROPERTY_FAVE_AGENT] is List &&
            tempMap[ADD_PROPERTY_FAVE_AGENT].isNotEmpty) {
          var agentId = tempMap[ADD_PROPERTY_FAVE_AGENT][0];
          if (agentId != null) {
            _selectedAgent = agentId.toString();
          }
        }
      } else if (selectedValue == realtorsList[2]) {
        if (tempMap.containsKey(ADD_PROPERTY_FAVE_AGENCY) &&
            tempMap[ADD_PROPERTY_FAVE_AGENCY] != null &&
            tempMap[ADD_PROPERTY_FAVE_AGENCY] is List &&
            tempMap[ADD_PROPERTY_FAVE_AGENCY].isNotEmpty) {
          var agencyId = tempMap[ADD_PROPERTY_FAVE_AGENCY][0];
          if (agencyId != null) {
            _selectedAgency = agencyId.toString();
          }
        }
      }
    } else if (_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
      selectedValue = realtorsList[2];
      if (useAuthorInfo && realtorId != null) {
        dataMap[ADD_PROPERTY_FAVE_AGENCY] = [realtorId.toString()];
        dataMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION] = AUTHOR_INFO;
      } else {
        dataMap[ADD_PROPERTY_FAVE_AGENCY] = [realtorIdStr[FAVE_AUTHOR_AGENCY_ID]];
        dataMap[ADD_PROPERTY_FAVE_AGENT_DISPLAY_OPTION] = AGENCY_INFO;
      }

      widget.listener(updatedDataMap: dataMap);
    }
  }

  int getRealtorId(List list, String realtorId, bool fromAgent) {
    int? id = int.tryParse(realtorId);
    if(id != null) {
      int? index;
      if (useAuthorInfo) {
        index = list.indexWhere((element) => element.id == id);
      } else {
        index = list.indexWhere((element) => element.id == id);
      }
      if (index != -1) {
        int? id;
        if (useAuthorInfo) {
          id = int.tryParse(list[index].agentId);
        } else {
          id = list[index].id;
        }

        if (id != null) {
          return id;
        }
      }
    }
    return -1;
  }

  void onAgentChosen(String? value) {
    if(mounted && value != null){
      setState(() {
        int id = getRealtorId(agentsInfoList, value, true);
        if(id != -1){
          _selectedAgent = id.toString();
          dataMap[ADD_PROPERTY_FAVE_AGENT] = [id];
          widget.listener(updatedDataMap: dataMap);
        }
      });
    }
  }

  void onAgencyChosen(String? value) {
    if(mounted && value != null) {
      setState(() {
        int id = getRealtorId(agenciesInfoList, value, false);
        if(id != -1) {
          _selectedAgency = id.toString();
          dataMap[ADD_PROPERTY_FAVE_AGENCY] = [id];
          widget.listener(updatedDataMap: dataMap);
        }
      });
    }
  }

  Future<List<dynamic>> fetchAllAgentsInfo(int page, int perPage) async {
    try {
      if (mounted) {
        List tempList = [];
        do {
          if (_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
            if(useAuthorInfo) {
              tempList = await _propertyBloc.fetchAgencyAllAgentList(realtorId!);
            } else {
              tempList = await _propertyBloc.fetchAgencyAgentInfoList(realtorId!);
            }

          } else {
            tempList = await _propertyBloc.fetchAllAgentsInfoList(page, perPage);
          }
          agentsList.addAll(tempList);
          page++;
        } while (tempList.length >= 16);
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return agentsList;
  }

  Future<List<dynamic>> fetchAllAgenciesInfo(int page, int perPage) async {
    try {
      if (mounted) {
        List tempList = [];
        do{
          if (_userRole == USER_ROLE_HOUZEZ_AGENCY_VALUE) {
            int? agencyUserId = HiveStorageManager.getUserId();
            if(agencyUserId != null) {
              tempList = await _propertyBloc.fetchSingleAgencyInfoList(agencyUserId);
            }
          } else {
            tempList = await _propertyBloc.fetchAllAgenciesInfoList(page, perPage);
          }

          agenciesList.addAll(tempList);
          page++;
        }while(tempList.length >= 16);

      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return agenciesList;
  }
}

class ContactInformationDropDownWidget extends StatelessWidget {
  final String? value;
  final List list;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  const ContactInformationDropDownWidget({
    Key? key,
    this.value,
    required this.list,
    this.onSaved,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      dropdownColor: AppThemePreferences().appTheme.dropdownMenuBgColor,
      value: value,
      isExpanded: true,
      icon: Icon(AppThemePreferences.dropDownArrowIcon),
      hint: GenericTextWidget(UtilityMethods.getLocalizedString("select")),
      onSaved: onSaved,
      onChanged: onChanged,
      items: list.map<DropdownMenuItem<String>>((item) {
        return DropdownMenuItem<String>(
          value: item.id.toString(),
          child: GenericTextWidget(item.title),
        );
      }).toList(),
    );
  }
}