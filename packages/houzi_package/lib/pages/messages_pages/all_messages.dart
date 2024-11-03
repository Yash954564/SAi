import 'dart:async';

import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/pages/realtor_information_page.dart';
import 'package:houzi_package/push_notif/one_singal_config.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/messages/all_thread_messages.dart';
import 'package:houzi_package/widgets/message_widgets/message_bottom_actionbar.dart';
import 'package:houzi_package/widgets/message_widgets/message_content.dart';
import 'package:houzi_package/widgets/message_widgets/message_date.dart';
import 'package:houzi_package/widgets/message_widgets/message_receiver_info.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';


class AllMessagesPage extends StatefulWidget {
  final bool? hideBackButton;
  final String threadId;
  final String propertyTitle;
  final String propertyId;
  final String senderId;
  final String senderDisplayName;
  final String senderPictureUrl;
  final String receiverId;
  final String receiverDisplayName;
  final String receiverPictureUrl;

  const AllMessagesPage({
    super.key,
    this.hideBackButton = false,
    required this.threadId,
    required this.propertyTitle,
    required this.propertyId,
    required this.senderId,
    required this.senderDisplayName,
    required this.senderPictureUrl,
    required this.receiverId,
    required this.receiverDisplayName,
    required this.receiverPictureUrl,
  });

  @override
  State<AllMessagesPage> createState() => _AllMessagesPageState();
}

class _AllMessagesPageState extends State<AllMessagesPage> {

  final PropertyBloc _propertyBloc = PropertyBloc();

  List<ThreadMessage> threadMessagesList = [];
  Future<AllThreadMessages?>? _futureAllThreadMessages;

  bool isLoading = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isInternetConnected = true;
  bool hideScrollDownFab = true;
  bool shouldScrollDown = true;
  bool showMessageSendingLoader = false;

  int page = 1;
  int perPage = 50;

  String currentUserId = '';
  String userStatus = 'Offline';
  String nonce = "";
  String content = "";

  Timer? apiTimer;
  int defaultApiRefreshTime = 5;

  late TextEditingController textFieldController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    textFieldController = TextEditingController();
    textFieldController.text = "";

    MessageApiRefreshTimeHook messageApiRefreshTimeHook = HooksConfigurations.messageApiRefreshTimeHook;

    if (messageApiRefreshTimeHook != null) {
      defaultApiRefreshTime = messageApiRefreshTimeHook()!;
    } else {
      defaultApiRefreshTime = 5;
    }

    fetchNonce();
    loadDataFromApi();

    apiTimer = Timer.periodic(Duration(seconds: defaultApiRefreshTime),
            (Timer t) => loadDataFromApi());

    int? id = HiveStorageManager.getUserId();
    if (id != null) {
      currentUserId = id.toString();
    }

