import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/message_widgets/message_author_info.dart';
import 'package:houzi_package/widgets/message_widgets/message_property_info.dart';

class MessageReceiverInfoWidget extends StatelessWidget {
  final String name;
  final String pictureUrl;
  final String propertyTitle;
  final String propertyId;
  final void Function() onTap;

  const MessageReceiverInfoWidget({
    super.key,
    required this.name,
    required this.pictureUrl,
    required this.propertyTitle,
    required this.propertyId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MessageAuthorAvatarWidget(
          width: 45, height: 45,
          avatarUrl: pictureUrl,
          onTap: ()=> onTap(),
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
              Container(
                padding: const EdgeInsets.only(top: 2),
                child: InkWell(
                  onTap: (){
                    int? id;
                    if (propertyId.isNotEmpty) {
                      id = int.tryParse(propertyId);
                    }
                    UtilityMethods.navigateToPropertyDetailPage(
                      context: context,
                      propertyID: id,
                      heroId: id.toString(),
                    );
                  },
                  child: GenericTextWidget(
                    propertyTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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

class MessageReceiverInfoWidgetOld extends StatelessWidget {
  final String name;
  final String pictureUrl;
  final String propertyTitle;
  final String status;

  const MessageReceiverInfoWidgetOld({
    super.key,
    required this.name,
    required this.pictureUrl,
    required this.propertyTitle,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: AppThemePreferences.messagePageElevation,
      child: Container(
        color: Colors.white,
        height: 105,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageAuthorAvatarWidget(
                width: 50, height: 50,
                avatarUrl: pictureUrl,
                onTap: (){},
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessageAuthorNameWidget(
                      name: name,
                      useHeadingTextStyle: false,
                      padding: const EdgeInsets.only(top: 0),
                    ),
                    MessagePropertyTitleWidget(
                      propertyTitle: propertyTitle,
                      padding: const EdgeInsets.only(top: 8),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          GenericTextWidget(
                            status,
                            style: status == 'Online'
                              ? AppThemePreferences().appTheme.messageUserStatusOnlineTextStyle
                              : AppThemePreferences().appTheme.messageUserStatusOfflineTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
