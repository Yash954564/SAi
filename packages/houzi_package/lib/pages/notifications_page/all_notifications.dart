import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/push_notif/notif_router.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:houzi_package/widgets/notifications_widgets/notification_widget-01.dart';
import 'package:houzi_package/models/notifications/notifications.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';


class AllNotificationsPage extends StatefulWidget {
  final String? title;
  final String? design;
  final bool? hideBackButton;

  const AllNotificationsPage({
    super.key,
    this.title,
    this.design,
    this.hideBackButton = false,
  });

  @override
  _AllNotificationsPageState createState() => _AllNotificationsPageState();
}

class _AllNotificationsPageState extends State<AllNotificationsPage> {
  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<NotificationItem> notificationItemsList = [];
  Future<AllNotifications?>? _futureAllNotification;

  bool isLoading = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 20;

  @override
  void initState() {
    super.initState();
    loadDataFromApi();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: widget.title ?? "Notifications",
        automaticallyImplyLeading: !(widget.hideBackButton ?? false),
      ),
      body: Stack(
        children: [
          SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: const MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () => loadDataFromApi(),
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget? body;
                if (mode == LoadStatus.loading) {
                  if (shouldLoadMore) {
                    body = const PaginationLoadingWidget();
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
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: NotificationsListingsFromFuture(
                onTap: (item) => onTap(item),
                onCloseTap: (item) => onCloseTap(item),
                loadingData: isLoading,
                design: widget.design,
                future: _futureAllNotification,
                // future: null,
                listener: (loadingComplete) {
                  isLoading = false;
                },
              ),
            ),
          ),
          if (_refreshController.isLoading)
            const PaginationLoadingWidget(),

          if (isInternetConnected == false) Align(
            alignment: Alignment.topCenter,
            child: NoInternetConnectionErrorWidget(onPressed: () => loadDataFromApi()),
          )
        ],
      ),
    );
  }

  void onTap(NotificationItem item) {
    NotificationRouter.notificationRouterFunc(
      context,
      item.extraDataMap ?? {},
      fromAllNotifications: true,
    );
  }

  void onCloseTap(NotificationItem item) {
    Map<String, dynamic> dataMap = {
      NOTIFICATION_ID_KEY : item.id,
      NOTIFICATION_USER_EMAIL_KEY: item.userEmail,
    };
    showDeleteDialogBoxWidget(
        context: context,
        onPositiveButtonPressed: () async {
          // Close the delete dialog box
          Navigator.pop(context);

          showWaitingDialogBoxWidget(context: context);

          ApiResponse response = await _propertyBloc.deleteNotification(dataMap);
          // Close the waiting dialog box
          Navigator.pop(context);

          if (response.success) {
            ShowToastWidget(buildContext: context, text: response.message);
            loadDataFromApi();
          } else {
            ShowToastWidget(buildContext: context, text: response.message);
          }
        }
    );
  }

  void loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      setState(() {
        isRefreshing = true;
        isLoading = true;
      });

      page = 1;
      _futureAllNotification = fetchAllNotifications(page);
      _refreshController.refreshCompleted();
    } else {
      if (!shouldLoadMore || isLoading) {
        _refreshController.loadComplete();
        return;
      }
      setState(() {
        isRefreshing = false;
        isLoading = true;
      });
      page++;
      _futureAllNotification = fetchAllNotifications(page);
      _refreshController.loadComplete();
    }
  }

  Future<AllNotifications?> fetchAllNotifications(int page) async {
    Map<String, dynamic> dataMap = {
      "page" : page.toString(),
      "per_page" : perPage.toString(),
    };

    var(success, internet, allNotifications) = await _propertyBloc.fetchAllNotifications(dataMap);
    if (mounted) {
      setState(() {
        isInternetConnected = internet;
        if (!internet) {
          shouldLoadMore = false;
        }
      });
    }

    if (success) {
      if (page == 1) {
        notificationItemsList = [];
      }
      if (allNotifications != null) {
        List<NotificationItem>? tempList = allNotifications.notificationsList;

        if (tempList != null && tempList.isNotEmpty) {
          notificationItemsList.addAll(tempList);
          allNotifications.notificationsList = notificationItemsList;
        } else if (notificationItemsList.isNotEmpty) {
          allNotifications.notificationsList = notificationItemsList;
        }

        if (tempList == null || tempList.isEmpty || tempList.length < perPage) {
          if (mounted) {
            setState(() {
              shouldLoadMore = false;
            });
          }
        }
      }

      return allNotifications;
    }

    return null;
  }
}

typedef NotificationsListingsFromFutureListener = void Function(bool loadingComplete);
class NotificationsListingsFromFuture extends StatelessWidget {
  final bool loadingData;
  final String? design;
  final Future<AllNotifications?>? future;
  final NotificationsListingsFromFutureListener listener;
  final void Function(NotificationItem) onTap;
  final void Function(NotificationItem) onCloseTap;

  const NotificationsListingsFromFuture({
    super.key,
    this.design,
    required this.loadingData,
    required this.future,
    required this.listener,
    required this.onTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllNotifications?>(
      future: future,
      builder: (context, articleSnapshot) {
        listener(true);
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data == null ||
              articleSnapshot.data!.notificationsList == null ||
              articleSnapshot.data!.notificationsList!.isEmpty) {
            return const NoNotificationFoundWidget();
          }

          List<NotificationItem> list = articleSnapshot.data!.notificationsList!;

          return Container(
            padding: const EdgeInsets.only(top: 15),
            child: NotificationsListingWidget(
              onTap: (item)=> onTap(item),
              onCloseTap: (item)=> onCloseTap(item),
              notificationsList: list,
            ),
          );
        } else if (!loadingData && (articleSnapshot.hasError || (!articleSnapshot.hasData))) {
          return const NoNotificationFoundWidget();
        }
        return const LoadingWidget();
      },
    );
  }
}

class NotificationsListingWidget extends StatelessWidget {
  final List<NotificationItem> notificationsList;
  final void Function(NotificationItem) onTap;
  final void Function(NotificationItem) onCloseTap;

  const NotificationsListingWidget({
    super.key,
    required this.onTap,
    required this.onCloseTap,
    required this.notificationsList,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: notificationsList.length,
      itemBuilder: (context, index) {
        NotificationItem item = notificationsList[index];
        return  NotificationWidget01(
            onTap: ()=> onTap(item),
            onCloseTap: ()=> onCloseTap(item),
            notificationItem: item,
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}

class PaginationLoadingWidget extends StatelessWidget {
  const PaginationLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: const SizedBox(
        width: 60,
        height: 50,
        child: BallRotatingLoadingWidget(),
      ),
    );
  }
}

class NoNotificationFoundWidget extends StatelessWidget {
  const NoNotificationFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      child: const NoResultErrorWidget(
        headerErrorText: "No Notification Found",
      ),
    );
  }
}