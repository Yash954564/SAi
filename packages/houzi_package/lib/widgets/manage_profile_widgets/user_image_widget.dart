import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';
import 'package:image_picker/image_picker.dart';

typedef ManageProfileUserImageWidgetListener = Function(bool showUploadPhotoButton, File? imageFile);

class ManageProfileUserImageWidget extends StatefulWidget {
  final String userAvatar;
  final bool showWaitingWidgetForPicUpload;
  final ManageProfileUserImageWidgetListener listener;

  const ManageProfileUserImageWidget({
    Key? key,
    required this.userAvatar,
    required this.showWaitingWidgetForPicUpload,
    required this.listener,
  }) : super(key: key);

  @override
  State<ManageProfileUserImageWidget> createState() => _ManageProfileUserImageWidgetState();
}

class _ManageProfileUserImageWidgetState extends State<ManageProfileUserImageWidget> {

  File? imageFile;
  
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
              onTap: () => chooseImageDialog(context),
              child: ImageWidget(
                userAvatar: widget.userAvatar,
                imageFile: imageFile,
                showLoadingWidget: widget.showWaitingWidgetForPicUpload,
              ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 90,
          right: 0,
          child: GestureDetector(
            onTap: () => chooseImageDialog(context),
            child: CircleAvatar(
              radius: 13,
              backgroundColor: AppThemePreferences().appTheme.selectedItemTextColor,
              child: Icon(
                AppThemePreferences.editIcon,
                size: AppThemePreferences.editProfilePictureIconSize,
                color:  AppThemePreferences.filledButtonIconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  chooseImageDialog(BuildContext context) {
    ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("select_image"),
      style: AppThemePreferences().appTheme.heading02TextStyle!,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () {
              _getImageFile(ImageSource.camera);
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString("from_camera"),
                  style: AppThemePreferences().appTheme.bodyTextStyle,
                )),
          ),
          const Divider(thickness: 1),
          InkWell(
            onTap: () {
              _getImageFile(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString("from_gallery"),
                  style: AppThemePreferences().appTheme.bodyTextStyle,
                )),
          ),
        ],
      ),
    );
  }

  Future _getImageFile(ImageSource source) async {
    var pickedFile = await picker.pickImage(
        source: source,
        maxHeight: 1000,
        maxWidth: 1000,
    );

    if (pickedFile != null) {
      if(mounted) setState(() {
        imageFile = File(pickedFile.path);
        widget.listener(true, imageFile);
      });
      ImageWidget(
        userAvatar: widget.userAvatar,
        imageFile: imageFile,
        showLoadingWidget: widget.showWaitingWidgetForPicUpload,
      );
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }
}

class ImageWidget extends StatelessWidget {
  final String userAvatar;
  final File? imageFile;
  final bool showLoadingWidget;

  const ImageWidget({
    Key? key,
    required this.userAvatar,
    this.imageFile,
    this.showLoadingWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FancyShimmerImage(
          imageUrl: userAvatar,
          boxFit: BoxFit.cover,
          shimmerBaseColor:
          AppThemePreferences().appTheme.shimmerEffectBaseColor,
          shimmerHighlightColor:
          AppThemePreferences().appTheme.shimmerEffectHighLightColor,
          width: 200,
          height: 200,
          errorWidget: ShimmerEffectErrorWidget(),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              Image.file(
                imageFile!,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
              if(showLoadingWidget) LoadingIndicatorWidget(),
            ],
          ),
        ),
      );
    }
  }
}


class LoadingIndicatorWidget extends StatelessWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.height) / 2,
      margin: const EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: SizedBox(
        width: 80,
        height: 20,
        child: BallBeatLoadingWidget(),
      ),
    );
  }
}

