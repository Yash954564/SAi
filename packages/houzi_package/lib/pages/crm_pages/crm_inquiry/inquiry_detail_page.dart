import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/crm_details_listing_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/crm_notes_listings.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/bottom_navigation_bar.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'add_new_inquiry_page.dart';

typedef InquiryDetailPageListener = void Function({int? index, bool refresh});

class InquiryDetailPage extends StatefulWidget {
  final CRMInquiries inquiryDetail;
  final int index;
  final InquiryDetailPageListener? inquiryDetailPageListener;

  const InquiryDetailPage({super.key,
    required this.inquiryDetail,
    required this.index,
    this.inquiryDetailPageListener,
  });

  @override
  _InquiryDetailPageState createState() => _InquiryDetailPageState();
}

class _InquiryDetailPageState extends State<InquiryDetailPage> {
  final CRMRepository _crmRepository = CRMRepository();

  List<Widget> pageList = <Widget>[];

  Map<String, dynamic> bottomNavBarItemsMap = {
    "details": AppThemePreferences.inquiriesIcon,
    "matching_listing": AppThemePreferences.listIcon,
    "notes": AppThemePreferences.requestPropertyIcon,
  };

  bool showIndicatorWidget = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageList.add(inquiryDetail());
    pageList.add(CRMDetailsListing(
      id: widget.inquiryDetail.enquiryId!,
      fetch: FETCH_INQUIRY_MATCHING,
      inquiries: widget.inquiryDetail,
    ));
    pageList.add(CRMNotesListings(
      id: widget.inquiryDetail.enquiryId!,
      fetch: FETCH_INQUIRY
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: UtilityMethods.getLocalizedString("inquiry_detail"),
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
        body: IndexedStack(
          index: _selectedIndex,
          children: pageList,
        ),
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

  Widget inquiryDetail() {
    return CardWidget(
      shape: AppThemePreferences.roundedCorners(
          AppThemePreferences.globalRoundedCornersRadius),
      elevation: AppThemePreferences.boardPagesElevation,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CRMTypeHeadingWidget("inquiry_detail", widget.inquiryDetail.time),
            const CRMDetailGap(),
            CRMHeadingWidget(widget.inquiryDetail.propertyTypeName,
                secondHeading: widget.inquiryDetail.enquiryType),
            const CRMDetailGap(),
            CRMContactDetail(
              widget.inquiryDetail.leads!.displayName,
              widget.inquiryDetail.leads!.email!,
              widget.inquiryDetail.leads!.mobile,
              () {
                takeActionBottomSheet(
                    context, false, widget.inquiryDetail.leads!.email!);
              },
              () {
                takeActionBottomSheet(
                    context, true, widget.inquiryDetail.leads!.mobile!);
              },
            ),
            const CRMDetailGap(),
            CRMFeatures(
                widget.inquiryDetail.minBeds,
                widget.inquiryDetail.minBaths,
                widget.inquiryDetail.minArea,
                widget.inquiryDetail.minPrice,
                addBottomPadding: true,
            ),
            const CRMDetailGap(),
            CRMIconBottomText(AppThemePreferences.messageIcon, "message",
                widget.inquiryDetail.leads?.message)
          ],
        ),
      ),
    );
  }

  onMenuPressed(BuildContext context) async {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(70.0, 80.0, 0.0, 0.0),
      items: <PopupMenuItem<dynamic>>[
        if (_selectedIndex == 0)
          genericPopupMenuItem(
            context,
            value: "Edit",
            text: UtilityMethods.getLocalizedString("edit"),
            iconData: AppThemePreferences.editIcon,
          ),
        if (_selectedIndex == 0)
          genericPopupMenuItem(
            context,
            value: "Delete",
            text: UtilityMethods.getLocalizedString("delete"),
            iconData: AppThemePreferences.deleteIcon,
          ),
      ],
    );
  }

  PopupMenuItem genericPopupMenuItem(BuildContext context, {
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
                builder: (context) => AddNewInquiry(forInquiryEdit: true,inquiries: widget.inquiryDetail,addNewInquiryPageListener: (bool refresh) {
                  if (refresh) {
                    Navigator.pop(context);
                    widget.inquiryDetailPageListener!(index: null, refresh: true);
                  }
                }),
              ),
            );
          }
          else if (value == "Delete") {
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
                  onPressed: onTapDelete,
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

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Future<void> onTapDelete() async {
    if (widget.inquiryDetail.enquiryId != null &&
        widget.inquiryDetail.enquiryId!.isNotEmpty) {
      int? inquiryId = int.tryParse(widget.inquiryDetail.enquiryId!);
      if (inquiryId != null) {
        final response = await _crmRepository.fetchDeleteInquiry(inquiryId);

        if (response.statusCode == 200) {
          Navigator.pop(context);
          Navigator.pop(context);
          widget.inquiryDetailPageListener!(index: widget.index, refresh: false);
          _showToast(context,
              UtilityMethods.getLocalizedString("inquiry_delete_successfully"));
        } else {
          _showToast(
              context, UtilityMethods.getLocalizedString("error_occurred"));
        }
      }
    }
  }
}
