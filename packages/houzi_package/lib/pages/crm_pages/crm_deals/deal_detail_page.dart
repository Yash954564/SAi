import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/drop_down_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:intl/intl.dart';

import 'add_new_deal_page.dart';

typedef DealDetailPageListener = void Function({int index, bool refresh, String dealOption});

class DealDetailPage extends StatefulWidget {

  final CRMDealsAndLeads deal;
  final DealDetailPageListener? dealDetailPageListener;
  final int index;
  final String action;
  final String status;
  final Map<String,String> dealDetailMap;

  DealDetailPage({
    this.dealDetailPageListener,
    required this.deal,
    required this.index,
    required this.action,
    required this.status,
    required this.dealDetailMap,
  });

  @override
  _DealDetailPageState createState() => _DealDetailPageState();
}

class _DealDetailPageState extends State<DealDetailPage> {
  final CRMRepository _crmRepository = CRMRepository();

  List<String> statusOptionsList = [];
  List<String> nextActionOptionsList = [];

  String? _statusValue;
  String? _nextActionValue;
  String nonce = "";

  final TextEditingController _actionDueTextController = TextEditingController();
  final TextEditingController _lastContactTextController = TextEditingController();
  DateTime actionDueSelectedDate = DateTime.now();
  DateTime lastContactSelectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadData();
    fetchNonce();
  }

  loadData() {
    String? dealStatus = HiveStorageManager.readDealStatusInfoData() ?? "";
    if (dealStatus != null && dealStatus.isNotEmpty) {
      statusOptionsList = dealStatus.split(', ');
    } else {
      if (widget.status.isNotEmpty) {
        statusOptionsList = widget.status.trim().split(", ");
      }
    }
    String? dealNextAction = HiveStorageManager.readNDealNextActionInfoData() ?? "";
    if (dealNextAction != null && dealNextAction.isNotEmpty) {
      nextActionOptionsList = dealNextAction.split(', ');
    } else {
      if (widget.action.isNotEmpty) {
        nextActionOptionsList = widget.action.trim().split(", ");
      }
    }

    _statusValue = widget.deal.resultStatus ?? "";
    _nextActionValue = widget.deal.nextAction ?? "";

    if (widget.deal.actionDueDate! != "0000-00-00 00:00:00") {
      actionDueSelectedDate = DateFormat("yyyy-MM-dd").parse(widget.deal.actionDueDate!);
      String date = "${actionDueSelectedDate.toLocal()}".split(' ')[0];
      _actionDueTextController.text = date;

    }
    if (widget.deal.lastContactDate! != "0000-00-00 00:00:00") {
      lastContactSelectedDate = DateFormat("yyyy-MM-dd").parse(widget.deal.lastContactDate!);
      String date = "${lastContactSelectedDate.toLocal()}".split(' ')[0];
      _lastContactTextController.text = date;
    }


  }

  fetchNonce() async {
    ApiResponse response = await _crmRepository.fetchDealDeleteNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("deal_detail"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Icon(
                    Icons.more_vert_outlined,
                    color: AppThemePreferences.backgroundColorLight
                ),
                onPressed: () {
                  onMenuPressed();
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardWidget(
                  shape: AppThemePreferences.roundedCorners(
                      AppThemePreferences.globalRoundedCornersRadius),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CRMTypeHeadingWidget("deal", widget.deal.resultTime),
                        const CRMDetailGap(),
                        CRMHeadingWidget(widget.deal.title),
                        const CRMDetailGap(),
                        CRMContactDetail(
                          widget.deal.displayName,
                          widget.deal.email,
                          widget.deal.mobile,
                              () => takeActionBottomSheet(
                            context, false, widget.deal.email,
                          ),
                              () => takeActionBottomSheet(
                            context, true, widget.deal.mobile,
                          ),
                          addBottomPadding: true,
                        ),
                        const CRMDetailGap(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CRMIconAndText(AppThemePreferences.agentsIcon, widget.deal.agentName),
                            CRMIconAndText(AppThemePreferences.priceTagIcon, widget.deal.dealValue),
                          ],
                        ),
                        const CRMDetailGap(gap: 20),
                        CRMIconAndText(AppThemePreferences.showCharts, "status",addBottomPadding: true),
                        dropDownWidget(
                          "status", statusOptionsList, _statusValue, DEAL_SET_STATUS,
                        ),
                        const CRMDetailGap(gap: 20),
                        CRMIconAndText(AppThemePreferences.timerOutlined, "action_due_date",addBottomPadding: true),
                        datePickerWidget(DEAL_SET_ACTION_DUE_DATE),
                        const CRMDetailGap(gap: 20),
                        CRMIconAndText(AppThemePreferences.filterCenterFocus, "next_action",addBottomPadding: true),
                        dropDownWidget(
                          "next_action", nextActionOptionsList, _nextActionValue, DEAL_SET_NEXT_ACTION,
                        ),
                        const CRMDetailGap(gap: 20),
                        CRMIconAndText(AppThemePreferences.calendarMonthOutlined, "last_contact_date",addBottomPadding: true),
                        datePickerWidget(DEAL_SET_LAST_CONTACT_DATE),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      );
  }

  Widget datePickerWidget(String key) {
    return TextFormFieldWidget(
      suffixIcon: Icon(
        AppThemePreferences.dropDownArrowIcon,
        color: AppThemePreferences().appTheme.isDark
            ? Colors.grey
            : Colors.grey[800],
      ),
      padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
      labelText: UtilityMethods.getLocalizedString(""),
      hintText: UtilityMethods.getLocalizedString("select"),

      onTap: () {
        if(key == DEAL_SET_ACTION_DUE_DATE){
          _selectDateActionDue(context, DEAL_SET_ACTION_DUE_DATE);
        } else {
          _selectDateLastContact(context, DEAL_SET_LAST_CONTACT_DATE);
        }
      },
      controller: key == DEAL_SET_ACTION_DUE_DATE ? _actionDueTextController : _lastContactTextController,
      readOnly: true,
    );
  }

  Future<void> _selectDateActionDue(BuildContext context, String key) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: actionDueSelectedDate,
        firstDate: actionDueSelectedDate,
        lastDate: DateTime(DateTime.now().year + 100));
    if (picked != null && picked != actionDueSelectedDate) {
        String date = "${picked.toLocal()}".split(' ')[0];
        setState(() {
          _actionDueTextController.text = date;
          actionDueSelectedDate = picked;
        });

        Map<String, dynamic> updateData = {
          DEAL_UPDATE_ID: widget.deal.dealId,
          DEAL_UPDATE_PURPOSE: key,
          DEAL_UPDATE_DATA: date,
        };
        await _crmRepository.fetchUpdateDealDetailResponse(updateData);
        widget.dealDetailPageListener!(refresh: true, dealOption: widget.deal.dealGroup!);

    }
  }

  Future<void> _selectDateLastContact(BuildContext context, String key) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: lastContactSelectedDate,
        firstDate: lastContactSelectedDate,
        lastDate: DateTime(DateTime.now().year + 100));
    if (picked != null && picked != lastContactSelectedDate) {
      String date = "${picked.toLocal()}".split(' ')[0];
      setState(() {
        _lastContactTextController.text = date;
        lastContactSelectedDate = picked;
      });

      Map<String, dynamic> updateData = {
        DEAL_UPDATE_ID: widget.deal.dealId,
        DEAL_UPDATE_PURPOSE: key,
        DEAL_UPDATE_DATA: date,
      };
      await _crmRepository.fetchUpdateDealDetailResponse(updateData);
      widget.dealDetailPageListener!(refresh: true, dealOption: widget.deal.dealGroup!);

    }
  }

  Widget dropDownWidget(String title,List? list,prefilled,String key) {
    if (list != null && list.isNotEmpty) {
      return GenericStringDropDownWidget(
        padding:  EdgeInsets.only(top: 7),
        labelText: UtilityMethods.getLocalizedString(""),
        hintText: UtilityMethods.getLocalizedString("select"),
        value: prefilled.isNotEmpty ? prefilled : null,
        items: list.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            child: GenericTextWidget(UtilityMethods.getLocalizedString(item)),
            value: item,
          );
        }).toList(),
        onChanged: (val) async {
          Map<String, dynamic> updateData = {
            DEAL_UPDATE_ID: widget.deal.dealId,
            DEAL_UPDATE_PURPOSE: key,
            DEAL_UPDATE_DATA: val,
          };
          await _crmRepository.fetchUpdateDealDetailResponse(updateData);
          widget.dealDetailPageListener!(refresh: true, dealOption: widget.deal.dealGroup!);

        },
      );

    }
    return Container();
  }

  onMenuPressed() async {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(70.0, 80.0, 0.0, 0.0),
      items: <PopupMenuItem<dynamic>>[
        genericPopupMenuItem(
          value: "Edit",
          text: UtilityMethods.getLocalizedString("edit"),
          iconData: AppThemePreferences.editIcon,
        ),
        genericPopupMenuItem(
          value: "Delete",
          text: UtilityMethods.getLocalizedString("delete"),
          iconData: AppThemePreferences.deleteIcon,
        ),
      ],
    );
  }

  PopupMenuItem genericPopupMenuItem({
    required dynamic value,
    required String text,
    required IconData iconData,
  }) {
    return PopupMenuItem(
      value: value,
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (value == "Edit") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AddNewDeal(dealDetailMap: widget.dealDetailMap,forEditDeal: true ,addNewDealPageListenerPageListener: (bool refresh,String dealOption){
                      widget.dealDetailPageListener!(refresh: true, dealOption: dealOption);
                      Navigator.pop(context);
                    }
                    ),
              ),
            );
          }
          if (value == "Delete") {
            ShowDialogBoxWidget(
              context,
              title: UtilityMethods.getLocalizedString("delete"),
              content: GenericTextWidget(
                  UtilityMethods.getLocalizedString("delete_confirmation")),
              actions: <Widget>[
                TextButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
                ),
                TextButtonWidget(
                  onPressed: () async {
                    int dealID = int.parse(widget.deal.dealId!);
                    final response = await _crmRepository.fetchDeleteDeal(dealID, nonce);
                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      widget.dealDetailPageListener!(index: widget.index,refresh: false);
                      _showToast(context, UtilityMethods.getLocalizedString("deal_deleted"));
                    } else {
                      _showToast(context, UtilityMethods.getLocalizedString("error_occurred"),
                      );
                    }
                  },
                  child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
                ),
              ],
            );
          }
        });
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: AppThemePreferences().appTheme.iconsColor,
          ),
          SizedBox(width: 10),
          GenericTextWidget(text),
        ],
      ),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
