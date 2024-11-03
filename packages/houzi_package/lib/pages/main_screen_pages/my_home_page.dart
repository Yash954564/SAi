import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/navbar_item.dart';
import 'package:houzi_package/pages/add_property_v2/add_property_v2.dart';
import 'package:houzi_package/pages/app_settings_pages/about.dart';
import 'package:houzi_package/pages/app_settings_pages/dark_mode_setting.dart';
import 'package:houzi_package/pages/app_settings_pages/language_settings.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/all_blogs.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/favorites.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/saved_searches.dart';
import 'package:houzi_package/pages/main_screen_pages/compact_uploading_widget.dart';
import 'package:houzi_package/pages/messages_pages/all_threads.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/pages/demo_expired.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/home_screen_utilities.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/add_property.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/saved.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_profile.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/pages/main_screen_pages/loading_page.dart';
import 'package:houzi_package/push_notif/notif_router.dart';
import 'package:houzi_package/widgets/bottom_nav_bar_widgets/bottom_navigation_bar.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/pages/filter_page.dart';
import 'package:houzi_package/pages/search_result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int homePageIndex = 0;
  int searchPageIndex = 1;
  int savedOrFavSearchesPageIndex = 2;
  int _selectedIndex = 0;
  int page = 1;
  int perPage = 16;
  int bedrooms = 0;
  int bathrooms = 0;
  int? totalResults;

  DateTime? currentBackPressTime;

  List<dynamic> recentSearchesInfoList = [];
  List<Widget> pageList = <Widget>[];
  List<NavbarItem> navbarItemsList = [];

  bool hasInternet = true;
  bool isUserLoggedIn = false;
  bool filterDataLoaded = false;
  bool recentSearchesDataLoaded = false;

  Map<String, dynamic> currentRecentSearchItem = {};
  Map<String, dynamic> previousRecentSearchItem = {};
  Map<String, dynamic> bottomNavBarItemsMap = {};

  VoidCallback? generalNotifierListener;

  Random random = Random();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AddPlusButtonInBottomBarHook addPlusButtonHook = HooksConfigurations.addPlusButtonInBottomBarHook;
  NavbarWidgetsHook navbarWidgetsHook = HooksConfigurations.navbarWidgetsHook;

  int? uploadingProgress;
  bool foundUploadingProperties = false;
  List<dynamic> uploadingPropertiesList = [];
  VoidCallback? propertyUploadListener;
  Article? uploadingArticle;

  @override
  void initState() {
    super.initState();

    navbarItemsList = UtilityMethods.readBottomNavigationBarConfigFile();

    if (Provider.of<UserLoggedProvider>(context, listen: false).isLoggedIn!) {
      isUserLoggedIn = true;
      // if (TOUCH_BASE_PAYMENT_ENABLED_STATUS != "no") {
      PropertyBloc().fetchUserPaymentStatus().then((value) {
        if (value.isNotEmpty) {
          HiveStorageManager.storeUserPaymentStatus(value);
          GeneralNotifier().publishChange(GeneralNotifier.USER_PAYMENT_STATUS_UPDATED);
        }
        return null;
      });
      // }
    }

    checkDemoAndVerify();

    AppThemePreferences().dark(ThemeNotifier().isDarkMode());
    ThemeNotifier().addListener(
        () => AppThemePreferences().dark(ThemeNotifier().isDarkMode()));

    Map tempFilterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};

    if (tempFilterDataMap.containsKey(SEARCH_COUNT) &&
        tempFilterDataMap[SEARCH_COUNT] is int) {
      totalResults = tempFilterDataMap[SEARCH_COUNT];
    }

    getHomeScreenDesign();

    setUpBottomNavbar();

    /// Property Upload Listener
    propertyUploadListener = () {
      if (mounted) {
        setState(() {
          foundUploadingProperties = !PropertyManager().isPropertyUploaderFree;
          uploadingProgress = PropertyManager().getTotalProgress;

          if (foundUploadingProperties) {
            uploadingPropertiesList = HiveStorageManager.readAddPropertiesDataMaps() ?? [];
            if (uploadingPropertiesList.isNotEmpty) {
              uploadingArticle = UtilityMethods.convertUploadAndDraftMapItemToArticle(uploadingPropertiesList[0]);
            }
          } else {
            uploadingPropertiesList = [];
            uploadingArticle = null;
          }

          if (uploadingProgress == 100) {
            PropertyManager().setTotalProgress = null;
          }
        });
      }
    };
    PropertyManager().addListener(propertyUploadListener!);

    /// General Notifier Listener
    generalNotifierListener = () {
      if (GeneralNotifier().change ==
          GeneralNotifier.FILTER_DATA_LOADING_COMPLETE) {
        debugPrint("Filter Page Data Loaded/Modified...");
        Map tempFilterDataMap = HiveStorageManager.readFilterDataInfo() ?? {};
        if (mounted) {
          setState(() {
            if (tempFilterDataMap.containsKey(SEARCH_COUNT) &&
                tempFilterDataMap[SEARCH_COUNT] is int) {
              totalResults = tempFilterDataMap[SEARCH_COUNT];
            }
            filterDataLoaded = true;
            if (searchPageIndex != -1) {
              setSearchPage();
            }
          });
        }
        tempFilterDataMap.clear();
      }

      if (GeneralNotifier().change == GeneralNotifier.USER_LOGGED_IN) {
        debugPrint("User Logged In...");
        if (mounted) {
          setState(() {
            isUserLoggedIn = true;
            setSavedSearchesOrFavouritesPage();
          });
        }
      }

      if (GeneralNotifier().change == GeneralNotifier.USER_LOGGED_OUT) {
        debugPrint("User Logged Out...");
        if(mounted && savedOrFavSearchesPageIndex != -1){
          setState(() {
            isUserLoggedIn = false;
            setSavedSearchesOrFavouritesPage();
          });
        }
      }

      if (GeneralNotifier().change == GeneralNotifier.DEEP_LINK_RECEIVED) {
        if (mounted) {
          setState(() {
            navigateToPropertyDetailPage(DEEP_LINK);
            DEEP_LINK = "";
          });
        }
      }

      if (GeneralNotifier().change == GeneralNotifier.notificationClicked) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            NotificationRouter.initNotificationRouter(context, setState);
          }
        });
      }

      if (GeneralNotifier().change == GeneralNotifier.CHANGE_LOCALIZATION) {
        if (mounted) {
          setState(() {
            pageList.removeLast();
            pageList.add(UserProfile(fromBottomNavigator: true));
          });
        }
      }

      if (GeneralNotifier().change == GeneralNotifier.HOME_DESIGN_MODIFIED) {
        debugPrint("Home Design Modified...");
        getHomeScreenDesign();
        if (mounted && homePageIndex != -1) {
          setState(() {
            setHomePage();
          });
        }
      }

      if (GeneralNotifier().change == GeneralNotifier.NAVBAR_DESIGN_MODIFIED) {
        debugPrint("Navbar Design Modified...");
        if (mounted) {
          setState(() {
            setUpBottomNavbar();
          });
        }
      }
    };

    GeneralNotifier().addListener(generalNotifierListener!);



    List<dynamic> _draftPropertiesList = [];
    _draftPropertiesList =
        HiveStorageManager.readDraftPropertiesDataMapsList() ?? [];
    // print("_draftPropertiesList: $_draftPropertiesList");
    if (_draftPropertiesList.isNotEmpty) {
      // print("Found Some draft properties...");
      int index = -1;
      Map mapItem = {};
      for (Map item in _draftPropertiesList) {
        if (item.containsKey(ADD_PROPERTY_DRAFT_PROGRESS_KEY)) {
          // print("ItemMap contains Key: $ADD_PROPERTY_DRAFT_PROGRESS_KEY...");
          if (item[ADD_PROPERTY_DRAFT_PROGRESS_KEY] ==
              ADD_PROPERTY_DRAFT_IN_PROGRESS) {
            // print("Key: $ADD_PROPERTY_DRAFT_PROGRESS_KEY Matched...");
            mapItem = item;
            index = _draftPropertiesList.indexOf(item);
            // print("Breaking the loop...................");
            break;
          }
        }
      }
      // print("index: $index");
      // print("mapItem: $mapItem");

      if (mapItem.isNotEmpty) {
        // print("mapItem Not-Null and Not-Empty...................");
        // print("Map Contains key [$ADD_PROPERTY_DRAFT_PROGRESS_KEY]: ${mapItem.containsKey(ADD_PROPERTY_DRAFT_PROGRESS_KEY)}");
        mapItem.remove(ADD_PROPERTY_DRAFT_PROGRESS_KEY);
        // print("Key: $ADD_PROPERTY_DRAFT_PROGRESS_KEY Removed...");
        // print("Map Contains key [$ADD_PROPERTY_DRAFT_PROGRESS_KEY]: ${mapItem.containsKey(ADD_PROPERTY_DRAFT_PROGRESS_KEY)}");
        if (index != -1) {
          // print("Found Some Editable draft properties...");
          // Update Storage
          // print("Updating Storage at index: $index");
          _draftPropertiesList[index] = mapItem;
          HiveStorageManager.storeDraftPropertiesDataMapsList(
              _draftPropertiesList);
          // print("Opening Add Property Page...");
          navigateToAddPropertyPage(
              map: UtilityMethods.convertMap(mapItem), index: index);
        }
      }
    }
  }

  @override
  void dispose() {
    uploadingProgress = null;
    uploadingPropertiesList = [];

    if (propertyUploadListener != null) {
      PropertyManager().removeListener(propertyUploadListener!);
    }

    super.dispose();
  }


  navigateToPropertyDetailPage(deepLink) {
    if (deepLink == null || deepLink.isEmpty) return;
    Future.delayed(Duration.zero, () {
      UtilityMethods.navigateToPropertyDetailPage(
        context: context,
        permaLink: deepLink,
        heroId: "1",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: pageList,
        ),
        floatingActionButton: (uploadingArticle == null
            && defaultAddButton() == null)
            ? null
            : Container(
                padding:
                    EdgeInsets.only(bottom: (kBottomNavigationBarHeight / 2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (uploadingArticle != null) UploadPropertyCompactWidget(
                      uploadProgress: uploadingProgress,
                      article: uploadingArticle!,
                      bottomFAB: defaultAddButton(),
                    ),
                    if (defaultAddButton() != null) defaultAddButton()!,
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
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
    if(_selectedIndex != homePageIndex){
    // if(_selectedIndex != 0){
      setState(() {
        _selectedIndex = homePageIndex;
        // _selectedIndex = 0;
      });
      return Future.value(false);
    }
    if(_selectedIndex == homePageIndex) {
    // if(_selectedIndex == 0) {
      if (_scaffoldKey.currentState!.isDrawerOpen) {
        Navigator.of(context).pop();
        return Future.value(false);
      }

      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        _showToastToExitApp(context);
        return Future.value(false);
      }
    }
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
    return Future.value(true);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // if(_selectedIndex == searchPageIndex && totalResults != null && totalResults == 0){
      //   filterDataLoaded = true;
      //   setSearchPage();
      // }
    });
  }

  _showToastToExitApp(BuildContext context) {
    ShowToastWidget(
      buildContext: context,
      text: UtilityMethods.getLocalizedString("press_again_to_exit"),
    );
  }

  checkDemoAndVerify() async {
    if (!APP_IS_IN_CLIENT_DEMO_MODE) {
      return;
    }
    var dio = Dio();
    Response<String> response = await dio.get(
        'https://raw.githubusercontent.com/AdilSoomro/houzi-app-for-houzez/master/orbit.json');
    Map<String, dynamic>? dataMap = json.decode(response.data!);
    List<dynamic> planets = [];
    if (dataMap != null && dataMap.isNotEmpty) {
      planets = dataMap["planet"] ?? [];
    }

    if (planets.isNotEmpty && planets.contains(APP_DEMO_ID)) {
      //everything is fine
      //navigateToDemoExpired();
    } else {
      navigateToDemoExpired();
    }
  }

  navigateToDemoExpired(){
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DemoExpired()),
        (Route<dynamic> route) => false);
  }

  void getHomeScreenDesign() {
    String tempHomeDesign =
        HiveStorageManager.readSelectedHomeOption() ?? home0SectionType;
    if (mounted)
      setState(() {
        if (tempHomeDesign == homeSectionType ||
            tempHomeDesign == home0SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_01;
        } else if (tempHomeDesign == home01SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_02;
        } else if (tempHomeDesign == home02SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_03;
        } else if (tempHomeDesign == home03SectionType) {
          HOME_SCREEN_DESIGN = DESIGN_04;
        }
      });
  }

  void setUpBottomNavbar() {
    pageList = [];
    bottomNavBarItemsMap = {};
    homePageIndex = -1;
    searchPageIndex = -1;
    savedOrFavSearchesPageIndex = -1;
    navbarItemsList = UtilityMethods.readBottomNavigationBarConfigFile();
    if (navbarItemsList.isNotEmpty) {

      if (BOTTOM_NAVIGATION_BAR_DESIGN == DESIGN_02 &&
          navbarItemsList.length > 5) {
        navbarItemsList = navbarItemsList.sublist(0, 5);
      }

      for (NavbarItem item in navbarItemsList) {
        int index = navbarItemsList.indexOf(item);

        if (item.sectionType == PLACE_HOLDER_SECTION_TYPE) {
          if (item.title != null &&
              navbarWidgetsHook(context, item.title!) != null) {
            bottomNavBarItemsMap[item.title!] = UtilityMethods.fromJsonToIconData(
                item.iconDataJson ?? DUMMY_ICON_JSON);
          }
        } else {
          bottomNavBarItemsMap[item.title!] = UtilityMethods.fromJsonToIconData(
              item.iconDataJson ?? DUMMY_ICON_JSON);
        }

        if ((item.checkLogin ?? false) && (!HiveStorageManager.isUserLoggedIn())) {
          pageList.add( UserSignIn(
                (String closeOption) {
              if (closeOption == CLOSE) {
                onWillPop();
              }
            },
          ));
        } else {
          if (item.sectionType == menuHomeSectionType) {
            homePageIndex = index;
            pageList.add(HomeScreenUtilities().getHomeScreen(
              scaffoldKey: _scaffoldKey,
              design: HOME_SCREEN_DESIGN,
            ));
          } else if (item.sectionType == searchSectionType) {
            searchPageIndex = index;
            pageList.add(LoadingPage());
          } else if (item.sectionType == savedSearchesAndFavouritesType) {
            savedOrFavSearchesPageIndex = index;
            pageList.add(LoadingPage());
          } else if (item.sectionType == profileSectionType) {
            pageList.add(UserProfile(fromBottomNavigator: true));
          } else if (item.sectionType == savedSectionType) {
            pageList.add(SavedSearches(showAppBar: true));
          } else if (item.sectionType == favouritesSectionType) {
            pageList.add(Favorites(
              showAppBar: true,
              favoritesPageListener: (String closeOption) {
                if (closeOption == CLOSE) {
                  onWillPop();
                  // Navigator.pop(context);
                }
              },
            ));
          } else if (item.sectionType == menuTermSectionType) {
            pageList.add(SearchResult(
              dataInitializationMap: item.searchApiMap,
              searchPageListener: (Map<String, dynamic> map, String closeOption){
                if(closeOption == CLOSE){
                  onWillPop();
                  // Navigator.of(context).pop();
                }
              },
            ));
          } else if (item.sectionType == aboutScreenSectionType) {
            if (SHOW_DEMO_CONFIGURATIONS) {
              pageList.add(About());
            } else {
              pageList.add(WebPage(COMPANY_URL, UtilityMethods.getLocalizedString("about"),
                  automaticallyImplyLeading: false));
            }
          } else if (item.sectionType == themeSettingScreenSectionType) {
            pageList.add(DarkModeSettings(showBackButton: false));
          } else if (item.sectionType == languageSettingScreenSectionType) {
            pageList.add(LanguageSettings(showBackButton: false));
          } else if (item.sectionType == privacyPolicyScreenSectionType) {
            pageList.add(WebPage(APP_PRIVACY_URL,
                UtilityMethods.getLocalizedString("privacy_policy"),
                automaticallyImplyLeading: false));
          } else if (item.sectionType == termsAndConditionsScreenSectionType) {
            pageList.add(WebPage(APP_TERMS_URL, UtilityMethods.getLocalizedString("terms_and_conditions"),
                automaticallyImplyLeading: false));
          } else if (item.sectionType == webUrlSectionType) {
            pageList.add(WebPage(item.url!, UtilityMethods.getLocalizedString(item.title!),
                automaticallyImplyLeading: false));
          } else if (item.sectionType == PLACE_HOLDER_SECTION_TYPE &&
              item.title != null &&
              navbarWidgetsHook(context, item.title!) != null) {
            pageList.add(navbarWidgetsHook(context,item.title!)!);
          } else if (item.sectionType == blogsKey) {
            pageList.add(AllBlogsPage(
              title: item.title ?? "Blogs",
              blogDesign: BLOGS_DESIGN,
              hideBackButton: true,
            ));
          } else if (item.sectionType == messagesKey) {
            pageList.add(AllThreadsPage(hideBackButton: true));
          }
        }
      }
    }
    else {
      bottomNavBarItemsMap = {
        "home" : AppThemePreferences.homeIcon,
        "search" : AppThemePreferences.searchIcon,
        "" : addPlusButtonHook(context) == null
            ? null : Icons.fiber_manual_record_outlined,
        "saved" : AppThemePreferences.savedSearchesIcon,
        "profile" : AppThemePreferences.personIcon,
      };
      bottomNavBarItemsMap.removeWhere((key, value) => value == null);

      homePageIndex = 0;
      searchPageIndex = 1;
      savedOrFavSearchesPageIndex = 2;

      pageList.add(HomeScreenUtilities().getHomeScreen(
        scaffoldKey: _scaffoldKey,
        design: HOME_SCREEN_DESIGN,
      ));

      pageList.add(LoadingPage());

      pageList.add(LoadingPage());

      if (addPlusButtonHook(context) != null) {
        pageList.add(LoadingPage());
        savedOrFavSearchesPageIndex = 3;
      }

      pageList.add(UserProfile(fromBottomNavigator: true));
    }

    if (mounted && savedOrFavSearchesPageIndex != -1) {
      setState(() {
        setSavedSearchesOrFavouritesPage();
      });
    }
  }

  void setHomePage() {
    loadLoadingPage(homePageIndex);
    pageList[homePageIndex] = HomeScreenUtilities().getHomeScreen(
      scaffoldKey: _scaffoldKey,
      design: HOME_SCREEN_DESIGN,
    );
  }

  void setSearchPage() {
    Map<String, dynamic> filterDataMap =
        HiveStorageManager.readFilterDataInfo() ?? {};
    if (filterDataLoaded &&
        filterDataMap.isNotEmpty &&
        totalResults != null &&
        totalResults! > 0) {
      // if(recentSearchesInfoList.isNotEmpty &&
      //     recentSearchesInfoList.first.isNotEmpty && totalResults != null &&
      //     totalResults! > 0){
      //   print("Navigating to Search Page................................................");
      loadLoadingPage(searchPageIndex);
      doSearch(filterDataMap);
    } else {
      // print("Replace Filter Page................................................");
      loadLoadingPage(searchPageIndex);
      loadFilterPage();
    }
    filterDataLoaded = false;
  }

  void loadLoadingPage(int pageIndex) {
    if (mounted) {
      setState(() {
        pageList[pageIndex] = LoadingPage(
          key: ObjectKey(random.nextInt(100)),
          showAppBar: false,
        );
      });
    }
  }

  void loadFilterPage() {
    pageList[searchPageIndex] = SHOW_MAP_INSTEAD_FILTER
        ? SearchResult(
            key: ObjectKey(random.nextInt(100)),
            dataInitializationMap: const {},
            searchPageListener: (Map<String, dynamic> map, String closeOption) {
              if (closeOption == CLOSE) {
                //Navigator.of(context).pop();
              }
            },
          )
        : FilterPage(
            key: ObjectKey(random.nextInt(100)),
            mapInitializeData: HiveStorageManager.readFilterDataInfo() ?? {},
            hasBottomNavigationBar: true,
            filterPageListener:
                (Map<String, dynamic> dataMap, String closeOption) {
              if (closeOption == DONE) {
                var searchResult = SearchResult(
                  hasBottomNavigationBar: true,
                  dataInitializationMap:
                      HiveStorageManager.readFilterDataInfo() ?? {},
                  searchPageListener:
                      (Map<String, dynamic> map, String closeOption) {
                    if (closeOption == CLOSE) {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    }
                    if (map.isNotEmpty && map.containsKey(SEARCH_COUNT)) {
                      if (mounted) {
                        setState(() {
                          totalResults = map[SEARCH_COUNT];
                        });
                      }
                    }
                  },
                );
                if (mounted) {
                  setState(() {
                    pageList[searchPageIndex] = searchResult;
                  });
                }
              } else if (closeOption == CLOSE) {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 0;
                  });
                }
              }
            },
          );
  }

  void doSearch(Map<String, dynamic> mapFromFilterScreen) {
    // Future.delayed(Duration(seconds: 2));
    // loadLoadingPage(searchPageIndex);
    // Future.delayed(Duration(seconds: 5));

    var filteredSearchResult = SearchResult(
      key: ObjectKey(random.nextInt(100)),
      hasBottomNavigationBar: true,
      dataInitializationMap: mapFromFilterScreen,
      searchPageListener: (Map<String, dynamic> map, String closeOption) {
        if (closeOption == CLOSE) {
          setState(() {
            _selectedIndex = 0;
          });
        }

        if (map.isNotEmpty && map.containsKey(SEARCH_COUNT)) {
          if (mounted) {
            setState(() {
              totalResults = map[SEARCH_COUNT];
            });
          }
        }
      },
    );
    if (mounted) {
      setState(() {
        pageList[searchPageIndex] = filteredSearchResult;
      });
    }
  }

  void setSavedSearchesOrFavouritesPage() {
    if (isUserLoggedIn) {
      pageList[savedOrFavSearchesPageIndex] = Saved((String closeOption) {
        if (closeOption == CLOSE) {
          if (mounted) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        }
      });
    } else {
      pageList[savedOrFavSearchesPageIndex] = UserSignIn(
        (String closeOption) {
          if (closeOption == CLOSE) {
            if (mounted) {
              setState(() {
                _selectedIndex = 0;
              });
            }
          }
        },
        fromBottomNavigator: true,
      );
    }
  }

  navigateToAddPropertyPage({required Map map, required int index}) {
    if (map.isEmpty) return;
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPropertyV2(
            // builder: (context) => AddProperty(
            draftPropertyIndex: index,
            isDraftProperty: true,
            propertyDataMap: map,
          ),
        ),
      );
    });
  }

  Widget? defaultAddButton() {
    //First we'll check if showing add button is allowed, then we'll check if the bottom tab bar design
    //is not design 2. then we'll check if hook is returning some widget.
    if (SHOW_BOTTOM_NAV_BAR_ADD_BTN && BOTTOM_NAVIGATION_BAR_DESIGN != DESIGN_02) {
      Widget? widgetFromHook = addPlusButtonHook(context);
      return widgetFromHook ?? Container(
        width: 65,
        height: 65,
        margin: const EdgeInsets.only(top: 0),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: AppThemePreferences.appSecondaryColor,
          child: const Icon(Icons.add, color: Colors.white, size: 35),
          elevation: 4.0,
          onPressed: () {
            UtilityMethods.navigateToRoute(
              context: context,
              builder: (context) =>
              HiveStorageManager.isUserLoggedIn()
                  ? UtilityMethods.navigateToAddPropertyPage(
                  navigateToQuickAdd: true)
                  : UserSignIn(
                    (String closeOption) {
                  if (closeOption == CLOSE) {
                    Navigator.pop(context);
                  }
                },
              ),
            );
          },
        ),
      );
    }
    return null;
  }
}