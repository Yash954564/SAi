import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/models/floor_plans.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:path_provider/path_provider.dart';

class PropertyDetailPageAttachments extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageAttachments({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageAttachments> createState() =>
      _PropertyDetailPageDescriptionState();
}

class _PropertyDetailPageDescriptionState extends State<PropertyDetailPageAttachments> {
  Article? _article;
  String title = UtilityMethods.getLocalizedString("Property Documents");
  List<Attachment> attachmentList = [];


  @override
  void initState() {
    _article = widget.article;
    loadData(_article!);
    super.initState();
  }

  loadData(Article article) {
    attachmentList = article.features!.attachments ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return attachmentList.isEmpty
        ? Container()
        : Column(
            children: [
              textHeadingWidget(
                text: UtilityMethods.getLocalizedString(
                    widget.title.isEmpty ? title : widget.title),
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              ),
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                itemCount: attachmentList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: AttachmentWidgetBody(attachment: attachmentList[index]),
                    // child: AttachmentWidget(
                    //   attachment: attachmentList[index],
                    // ),
                  );
                },
              )
            ],
          );
  }
}

class AttachmentWidgetBody extends StatelessWidget {
  final Attachment attachment;

  const AttachmentWidgetBody({
    Key? key,
    required this.attachment
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(attachment.url);
        if (attachment.url != null && attachment.url!.isNotEmpty) {
          try {
            final dio = Dio();
            String savePath = "";
            if (Platform.isAndroid) {
              // We need to save the file to the download directory of device
              final directory = Directory('/storage/emulated/0/Download');
              savePath = directory.path;
            } else if (Platform.isIOS) {
              final directory = await getApplicationDocumentsDirectory();
              savePath = directory.path;
            }

            final filename = attachment.name;
            savePath = '$savePath/$filename';

            int randomID = Random().nextInt(1000);

            await dio.download(attachment.url!, savePath, onReceiveProgress: (received, total){
              print("received: $received");
              print("total: $total");

              print("randomID: $randomID");

              String title = 'Download in Progress';
              bool uploadComplete = false;

              if(received == total) {
                title = 'Download Complete';
                uploadComplete = true;
              }



              var notifications = FlutterLocalNotificationsPlugin();
              var progress = (received / total) * 100;
              notifications.show(
                randomID,
                APP_NAME,
                title,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    APP_NAME,
                    '$APP_NAME Download',
                    channelDescription:
                    'Installed when you activate the Flutter Uploader Example',
                    progress: progress.toInt(),
                    // icon: 'cloud_upload_outlined',
                    icon: 'ic_upload',
                    enableVibration: false,
                    importance: Importance.low,
                    showProgress: !uploadComplete,
                    onlyAlertOnce: !uploadComplete,
                    maxProgress: uploadComplete ? 0 : 100,
                    channelShowBadge: false,
                  ),
                  iOS: const DarwinNotificationDetails(),
                  // iOS: const IOSNotificationDetails(),
                ),
              );
            });
          } catch (e, s) {
            print(e);
          }

        }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Row(
              children: [
                Transform.rotate(
                  angle: 45 * pi / 180,
                  child: Icon(AppThemePreferences.attachmentIcon),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: UtilityMethods.isRTL(context) ? 0.0 :  10.0,
                    right: UtilityMethods.isRTL(context) ? 10.0 :  0.0,
                  ),
                  child: GenericTextWidget(
                      attachment.name ??
                          UtilityMethods.getLocalizedString("Attached File")),
                ),
              ],
            ),
            Expanded(child: Container()),
            Icon(AppThemePreferences.downloadIcon),
          ],
        ),
      ),
    );
  }
}

class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;

  const AttachmentWidget({required this.attachment, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(attachment.url);
        if (attachment.url != null && attachment.url!.isNotEmpty) {
          try {
            final dio = Dio();
            String savePath = "";
            if (Platform.isAndroid) {
              // We need to save the file to the download directory of device
              final directory = Directory('/storage/emulated/0/Download');
              savePath = directory.path;
            } else if (Platform.isIOS) {
              final directory = await getApplicationDocumentsDirectory();
              savePath = directory.path;
            }

            final filename = attachment.name;
            savePath = '$savePath/$filename';

            int? randomID = null;

            await dio.download(attachment.url!, savePath, onReceiveProgress: (received, total){
              print("received: $received");
              print("total: $total");
              if(randomID == null) {
                randomID = Random().nextInt(1000);
              }

              print("randomID: $randomID");

              String title = 'Download in Progress';
              bool uploadComplete = false;

              if(received == total) {
                title = 'Download Complete';
                uploadComplete = true;
              }



              var notifications = FlutterLocalNotificationsPlugin();
              var progress = (received / total) * 100;
              notifications.show(
                randomID!,
                APP_NAME,
                title,
                NotificationDetails(
                  android: AndroidNotificationDetails(
                    APP_NAME,
                    '$APP_NAME Download',
                    channelDescription:
                    'Installed when you activate the Flutter Uploader Example',
                    progress: progress.toInt(),
                    // icon: 'cloud_upload_outlined',
                    icon: 'ic_upload',
                    enableVibration: false,
                    importance: Importance.low,
                    showProgress: !uploadComplete,
                    onlyAlertOnce: !uploadComplete,
                    maxProgress: uploadComplete ? 0 : 100,
                    channelShowBadge: false,
                  ),
                  iOS: const DarwinNotificationDetails(),
                  // iOS: const IOSNotificationDetails(),
                ),
              );
            });
          } catch (e, s) {
            print(e);
          }

        }

      },
      child: Row(
        children: [
          Icon(AppThemePreferences.attachmentIcon),
          GenericTextWidget(
            attachment.name ??
                UtilityMethods.getLocalizedString("Attached File"),
          )
        ],
      ),
    );
  }
}