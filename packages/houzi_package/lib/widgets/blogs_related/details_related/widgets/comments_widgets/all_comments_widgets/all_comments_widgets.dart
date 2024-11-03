import 'package:flutter/material.dart';

import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/blog_models/blog_comments_data.dart';
import 'package:houzi_package/pages/property_details_related_pages/bottom_buttons_action_bar.dart';
import 'package:houzi_package/widgets/blogs_related/design_layouts/blog_layout_widgets.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/no_result_error_widget.dart';

typedef CommentsListingWidgetListener = void Function(bool loadingComplete);
class CommentsListingWidget extends StatelessWidget {
  final String userRole;
  final Future<BlogCommentsData?>? future;
  final void Function(BlogComment) onReplyPressed;
  final void Function(BlogComment) onEditPressed;
  final CommentsListingWidgetListener listener;

  const CommentsListingWidget({
    super.key,
    required this.userRole,
    required this.future,
    required this.listener,
    required this.onReplyPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (future == null) {
      return NoCommentsFoundWidget();
    }
    return FutureBuilder<BlogCommentsData?>(
      future: future,
      builder: (context, articleSnapshot) {
        listener(true);
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data == null ||
              articleSnapshot.data!.commentsList == null ||
              articleSnapshot.data!.commentsList!.isEmpty) {
            return NoCommentsFoundWidget();
          }

          List<BlogComment> list = articleSnapshot.data!.commentsList!;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list.map<Widget>((comment) {
                return SingleCommentWidget(
                  comment: comment,
                  role: userRole,
                  onEditPressed: (comment)=> onEditPressed(comment),
                  onReplyPressed: (comment)=> onReplyPressed(comment),
                );
              }).toList(),
            ),
          );
        } else if (articleSnapshot.hasError) {
          return NoCommentsFoundWidget();
        }
        return LoadingWidget();
      },
    );
  }
}

class SingleCommentWidget extends StatelessWidget {
  final BlogComment comment;
  final String role;
  final void Function(BlogComment) onReplyPressed;
  final void Function(BlogComment) onEditPressed;

