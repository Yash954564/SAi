import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/models/blog_models/blog_articles_data.dart';
import 'package:houzi_package/models/blog_models/blog_comments_data.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widgets.dart';
import 'package:houzi_package/widgets/blogs_related/details_related/widgets/comments_widgets/all_comments_page.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:provider/provider.dart';


class BlogDetailsLayoutCommentsWidget extends StatefulWidget {
  final BlogArticle article;

  const BlogDetailsLayoutCommentsWidget({
    super.key,
    required this.article,
  });

  @override
  State<BlogDetailsLayoutCommentsWidget> createState() => _BlogDetailsLayoutCommentsWidgetState();
}

class _BlogDetailsLayoutCommentsWidgetState extends State<BlogDetailsLayoutCommentsWidget> {

  String page = "1";
  String perPage = "3";
  String articleId = "";

  bool isLoggedIn = false;
  bool isInternetConnected = true;


  final PropertyBloc _propertyBloc = PropertyBloc();
  Future<BlogCommentsData?>? _futureBlogCommentsData;
  
  @override
  void initState() {
    articleId = (widget.article.id) != null
        ? (widget.article.id!).toString() : "";

    if (Provider.of<UserLoggedProvider>(context,listen: false).isLoggedIn!) {
      setState(() {
        isLoggedIn = true;
      });
    }

    _futureBlogCommentsData = fetchCommentsData();

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!isInternetConnected) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderWidget(text: "Comments"),
          CommentsListingWidget(
            future: _futureBlogCommentsData,
            onWriteCommentPressed: ()=> onWriteACommentPressed(),
            onViewAllPressed: ()=> onViewAllPressed(),
          ),
        ],
      ),
    );
  }

  void onWriteACommentPressed() {
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllCommentsPage(postId: articleId),
        ),
      );
    } else {
      showLoginPageToast(context);
    }
  }

  void onViewAllPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCommentsPage(postId: articleId),
      ),
    );
  }

  Future<BlogCommentsData?> fetchCommentsData() async {
    Map<String, dynamic> dataMap = {
      "page" : page,
      "per_page" : perPage,
      "post_id" : articleId,
    };

    var(success, internet, commentsData) = await _propertyBloc.fetchBlogAllComments(dataMap);
    if (mounted) {
      setState(() {
        isInternetConnected = internet;
      });
    }

    if (success) {
      return commentsData;
    }

    return null;
  }

  showLoginPageToast(BuildContext context) {
    ShowToastWidget(
      buildContext: context,
      showButton: true,
      buttonText: UtilityMethods.getLocalizedString("login"),
      text: "You must login before adding a comment",
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

  showToastWidget(BuildContext context, String msg, bool forLogin) {
    !forLogin ? ShowToastWidget(
      buildContext: context,
      text: msg,
    ) : ShowToastWidget(
      buildContext: context,
      showButton: true,
      buttonText: UtilityMethods.getLocalizedString("login"),
      text: msg,
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

class CommentsListingWidget extends StatelessWidget {
  final void Function() onWriteCommentPressed;
  final void Function() onViewAllPressed;
  final Future<BlogCommentsData?>? future;

  const CommentsListingWidget({
    super.key,
    required this.future,
    required this.onWriteCommentPressed,
    required this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return WriteACommentWidget(onPressed: ()=> onWriteCommentPressed());
    }
    return FutureBuilder<BlogCommentsData?>(
      future: future,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data == null &&
              articleSnapshot.data!.commentsList == null &&
              articleSnapshot.data!.commentsList!.isEmpty) {
            return WriteACommentWidget(onPressed: onWriteCommentPressed);
          }

          List<BlogComment> list = articleSnapshot.data!.commentsList!;

          if (list.length > 3) {
            list = list.sublist(0, 3);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: list.map<Widget>((comment) {
                      return SingleCommentWidget(comment: comment);
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WriteACommentWidget(onPressed: () => onWriteCommentPressed()),
                      ViewAllCommentsWidget(onPressed: () =>onViewAllPressed()),
                    ],
                  )
                ],
              ),
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container();
      },
    );;
  }
}

class SingleCommentWidget extends StatelessWidget {
  final BlogComment comment;

  const SingleCommentWidget({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 2.0),
      elevation: AppThemePreferences.commentsElevation,
      shape: AppThemePreferences.roundedCorners(AppThemePreferences.commentsRoundedCornersRadius),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlogLayoutUserAvatarWidget(
                      userAvatarUrl: comment.commentAuthorAvatar ?? "",
                    ),
                    const SizedBox(width: 8),
                    GenericTextWidget(
                      comment.commentAuthor ?? "",
                      style: AppThemePreferences().appTheme.blogAuthorInfoTextStyle,
                    ),
                  ],
                ),

                GenericTextWidget(
                  comment.commentDateFormatted ?? "",
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.only(top: 8),
              child: GenericTextWidget(comment.commentContent ?? ""),
            ),
          ],
        ),
      ),
    );
  }
}

class WriteACommentWidget extends StatelessWidget {
  final void Function() onPressed;

  const WriteACommentWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButtonWidget(
      onPressed: ()=> onPressed(),
      child: GenericTextWidget(
        "Write a Comment",
        style: AppThemePreferences().appTheme.readMoreTextStyle,
      ),
    );
  }
}

class ViewAllCommentsWidget extends StatelessWidget {
  final void Function() onPressed;

  const ViewAllCommentsWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButtonWidget(
      onPressed: ()=> onPressed(),
      child: GenericTextWidget(
        "view_all",
        style: AppThemePreferences().appTheme.readMoreTextStyle,
      ),
    );
  }
}