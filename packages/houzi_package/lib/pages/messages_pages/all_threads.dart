import 'dart:async';

import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/theme_service_files/theme_notifier.dart';
import 'package:houzi_package/pages/messages_pages/all_messages.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/message_widgets/message_author_info.dart';
import 'package:houzi_package/widgets/message_widgets/message_last_message.dart';
import 'package:houzi_package/widgets/message_widgets/message_property_info.dart';
import 'package:houzi_package/widgets/message_widgets/message_time_and_actions.dart';
import 'package:houzi_package/models/messages/all_message_threads.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';


class AllThreadsPage extends StatefulWidget {
  final bool? hideBackButton;

  const AllThreadsPage({
    super.key,
    this.hideBackButton = false,
  });

  @override
  State<AllThreadsPage> createState() => _AllMessageThreadsState();
}

class _AllMessageThreadsState extends State<AllThreadsPage> {

  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<MessageThread> messageThreadsList = [];
  Future<AllMessageThreads?>? _futureAllMessageThreads;

  bool isLoading = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isInternetConnected = true;

  int page = 1;
  int perPage = 20;

  Timer? timer;
  int defaultApiRefreshTime = 5;

  @override
  void initState() {
    super.initState();

    ThreadApiRefreshTimeHook threadApiRefreshTimeHook = HooksConfigurations.threadApiRefreshTimeHook;

    if (threadApiRefreshTimeHook != null) {
      defaultApiRefreshTime = threadApiRefreshTimeHook()!;
    } else {
      defaultApiRefreshTime = 5;
    }

    loadDataFromApi();

    timer = Timer.periodic(Duration(seconds: defaultApiRefreshTime),
      (Timer t) => loadDataFromApi());
  }

  @override
  void dispose() {
    messageThreadsList = [];
    _refreshController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        appBarTitle: "Messages",
        automaticallyImplyLeading: !(widget.hideBackButton ?? false),
      ),
      body: Consumer<ThemeNotifier>(builder: (context, value, child) {
        bool isRTL = UtilityMethods.isRTL(context);
        return Stack(
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
                child: MessageThreadsListingsFromFuture(
                  loadingData: isLoading,
                  future: _futureAllMessageThreads,
                  listener: (loadingComplete, refreshPage) {
                    if (loadingComplete) {
                      isLoading = false;
                    }

                    if (refreshPage) {
                      loadDataFromApi();
                    }
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
        );
      },),
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
      _futureAllMessageThreads = fetchAllMessageThreads(page);
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
      _futureAllMessageThreads = fetchAllMessageThreads(page);
      _refreshController.loadComplete();
    }
  }

  Future<AllMessageThreads?> fetchAllMessageThreads(int page) async {
    var(success, internet, allMessageThreads) = await _propertyBloc.fetchAllMessageThreads(page, perPage, null);
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
        messageThreadsList = [];
      }
      if (allMessageThreads != null) {
        List<MessageThread>? tempList = allMessageThreads.threadsList;

        if (tempList != null && tempList.isNotEmpty) {
          messageThreadsList.addAll(tempList);
          allMessageThreads.threadsList = messageThreadsList;
        } else if (messageThreadsList.isNotEmpty) {
          allMessageThreads.threadsList = messageThreadsList;
        }

        if (tempList == null || tempList.isEmpty || tempList.length < perPage) {
          if (mounted) {
            setState(() {
              shouldLoadMore = false;
            });
          }
        }
      }

      return allMessageThreads;
    }

    return null;
  }
}

typedef MessageThreadsListingsFromFutureListener = void Function(bool loadingComplete, bool refreshPage);
class MessageThreadsListingsFromFuture extends StatelessWidget {
  final bool loadingData;
  final Future<AllMessageThreads?>? future;
  final MessageThreadsListingsFromFutureListener listener;

