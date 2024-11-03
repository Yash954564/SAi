import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_leads/add_new_lead_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/crm_details_listing_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/crm_notes_listings.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/saved_searches.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/bottom_navigation_bar.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

typedef LeadDetailPageListener = void Function(int? index, bool refresh);

class LeadDetailPage extends StatefulWidget {

  final CRMDealsAndLeads? lead;
  final LeadDetailPageListener? leadDetailPageListener;
  final int index;
  final String? idForFetchLead;

  const LeadDetailPage({
    super.key,
    this.leadDetailPageListener,
    this.lead,
    this.idForFetchLead,
    required this.index,
  });

  @override
  _LeadDetailPageState createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final CRMRepository _crmRepository = CRMRepository();

  List<Widget> pageList = <Widget>[];

  Map<String, dynamic> bottomNavBarItemsMap = {
    "details": AppThemePreferences.leadsIcon,
    "inquiry": AppThemePreferences.inquiriesIcon,
    "viewed": AppThemePreferences.listIcon,
    "saved": AppThemePreferences.savedSearchesIcon,
    "notes": AppThemePreferences.requestPropertyIcon,
  };

  String nonce = "";
  int _selectedIndex = 0;
  bool showIndicatorWidget = false;


  CRMDealsAndLeads? leadDetail;

  @override
  void initState() {
    super.initState();
    loadData();
    fetchNonce();
  }

  loadData() async {
    if(widget.lead == null) {
      List list = await fetchLeadDetail();
      CRMDealsAndLeads leads = list[0];
      leadDetail = leads;
      initializePage();
    } else {
      leadDetail = widget.lead;
      initializePage();
    }
  }

