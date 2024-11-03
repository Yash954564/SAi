import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_inquiry/inquiry_detail_page.dart';
import 'package:houzi_package/pages/crm_pages/crm_model/crm_models.dart';
import 'package:houzi_package/pages/crm_pages/crm_pages_widgets/board_pages_widgets.dart';
import 'package:houzi_package/pages/crm_pages/crm_webservices_manager/crm_repository.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CRMDetailsListing extends StatefulWidget {
  final String id;
  final String fetch;
  final CRMInquiries? inquiries;

  const CRMDetailsListing({
    required this.id,
    required this.fetch,
    this.inquiries,
    Key? key,
  }) : super(key: key);

  @override
  State<CRMDetailsListing> createState() => _CRMDetailsListingState();
}

class _CRMDetailsListingState extends State<CRMDetailsListing> {

  final CRMRepository _crmRepository = CRMRepository();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<List<dynamic>>? _futureCRMDetails;
  List<dynamic> crmDetailsList = [];
  bool shouldLoadMore = true;

  bool isLoading = false;
  bool showIndicatorWidget = false;
  List<dynamic> matchListingEmailIds = [];
  int page = 1;
  int perPage = 15;

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
    }

    setState(() {
      if (forPullToRefresh) {
        page = 1;
      } else {
        page++;
      }
      isLoading = true;
    });

    _futureCRMDetails = fetchInquiryDetailMatchedFromBoard();
    if (forPullToRefresh) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<List<dynamic>> fetchInquiryDetailMatchedFromBoard() async {
    if (page == 1) {
      setState(() {
        shouldLoadMore = true;
      });
    }
    List<dynamic> tempList = [];
    if (widget.fetch == FETCH_INQUIRY_MATCHING) {
      tempList = await _crmRepository.fetchInquiryDetailMatchedFromBoard(widget.id, page);
    } else if (widget.fetch == FETCH_LEAD_INQUIRY) {
      tempList = await _crmRepository.fetchLeadsInquiriesFromBoard(widget.id, page);
    } else if (widget.fetch == FETCH_LEAD_VIEWED) {
      tempList = await _crmRepository.fetchLeadsViewedFromBoard(widget.id, page);
    } else if (widget.fetch == FETCH_LEAD_DETAIL) {
      tempList = await _crmRepository.fetchLeadsInquiriesFromBoard(widget.id, page, fetchLeadDetail: true);
    }

    if (tempList == null ||
        (tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          // isInternetConnected = false;
        });
      }
      return crmDetailsList;
    } else {
      if (mounted) {
        setState(() {
          // isInternetConnected = true;
        });
      }
      if (tempList.isEmpty || tempList.length < perPage) {
        if (mounted) {
          setState(() {
            shouldLoadMore = false;
          });
        }
      }

      if (page == 1) {
        crmDetailsList.clear();
      }
      if (tempList.isNotEmpty) {
        crmDetailsList.addAll(tempList);
      }
    }
    return crmDetailsList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: widget.fetch == FETCH_INQUIRY_MATCHING ? Stack(
            children: [
              showListing(context, _futureCRMDetails),
              if (_refreshController.isLoading)
                const CRMPaginationLoadingWidget(),
              if (showIndicatorWidget)
                loadingIndicatorWidget(),
              bottomSendEmailWidget()
            ],
          ) : showListing(context, _futureCRMDetails),

        ),
      ),
    );
  }

  Widget bottomSendEmailWidget() {
    return Positioned(
      bottom: 10.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: matchListingEmailIds.isNotEmpty
            ? Container(
                height: 55.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey
                  ),
                  color:  AppThemePreferences().appTheme.backgroundColor!,
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: GenericTextWidget(
                          UtilityMethods.getLocalizedString("send_email"),
                          style: AppThemePreferences().appTheme.crmHeadingTextStyle,
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40,
                          child: ButtonWidget(
                            text: UtilityMethods.getLocalizedString("email"),
                            onPressed: onTapEmail,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  onTapEmail() async {
    setState(() {
      showIndicatorWidget = true;
    });

    Map<String, dynamic> dataMap = {
      IDS: matchListingEmailIds,
      EMAIL_TO: widget.inquiries!.leads!.email!,
    };

    final response = await _crmRepository.fetchSendCRMEmailResponse(dataMap);
    String tempResponseString = response.toString().split("{")[1];
    Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");

    if (map["success"] == true) {
      _showToast(context, map["msg"]);
      matchListingEmailIds.clear();
    } else {
      _showToast(context, map["reason"]);
    }

    setState(() {
      showIndicatorWidget = false;
    });
  }

  Widget showListing(
      BuildContext context, Future<List<dynamic>>? futureCRMDetails) {
    return FutureBuilder<List<dynamic>>(
      future: futureCRMDetails,
      builder: (context, articleSnapshot) {
        isLoading = false;

        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) {
            return noResultFoundPage();
          }

          List<dynamic> list = articleSnapshot.data!;


          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body = Container();
                if (mode == LoadStatus.loading) {
                  if (shouldLoadMore) {
                    body = const CRMPaginationLoadingWidget();
                  } else {
                    body = Container();
                  }
                }
                return SizedBox(
                  height: 50.0,
                  child: Center(child: body),
                );
              },
            ),
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: loadDataFromApi,
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                dynamic item;
                if (widget.fetch == FETCH_INQUIRY_MATCHING) {
                  item = list[index] as Article;
                } else if (widget.fetch == FETCH_LEAD_INQUIRY) {
                  item = list[index] as CRMInquiries;
                } else {
                  item = list[index];
                }

                // Article matchedItem = list[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    elevation: AppThemePreferences.boardPagesElevation,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          if (widget.fetch == FETCH_INQUIRY_MATCHING)
                            showInquiryMatchWidget(item),
                          if (widget.fetch == FETCH_LEAD_INQUIRY)
                            showLeadInquiryWidget(item),
                          if (widget.fetch == FETCH_LEAD_VIEWED)
                            showViewedWidget(item),
                          if (widget.fetch == FETCH_LEAD_DETAIL)
                            showLeadDetailWidget(item),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return loadingIndicatorWidget();
      },
    );
  }

  Widget showInquiryMatchWidget(Article item) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: InkWell(
            onTap: () {
              if (item.id != null && item.id is int) {
                UtilityMethods.navigateToPropertyDetailPage(
                  context: context,
                  propertyID: item.id,
                  heroId: item.id.toString(),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CRMTypeHeadingWidget("matching_listing", ""),
                CRMHeadingWidget(item.title!),
                _inquiryDetailWidget(item),
              ],
            ),
          ),
        ),
        Expanded(
          child: Checkbox(
            activeColor: AppThemePreferences().appTheme.primaryColor,
            value: matchListingEmailIds.contains(item.id.toString()), onChanged: (bool? value) {
            _onSelected(value!, item.id.toString());
          },),
        ),
      ],
    );
  }

  Widget _inquiryDetailWidget(Article object) {
    String? bed;
    String? bath;
    String? area;
    String? price;

    Article obj = object;
    String _propertyPrice = "";
    String _firstPrice = "";
    bed = obj.features?.bedrooms ?? "";
    bath = obj.features?.bathrooms ?? "";
    area = obj.features?.propertyArea ?? "";
    price = "";
    if (obj.propertyDetailsMap!.containsKey(PRICE)) {
      String? tempPrice = obj.propertyDetailsMap![PRICE];
      if (tempPrice != null && tempPrice.isNotEmpty) {
        _propertyPrice = tempPrice;
      }
    }
    if (obj.propertyDetailsMap!.containsKey(FIRST_PRICE)) {
      String? tempPrice = obj.propertyDetailsMap![FIRST_PRICE];
      if (tempPrice != null && tempPrice.isNotEmpty) {
        _firstPrice = tempPrice;
      }
    }

    if (_propertyPrice.isNotEmpty) {
      price = _propertyPrice;
    } else if (_firstPrice.isNotEmpty) {
      price = _firstPrice;
    }

    return CRMFeatures(bed, bath, area, price);
  }

  void _onSelected(bool selected, String dataId) {
    if (selected) {
      setState(() {
        matchListingEmailIds.add(dataId);
      });
    } else {
      setState(() {
        matchListingEmailIds.remove(dataId);
      });
    }
  }

  Widget showLeadInquiryWidget(CRMInquiries inquiry) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InquiryDetailPage(
              inquiryDetail: inquiry,
              index: 0,
              inquiryDetailPageListener: ({int? index, bool refresh = false}) {
                if (refresh) {
                  loadDataFromApi();
                }
              },
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CRMTypeHeadingWidget("inquiry", inquiry.time),
          CRMHeadingWidget(inquiry.propertyTypeName, secondHeading: inquiry.enquiryType),
          CRMContactDetail(
            inquiry.leads!.displayName,
            inquiry.leads!.email!,
            inquiry.leads!.mobile,
                () {
              takeActionBottomSheet(context, false, inquiry.leads!.email!);
            },
                () {
              takeActionBottomSheet(context, true, inquiry.leads!.mobile!);
            },
          ),
          CRMFeatures(inquiry.minBeds, inquiry.minBaths, inquiry.minArea, inquiry.minPrice),
          // inquiryDetailWidget(inquiry),
        ],
      ),
    );
  }

  Widget showViewedWidget(Map<String, dynamic> infoDataMap) {
    // Random random = Random();
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () {
        int? id = int.tryParse(infoDataMap["listing_id"]);
        if (id != null) {
          UtilityMethods.navigateToPropertyDetailPage(
            context: context,
            propertyID: id,
            heroId: id.toString(),
          );
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: imageWidget(infoDataMap)),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _propertyTitleWidget(infoDataMap: infoDataMap, padding: const EdgeInsets.fromLTRB(10,0,10,0)),
                _propertyAddressWidget(infoDataMap: infoDataMap),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imageWidget(
      Map<String, dynamic> infoDataMap,
  ){
    Random random = Random();
    String _heroId = random.nextInt(100).toString();
    String _imageUrl = "";
    if (infoDataMap["thumbnail"] != null && infoDataMap["thumbnail"] is String) {
      _imageUrl = infoDataMap["thumbnail"];
    }
    return SizedBox(
      height: 100,
      width: 80,
      child: Hero(
        tag: _heroId,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: FancyShimmerImage(
            imageUrl: _imageUrl,
            boxFit: BoxFit.cover,
            shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
            shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
            errorWidget: errorWidget(),
          ),
        ),
      ),
    );
  }

  Widget _propertyTitleWidget({
    required Map<String, dynamic> infoDataMap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10.0),
  }){
    String _title = infoDataMap["title"];
    return Padding(
      padding: padding,
      child: GenericTextWidget(
        _title,
        overflow: TextOverflow.clip,
        strutStyle: const StrutStyle(
            forceStrutHeight: true,
            height: 1.7
        ),
        style: AppThemePreferences().appTheme.crmHeadingTextStyle,
      ),
    );
  }

  Widget _propertyAddressWidget({
    required Map<String, dynamic> infoDataMap,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10.0),
    // EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(10, 0, 10, 0),
  }){
    String _address = infoDataMap["address"];
    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(child: Icon(AppThemePreferences.locationIcon,color: AppThemePreferences().appTheme.crmIconColor,)),
          Flexible(
            flex: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: GenericTextWidget(
                _address,
                strutStyle: const StrutStyle(forceStrutHeight: true),
                overflow: TextOverflow.clip,
                style: AppThemePreferences().appTheme.subBodyTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showLeadDetailWidget(CRMDealsAndLeads lead) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CRMTypeHeadingWidget("lead_detail", lead.leadTime),
        const CRMDetailGap(),
        CRMContactDetail(lead.displayName, lead.email, lead.mobile, () {
          takeActionBottomSheet(context, false, lead.email);
        }, () {
          takeActionBottomSheet(context, true, lead.mobile);
        }),
        const CRMDetailGap(),
        CRMIconBottomText(AppThemePreferences.verifiedIcon, "type", lead.type),
        const CRMDetailGap(),
        CRMIconBottomText(AppThemePreferences.messageIcon, "message", lead.message),
        const CRMDetailGap(),
        InkWell(
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if(UtilityMethods.validateURL(lead.sourceLink!)) {
                if (lead.source! == PROPERTY) {
                  navigateToPropertyDetailPage(lead.sourceLink!);
                } else if(lead.source! == "agent" || lead.source! == "agency") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RealtorInformationDisplayPage(
                        heroId: "1",
                        realtorId: lead.enquiryTo,
                        agentType: lead.enquiryUserType!,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebPage(
                        lead.sourceLink!,
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
              lead.sourceLink!.isEmpty ? lead.source! : lead.sourceLink!
          ),
        ),
        const CRMDetailGap(),
        CRMIconBottomText(AppThemePreferences.agentsIcon, "agent", lead.leadAgentName),
        const CRMDetailGap(),

      ],
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

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      hideGoBackButton: true,
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("oops_list_not_exist"),
    );
  }

  Widget errorWidget(){
    return Container(
      color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(buildContext: context, text: msg,toastGravity: ToastGravity.CENTER);
  }


}