  const MessageThreadsListingsFromFuture({
    super.key,
    required this.loadingData,
    required this.future,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllMessageThreads?>(
      future: future,
      builder: (context, articleSnapshot) {
        listener(true, false);
        if (articleSnapshot.hasData) {

          if (articleSnapshot.data == null ||
              articleSnapshot.data!.threadsList == null ||
              articleSnapshot.data!.threadsList!.isEmpty) {
            return const NoNotificationFoundWidget();
          }

          List<MessageThread> list = articleSnapshot.data!.threadsList!;

          return Container(
            padding: const EdgeInsets.only(top: 15),
            child: MessageThreadsListingWidget(
              messageThreadsList: list,
              listener: (refreshPage) => listener(false, refreshPage),
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

typedef MessageThreadsListingWidgetListener = void Function(bool refreshPage);
class MessageThreadsListingWidget extends StatelessWidget {
  final List<MessageThread> messageThreadsList;
  final MessageThreadsListingWidgetListener listener;

  const MessageThreadsListingWidget({
    super.key,
    required this.messageThreadsList,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: true,
      itemCount: messageThreadsList.length,
      itemBuilder: (context, index) {
        MessageThread item = messageThreadsList[index];
        return  MessageThreadListItemWidget(
          item: item,
          listener: (refreshPage) => listener(refreshPage),
        );
      },
    );
  }
}

typedef MessageThreadListItemWidgetListener = void Function(bool refreshPage);
class MessageThreadListItemWidget extends StatefulWidget {
  final MessageThread item;
  final MessageThreadListItemWidgetListener listener;

  const MessageThreadListItemWidget({
    super.key,
    required this.item,
    required this.listener,
  });

  @override
  State<MessageThreadListItemWidget> createState() => _MessageThreadListItemWidgetState();
}

class _MessageThreadListItemWidgetState extends State<MessageThreadListItemWidget> {
  bool showCompleteMessage = false;
  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: GestureDetector(
        onTap: () => onReplyTap(widget.item),
        child: CardWidget(
          shape: AppThemePreferences.roundedCorners(
              AppThemePreferences.globalRoundedCornersRadius),
          elevation: AppThemePreferences.messagePageElevation,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MessageAuthorInfoWidget(
                  pictureWidth: 35, pictureHeight: 35,
                  name: widget.item.senderDisplayName ?? "",
                  pictureUrl: widget.item.senderPicture ?? "",
                ),

                MessagePropertyTitleWidget(propertyTitle: widget.item.propertyTitle),

                LastMessageWidget(
                  author: getLastMessageAuthor(widget.item),
                  message: widget.item.lastMessage ?? "",
                  showAllMessage: showCompleteMessage,
                ),

                MessageTimeAndActionsWidget(
                  showSeeMore: showSeeMoreWidget(widget.item),
                  time: widget.item.lastMessageTimeInTimeAgoFormat,
                  showCompleteMessage: showCompleteMessage,
                  onShowMoreTap: ()=> onShowMoreTap(),
                  onReplyTap: () => onReplyTap(widget.item),
                  onDeleteTap: () => onDeleteTap(widget.item),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool showSeeMoreWidget(MessageThread item) {
    String message = "${getLastMessageAuthor(item)}: ${widget.item.lastMessage ?? ""}";
    if (message.length > 130) {
      return true;
    }
    return false;
  }

  void onShowMoreTap() {
    if (mounted) {
      setState(() {
        showCompleteMessage = !showCompleteMessage;
      });
    }
  }

  void onReplyTap(MessageThread item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllMessagesPage(
          threadId: item.threadId ?? "",
          propertyTitle: item.propertyTitle ?? "",
          propertyId: item.propertyId ?? "",
          senderId: item.senderId ?? "",
          senderDisplayName: UtilityMethods.getThreadSenderDisplayName(item),
          senderPictureUrl: item.senderPicture ?? "",
          receiverId: item.receiverId ?? "",
          receiverDisplayName: UtilityMethods.getThreadReceiverDisplayName(item),
          receiverPictureUrl: item.receiverPicture ?? "",
        ),
      ),
    );
  }

  void onDeleteTap(MessageThread item) {
    String threadId = item.threadId ?? '';
    String senderId = item.senderId ?? '';
    String receiverId = item.receiverId ?? '';

    showDeleteDialogBoxWidget(
      context: context,
      onPositiveButtonPressed: () async {
        // Close the delete dialog box
        Navigator.pop(context);

        showWaitingDialogBoxWidget(context: context);

        ApiResponse response = await _propertyBloc.fetchDeleteMessageThreadResponse(threadId, senderId, receiverId);
        // Close the waiting dialog box
        Navigator.pop(context);

        if (response.success) {
          ShowToastWidget(buildContext: context, text: response.message);
          widget.listener(true);
        } else {
          ShowToastWidget(buildContext: context, text: response.message);
        }
      }
    );
  }

  String getLastMessageAuthor(MessageThread item) {
    String? displayName = item.lastMessageAuthorDisplayName;
    String? firstName = item.lastMessageAuthorFirstName;
    String? lastName = item.lastMessageAuthorLastName;

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    } else if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    } else if (lastName != null && lastName.isNotEmpty) {
      return lastName;
    }
    return "";
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
        headerErrorText: "No Message Found",
      ),
    );
  }
}