  fetchNonce() async {
    ApiResponse response = await _crmRepository.fetchLeadDeleteNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  initializePage() {
    pageList = [
      leadDetailWidget(),
      CRMDetailsListing(
          id: leadDetail!.leadLeadId!,
          fetch: FETCH_LEAD_INQUIRY,),
      CRMDetailsListing(
          id: leadDetail!.leadLeadId!,
          fetch: FETCH_LEAD_VIEWED,),
      SavedSearches(leadId: leadDetail!.leadLeadId!, fetchLeadSavedSearches: true),
      CRMNotesListings(id: leadDetail!.leadLeadId!, fetch: FETCH_LEAD),
    ];

    setState(() {});
  }

  Future<List<dynamic>> fetchLeadDetail() async {
    List tempList = [];
    tempList = await _crmRepository.fetchLeadsInquiriesFromBoard(widget.idForFetchLead!, 1, fetchLeadDetail: true);
    return tempList;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("lead_detail"),
          actions: <Widget>[
            if (_selectedIndex == 0)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(
                  icon: Icon(
                    Icons.more_vert_outlined,
                    color: AppThemePreferences.backgroundColorLight,
                  ),
                  onPressed: ()=> onMenuPressed(context),
                ),
              )
          ],
        ),
        extendBody: true,
        body: pageList.isNotEmpty ? IndexedStack(
          index: _selectedIndex,
          children: pageList,
        ) : loadingIndicatorWidget(),
        bottomNavigationBar: BottomNavigationBarWidget(
          design: BOTTOM_NAVIGATION_BAR_DESIGN,
          currentIndex: _selectedIndex,
          itemsMap: bottomNavBarItemsMap,
          onTap: _onItemTapped,
          backgroundColor:
          AppThemePreferences().appTheme.bottomNavBarBackgroundColor,
          selectedItemColor: AppThemePreferences.bottomNavBarTintColor,
          unselectedItemColor:
          AppThemePreferences.unSelectedBottomNavBarTintColor,
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget leadDetailWidget() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
      elevation: AppThemePreferences.boardPagesElevation,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CRMTypeHeadingWidget(
              "lead_detail",
              leadDetail!.leadTime,
            ),
            const CRMDetailGap(),
            CRMContactDetail(
                leadDetail!.displayName, leadDetail!.email, leadDetail!.mobile,
                () {
              takeActionBottomSheet(
                context,
                false,
                leadDetail!.email,
              );
            }, () {
              takeActionBottomSheet(
                context,
                true,
                leadDetail!.mobile,
              );
            }),
            const CRMDetailGap(),
            CRMIconBottomText(
              AppThemePreferences.verifiedIcon,
              "type",
              leadDetail!.type,
            ),
            const CRMDetailGap(),
            CRMIconBottomText(
              AppThemePreferences.messageIcon,
              "message",
              leadDetail!.message,
            ),
            const CRMDetailGap(),
            InkWell(
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if(UtilityMethods.validateURL(leadDetail!.sourceLink!)) {
                    if (leadDetail!.source! == PROPERTY) {
                      navigateToPropertyDetailPage(leadDetail!.sourceLink!);
                    } else if(leadDetail!.source! == "agent" || leadDetail!.source! == "agency") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealtorInformationDisplayPage(
                            heroId: "1",
                            realtorId: leadDetail!.enquiryTo,
                            agentType: leadDetail!.enquiryUserType!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebPage(
                            leadDetail!.sourceLink!,
                            UtilityMethods.getLocalizedString("source"),
                          ),
                        ),
                      );
                    }
                  } else {
                    print("Not valid source to open webpage");
                  }
                });
              },
              child: CRMIconBottomText(
                AppThemePreferences.adsClickIcon,
                "source",
                leadDetail!.sourceLink!.isEmpty ? leadDetail!.source! : leadDetail!.sourceLink!
              ),
            ),
            const CRMDetailGap(),
            CRMIconBottomText(
              AppThemePreferences.agentsIcon,
              "agent",
              leadDetail!.leadAgentName,
            ),
            const CRMDetailGap(),
          ],
        ),
      ),
    );
  }

  navigateToPropertyDetailPage(sourceLink){
    if (sourceLink == null || sourceLink.isEmpty) return;
    Future.delayed(Duration.zero, () {
      UtilityMethods.navigateToPropertyDetailPage(
        context: context, permaLink: sourceLink, heroId: "1",
      );
    });
  }

  onMenuPressed(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(70.0, 80.0, 0.0, 0.0),
      items: <PopupMenuItem<dynamic>>[
        genericPopupMenuItem(
          context: context,
          value: "Edit",
          text: UtilityMethods.getLocalizedString("edit"),
          iconData: AppThemePreferences.editIcon,
        ),
        genericPopupMenuItem(
          context: context,
          value: "Delete",
          text: UtilityMethods.getLocalizedString("delete"),
          iconData: AppThemePreferences.deleteIcon,
        ),
      ],
    );
  }

  PopupMenuItem genericPopupMenuItem({
    required BuildContext context,
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
                builder: (context) => AddNewLeadPage(
                  leads: leadDetail,
                  forEditLead: true,
                  addNewLeadPageListener: (bool refresh) {
                    Navigator.pop(context);
                    widget.leadDetailPageListener!(null, true);
                  },
                ),
              ),
            );
          } else if (value == "Delete") {
            ShowDialogBoxWidget(
              context,
              title: UtilityMethods.getLocalizedString("delete"),
              content: GenericTextWidget(
                  UtilityMethods.getLocalizedString("delete_confirmation")),
              actions: <Widget>[
                TextButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  child: GenericTextWidget(
                      UtilityMethods.getLocalizedString("cancel")),
                ),
                TextButtonWidget(
                  onPressed: () async {
                    int? leadID = int.tryParse(leadDetail!.leadLeadId!);
                    if (leadID != null) {
                      final response =
                          await _crmRepository.fetchDeleteLead(leadID, nonce);
                      if (response.statusCode == 200) {
                        widget.leadDetailPageListener!(widget.index, true);

                        Navigator.pop(context);
                        Navigator.pop(context);

                        _showToast(context, UtilityMethods.getLocalizedString("lead_deleted"));
                      } else {
                        Navigator.pop(context);
                        _showToast(
                          context,
                          UtilityMethods.getLocalizedString("error_occurred"),
                        );
                      }
                    }
                  },
                  child: GenericTextWidget(
                      UtilityMethods.getLocalizedString("yes")),
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
          const SizedBox(width: 10),
          GenericTextWidget(text),
        ],
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

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }
}
