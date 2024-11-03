import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/item_design_files/item_design_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/bottom_buttons_action_bar.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/models/realtor_model.dart';
import 'package:houzi_package/pages/search_result.dart';
import 'package:houzi_package/pages/send_email_to_realtor.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_segment_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:houzi_package/widgets/review_related_widgets/reviews_widget.dart';

class RealtorInformationDisplayPage extends StatefulWidget {
  final String heroId;
  final String agentType;
  final String? realtorId;
  final Map<String, dynamic>? realtorInformation;

  @override
  State<StatefulWidget> createState() => RealtorInformationDisplayPageState();

  RealtorInformationDisplayPage({
    required this.heroId,
    required this.agentType,
    this.realtorId,
    this.realtorInformation,
  });
}

class RealtorInformationDisplayPageState
    extends State<RealtorInformationDisplayPage> with TickerProviderStateMixin {
  var item;
  String totalRating = "";
  final PropertyBloc _propertyBloc = PropertyBloc();

  int? realtorId;
  int page = 1;
  int perPage = 3;

  bool isAgent = false;
  bool isAgency = false;
  bool isAuthor = false;
  bool isReadMore = false;
  bool isShowMore = false;
  bool showListings = false;
  bool isSubRealtorsEmpty = false;
  bool isListingButtonClicked = true;
  bool isSubRealtorButtonClicked = false;
  bool showMoreButton = false;
  bool isUserLoggedIn = false;
  bool isInternetConnected = true;
  bool emailDeliveryCheck = true;

  String address = "";
  String license = "";
  String taxNumber = "";
  String phoneNumber = "";
  String mobileNumber = "";
  String faxNumber = "";
  String email = "";
  String image = "";
  String link = "";
  String? title;

  // String title = "";
  String whatsappNumber = "";
  String content = "";
  String agentPosition = "";
  String agentCompany = "";
  String agentServiceAreas = "";
  String agentSpecialties = "";
  String articleBoxDesign = "";
  String reviewPostType = "";
  String appName = '';
  String type = '';
  String lineId = "";
  String telegramId = "";

  List<dynamic> agencyOrAgentsList = [];
  List<dynamic> realtorListings = [];
  List<dynamic> tabList = [];

  Future<List<dynamic>>? _futureProperties;
  Future<List<dynamic>>? _futureSubRealtors;

  bool showReviews = true;
  bool showListingsFromTab = false;

  int _currentSelection = 0;

  int tempIndexListing = 0;
  int tempIndexRealtor = 1;

  bool showAgentAgency = false;
  bool showPropertyListings = false;

  Map<String, dynamic> realtorInformation = {};

  @override
  void initState() {
    super.initState();

    // print("realtorInformation: ${widget.realtorInformation}");
    if (widget.realtorInformation != null) {
      realtorInformation = widget.realtorInformation!;
    }

    appName = HiveStorageManager.readAppInfo()[APP_INFO_APP_NAME] ?? "";

    if (Provider.of<UserLoggedProvider>(context, listen: false).isLoggedIn ??
        false) {
      if (mounted) {
        setState(() {
          isUserLoggedIn = true;
        });
      }
    }

    type = checkType(widget.agentType);

    setRealtorData();
    // checkInternetAndLoadData();
  }

  setRealtorData() async {
    if (realtorInformation.isEmpty) {
      if (widget.agentType == AGENT_INFO) {
        List list = await fetchAgentInfo(widget.realtorId!);
        realtorInformation[AGENT_DATA] = list[0];
      } else if (widget.agentType == AGENCY_INFO){
        List list = await fetchAgencyInfo(widget.realtorId!);
        realtorInformation[AGENCY_DATA] = list[0];
      } else {
        realtorInformation[AUTHOR_DATA] = widget.realtorInformation;
      }
    }

    loadRealtorData(realtorInformation);
  }

  loadRealtorData(Map<String, dynamic> realtorInformation) {
    if (realtorInformation.containsKey(AGENCY_DATA)) {
      setState(() {
        isAgency = true;
        item = realtorInformation[AGENCY_DATA];
        if (item != null) {
          realtorId = item.id;
          image = item.thumbnail ?? "";
          title = item.title ?? "";
          content = item.content ?? "";
          if (content.isNotEmpty) {
            content = UtilityMethods.stripHtmlIfNeeded(content);
          }
          address = item.agencyMapAddress ?? "";
          if (address.isEmpty) {
            address = item.agencyAddress ?? "";
          }
          license = item.agencyLicenseNumber ?? "";
          taxNumber = item.agencyTaxNumber ?? "";
          phoneNumber = item.agencyPhoneNumber ?? "";
          mobileNumber = item.agencyMobileNumber ?? "";
          faxNumber = item.agencyFaxNumber ?? "";
          email = item.email ?? "";
          link = item.agencyLink ?? "";
          whatsappNumber = item.agencyWhatsappNumber ?? "";
          var tempRatingData = item.totalRating;
          if (tempRatingData != null && tempRatingData.isNotEmpty) {
            double tempTotalRating = double.parse(tempRatingData);
            totalRating = tempTotalRating.toStringAsFixed(0);
          }
          lineId = item.lineApp ?? "";
          telegramId = item.telegram ?? "";
        }
      });
    }
    else if (realtorInformation.containsKey(AGENT_DATA)) {
      setState(() {
        isAgent = true;
        item = realtorInformation[AGENT_DATA];
        if (item != null) {
          realtorId = item.id ?? int.tryParse(item.agentId);
          image = item.thumbnail ?? "";
          title = item.title ?? "";
          content = item.content ?? "";
          if (content.isNotEmpty) {
            content = UtilityMethods.stripHtmlIfNeeded(content);
          }
          address = item.agentAddress ?? "";
          license = item.agentLicenseNumber ?? "";
          taxNumber = item.agentTaxNumber ?? "";
          phoneNumber = item.agentOfficeNumber ?? "";
          mobileNumber = item.agentMobileNumber ?? "";
          faxNumber = item.agentFaxNumber ?? "";
          email = item.email ?? "";
          link = item.agentLink ?? "";
          var tempRatingData = item.totalRating;
          if (tempRatingData != null && tempRatingData.isNotEmpty) {
            double tempTotalRating = double.parse(tempRatingData);
            totalRating = tempTotalRating.toStringAsFixed(0);
          }
          agentPosition = item.agentPosition ?? "";
          agentCompany = item.agentCompany ?? "";
          agentServiceAreas = item.agentServiceArea ?? "";
          agentSpecialties = item.agentSpecialties ?? "";
          whatsappNumber = item.agentWhatsappNumber ?? "";
          lineId = item.lineApp ?? "";
          telegramId = item.telegram ?? "";
        }
      });
    }
    else if (realtorInformation.containsKey(AUTHOR_DATA)) {
      setState(() {
        isAuthor = true;
        isSubRealtorsEmpty = true;
        // isListingButtonClicked = false;



        item = realtorInformation[AUTHOR_DATA];
        if (item != null) {
          realtorId = item[tempRealtorIdKey];
          title = item[tempRealtorNameKey] ?? "";
          image = item[tempRealtorThumbnailKey] ?? "";
          mobileNumber = item[tempRealtorMobileKey] ?? "";
          phoneNumber = item[tempRealtorPhoneKey] ?? "";
          whatsappNumber = item[tempRealtorWhatsAppKey] ?? "";
          email = item[tempRealtorEmailKey] ?? "";
          lineId = item[tempRealtorLineAppKey] ?? "";
          telegramId = item[tempRealtorTelegramKey] ?? "";

          // var tempRatingData = item.totalRating;
          // if(tempRatingData != null && tempRatingData.isNotEmpty){
          //   double tempTotalRating = double.parse(tempRatingData);
          //   totalRating = tempTotalRating.toStringAsFixed(0);
          // }
        }
      });
    }
    else if (widget.agentType == AUTHOR_INFO && widget.realtorInformation != null) {
      setState(() {
        isAuthor = true;
        isSubRealtorsEmpty = true;

        item = widget.realtorInformation!;
        if (item != null) {
          realtorId = item[tempRealtorIdKey];
          title = item[tempRealtorNameKey] ?? "";
          image = item[tempRealtorThumbnailKey] ?? "";
          mobileNumber = item[tempRealtorMobileKey] ?? "";
          phoneNumber = item[tempRealtorPhoneKey] ?? "";
          whatsappNumber = item[tempRealtorWhatsAppKey] ?? "";
          email = item[tempRealtorEmailKey] ?? "";
          lineId = item[tempRealtorLineAppKey] ?? "";
          telegramId = item[tempRealtorTelegramKey] ?? "";

          // var tempRatingData = item.totalRating;
          // if(tempRatingData != null && tempRatingData.isNotEmpty){
          //   double tempTotalRating = double.parse(tempRatingData);
          //   totalRating = tempTotalRating.toStringAsFixed(0);
          // }
        }
      });
    }
    loadData();
  }

  Future<List<dynamic>> fetchAgencyInfo(String idStr) async {
    int id = int.parse(idStr);
    List<dynamic>? tempList = await _propertyBloc.fetchSingleAgencyInfoList(id);
    if (tempList == null ||
        tempList.isEmpty ||
        tempList[0] == null ||
        tempList[0].runtimeType == Response) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
    }

    return tempList;
  }

  Future<List<dynamic>> fetchAgentInfo(String idStr) async {
    int id = int.parse(idStr);

    List<dynamic>? tempList = await _propertyBloc.fetchSingleAgentInfoList(id);
    if (tempList == null ||
        tempList.isEmpty ||
        tempList[0] == null ||
        tempList[0].runtimeType == Response) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
    }

    return tempList;
  }

  checkInternetAndLoadData() {
    // InternetConnectionChecker().checkInternetConnection().then((value){
    //   if(value){
    //     setState(() {
    //       isInternetConnected = true;
    //     });
    //     loadData();
    //   }else{
    //     setState(() {
    //       isInternetConnected = false;
    //     });
    //   }
    //   return null;
    // });
    loadData();
  }

  loadData() {
    // if (SHOW_REVIEWS) {
    //   tabList = [GenericMethods.getLocalizedString("error_occurred")reviews];
    // }

    if (isAgency) {
      _futureProperties = fetchProperties(realtorId!, page, perPage);
      _futureProperties!.then((value) {
        if (value.isNotEmpty) {
          //if (_userRole == ROLE_ADMINISTRATOR) {
          _futureSubRealtors = fetchAgents(realtorId!);
          //}
        }
        return null;
      });
    } else if (isAgent) {
      _futureProperties = fetchProperties(realtorId!, page, perPage);
      _futureProperties!.then((value) {
        if (value.isNotEmpty) {
          if (item.agentAgencies != null && item.agentAgencies.isNotEmpty) {
            int agencyId = int.parse(item.agentAgencies[0]);
            //if (_userRole == ROLE_ADMINISTRATOR) {
            _futureSubRealtors = fetchAgency(agencyId);
            //}
          }
        }
        return null;
      });
    } else if (isAuthor) {
      _futureProperties = fetchProperties(realtorId!, page, perPage);
      _futureProperties!.then((value) {
        if (value != null && value.isNotEmpty) {
          if (mounted) {
            setState(() {
              showListings = true;
              isListingButtonClicked = true;
            });
          }
        }
        return null;
      });
    }

    type = checkType(widget.agentType);
  }

  @override
  void didChangeDependencies() {
    if (SHOW_REVIEWS) {
      tabList = [UtilityMethods.getLocalizedString("reviews")];
    }
    super.didChangeDependencies();
  }

  @override
  dispose() {
    realtorListings = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: title ?? UtilityMethods.getLocalizedString("realtor_info"),
      ),
      body: Stack(
        children: [
          if (realtorInformation.isNotEmpty)
            RefreshIndicator(
              onRefresh: () => onRefresh(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    RealtorInfoWidget(
                      title: title ?? "",
                      imageUrl: image,
                      heroId: widget.heroId,
                      position: agentPosition,
                      company: agentCompany,
                    ),
                    AddressWidget(address: address),
                    if (HooksConfigurations.agentProfileConfigurationsHook(
                            "additional_info") ?? true)
                      AdditionalInfoWidget(
                        showMore: isShowMore,
                        license: license,
                        taxNumber: taxNumber,
                        agentSpecialties: agentSpecialties,
                        agentServiceAreas: agentServiceAreas,
                        listener: (tapped) => onShowMoreWidgetTap(),
                      ),
                    if (content.isNotEmpty)
                      DescriptionWidget(
                        readMore: isReadMore,
                        content: content,
                        listener: (tapped) => onReadMoreTap(),
                      ),
                    if (tabList.length > 1)
                      TabBarViewWidget(
                        onSegmentChosen: onSegmentChosen,
                        currentSelection: _currentSelection,
                        tabsList: tabList,
                      ),
                    if (SHOW_REVIEWS && (_currentSelection == 0) && realtorId != null)
                      ReviewsWidget(
                        fromProperty: false,
                        idForReviews: realtorId,
                        link: link,
                        title: title,
                        totalRating: totalRating,
                        type: type,
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: tabList.length == 1 ? 20 : 5,
                        ),
                      ),
                    if (showPropertyListings) HeadingWidget(text: "listings"),
                    if (_futureProperties != null)
                      ListingsWidget(
                        articlesList: _futureProperties!,
                        tempIndexListing: tempIndexListing,
                        isUserLoggedIn: isUserLoggedIn,
                        currentSelection: _currentSelection,
                        listener: (error) => onListingError(),
                      ),
                    if (showAgentAgency)
                      HeadingWidget(text: isAgent ? "agency" : "agents"),
                    RealtorInformationDisplayWidget(
                      currentSelection: _currentSelection,
                      tempIndexRealtor: tempIndexRealtor,
                      isAgency: isAgency,
                      isAgent: isAgent,
                      realtorsList: _futureSubRealtors,
                      showAgentAgency: showAgentAgency,
                    ),
                    MoreElevatedButtonWidget(
                      onTap: ()=> onMoreButtonTap(),
                      currentSelection: _currentSelection,
                      tempIndexListing: tempIndexListing,
                      realtorListings: realtorListings,
                    ),
                    if (showContactWidget())
                      ContactWidget(
                        address: address,
                        email: email,
                        faxNumber: faxNumber,
                        mobileNumber: mobileNumber,
                        phoneNumber: phoneNumber,
                      ),
                  ],
                ),
              ),
            )
          else
            LoadingIndicatorWidget()
        ],
      ),
      bottomNavigationBar: showBottomActionBar() ? BottomAppBar(
        padding: const EdgeInsets.all(0),
        surfaceTintColor: Colors.transparent,
        child: bottomActionBarWidget(),
      ) : null,
    );
  }

  bool showContactWidget() {
    if (address.isNotEmpty || email.isNotEmpty || faxNumber.isNotEmpty
    || mobileNumber.isNotEmpty || phoneNumber.isNotEmpty) {
      return true;
    }

    return false;
  }

  bool showBottomActionBar() {
    if (email.isNotEmpty || phoneNumber.isNotEmpty || mobileNumber.isNotEmpty
        || whatsappNumber.isNotEmpty || lineId.isNotEmpty
        || telegramId.isNotEmpty) {
      return true;
    }

    return false;
  }

  onRefresh() async {
    if (mounted) {
      setState(() {
        agencyOrAgentsList.clear();
        realtorListings.clear();
        tabList.clear();
        _currentSelection = 0;
        tempIndexListing = 0;
        tempIndexRealtor = 1;
      });
    }
    tabList = [UtilityMethods.getLocalizedString("reviews")];
    loadData();
    return null;
  }

  void onShowMoreWidgetTap() {
    if (mounted) {
      setState(() {
        isShowMore = !isShowMore;
      });
    }
  }

  void onReadMoreTap() {
    if (mounted) {
      setState(() {
        isReadMore = !isReadMore;
      });
    }
  }

  onSegmentChosen(int index) {
    if (mounted) {
      setState(() {
        _currentSelection = index;
      });
    }
  }

  void onListingError() {
    if (mounted) {
      setState(() {
        showListings = false;
      });
    }
  }

  String phoneOrMobile() {
    if (mobileNumber.isNotEmpty) {
      return mobileNumber;
    }
    return phoneNumber;
  }

  Widget bottomActionBarWidget() {
    //if(!isInternetConnected) noInternetBottomActionBar(context, ()=> checkInternetAndLoadData())
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppThemePreferences().appTheme.backgroundColor!.withOpacity(0.8),
          border: Border(
            top: AppThemePreferences().appTheme.propertyDetailsPageBottomMenuBorderSide!,
          ),
        ),
        child: SizedBox(
          height: 70,
          child: !isInternetConnected
              ? NoInternetBottomActionBarWidget(
                  onPressed: () => checkInternetAndLoadData())
              : (showSmallActionButtons())
                  ? SmallActionButtons(
                      article: Article(),
                      showMessageButton: false,
                      showMessageButtonPadding: false,
                      onMessageButtonPressed: (){},
                      showEmailButton: showEmailActionButton(),
                      showCallButton: showCallActionButton(),
                      showWhatsAppButton: showWhatsappActionButton(),
                      showLineButton: showLineAppActionButton(),
                      showTelegramButton: showTelegramActionButton(),
                      showCallButtonPadding: showCallButtonPadding(),
                      showWhatsAppButtonPadding: showWhatsAppButtonPadding(),
                      showLineButtonPadding: showLineButtonPadding(),
                      showTelegramButtonPadding: showTelegramButtonPadding(),
                      onEmailButtonPressed: onEmailButtonPressed,
                      onCallButtonPressed: onCallButtonPressed,
                      onWhatsAppButtonPressed: onWhatsAppButtonPressed,
                      onLineButtonPressed: onLineAppButtonPressed,
                      onTelegramButtonPressed: onTelegramAppButtonPressed)
                  : LargeActionButtons(
                      article: Article(),
                      showMessageButton: false,
                      showMessageButtonPadding: false,
                      onMessageButtonPressed: (){},
                      showEmailButton: showEmailActionButton(),
                      showCallButton: showCallActionButton(),
                      showWhatsAppButton: showWhatsappActionButton(),
                      showLineButton: showLineAppActionButton(),
                      showTelegramButton: showTelegramActionButton(),
                      showCallButtonPadding: showCallButtonPadding(),
                      showWhatsAppButtonPadding: showWhatsAppButtonPadding(),
                      showLineButtonPadding: showLineButtonPadding(),
                      showTelegramButtonPadding: showTelegramButtonPadding(),
                      onEmailButtonPressed: onEmailButtonPressed,
                      onCallButtonPressed: onCallButtonPressed,
                      onWhatsAppButtonPressed: onWhatsAppButtonPressed,
                      onLineButtonPressed: onLineAppButtonPressed,
                      onTelegramButtonPressed: onTelegramAppButtonPressed),
        ),
      ),
    );
  }

  bool showSmallActionButtons() {
    int trueCount = 0;

    if (showEmailActionButton()) trueCount++;
    if (showCallActionButton()) trueCount++;
    if (showWhatsappActionButton()) trueCount++;
    if (showLineAppActionButton()) trueCount++;
    if (showTelegramActionButton()) trueCount++;

    return trueCount >= 4;
  }

  bool showBottomButtonActionBar() {
    if (showEmailActionButton() ||
        showCallActionButton() ||
        showWhatsappActionButton() ||
        showLineAppActionButton() ||
        showTelegramActionButton()) {
      return true;
    }
    return false;
  }

  bool showEmailActionButton() {
    if (SHOW_EMAIL_BUTTON && UtilityMethods.isValidString(email)) {
      return true;
    }

    return false;
  }

  bool showCallActionButton() {
    if (SHOW_CALL_BUTTON && (UtilityMethods.isValidString(phoneOrMobile()))) {
      return true;
    }

    return false;
  }

  bool showWhatsappActionButton() {
    if (SHOW_WHATSAPP_BUTTON && UtilityMethods.isValidString(whatsappNumber)) {
      return true;
    }

    return false;
  }

  bool showLineAppActionButton() {
    if (SHOW_LINE_APP_BUTTON && UtilityMethods.isValidString(lineId)) {
      return true;
    }
    return false;
  }

  bool showTelegramActionButton() {
    if (SHOW_TELEGRAM_BUTTON && UtilityMethods.isValidString(telegramId)) {
      return true;
    }
    return false;
  }

  bool showCallButtonPadding() {
    int trueCount = 0;
    if (showEmailActionButton()) trueCount++;
    if (showCallActionButton()) trueCount++;
    return trueCount == 2;
  }

  bool showWhatsAppButtonPadding() {
    if (showWhatsappActionButton()) {
      int trueCount = 0;
      if (showEmailActionButton()) trueCount++;
      if (showCallActionButton()) trueCount++;
      if (showWhatsappActionButton()) trueCount++;
      return trueCount >= 2;
    }
    return false;
  }

  bool showLineButtonPadding() {
    if (showLineAppActionButton()) {
      int trueCount = 0;
      if (showEmailActionButton()) trueCount++;
      if (showCallActionButton()) trueCount++;
      if (showWhatsappActionButton()) trueCount++;
      if (showLineAppActionButton()) trueCount++;
      return trueCount >= 2;
    }
    return false;
  }

  bool showTelegramButtonPadding() {
    if (showTelegramActionButton()) {
      int trueCount = 0;
      if (showEmailActionButton()) trueCount++;
      if (showCallActionButton()) trueCount++;
      if (showWhatsappActionButton()) trueCount++;
      if (showLineAppActionButton()) trueCount++;
      if (showTelegramActionButton()) trueCount++;
      return trueCount >= 2;
    }
    return false;
  }

  void onEmailButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendEmailToRealtor(
          informationMap: {
            SEND_EMAIL_REALTOR_ID: realtorId,
            SEND_EMAIL_REALTOR_TYPE: widget.agentType,
            SEND_EMAIL_REALTOR_EMAIL: email,
            SEND_EMAIL_MESSAGE: UtilityMethods.getLocalizedString(
                "realtor_message",
                inputWords: [title, appName, link]),
            SEND_EMAIL_REALTOR_NAME: title,
            SEND_EMAIL_THUMBNAIL: image,
            SEND_EMAIL_APP_BAR_TITLE: title,
            SEND_EMAIL_SITE_NAME: APP_NAME,
            SEND_EMAIL_LISTING_LINK: link,
            SEND_EMAIL_SOURCE: isAgent
                ? "agent"
                : isAgency
                    ? "agency"
                    : "author",
            // SEND_EMAIL_SITE_NAME: APP_NAME,
          },
        ),
      ),
    );
  }

  onCallButtonPressed() async {
    await launchUrl(Uri.parse("tel://${phoneOrMobile()}"));
  }

  void onWhatsAppButtonPressed() async {
    String msg = UtilityMethods.getLocalizedString("realtor_message",
        inputWords: [title, appName, link]);
    whatsappNumber = whatsappNumber.replaceAll(RegExp(r'[()\s+-]'), '');
    var whatsappUrl = "whatsapp://send?phone=$whatsappNumber&text=$msg";
    await canLaunchUrl(Uri.parse(whatsappUrl))
        ? launchUrl(Uri.parse(whatsappUrl))
        : launchUrl(Uri.parse("https://wa.me/$whatsappNumber"));
  }

  onLineAppButtonPressed() async {
    await launchUrl(Uri.parse("https://line.me/R/ti/p/%7E$lineId"));
  }

  onTelegramAppButtonPressed() async {
    await launchUrl(Uri.parse("https://t.me/$telegramId"));
  }

  void onMoreButtonTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResult(
          dataInitializationMap:
          isAuthor ? {} : getRealtorDataMap(item),
          searchRelatedData:
          isAuthor ? getRealtorDataMap(item) : {},
          searchPageListener:
              (Map<String, dynamic> map, String closeOption) {
            if (closeOption == CLOSE) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Map<String, dynamic> getRealtorDataMap(dynamic item) {
    Map<String, dynamic> realtorMap = {};
    if (isAgent) {
      realtorMap = {
        REALTOR_SEARCH_TYPE: REALTOR_SEARCH_TYPE_AGENT,
        REALTOR_SEARCH_ID: item.id,
        REALTOR_SEARCH_NAME: item.title,
      };
    } else if (isAgency) {
      realtorMap = {
        REALTOR_SEARCH_TYPE: REALTOR_SEARCH_TYPE_AGENCY,
        REALTOR_SEARCH_ID: item.id,
        REALTOR_SEARCH_NAME: item.title,
      };
    } else {
      realtorMap = {
        REALTOR_SEARCH_TYPE: REALTOR_SEARCH_TYPE_AUTHOR,
        REALTOR_SEARCH_ID: item[tempRealtorIdKey],
        REALTOR_SEARCH_NAME: title,
      };
    }

    return realtorMap;
  }

  Future<List<dynamic>> fetchProperties(int id, int page, int perPage) async {
    List<dynamic> tempList = [];
    Map<String, dynamic> dataMap = {
      REALTOR_SEARCH_PAGE: page,
      REALTOR_SEARCH_PER_PAGE: perPage
    };
    if (isAgent) {
      dataMap[REALTOR_SEARCH_AGENT] = id;
      Map<String, dynamic> tempMap =
          await _propertyBloc.fetchFilteredArticles(dataMap);
      tempList.addAll(tempMap["result"]);
    } else if (isAgency) {
      dataMap[REALTOR_SEARCH_AGENCY] = id;
      Map<String, dynamic> tempMap =
          await _propertyBloc.fetchFilteredArticles(dataMap);
      tempList.addAll(tempMap["result"]);
    } else if (isAuthor) {
      tempList =
          await _propertyBloc.fetchAllProperties('any', page, perPage, id);
    }

    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempList.isNotEmpty) {
        if (mounted) {
          setState(() {
            if (SHOW_REVIEWS) {
              tempIndexListing = tempIndexListing + 1;
            }
            tabList.add(UtilityMethods.getLocalizedString("listings"));
            if (tabList.length == 1) {
              showPropertyListings = true;
            }
            realtorListings = tempList;
          });
        }
      }
    }

    return realtorListings;
  }

  Future<List<dynamic>> fetchAgents(int id) async {
    List<dynamic> tempList = await _propertyBloc.fetchAgencyAgentInfoList(id);
    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempList.isNotEmpty) {
        if (tempList[0].isNotEmpty) {
          if (mounted) {
            setState(() {
              if (tempIndexListing == 1) {
                tempIndexRealtor = tempIndexRealtor + 1;
              }
              tabList.add(UtilityMethods.getLocalizedString("agents"));
              if (tabList.length == 1) {
                showAgentAgency = true;
              }
              showPropertyListings = false;
              agencyOrAgentsList = tempList;
            });
          }
        }
      }
    }

    return agencyOrAgentsList;
  }

  Future<List<dynamic>> fetchAgency(int id) async {
    List<dynamic> tempList = await _propertyBloc.fetchSingleAgencyInfoList(id);
    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempList.isNotEmpty) {
        if (mounted) {
          setState(() {
            if (tempIndexListing == 1) {
              tempIndexRealtor++;
            }
            tabList.add(UtilityMethods.getLocalizedString("agency"));
            if (tabList.length == 1) {
              showAgentAgency = true;
            }
            showPropertyListings = false;
            agencyOrAgentsList = tempList;
          });
        }
      }
    }

    return agencyOrAgentsList;
  }

  String checkType(String agentType) {
    if (agentType == AGENT_INFO) {
      return USER_ROLE_HOUZEZ_AGENT_VALUE;
    } else if (agentType == AGENCY_INFO) {
      return USER_ROLE_HOUZEZ_AGENCY_VALUE;
    } else {
      return USER_ROLE_HOUZEZ_AUTHOR_VALUE;
    }
  }
}