    scrollController.addListener(() {
      if (scrollController.hasClients) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && mounted) {
          setState(() {
            hideScrollDownFab = true;
          });
        } else {
          setState(() {
            hideScrollDownFab = false;
          });
        }

        if (scrollController.position.pixels == 0) {
          loadDataFromApi(forPullToRefresh: false);
        }
      }
    });
  }



  @override
  void dispose() {
    threadMessagesList = [];
    textFieldController.dispose();
    scrollController.dispose();
    apiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: "Messages",
          backgroundColor: AppThemePreferences().appTheme.sendMessageAppBarBgColor,
          leadingWidth: 28,
          automaticallyImplyLeading: !(widget.hideBackButton ?? false),
          title: MessageReceiverInfoWidget(
            name: getReceiverName(),
            propertyTitle: widget.propertyTitle,
            propertyId: widget.propertyId,
            pictureUrl: getReceiverPicture(),
            onTap: ()=> onReceiverImageTap(),
          ),
        ),

        floatingActionButton: (!hideScrollDownFab)
            ? FloatingActionButton.small(
                onPressed: ()=> scrollDownFunc(),
                backgroundColor: AppThemePreferences().appTheme.messageScrollFABBgColor,
                shape: AppThemePreferences.roundedCorners(30),
                child: Icon(
                  AppThemePreferences.pageScrollDownIcon,
                  color: AppThemePreferences().appTheme.messageTimeTextColor,
                ),
              )
            : null,
        bottomNavigationBar: MessagesBottomActionBar(
          controller: textFieldController,
          formKey: formKey,
          showLoader: showMessageSendingLoader,
          onSaved: (content) => onSavedFunc(content),
          onSendMessagePressed: ()=> onSendMessagePressed(),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: ThreadMessagesListingsFromFuture(
                currentUserId: currentUserId,
                propertyTitle: widget.propertyTitle,
                senderId: widget.senderId,
                senderDisplayName: widget.senderDisplayName,
                senderPictureUrl: widget.senderPictureUrl,
                receiverId: widget.receiverId,
                receiverDisplayName: widget.receiverDisplayName,
                receiverPictureUrl: widget.receiverPictureUrl,
                loadingData: isLoading,
                future: _futureAllThreadMessages,
                listener: (loadingComplete, refreshPage, dataReceived) {
                  if (loadingComplete) {
                    isLoading = false;
                  }

                  if (refreshPage) {
                    loadDataFromApi();
                  }

                  if (dataReceived) {
                    if (shouldScrollDown) {
                      if (scrollController.hasClients) {
                        Future.delayed(const Duration(milliseconds: 100), (){
                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                          // scrollController.animateTo(scrollController.position.maxScrollExtent,
                          // duration: const Duration(milliseconds: 100),
                          // curve: Curves.bounceInOut);
                        });
                      }
                    }
                    shouldScrollDown = false;
                  }
                },
              ),
            ),

            if (isInternetConnected == false) Align(
              alignment: Alignment.topCenter,
              child: NoInternetConnectionErrorWidget(onPressed: () => loadDataFromApi()),
            ),
          ],
        ),
      ),
    );
  }

  void scrollDownFunc() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  String getReceiverName() {

    if (currentUserId != widget.senderId) {
      return widget.senderDisplayName;
    } else if (currentUserId != widget.receiverId) {
      return widget.receiverDisplayName;
    }

    return "";
  }

  String getReceiverPicture() {
    if (currentUserId != widget.senderId) {
      return widget.senderPictureUrl;
    } else if (currentUserId != widget.receiverId) {
      return widget.receiverPictureUrl;
    }

    return "";
  }

  String? getReceiverId() {
    if (currentUserId != widget.senderId) {
      return widget.senderId;
    } else if (currentUserId != widget.receiverId) {
      return widget.receiverId;
    }

    return null;
  }

  void onReceiverImageTap() {
    Map<String, dynamic> dataMap = {
      tempRealtorIdKey: getReceiverId() != null ? int.tryParse(getReceiverId()!) : null,
      tempRealtorNameKey: getReceiverName(),
      tempRealtorThumbnailKey: getReceiverPicture(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RealtorInformationDisplayPage(
              agentType: AUTHOR_INFO,
              heroId: "$currentUserId - Hero",
              realtorInformation: dataMap,
            ),
      ),
    );
  }

  void onSavedFunc(String? text) {
    if (mounted) {
      setState(() {
        content = text ?? "";
      });
    }
  }

  Future<void> onSendMessagePressed() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (mounted) {
        setState(() {
          showMessageSendingLoader = true;
        });
      }

      ApiResponse response = await _propertyBloc.fetchSendMessageResponse(widget.threadId, content, nonce);

      if (response.success) {
        ShowToastWidget(buildContext: context, text: response.message);
        textFieldController.text = "";
        content = "";
        loadDataFromApi();
        setState(() {
          showMessageSendingLoader = false;
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
            hideScrollDownFab = false;
          }
        });

      } else {
        if (mounted) {
          setState(() {
            showMessageSendingLoader = false;
          });
        }
        ShowToastWidget(buildContext: context, text: response.message);
      }
    }

  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchSendMessageNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  void loadDataFromApi({bool forPullToRefresh = true}) {
    if (forPullToRefresh) {
      if (isLoading) {
        return;
      }
      setState(() {
        isRefreshing = true;
        isLoading = true;
        shouldLoadMore = true;
      });

      page = 1;
      _futureAllThreadMessages = fetchAllThreadMessages(page);

      setState(() {
        isRefreshing = false;
      });
    } else {
      if (!shouldLoadMore || isLoading) {
        return;
      }
      setState(() {
        isRefreshing = false;
        isLoading = true;
      });
      page++;
      _futureAllThreadMessages = fetchAllThreadMessages(page);
    }
  }

  Future<AllThreadMessages?> fetchAllThreadMessages(int page) async {
    Map<String, dynamic> dataMap = {
      "threadId": widget.threadId,
      "senderId": widget.senderId,
      "receiverId": widget.receiverId,
      "seen": "1",
      "page": "$page",
      "perPage": "$perPage",
    };
    var(success, internet, allThreadMessages) = await _propertyBloc.fetchAllThreadMessages(dataMap);
    if (mounted) {
      setState(() {
        isInternetConnected = internet;
        if (!internet) {
          shouldLoadMore = false;
        }
      });
    }

    if (success) {

      // CLEAR MESSAGES GROUP NOTIFICATIONS
      OneSignalConfig.clearGroupedNotificationForGroupId(widget.threadId);

      if (page == 1) {
        threadMessagesList = [];
      }
      if (allThreadMessages != null) {
        String? status;

        if (currentUserId != widget.senderId) {
          status = allThreadMessages.senderStatus;
        } else if (currentUserId != widget.receiverId) {
          status = allThreadMessages.receiverStatus;
        }

        if (status != null && status.isNotEmpty && mounted) {
          setState(() {
            userStatus = status ?? 'Offline';
          });
        }

        List<ThreadMessage>? tempList = allThreadMessages.messagesList;

        if (tempList != null && tempList.isNotEmpty) {
          threadMessagesList.addAll(tempList);
          allThreadMessages.messagesList = threadMessagesList;
        } else if (threadMessagesList.isNotEmpty) {
          allThreadMessages.messagesList = threadMessagesList;
        }

        if (tempList == null || tempList.isEmpty || tempList.length < perPage) {
          if (mounted) {
            setState(() {
              shouldLoadMore = false;
            });
          }
        }
      }

      return allThreadMessages;
    }

    return null;
  }
}

