import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/models/api/data_models.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/add_agent.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/refresh_indicator_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/showModelBottomSheetWidget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';

class MyAgencyAgents extends StatefulWidget {
  final bool fromBottomNavigator;
  const MyAgencyAgents({Key? key, this.fromBottomNavigator = false}) : super(key: key);

  @override
  _MyAgencyAgentsState createState() => _MyAgencyAgentsState();
}

class _MyAgencyAgentsState extends State<MyAgencyAgents> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<List<dynamic>>? _futureAgentsList;
  List<dynamic> agentsList = [];

  bool isInternetConnected = true;
  bool isAgentsListEmpty = false;
  bool isRefreshing = false;

  int? userId;
  String nonce = "";

  @override
  void initState() {
    super.initState();
    userId = HiveStorageManager.getUserId();
    loadData();
    fetchNonce();
  }

  loadData() {
    _futureAgentsList = fetchAgentsInfo(false);
    _futureAgentsList!.then((value) {
      if(value !=null && value.isNotEmpty) {
        agentsList = value;
      }
      return null;
    });
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchDeleteAgentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  checkInternetAndLoadData() {
    _onRefresh();
  }

  Future<List<dynamic>> fetchAgentsInfo(bool refreshing) async {
    if (refreshing) {
      if(mounted){
        setState(() {
          agentsList.clear();
        });
      }
    }

    List<dynamic> tempList = await _propertyBloc.fetchAgencyAllAgentList(userId!);


    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
        });
      }
      return agentsList;
    }else{
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      agentsList.addAll(tempList);
    }

    return agentsList;
  }

  Future<void> _onRefresh() async {
    setState(() {
      isRefreshing = true;
    });
    _futureAgentsList = fetchAgentsInfo(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        automaticallyImplyLeading: widget.fromBottomNavigator ? false : true,
        appBarTitle: UtilityMethods.getLocalizedString("My Agents"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: Icon(
                  AppThemePreferences.addNewAgentIcon,
                  color: AppThemePreferences().appTheme.genericAppBarIconsColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddNewAgentPage(
                          agentDataForEdit: null,
                          addNewAgentPageListener: (bool refresh) {
                            if (refresh) {
                              _onRefresh();
                            }
                          }),
                    ),
                  );
                }),
          )
        ],
      ),
      body: isInternetConnected == false
          ? Align(
        alignment: Alignment.topCenter,
        child: NoInternetConnectionErrorWidget(onPressed: () {
          checkInternetAndLoadData();
        }),
      )
          : RefreshIndicatorWidget(
        child: SingleChildScrollView(
          child: _horizontalListForAgents(context, _futureAgentsList!),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');
  }

  Widget _horizontalListForAgents(BuildContext context, Future<List<dynamic>> agentsAndAgenciesInfoList) {
    return FutureBuilder<List<dynamic>>(
        future: agentsAndAgenciesInfoList,
        builder: (context, articleSnapshot) {
          if (articleSnapshot.hasData) {
            List tempList = articleSnapshot.data!;
            if (tempList.isEmpty && isRefreshing != true) {
              return Padding(padding: const EdgeInsets.only(top: 150),child: noResultFoundPage());
            } else if (tempList.isNotEmpty) {
              if (tempList == null || tempList.isEmpty) {
                return Padding(padding: const EdgeInsets.only(top: 150),child: noResultFoundPage());
              }
            }
            if (tempList.isNotEmpty && tempList != null && tempList.isNotEmpty) {
              List<dynamic> _agentOrAgencyInfoList = tempList;//[0].map((e) => e).toList();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: _agentOrAgencyInfoList.length,
                itemBuilder: (context, index) {
                  var item = _agentOrAgencyInfoList[index];
                  String heroId = HERO + item.id.toString();
                  return Container(
                    padding: const EdgeInsets.only(left: 5, right: 5,top: 10),
                    child: CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.realtorPageRoundedCornersRadius),
                      elevation: AppThemePreferences.agentAgencyPageElevation,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        onTap: () {
                          navigateToRealtorInformationDisplayPage(
                            heroId: heroId,
                            realtorType: AGENT_INFO,
                            realtorInfo: {
                              AGENT_DATA: item,
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: heroId,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FancyShimmerImage(
                                      imageUrl: item.thumbnail,
                                      boxFit: BoxFit.cover,
                                      shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                                      shimmerHighlightColor:
                                      AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                                      width: 110,
                                      //180,
                                      height: 140,
                                      //180,
                                      errorWidget: const ShimmerEffectErrorWidget(iconSize: 50),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                                        child: GenericTextWidget(
                                          item.title,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemePreferences().appTheme.homeScreenRealtorTitleTextStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                                        child: GenericTextWidget(
                                          item.email,
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemePreferences().appTheme.homeScreenRealtorInfoTextStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                                        child: GenericTextWidget(
                                          item.agentMobileNumber ?? item.agentPhoneNumber ?? "",
                                          textAlign: TextAlign.left,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemePreferences().appTheme.homeScreenRealtorInfoTextStyle,
                                        ),
                                      ),
                                      actionButtonWidget(item,index)

                                      // Container(
                                      //   padding: const EdgeInsets.only(left: 10, top: 10),
                                      //   child: Column(
                                      //     crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      //     children: [
                                      //       genericTextWidget(
                                      //         "${item.agentPosition}",
                                      //         textAlign: TextAlign.left,
                                      //         style: AppThemePreferences().appTheme.homeScreenRealtorInfoTextStyle,
                                      //       ),
                                      //       Container(
                                      //         padding: const EdgeInsets.only(top: 10),
                                      //         child: genericTextWidget("${item.agentCompany}",
                                      //           maxLines: 1,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           textAlign: TextAlign.left,
                                      //           style: AppThemePreferences().appTheme.homeScreenRealtorTitleTextStyle,
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         padding: const EdgeInsets.only(top: 5, bottom: 10, right: 10),
                                      //         child: genericTextWidget(
                                      //           stringContent.replaceFirst("\n", ""),
                                      //           maxLines: 2,
                                      //           overflow: TextOverflow.ellipsis,
                                      //           style: AppThemePreferences().appTheme.subBodyTextStyle,
                                      //           textAlign: TextAlign.justify,
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (articleSnapshot.hasError) {
            return noResultFoundPage();
          }
          return loadingIndicatorWidget();
        });
  }

  actionButtonWidget(agentData, int index){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ButtonWidget(
              buttonHeight: 40,
              centeredContent: true,
              iconOnRightSide: true,
              icon: Icon(
                AppThemePreferences.dropDownArrowIcon,
                color: AppThemePreferences.filledButtonIconColor,
              ),
              text: UtilityMethods.getLocalizedString("action"),
              onPressed: () {
                return _actionBottomSheet(agentData,index);
              },
            ),)
        ],
      ),
    );
  }

  void _actionBottomSheet(agentData, int index) {
    showModelBottomSheetWidget(
      useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                genericOptionsOfBottomSheet(
                    UtilityMethods.getLocalizedString("edit"),
                    isEdit: true,
                    data: agentData
                ),
                genericOptionsOfBottomSheet(
                    UtilityMethods.getLocalizedString("delete"),
                    style: AppThemePreferences().appTheme.bottomSheetNegativeOptionsTextStyle!,
                    data: agentData,
                    index: index
                ),

              ],
            ),
          );
        }
    );
  }

  void navigateToAddAgentForEdit(agentData) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewAgentPage(
            agentDataForEdit: agentData,
            addNewAgentPageListener: (bool refresh) {
              if (refresh) {
                _onRefresh();
              }
            },
        ),
      ),
    );
  }

  Widget genericOptionsOfBottomSheet(
      String label,
      {
        bool isEdit = false,
        data,
        TextStyle? style, int? index,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: AppThemePreferences.dividerDecoration(),
        child: TextButtonWidget(
          child: GenericTextWidget(label, style: style ?? AppThemePreferences().appTheme.bottomSheetOptionsTextStyle),
          onPressed: () {
            if(isEdit) {
              return navigateToAddAgentForEdit(data);
            } else {
              showDialog<String>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialogWidget(
                  title: GenericTextWidget(UtilityMethods.getLocalizedString("delete")),
                  content: GenericTextWidget(UtilityMethods.getLocalizedString("delete_confirmation")),
                  actions: <Widget>[
                    TextButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
                    ),
                    TextButtonWidget(
                      onPressed: () async {
                        final response = await _propertyBloc.fetchDeleteAgentResponse(
                          AgencyAgentsModel(agentId: data.userAgentId),
                          nonce,
                        );

                        if (response.success) {
                            agentsList.removeAt(index!);
                          _showToast(context, response.message);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          if (agentsList.isEmpty) {
                            agentsList.clear();
                          }
                          setState(() {});
                        } else {
                          _showToast(context, response.message);
                          Navigator.pop(context);
                        }
                        // String tempResponseString = response.toString().split("{")[1];
                        // Map map = jsonDecode("{${tempResponseString.split("}")[0]}}");
                        // // _idToDelete = null;
                        // if (map['success'] == true) {
                        //   setState(() {
                        //     agentsList.removeAt(index!);
                        //   });
                        //   _showToast(context, map['msg']);
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        //   if (agentsList.isEmpty) {
                        //     setState(() {
                        //       agentsList.clear();
                        //     });
                        //   }
                        //
                        // } else if(map['success'] == false) {
                        //
                        //
                        // }
                        // else{
                        //   _showToast(context, UtilityMethods.getLocalizedString("error_occurred"));
                        // }
                      },
                      child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
                    ),
                  ],
                ),
              );
            }

          },
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
      hideGoBackButton: widget.fromBottomNavigator ? true : false,
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_agents_found"),
    );
  }

  void navigateToRealtorInformationDisplayPage(
      {required String heroId,
      required Map<String, dynamic> realtorInfo,
      required String realtorType}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RealtorInformationDisplayPage(
          heroId: heroId,
          realtorInformation: realtorInfo,
          agentType: realtorType,
        ),
      ),
    );
  }
}