class RealtorInfoWidget extends StatelessWidget {
  final String title;
  final String heroId;
  final String imageUrl;
  final String position;
  final String company;

  const RealtorInfoWidget({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.heroId,
    required this.position,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppThemePreferences().appTheme.containerBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              shape: AppThemePreferences.roundedCorners(
                  AppThemePreferences.realtorPageRoundedCornersRadius),
              child: SizedBox(
                height: 90,
                width: 90,
                child: Hero(
                  tag: heroId,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: !UtilityMethods.validateURL(imageUrl)
                        ? ShimmerEffectErrorWidget(iconSize: 100)
                        : FancyShimmerImage(
                            imageUrl: imageUrl,
                            boxFit: BoxFit.cover,
                            shimmerBaseColor: AppThemePreferences()
                                .appTheme
                                .shimmerEffectBaseColor,
                            shimmerHighlightColor: AppThemePreferences()
                                .appTheme
                                .shimmerEffectHighLightColor,
                            errorWidget: ShimmerEffectErrorWidget(
                                iconSize: 70.0,
                                iconData: AppThemePreferences.personIcon),
                          ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GenericTextWidget(
                    title,
                    strutStyle: StrutStyle(
                        height: AppThemePreferences.genericTextHeight),
                    style: AppThemePreferences().appTheme.heading01TextStyle,
                  ),
                  AgentPositionWidget(
                    company: company,
                    position: position,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AgentPositionWidget extends StatelessWidget {
  final String position;
  final String company;

  const AgentPositionWidget({
    super.key,
    required this.position,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (position.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GenericTextWidget(
              "$position${company.isNotEmpty ? " at " : ""}",
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.bodyTextStyle,
            ),
          ),
        if (company.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GenericTextWidget(
              "$company",
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.heading02TextStyle,
            ),
          ),
      ],
    );
  }
}

class AddressWidget extends StatelessWidget {
  final String address;

  const AddressWidget({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    if (address.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 20, 20),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.location_on,
              ),
            ),
            Expanded(
              flex: 9,
              child: GenericTextWidget(
                address,
                strutStyle:
                    StrutStyle(height: AppThemePreferences.genericTextHeight),
                style: AppThemePreferences().appTheme.bodyTextStyle,
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      );
    }

    return Container(padding: const EdgeInsets.only(bottom: 20));
  }
}

typedef TapListener = void Function(bool tapped);

class AdditionalInfoWidget extends StatelessWidget {
  final bool showMore;
  final String license;
  final String taxNumber;
  final String agentServiceAreas;
  final String agentSpecialties;
  final TapListener listener;

  const AdditionalInfoWidget({
    super.key,
    required this.showMore,
    required this.license,
    required this.taxNumber,
    required this.agentServiceAreas,
    required this.agentSpecialties,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (HooksConfigurations.agentProfileConfigurationsHook(
            "additional_info") ?? true)
        if ((HooksConfigurations.agentProfileConfigurationsHook(
            "license") ?? true) && (license.isNotEmpty)) LicenseNumberWidget(license: license),
        if ((HooksConfigurations.agentProfileConfigurationsHook(
            "tax_number") ?? true) && (taxNumber.isNotEmpty)) TaxNumberWidget(taxNumber: taxNumber),
        if (showServicesAndSpecialities() && showMore &&
            (agentServiceAreas.isNotEmpty || agentSpecialties.isNotEmpty))
          ServiceAreasAndSpecialitiesWidget(
            agentServiceAreas: agentServiceAreas,
            agentSpecialties: agentSpecialties,
          ),
        if (showServicesAndSpecialities() && (agentServiceAreas.isNotEmpty || agentSpecialties.isNotEmpty))
          ShowMoreWidget(
            showMore: showMore,
            agentSpecialties: agentSpecialties,
            agentServiceAreas: agentServiceAreas,
            listener: listener,
          ),
      ],
    );
  }

  bool showServicesAndSpecialities() {
    return ((HooksConfigurations.agentProfileConfigurationsHook(
        "service_areas") ?? true) || (HooksConfigurations.agentProfileConfigurationsHook(
        "specialities") ?? true));
  }
}

class LicenseNumberWidget extends StatelessWidget {
  final String license;

  const LicenseNumberWidget({
    super.key,
    required this.license,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("license"),
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.label01TextStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: GenericTextWidget(
              license,
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.subBody01TextStyle,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(
                color: AppThemePreferences().appTheme.dividerColor!)),
      ),
    );
  }
}

class TaxNumberWidget extends StatelessWidget {
  final String taxNumber;

  const TaxNumberWidget({
    super.key,
    required this.taxNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("tax_number"),
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.label01TextStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: GenericTextWidget(
              taxNumber,
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.subBody01TextStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceAreasAndSpecialitiesWidget extends StatelessWidget {
  final String agentServiceAreas;
  final String agentSpecialties;

  const ServiceAreasAndSpecialitiesWidget({
    super.key,
    required this.agentServiceAreas,
    required this.agentSpecialties,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Column(
        children: [
          if ((HooksConfigurations.agentProfileConfigurationsHook(
              "service_areas") ?? true) && (agentServiceAreas.isNotEmpty))
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: GenericTextWidget(
                      UtilityMethods.getLocalizedString("service_areas"),
                      strutStyle: StrutStyle(
                          height: AppThemePreferences.genericTextHeight),
                      style: AppThemePreferences().appTheme.label01TextStyle,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GenericTextWidget(
                      agentServiceAreas,
                      strutStyle: StrutStyle(
                          height: AppThemePreferences.genericTextHeight),
                      style: AppThemePreferences().appTheme.subBody01TextStyle,
                    ),
                  ),
                ],
              ),
            ),
          if ((HooksConfigurations.agentProfileConfigurationsHook(
              "specialities") ?? true) && (agentSpecialties.isNotEmpty))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: GenericTextWidget(
                    UtilityMethods.getLocalizedString("specialties"),
                    strutStyle: StrutStyle(
                        height: AppThemePreferences.genericTextHeight),
                    style: AppThemePreferences().appTheme.label01TextStyle,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: GenericTextWidget(
                    agentSpecialties,
                    strutStyle: StrutStyle(
                        height: AppThemePreferences.genericTextHeight),
                    style: AppThemePreferences().appTheme.subBody01TextStyle,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class ShowMoreWidget extends StatelessWidget {
  final bool showMore;
  final String agentServiceAreas;
  final String agentSpecialties;
  final TapListener listener;

  const ShowMoreWidget({
    super.key,
    required this.showMore,
    required this.agentServiceAreas,
    required this.agentSpecialties,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: InkWell(
            onTap: () => listener(true),
            child: GenericTextWidget(
              showMore
                  ? UtilityMethods.getLocalizedString("show_less")
                  : UtilityMethods.getLocalizedString("show_more"),
              strutStyle:
                  StrutStyle(height: AppThemePreferences.genericTextHeight),
              style: AppThemePreferences().appTheme.readMoreTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class HeadingWidget extends StatelessWidget {
  final String text;

  const HeadingWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString(text),
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final bool readMore;
  final String content;
  final TapListener listener;

  const DescriptionWidget({
    super.key,
    required this.readMore,
    required this.content,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              HeadingWidget(text: UtilityMethods.getLocalizedString("about")),
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: AppThemePreferences().appTheme.dividerColor!)),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: GenericTextWidget(
            content.replaceAll("\n", ""),
            strutStyle: StrutStyle(height: AppThemePreferences.bodyTextHeight),
            maxLines: readMore ? null : 3,
            overflow: readMore ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppThemePreferences().appTheme.bodyTextStyle,
            textAlign: TextAlign.justify,
          ),
        ),
        if (content.length > 300)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: InkWell(
                  onTap: () {
                    listener(true);
                  },
                  child: GenericTextWidget(
                    readMore
                        ? UtilityMethods.getLocalizedString("read_less")
                        : UtilityMethods.getLocalizedString("read_more"),
                    strutStyle: StrutStyle(
                        height: AppThemePreferences.genericTextHeight),
                    style: AppThemePreferences().appTheme.readMoreTextStyle,
                  ),
                ),
              ),
            ],
          ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          decoration: AppThemePreferences.dividerDecoration(),
        ),
      ],
    );
  }
}

class TabBarViewWidget extends StatelessWidget {
  final List<dynamic> tabsList;
  final int currentSelection;
  final dynamic Function(int) onSegmentChosen;

  const TabBarViewWidget({
    super.key,
    required this.tabsList,
    required this.currentSelection,
    required this.onSegmentChosen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
        child: SegmentedControlWidget(
          itemList: tabsList,
          selectionIndex: currentSelection,
          onSegmentChosen: onSegmentChosen,
          padding: EdgeInsets.only(left: 20, right: 20),
          fontSize: AppThemePreferences.realtorPageTabBarTitleFontSize,
        )

        //   MaterialSegmentedControl(
        //   // horizontalPadding: EdgeInsets.only(left: 5,right: 5),
        //   children: tabList.map((item) {
        //     var index = tabList.indexOf(item);
        //     return Container(
        //       padding:  const EdgeInsets.only(left: 20 ,right: 20),
        //       child: genericTextWidget(
        //         UtilityMethods.getLocalizedString(item),
        //         style: TextStyle(
        //           fontSize: AppThemePreferences.realtorPageTabBarTitleFontSize,
        //           fontWeight: AppThemePreferences.tabBarTitleFontWeight,
        //           color: _currentSelection == index ? AppThemePreferences().appTheme.selectedItemTextColor :
        //           AppThemePreferences.unSelectedItemTextColorLight,
        //         ),),
        //     );
        //   },).toList().asMap(),
        //
        //   selectionIndex: _currentSelection,
        //   unselectedColor: AppThemePreferences().appTheme.unSelectedItemBackgroundColor,
        //   selectedColor: AppThemePreferences().appTheme.selectedItemBackgroundColor!,
        //   borderRadius: 5.0,
        //   verticalOffset: 8.0,
        //   onSegmentChosen: onSegmentChosen,
        // ),
        );
  }
}

typedef ListingsWidgetListener = void Function(bool error);

class ListingsWidget extends StatelessWidget {
  final int currentSelection;
  final bool isUserLoggedIn;
  final Future<List<dynamic>> articlesList;
  final int tempIndexListing;
  final ListingsWidgetListener listener;

  const ListingsWidget({
    super.key,
    required this.currentSelection,
    required this.isUserLoggedIn,
    required this.articlesList,
    required this.tempIndexListing,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemDesignNotifier>(
      builder: (context, itemDesignNotifier, child) {
        return currentSelection == tempIndexListing
            ? FutureBuilder<List<dynamic>>(
                future: articlesList,
                builder: (context, articleSnapshot) {
                  if (articleSnapshot.hasData) {
                    if (articleSnapshot.data!.isEmpty) return Container();
                    return Column(
                      children: articleSnapshot.data!.map((item) {
                        var heroId =
                            "${item.id}-${UtilityMethods.getRandomNumber()}-REALTOR_PROPS";
                        ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();
                        // articleBoxDesign = itemDesignNotifier.homeScreenItemDesign;
                        return SizedBox(
                          height: _articleBoxDesign.getArticleBoxDesignHeight(
                              design: itemDesignNotifier.homeScreenItemDesign),
                          child: _articleBoxDesign.getArticleBoxDesign(
                            article: item,
                            heroId: heroId,
                            buildContext: context,
                            design: itemDesignNotifier.homeScreenItemDesign,
                            onTap: () {
                              if (item.propertyInfo!.requiredLogin) {
                                isUserLoggedIn
                                    ? UtilityMethods
                                        .navigateToPropertyDetailPage(
                                        context: context,
                                        article: item,
                                        propertyID: item.id,
                                        heroId: heroId,
                                      )
                                    : UtilityMethods.navigateToLoginPage(
                                        context, false);
                              } else {
                                UtilityMethods.navigateToPropertyDetailPage(
                                  context: context,
                                  article: item,
                                  propertyID: item.id,
                                  heroId: heroId,
                                );
                              }
                            },
                          ),
                        );
                      }).toList(),
                    );
                  } else if (articleSnapshot.hasError) {
                    listener(true);
                    return Container();
                  }
                  return Container();
                },
              )
            : Container();
      },
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 80,
        height: 20,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          colors: [AppThemePreferences().appTheme.primaryColor!],
        ),
      ),
    );
  }
}

class RealtorInformationDisplayWidget extends StatelessWidget {
  final Future<List<dynamic>>? realtorsList;
  final int currentSelection;
  final int tempIndexRealtor;
  final bool showAgentAgency;
  final bool isAgency;
  final bool isAgent;

  const RealtorInformationDisplayWidget({
    super.key,
    required this.realtorsList,
    required this.currentSelection,
    required this.tempIndexRealtor,
    required this.showAgentAgency,
    required this.isAgency,
    required this.isAgent,
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> dataList = [];
    return ((currentSelection == tempIndexRealtor) || showAgentAgency)
        ? FutureBuilder<List<dynamic>>(
      future: realtorsList,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return Container();
          } else if (articleSnapshot.data![0] is Agency ||
              articleSnapshot.data![0] is Agent ||
              (articleSnapshot.data![0] is List<dynamic> &&
                  articleSnapshot.data![0].length > 0)) {
            if (articleSnapshot.data![0] is List<dynamic>) {
              dataList = articleSnapshot.data![0];
            } else {
              dataList = articleSnapshot.data!;
            }
            return Container(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Column(
                children: <Widget>[
                  Column(
                    children: dataList.map((item) {
                      bool _validURL =
                      UtilityMethods.validateURL(item.thumbnail);
                      var heroId =
                          "${item.id}-${UtilityMethods.getRandomNumber()}-REALTOR-INFO";
                      String realtorPhone = isAgency
                          ? item.agentOfficeNumber ?? ""
                          : item.agencyPhoneNumber ?? "";
                      String realtorMobile = isAgency
                          ? item.agentMobileNumber ?? ""
                          : item.agencyMobileNumber ?? "";
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1, horizontal: 1),
                        color: AppThemePreferences()
                            .appTheme
                            .containerBackgroundColor,
                        height: 150,
                        child: CardWidget(
                          shape: AppThemePreferences.roundedCorners(
                              AppThemePreferences
                                  .globalRoundedCornersRadius),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10),
                                child: SizedBox(
                                  height: 120, //150
                                  width: 110, //120
                                  child: Hero(
                                    tag: heroId,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(
                                              Radius.circular(10)),
                                          child: !_validURL
                                              ? ShimmerEffectErrorWidget(
                                              iconSize: 100)
                                              : FancyShimmerImage(
                                            imageUrl: UtilityMethods
                                                .validateURL(item
                                                .thumbnail)
                                                ? item.thumbnail
                                                : ShimmerEffectErrorWidget(
                                                iconSize: 100),
                                            boxFit: BoxFit.cover,
                                            shimmerBaseColor:
                                            AppThemePreferences()
                                                .appTheme
                                                .shimmerEffectBaseColor,
                                            shimmerHighlightColor:
                                            AppThemePreferences()
                                                .appTheme
                                                .shimmerEffectHighLightColor,
                                            errorWidget:
                                            ShimmerEffectErrorWidget(
                                              iconSize: 60,
                                              iconData: Icons
                                                  .person_outlined,
                                            ),
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                              const BorderRadius.all(
                                                  Radius.circular(
                                                      10)),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RealtorInformationDisplayPage(
                                                          heroId: heroId,
                                                          agentType: isAgent
                                                              ? AGENT_INFO
                                                              : AGENCY_INFO,
                                                          realtorInformation:
                                                          isAgent
                                                              ? {
                                                            AGENCY_DATA:
                                                            item,
                                                          }
                                                              : {
                                                            AGENT_DATA:
                                                            item,
                                                          },
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      10, 10, 0, 5),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        borderRadius:
                                        BorderRadius.circular(5.0),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RealtorInformationDisplayPage(
                                                    heroId: heroId,
                                                    agentType: isAgent
                                                        ? AGENT_INFO
                                                        : AGENCY_INFO,
                                                    realtorInformation:
                                                    isAgent
                                                        ? {
                                                      AGENCY_DATA:
                                                      item,
                                                    }
                                                        : {
                                                      AGENT_DATA:
                                                      item,
                                                    },
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 10),
                                                child: GenericTextWidget(
                                                  item.title,
                                                  strutStyle: StrutStyle(
                                                      height: AppThemePreferences
                                                          .genericTextHeight),
                                                  style: AppThemePreferences()
                                                      .appTheme
                                                      .subBody01TextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      realtorPhone.isEmpty
                                          ? Container()
                                          : InkWell(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5.0),
                                        onTap: () {
                                          launchUrl(Uri.parse(
                                              "tel://$realtorPhone"));
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.call),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 10),
                                                child:
                                                GenericTextWidget(
                                                  realtorPhone,
                                                  strutStyle: StrutStyle(
                                                      height: AppThemePreferences
                                                          .genericTextHeight),
                                                  style: AppThemePreferences()
                                                      .appTheme
                                                      .subBody01TextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      realtorMobile.isEmpty
                                          ? Container()
                                          : InkWell(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5.0),
                                        onTap: () {
                                          launchUrl(Uri.parse(
                                              "tel://$realtorMobile"));
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons
                                                .phone_android),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets
                                                    .only(
                                                    left: 10),
                                                child:
                                                GenericTextWidget(
                                                  realtorMobile,
                                                  strutStyle: StrutStyle(
                                                      height: AppThemePreferences
                                                          .genericTextHeight),
                                                  style: AppThemePreferences()
                                                      .appTheme
                                                      .subBody01TextStyle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container();
      },
    )
        : Container();
  }
}

class MoreElevatedButtonWidget extends StatelessWidget {
  final List<dynamic> realtorListings;
  final int currentSelection;
  final int tempIndexListing;
  final void Function()? onTap;
  
  const MoreElevatedButtonWidget({
    super.key,
    required this.realtorListings,
    required this.currentSelection,
    required this.tempIndexListing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ((realtorListings.length > 2) && (currentSelection == tempIndexListing))
        ? SizedBox(
      // width: 140, //160
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: onTap,
              child: GenericTextWidget(
                UtilityMethods.getLocalizedString("see_more"),
                style: AppThemePreferences().appTheme.readMoreTextStyle,
              ),
            ),
          ],
        ),
      ),
    )
        : Container();
  }
}

class ContactWidget extends StatelessWidget {
  final String address;
  final String phoneNumber;
  final String mobileNumber;
  final String faxNumber;
  final String email;

  const ContactWidget({
    super.key,
    required this.address,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.faxNumber,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:
              HeadingWidget(text: UtilityMethods.getLocalizedString("contact")),
          decoration: AppThemePreferences.dividerDecoration(top: true),
        ),
        if (address.isNotEmpty)
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.location_on,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: GenericTextWidget(
                    address,
                    strutStyle: StrutStyle(
                        height: AppThemePreferences.genericTextHeight),
                    style: AppThemePreferences().appTheme.bodyTextStyle,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        Container(
          color: AppThemePreferences().appTheme.containerBackgroundColor,
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
            children: [
              if (phoneNumber.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericTextWidget(
                          UtilityMethods.getLocalizedString("office"),
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.label01TextStyle,
                        ),
                        GenericTextWidget(
                          phoneNumber,
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.subBody01TextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              if (mobileNumber.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: Container(
                    // color: AppThemePreferences().current.containerBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericTextWidget(
                          UtilityMethods.getLocalizedString(
                              "mobile_with_colon"),
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.label01TextStyle,
                        ),
                        GenericTextWidget(
                          mobileNumber,
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.subBody01TextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              if (faxNumber.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // color: AppThemePreferences().current.containerBackgroundColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericTextWidget(
                          UtilityMethods.getLocalizedString("fax_with_colon"),
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.label01TextStyle,
                        ),
                        GenericTextWidget(
                          faxNumber,
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.subBody01TextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              if (email.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: Container(
                    // color: AppThemePreferences().current.containerBackgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericTextWidget(
                          UtilityMethods.getLocalizedString("email_with_colon"),
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.label01TextStyle,
                        ),
                        GenericTextWidget(
                          email,
                          strutStyle: StrutStyle(
                              height: AppThemePreferences.genericTextHeight),
                          style:
                              AppThemePreferences().appTheme.subBody01TextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(height: 30),
      ],
    );
  }
}


