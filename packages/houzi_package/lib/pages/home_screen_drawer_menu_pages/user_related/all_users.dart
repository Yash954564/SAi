import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/admin_user_signup.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:houzi_package/widgets/show_dialog_for_search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final PropertyBloc _propertyBloc = PropertyBloc();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  TextEditingController searchNameController = TextEditingController();

  Future<List<dynamic>>? _futureUsers;

  List<dynamic> usersList = [];

  bool shouldLoadMore = true;
  bool isLoading = false;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 50;

  bool showSearchDialog = false;

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  loadDataFromApi({bool forPullToRefresh = true, String search = ""}) {
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

    _futureUsers = fetchUsers(page, search);
    if (forPullToRefresh) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.loadComplete();
    }
  }

  Future<List<dynamic>> fetchUsers(int page, String search) async {
    if (page == 1 || search.isNotEmpty) {
      if (mounted) setState(() {
        shouldLoadMore = true;
      });
    }
    List<dynamic> tempList = await _propertyBloc.fetchUsers(page, perPage, search);
    if ((tempList.isNotEmpty && tempList[0] == null) ||
        (tempList.isNotEmpty && tempList[0].runtimeType == Response)) {
      if (mounted) {
        setState(() {
          isInternetConnected = false;
        });
      }
      return usersList;
    } else {
      if (mounted) {
        setState(() {
          isInternetConnected = true;
        });
      }
      if (tempList.isEmpty || tempList.length < perPage) {
        if (mounted) {
          setState(() {
            shouldLoadMore = false;
          });
        }
      }

      if (page == 1 || search.isNotEmpty) {
        if (mounted) setState(() {
          usersList.clear();
        });
      }
      if (tempList.isNotEmpty) {
        usersList.addAll(tempList);
      }
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("users"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                icon: Icon(
                  AppThemePreferences.addIcon,
                  color: AppThemePreferences().appTheme.genericAppBarIconsColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminUserSignUp(adminUserSignUpPageListener: (bool refresh) {
                        if (refresh) {
                          loadDataFromApi();
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
              child: NoInternetConnectionErrorWidget(onPressed: () => loadDataFromApi()),
            )
          : Stack(
              children: [
                Column(
                  children: [
                    SearchBarWidget(
                      showSearchDialog: showSearchDialog,
                      controller: searchNameController,
                      listener: (showDialog){
                        if(mounted) setState(() {
                          showSearchDialog = showDialog;
                        });
                      },
                    ),
                    showUsersList(context, _futureUsers!),
                  ],
                ),
                !showSearchDialog
                    ? Container()
                    : ShowSearchDialog(
                        fromUsers: true,
                        searchDialogPageListener: (bool showDialog, Map<String, dynamic>? searchMap) {
                          if(mounted) setState(() {
                            showSearchDialog = showDialog;
                            searchNameController.text = searchMap![SEARCH_KEYWORD] ?? "";
                          });

                          loadDataFromApi(search: searchMap![SEARCH_KEYWORD] ?? "");
                        },
                      ),
              ],
            ),
    );
  }

  Widget showUsersList(BuildContext context, Future<List<dynamic>> futureUsers) {
    return Expanded(
      child: FutureBuilder<List<dynamic>>(
        future: futureUsers,
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
                      body = PaginationLoadingWidget();
                    } else {
                      body = Container();
                    }
                  }
                  return SizedBox(
                    height: 55.0,
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
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Article userDetail = list[index];
                  return CardWidget(
                    shape: AppThemePreferences.roundedCorners(
                        AppThemePreferences.globalRoundedCornersRadius),
                    elevation: AppThemePreferences.boardPagesElevation,
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(50)),
                              child: FancyShimmerImage(
                                imageUrl: userDetail.avatarUrls!["96"] ?? "",
                                boxFit: BoxFit.cover,
                                shimmerBaseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor,
                                shimmerHighlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor,
                                errorWidget: ShimmerEffectErrorWidget(iconData: AppThemePreferences.personIcon, iconSize: 20),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    UtilityMethods.isRTL(context) ? 0 : 15,
                                    0,
                                    UtilityMethods.isRTL(context) ? 15 : 0,
                                    0,
                                  ),
                                  child: GenericTextWidget(
                                    userDetail.title!,
                                    style: AppThemePreferences().appTheme.labelTextStyle,
                                  ),
                                ),
                                userDetail.description !=null && userDetail.description!.isNotEmpty ?
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      UtilityMethods.isRTL(context) ? 0 : 15,
                                      0,
                                      UtilityMethods.isRTL(context) ? 15 : 0,
                                      0,
                                  ),
                                  child: GenericTextWidget(
                                    userDetail.description!,
                                    style: AppThemePreferences().appTheme.subTitleTextStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ) : Container(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (articleSnapshot.hasError) {
            return noResultFoundPage();
          }
          return LoadingIndicatorWidget();
        },
      ),
    );
  }

  Widget noResultFoundPage() {
    return NoResultErrorWidget(
      headerErrorText: UtilityMethods.getLocalizedString("no_result_found"),
      bodyErrorText: UtilityMethods.getLocalizedString("no_user_found"),
    );
  }
}

class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }
}


class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      alignment: Alignment.center,
      child: Column(
        children: [
          SizedBox(
            width: 60,
            height: 50,
            child: BallRotatingLoadingWidget(),
          ),
        ],
      ),
    );
  }
}


typedef SearchBarWidgetListener = Function(bool showSearchDialog);
class SearchBarWidget extends StatelessWidget {
  final bool showSearchDialog;
  final TextEditingController controller;
  final SearchBarWidgetListener listener;

  const SearchBarWidget({
    Key? key,
    required this.showSearchDialog,
    required this.controller,
    required this.listener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => listener(true),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          readOnly: true,
          controller: controller,
          decoration: InputDecoration(
            enabled: false,
            contentPadding: const EdgeInsets.only(top: 5, left: 15, right: 15),
            fillColor: AppThemePreferences().appTheme.containerBackgroundColor,
            filled: true,
            hintText: (controller.text.isEmpty)
                ? UtilityMethods.getLocalizedString("search")
                : controller.text,
            hintStyle: AppThemePreferences().appTheme.searchBarTextStyle,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: AppThemePreferences().appTheme.homeScreenSearchBarIcon,
            ),
            border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: AppThemePreferences().appTheme.containerBackgroundColor!,
                // width: 5.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