  const SingleCommentWidget({
    super.key,
    required this.comment,
    required this.role,
    required this.onReplyPressed,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlogLayoutUserAvatarWidget(
            userAvatarUrl: comment.commentAuthorAvatar ?? "",
            height: 60,
            width: 60,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: GenericTextWidget(
                    comment.commentAuthor ?? "",
                    style: AppThemePreferences().appTheme.blogCommentAuthorNameTextStyle,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: GenericTextWidget(
                    comment.commentContent ?? "",
                    strutStyle: StrutStyle(height: AppThemePreferences.blogCommentContentHeight),
                    style: AppThemePreferences().appTheme.blogCommentContentTextStyle,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      GenericTextWidget(
                        getCommentDate(comment),
                        style: AppThemePreferences().appTheme.blogCommentActionsTextStyle,
                      ),

                      if (role == ROLE_ADMINISTRATOR && getCommentDate(comment).isNotEmpty)
                        const SizedBox(width: 10),
                      if (role == ROLE_ADMINISTRATOR)
                        EditWidget(onPressed: ()=> onEditPressed(comment)),

                      if (role == ROLE_ADMINISTRATOR ||
                          (role != ROLE_ADMINISTRATOR && getCommentDate(comment).isNotEmpty))
                        const SizedBox(width: 10),
                      ReplyWidget(onPressed: ()=> onReplyPressed(comment)),
                    ],
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  String getCommentDate(BlogComment comment) {
    return (comment.commentDateFormatted ?? "");
  }
}

class AllCommentsBottomActionBar extends StatefulWidget {
  final FocusNode? focusNode;
  final void Function() onPostACommentPressed;
  final GlobalKey<FormState> formKey;
  final void Function(String? content) onSaved;
  final TextEditingController? controller;
  final bool readOnly;
  final void Function()? onTap;

  const AllCommentsBottomActionBar({
    super.key,
    this.focusNode,
    required this.onPostACommentPressed,
    required this.formKey,
    required this.onSaved,
    this.controller,
    this.readOnly = false,
    this.onTap,
  });

  @override
  State<AllCommentsBottomActionBar> createState() => _AllCommentsBottomActionBarState();
}

class _AllCommentsBottomActionBarState extends State<AllCommentsBottomActionBar> with ValidationMixin {
  bool notAValidString = false;
  int maxLines = 1;
  int maxLength = 40;
  double height = 110;

  int defaultMaxLines = 1;
  double defaultHeight = 110;
  int extendedMaxLines = 4;
  double extendedMaxHeight = 180;

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null && widget.controller!.text.length >= maxLength) {
      maxLines = extendedMaxLines;
      height = extendedMaxHeight;
    } else {
      maxLines = defaultMaxLines;
      height = defaultHeight;
    }

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: AppThemePreferences().appTheme.backgroundColor,
        border: Border(
          top: AppThemePreferences().appTheme.propertyDetailsPageBottomMenuBorderSide!,
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: notAValidString ? 131 : height,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Form(
                    key: widget.formKey,
                    child: TextFormFieldWidget(
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                      maxLines: maxLines,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      padding: const EdgeInsets.only(top: 3),
                      hintText: "Type your comment",
                      validator: (value) {
                        if (mounted) {
                          setState(() {
                            if (validateTextField(value) != null) {
                              notAValidString = true;
                            } else {
                              notAValidString = false;
                            }
                          });
                        }
                        return validateTextField(value);
                      },
                      onSaved: (content) => widget.onSaved(content),
                      onChanged: (content) {
                        setState(() {
                          if (content != null && content.length >= maxLength) {
                            maxLines = extendedMaxLines;
                            height = extendedMaxHeight;
                          } else {
                            maxLines = defaultMaxLines;
                            height = defaultHeight;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(bottom: notAValidString ? 21 : 0),
                    child: SmallButtonWidget(
                      buttonHeight: 65,
                      buttonWidth: 65,
                      onPressed: ()=> widget.onPostACommentPressed(),
                      icon: Icon(
                        AppThemePreferences.sendIcon,
                        color: AppThemePreferences.blogPostCommentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditWidget extends StatelessWidget {
  final void Function() onPressed;

  const EditWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onPressed(),
      child: Row(
        children: [
          Icon(
            AppThemePreferences.editIcon,
            size: 20,
            color: AppThemePreferences.blogCommentActionsColor,
          ),
          const SizedBox(width: 2),
          GenericTextWidget(
            "edit_small_caps",
            style: AppThemePreferences().appTheme.blogCommentActionsTextStyle,
          ),
        ],
      ),
    );
  }
}

class ReplyWidget extends StatelessWidget {
  final void Function() onPressed;

  const ReplyWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> onPressed(),
      child: Row(
        children: [
          Icon(
            AppThemePreferences.replyOutlined,
            color: AppThemePreferences.blogCommentActionsColor,
          ),
          const SizedBox(width: 4),
          GenericTextWidget(
            "reply",
            style: AppThemePreferences().appTheme.blogCommentActionsTextStyle,
          ),
        ],
      ),
    );
  }
}

class NoCommentsFoundWidget extends StatelessWidget {
  const NoCommentsFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 180),
      child: NoResultErrorWidget(
        headerErrorText: "No Comments Yet",
        bodyErrorText: "Start The Discussion",
        hideErrorIcon: true,
        hideGoBackButton: true,
      ),
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
      color: Theme.of(context).canvasColor,
      alignment: Alignment.center,
      child: const Column(
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

class AllCommentsLoadingWidget extends StatelessWidget {
  final bool makeVisible;

  const AllCommentsLoadingWidget({
    super.key,
    required this.makeVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (makeVisible) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: const SizedBox(
              width: 80,
              height: 20,
              child: BallBeatLoadingWidget(),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}