typedef ThreadMessagesListingsFromFutureListener = void Function(bool loadingComplete, bool refreshPage, bool dataReceived);
class ThreadMessagesListingsFromFuture extends StatelessWidget {
  final bool loadingData;
  final Future<AllThreadMessages?>? future;
  final ThreadMessagesListingsFromFutureListener listener;
  final String propertyTitle;
  final String senderId;
  final String senderDisplayName;
  final String senderPictureUrl;
  final String receiverId;
  final String receiverDisplayName;
  final String receiverPictureUrl;
  final String currentUserId;

  const ThreadMessagesListingsFromFuture({
    super.key,
    required this.loadingData,
    required this.future,
    required this.listener,
    required this.propertyTitle,
    required this.senderId,
    required this.senderDisplayName,
    required this.senderPictureUrl,
    required this.receiverId,
    required this.receiverDisplayName,
    required this.receiverPictureUrl,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllThreadMessages?>(
      future: future,
      builder: (context, articleSnapshot) {
        listener(true, false, false);
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data == null ||
              articleSnapshot.data!.messagesList == null ||
              articleSnapshot.data!.messagesList!.isEmpty) {
            return const NoNotificationFoundWidget();
          }

          List<ThreadMessage> list = articleSnapshot.data!.messagesList!;
          if (list.isNotEmpty) {
            listener(false, false, true);
          }

          return ThreadMessagesListingWidget(
            currentUserId: currentUserId,
            propertyTitle: propertyTitle,
            senderId: senderId,
            senderDisplayName: senderDisplayName,
            senderPictureUrl: senderPictureUrl,
            receiverId: receiverId,
            receiverDisplayName: receiverDisplayName,
            receiverPictureUrl: receiverPictureUrl,
            threadMessagesList: list,
            listener: (refreshPage) => listener(false, refreshPage, false),
          );

        } else if (!loadingData && (articleSnapshot.hasError || (!articleSnapshot.hasData))) {
          return const NoNotificationFoundWidget();
        }
        return const LoadingWidget();
      },
    );
  }
}

