import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class UploadPropertyCompactWidget extends StatelessWidget {
  final int? uploadProgress;
  final Article article;
  final Widget? bottomFAB;

  const UploadPropertyCompactWidget({
    super.key,
    required this.uploadProgress,
    required this.article,
    this.bottomFAB,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.only(
        bottom: bottomFAB == null
            ? kBottomNavigationBarHeight : 10,
      ),
      child: FloatingActionButton(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor:
        // AppThemePreferences().appTheme.articleDesignItemBackgroundColor,
        AppThemePreferences.appPrimaryColor,
        child: Row(
          children: [
            ImageWidget(imagePath: article.image!),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UploadProgressWidget(progress: uploadProgress),
                ],
              ),
            ),
          ],
        ),

        onPressed: () {
          /// Navigate to Properties and show uploading progress.
          UtilityMethods.navigateToRoute(
            context: context,
            builder: (context) => Properties(
              showUploadingProgress: true,
              uploadProgress: uploadProgress,
            ),
          );
        },
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final String? imagePath;

  const ImageWidget({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    bool _validURL = (imagePath != null && imagePath!.isNotEmpty) ? true : false;
    return Container(
      padding: EdgeInsets.only(left: 10),
      height: 40,
      width: 50,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        // child: !_validURL ? ErrorWidget() : Image.asset(
        //   imagePath!,
        child: !_validURL ? ErrorWidget() : Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class UploadProgressWidget extends StatelessWidget {
  final int? progress;

  const UploadProgressWidget({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: GenericTextWidget(
                    '${UtilityMethods.getLocalizedString('Uploading')} ${progress ?? 0} %',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress != null ? (progress! / 100) : 0,
                    color: Colors.white,
                    backgroundColor: AppThemePreferences.appPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ErrorWidget extends StatelessWidget {
  const ErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppThemePreferences().appTheme.shimmerEffectErrorWidgetBackgroundColor,
      child: Center(child: AppThemePreferences().appTheme.shimmerEffectImageErrorIcon),
    );
  }
}