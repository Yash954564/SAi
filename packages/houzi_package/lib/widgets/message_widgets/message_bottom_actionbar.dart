import 'package:flutter/material.dart';
import 'package:houzi_package/Mixins/validation_mixins.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';


class MessagesBottomActionBar extends StatefulWidget {
  final bool readOnly;
  final bool showLoader;
  final FocusNode? focusNode;
  final GlobalKey<FormState> formKey;
  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function() onSendMessagePressed;
  final void Function(String? content) onSaved;

  const MessagesBottomActionBar({
    super.key,
    this.focusNode,
    required this.onSendMessagePressed,
    required this.formKey,
    required this.onSaved,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.showLoader = false,
  });

  @override
  State<MessagesBottomActionBar> createState() => _MessagesBottomActionBarState();
}

class _MessagesBottomActionBarState extends State<MessagesBottomActionBar> with ValidationMixin {
  bool notAValidString = false;
  int maxLines = 1;
  int maxLength = 40;
  double height = 66;

  int defaultMaxLines = 1;
  double defaultHeight = 66;
  int extendedMaxLines = 4;
  double extendedMaxHeight = 140;

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
        child: Container(
          color: AppThemePreferences().appTheme.messageTextFieldOuterBgColor,
          height: notAValidString ? 90 : height,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Form(
                    key: widget.formKey,
                    child: TextFormFieldWidget(
                      hideBorder: true,
                      backgroundColor: AppThemePreferences().appTheme.messageTextFieldInnerBgColor,
                      readOnly: widget.readOnly,
                      onTap: widget.onTap,
                      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      maxLines: maxLines,
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      padding: const EdgeInsets.only(top: 3),
                      hintText: "Type your message",
                      hintTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppThemePreferences().appTheme.messageTimeTextColor,
                      ),
                      borderRadius: BorderRadius.circular(30),
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
                if (widget.showLoader == true) Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: BallRotatingLoadingWidget(),
                    ),
                  ),
                ),
                if (widget.showLoader != true) InkWell(
                  onTap: ()=> widget.onSendMessagePressed(),
                  child: Container(
                    width: 45, height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppThemePreferences.appPrimaryColor,
                    ),
                    child: Center(
                      child: Icon(
                        AppThemePreferences.sendIcon,
                        color: AppThemePreferences().appTheme.sendMessageIconColor,
                        // color: AppThemePreferences.sendMessageIconColor,
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