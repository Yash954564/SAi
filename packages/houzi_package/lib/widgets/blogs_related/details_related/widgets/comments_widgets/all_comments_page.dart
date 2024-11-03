import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/blog_models/blog_comments_data.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/comments_widgets/all_comments_widgets/all_comments_widgets.dart';
import 'package:houzi_package/widgets/no_internet_error_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:houzi_package/models/api/api_response.dart';

class AllCommentsPage extends StatefulWidget {
  final String postId;

  const AllCommentsPage({
    super.key,
    required this.postId,
  });

  @override
  State<AllCommentsPage> createState() => _AllCommentsPageState();
}

class _AllCommentsPageState extends State<AllCommentsPage> {

  late FocusNode myFocusNode;

  String userRole = "";

  int page = 1;
  int perPage = 100;

  bool isLoading = false;
  bool isLoggedIn = false;
  bool isRefreshing = false;
  bool shouldLoadMore = true;
  bool isInternetConnected = true;

  List<BlogComment> commentsList = [];

  Future<BlogCommentsData?>? _futureBlogCommentsData;

  final PropertyBloc _propertyBloc = PropertyBloc();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  late TextEditingController textFieldController;

  // Posting Comment Related
  String nonce = "";
  String content = "";
  String postId = "";
  String isUpdate = "0";
  String commentId = "";
  String commentParentId = "";
  String authorEmail = "";
  String authorName = "";
  bool showLoadingWidget = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // State Management
  bool editingAComment = false;
  bool replyingAComment = false;

  @override
  void initState() {
    super.initState();

    fetchNonce();
    loadDataFromApi();
    myFocusNode = FocusNode();
    textFieldController = TextEditingController();
    textFieldController.text = "";

    userRole = HiveStorageManager.getUserRole();
    if (Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn!) {
      setState(() {
        isLoggedIn = true;
      });
    }

    if (isLoggedIn) {
      authorName = HiveStorageManager.getUserName() ?? "";
      authorEmail = HiveStorageManager.getUserEmail() ?? "";
    }
  }

  @override
  void dispose() {
    textFieldController.dispose();
    _refreshController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
          appBar: AppBarWidget(
            appBarTitle: "Comments",
            centerTitle: true,
          ),
          bottomNavigationBar: AllCommentsBottomActionBar(
            readOnly: isLoggedIn ? false : true,
            onTap: isLoggedIn ? null : ()=> showLoginPageToast(context),
            controller: textFieldController,
            focusNode: myFocusNode,
            formKey: formKey,
            onSaved: (content) => onSavedFunc(content),
            onPostACommentPressed: ()=> onPostACommentPressed(),
          ),
          body: isInternetConnected == false ? Align(
            alignment: Alignment.topCenter,
            child: NoInternetConnectionErrorWidget(onPressed: ()=> loadDataFromApi()),
          ) : SmartRefresher(
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
            onRefresh: () => onRefresh(),
            onLoading: () => loadDataFromApi(forPullToRefresh: false),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      CommentsListingWidget(
                        userRole: userRole,
                        future: _futureBlogCommentsData,
                        onEditPressed: (comment)=> onEditPressed(comment),
                        onReplyPressed: (comment)=> onReplyPressed(comment),
                        listener: (loadingComplete) {
                          isLoading = false;
                        },
                      ),
                    ],
                  ),
                  AllCommentsLoadingWidget(makeVisible: showLoadingWidget),
                ],
              ),
            ),
          ),
      ),
    );
  }

  void onRefresh() {
    shouldLoadMore = true;
    loadDataFromApi();
  }

  void onEditPressed(BlogComment comment) {
    if (!isLoggedIn) {
      showLoginPageToast(context);
    } else {
      editingAComment = true;
      replyingAComment = false;
      textFieldController.text = comment.commentContent ?? "";
      myFocusNode.requestFocus();
      commentId = comment.commentId ?? "";
    }
  }

  void onReplyPressed(BlogComment comment) {
    textFieldController.text = "";
    if (!isLoggedIn) {
      showLoginPageToast(context, reply: true);
    } else {
      replyingAComment = true;
      editingAComment = false;
      myFocusNode.requestFocus();
      commentParentId = comment.commentId ?? "";
    }
  }

  Future<void> onPostACommentPressed() async {
    FocusScope.of(context).unfocus();
    if (!isLoggedIn) {
      showLoginPageToast(context);
    } else {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (mounted) {
          setState(() {
            showLoadingWidget = true;
          });
        }

        Map<String, dynamic> dataMap = {
          COMMENT_CONTENT : content,
          COMMENT_POST_ID : widget.postId,
          COMMENT_IS_UPDATE : isUpdate,
          COMMENT_AUTHOR_EMAIL : authorEmail,
          COMMENT_AUTHOR_NAME : authorName,
        };

        if (editingAComment) {
          isUpdate = "1";
          dataMap[COMMENT_ID] = commentId;
          dataMap[COMMENT_IS_UPDATE] = isUpdate;
          // print("Editing a comment...");
        } else {
          isUpdate = "0";
          commentId = "";
        }

        if (replyingAComment) {
          dataMap[COMMENT_PARENT_ID] = commentParentId;
          // print("Replying to a comment...");
        } else {
          commentParentId = "";
        }

        // if (!editingAComment && !replyingAComment) {
        //   print("Adding a new comment...");
        // }

        ApiResponse response = await _propertyBloc.fetchBlogAddCommentResponse(dataMap, nonce);
        if (mounted) {
          setState(() {
            showLoadingWidget = false;
          });
        }

        if (response.success) {
          ShowToastWidget(buildContext: context, text: response.message);
          textFieldController.text = "";
          isUpdate = "0";
          replyingAComment = false;
          editingAComment = false;
          onRefresh();
        } else {
          ShowToastWidget(buildContext: context, text: response.message);
        }
      }
    }
  }

  void onSavedFunc(String? text) {
    if (mounted) {
      setState(() {
        content = text ?? "";
      });
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
      });

      page = 1;
      _futureBlogCommentsData = fetchCommentsData(page, perPage);
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
      _futureBlogCommentsData = fetchCommentsData(page, perPage);
      _refreshController.loadComplete();
    }
  }

  Future<BlogCommentsData?> fetchCommentsData(int page, int perPage) async {
    Map<String, dynamic> dataMap = {
      "page" : page.toString(),
      "per_page" : perPage.toString(),
      "post_id" : widget.postId,
    };

    var(success, internet, commentsData) = await _propertyBloc.fetchBlogAllComments(dataMap);
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
        commentsList = [];
      }
      if (commentsData != null) {
        List<BlogComment>? tempList = commentsData.commentsList;

        if (tempList != null && tempList.isNotEmpty) {
          commentsList.addAll(tempList);
          commentsData.commentsList = commentsList;
        } else if (commentsList.isNotEmpty) {
          commentsData.commentsList = commentsList;
        }

        if (tempList == null || tempList.isEmpty || tempList.length < perPage) {
          if (mounted) {
            setState(() {
              shouldLoadMore = false;
            });
          }
        }
      }

      return commentsData;
    }

    return null;
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchAddCommentNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  showLoginPageToast(BuildContext context, {bool? reply = false}) {
    ShowToastWidget(
      buildContext: context,
      showButton: true,
      buttonText: UtilityMethods.getLocalizedString("login"),
      text: reply == true
          ? "You must login before replying a comment"
          : "You must login before adding a comment",
      toastDuration: 4,
      onButtonPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserSignIn(
                  (String closeOption) {
                if (closeOption == CLOSE) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        );
      },
    );
  }
}