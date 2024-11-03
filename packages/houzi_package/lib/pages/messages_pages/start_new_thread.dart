import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/mixins/validation_mixins.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/message_widgets/message_author_info.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';

class StartNewThreadWidget extends StatefulWidget {
  final int propertyId;
  final String realtorName;
  final String realtorPicture;

  const StartNewThreadWidget({
    super.key,
    required this.propertyId,
    required this.realtorName,
    required this.realtorPicture,
  });

  @override
  State<StartNewThreadWidget> createState() => _StartNewThreadWidgetState();
}

class _StartNewThreadWidgetState extends State<StartNewThreadWidget> with ValidationMixin {

  bool isInternetConnected = true;
  String message = '';
  String nonce = '';

  final PropertyBloc _propertyBloc = PropertyBloc();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchNonce();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBarWidget(
          appBarTitle: "Messages",
          leadingWidth: 28,
          title: RealtorInfoWidget(
            name: widget.realtorName,
            pictureUrl: widget.realtorPicture,
          ),
        ),
        bottomNavigationBar: !isInternetConnected
            ? NoInternetBottomActionBarWidget(
                onPressed: () => onSendMessagePressed())
            : null,
        body: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      TextFormFieldWidget(
                        padding: const EdgeInsets.only(top: 20.0),
                        labelText: "message",
                        hintText: "enter_your_msg",
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        validator: (value) => validateTextField(value!),
                        onSaved: (value) {
                          setState(() {
                            message = value!;
                          });
                        },
                      ),
                      SendMessageButtonWidget(
                        onPressed: ()=> onSendMessagePressed(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onSendMessagePressed() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showWaitingDialogBoxWidget(context: context);

      ApiResponse response = await _propertyBloc.fetchStartMessageThreadResponse(widget.propertyId, message, nonce);
      // Close the waiting dialog box
      Navigator.pop(context);

      if (response.success) {
        ShowToastWidget(buildContext: context, text: response.message);
        // Close the message screen
        Navigator.pop(context);
      } else {
        ShowToastWidget(buildContext: context, text: response.message);
      }

    }
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchStartThreadNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }
}

class SendMessageButtonWidget extends StatelessWidget {
  final void Function() onPressed;

  const SendMessageButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
      child: Center(
        child: ButtonWidget(
          text: "Send Message",
          onPressed: ()=> onPressed(),
        ),
      ),
    );
  }
}

class RealtorInfoWidget extends StatelessWidget {
  final String name;
  final String pictureUrl;

  const RealtorInfoWidget({
    super.key,
    required this.name,
    required this.pictureUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MessageAuthorAvatarWidget(
          width: 45, height: 45,
          avatarUrl: pictureUrl,
          boxFit: BoxFit.fill,
          errorWidget: Container(
            color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
            child: Center(
              child: Icon(
                AppThemePreferences.imageIcon,
                color: AppThemePreferences().appTheme.shimmerEffectErrorIconColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: GenericTextWidget(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}