typedef ThreadMessagesListingWidgetListener = void Function(bool refreshPage);
class ThreadMessagesListingWidget extends StatelessWidget {
  final List<ThreadMessage> threadMessagesList;
  final ThreadMessagesListingWidgetListener listener;
  final String propertyTitle;
  final String senderId;
  final String senderDisplayName;
  final String senderPictureUrl;
  final String receiverId;
  final String receiverDisplayName;
  final String receiverPictureUrl;
  final String currentUserId;

  const ThreadMessagesListingWidget({
    super.key,
    required this.threadMessagesList,
    required this.listener,
    required this.propertyTitle,
    required this.senderId,
    required this.senderDisplayName,
    required this.senderPictureUrl,
    required this.receiverId,
    required this.receiverDisplayName,
    required this.receiverPictureUrl,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: threadMessagesList.length,
      itemBuilder: (context, index) {
        bool isSameDate = false;
        ThreadMessage item = threadMessagesList[index];

        // since it is a reverse list so date comparison will also be performed
        // in reverse order
        if (index == (threadMessagesList.length - 1)) {
          isSameDate = false;
        } else {
          ThreadMessage nextItem = threadMessagesList[index + 1];
          String currMessageDate = item.messageDate ?? "";
          String prevMessageDate = nextItem.messageDate ?? "";

          if (currMessageDate == prevMessageDate) {
            isSameDate = true;
          } else {
            isSameDate = false;
          }
        }

        return ThreadMessageListItemWidget(
          currentUserId: currentUserId,
          showMessageDate: !isSameDate,
          propertyTitle: propertyTitle,
          senderId: senderId,
          senderDisplayName: senderDisplayName,
          senderPictureUrl: senderPictureUrl,
          receiverId: receiverId,
          receiverDisplayName: receiverDisplayName,
          receiverPictureUrl: receiverPictureUrl,
          item: item,
          listener: (refreshPage) => listener(refreshPage),
        );
      },
    );
  }
}

typedef ThreadMessageListItemWidgetListener = void Function(bool refreshPage);
class ThreadMessageListItemWidget extends StatelessWidget {
  final ThreadMessage item;
  final ThreadMessageListItemWidgetListener listener;
  final String propertyTitle;
  final String senderId;
  final String senderDisplayName;
  final String senderPictureUrl;
  final String receiverId;
  final String receiverDisplayName;
  final String receiverPictureUrl;
  final String currentUserId;
  final bool showMessageDate;

  const ThreadMessageListItemWidget({
    super.key,
    required this.item,
    required this.listener,
    required this.propertyTitle,
    required this.senderId,
    required this.senderDisplayName,
    required this.senderPictureUrl,
    required this.receiverId,
    required this.receiverDisplayName,
    required this.receiverPictureUrl,
    required this.currentUserId,
    required this.showMessageDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (showMessageDate) MessageDateWidget(date: item.messageDate ?? ""),

          MessageContentWidget(
            time: item.messageTime ?? "",
            message: item.message ?? "",
            isCurrentUser: item.createdBy == currentUserId,
          ),
          // Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),)
        ],
      ),
    );
  }

  String getMessageAuthorName(ThreadMessage item) {
    if (item.createdBy == senderId) {
      if (currentUserId == senderId) {
        return "Me";
      } else {
        return senderDisplayName;
      }
    } else {
      if (currentUserId == receiverId) {
        return "Me";
      } else {
        return receiverDisplayName;
      }
    }
  }

  String getMessageAuthorPicture(ThreadMessage item) {
    if (item.createdBy == senderId) {
      return senderPictureUrl;
    } else {
      return receiverPictureUrl;
    }
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
