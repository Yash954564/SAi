import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/api/api_response.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef PropertyMediaPageListener = void Function(Map<String, dynamic> dataMap);

class PropertyMedia extends StatefulWidget {

  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyMediaPageListener? propertyMediaPageListener;
  final bool? isPropertyForUpdate;

  const PropertyMedia({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.propertyMediaPageListener,
    this.isPropertyForUpdate = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertyMediaState();
}

class PropertyMediaState extends State<PropertyMedia> {
  // final picker = ImagePicker();
  // final PropertyBloc _propertyBloc = PropertyBloc();
  final _videoURLTextController = TextEditingController();

  // List<dynamic> _imageMapsList = [];
  Map<String, dynamic> dataMap = {};
  //
  // int _totalImages = 0;
  // int selectedImageIndex = 0;
  // String nonce = "";
  //
  // var propertyId;

  @override
  void initState() {
    super.initState();
    Map? tempMap = widget.propertyInfoMap;

    if (tempMap != null) {
      // propertyId = tempMap[UPDATE_PROPERTY_ID];
      if (tempMap.containsKey(ADD_PROPERTY_VIDEO_URL)) {
        _videoURLTextController.text = tempMap[ADD_PROPERTY_VIDEO_URL] ?? "";
      }
      //   if (tempMap.containsKey(ADD_PROPERTY_PENDING_IMAGES_LIST)) {
      //     _imageMapsList = tempMap[ADD_PROPERTY_PENDING_IMAGES_LIST] ?? [];
      //     _totalImages = _imageMapsList.length;
      //   }
      //   if (tempMap.containsKey(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID)) {
      //     String? selectedImageId = tempMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
      //     if(selectedImageId != null){
      //       int index = _imageMapsList.indexWhere((element) => element[PROPERTY_MEDIA_IMAGE_ID] == selectedImageId);
      //       selectedImageIndex = index;
      //     }
      //   }
      //
      //   if (tempMap.containsKey(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX)) {
      //     String? selectedImageId = tempMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX];
      //     if(selectedImageId != null){
      //       selectedImageIndex = int.parse(selectedImageId);
      //     }
      //
      //     if (kDebugMode) {
      //       // print("selected index is $selectedImageIndex");
      //     }
      //   }
      //
      //   if (widget.isPropertyForUpdate!) {
      //     List<dynamic> propertyAlreadyUploadedImages = tempMap[UPDATE_PROPERTY_IMAGES] ?? [];
      //     List<dynamic> propertyAlreadyUploadedImagesId = tempMap[ADD_PROPERTY_IMAGE_IDS] ?? [];
      //     List<dynamic> finalList = [];
      //
      //     if (propertyAlreadyUploadedImagesId.isNotEmpty) {
      //
      //       for (int i = 0; i < propertyAlreadyUploadedImages.length; i++) {
      //         Map<String, dynamic> maps = {
      //           PROPERTY_MEDIA_IMAGE_NAME: "",
      //           PROPERTY_MEDIA_IMAGE_PATH: propertyAlreadyUploadedImages[i],
      //           PROPERTY_MEDIA_IMAGE_STATUS: UPLOADED,
      //           PROPERTY_MEDIA_IMAGE_ID: propertyAlreadyUploadedImagesId[i],
      //         };
      //         finalList.add(maps);
      //       }
      //
      //       _imageMapsList = finalList;
      //       _totalImages = _imageMapsList.length;
      //     }
      //   }
      // }
      //
      // fetchNonce();
    }
  }

  // fetchNonce() async {
  //   ApiResponse response = await _propertyBloc.fetchDeleteImageNonceResponse();
  //   if (response.success) {
  //     nonce = response.result;
  //   }
  // }

  @override
  void dispose() {
    _videoURLTextController.dispose();
    // _imageMapsList = [];
    dataMap = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: widget.formKey,
          child: Column(
            children: [
              CardWidget(
                child: Column(
                  children: [
                    mediaTextWidget(context),
                    // addImages(context),
                    AddPropertyMediaWidget(
                      propertyInfoMap: widget.propertyInfoMap,
                      isPropertyForUpdate: widget.isPropertyForUpdate ?? false,
                      listener: (_dataMap) {
                        widget.propertyMediaPageListener!(_dataMap);
                      },
                    ),
                  ],
                ),
              ),
              CardWidget(
                child: Column(
                  children: [
                    videoTextWidget(context),
                    addVideoUrl(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headingWidget({required String text}){
    return HeaderWidget(
      text: text,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppThemePreferences().appTheme.dividerColor!),
        ),
      ),
    );
  }

  Widget labelWidget(String text){
    return GenericTextWidget(
      text,
      style: AppThemePreferences().appTheme.labelTextStyle,
    );
  }

  // Widget addImages(BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         labelWidget(UtilityMethods.getLocalizedString("select_and_upload")),
  //         Padding(
  //           padding: const EdgeInsets.only(top: 15, bottom: 5),
  //           child: GenericTextWidget(
  //             "$_totalImages" + UtilityMethods.getLocalizedString("fifty_files"),
  //             style: AppThemePreferences().appTheme.subBody01TextStyle,
  //           ),
  //         ),
  //         lightButtonWidget(
  //           text: UtilityMethods.getLocalizedString("upload_media"),
  //             fontSize: AppThemePreferences.buttonFontSize,
  //           onPressed: ()=> _totalImages <= 50
  //               ? chooseImageOption(context)
  //               : _showToast(context)
  //         ),
  //         _imageMapsList.isNotEmpty
  //             ? Padding(
  //                 padding: const EdgeInsets.only(top: 10),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     GenericTextWidget(
  //                       UtilityMethods.getLocalizedString("click_on_the_star_icon_to_select_the_cover_image"),
  //                       style: AppThemePreferences().appTheme.subBody01TextStyle,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 10.0),
  //                       child: _buildGridView(context),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             : Container(),
  //         noImageErrorWidget(context),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget noImageErrorWidget(BuildContext context){
  //   return FormField<bool>(
  //     builder: (state) {
  //       return Container(
  //         child: state.errorText != null && _totalImages < 1
  //             ? Padding(
  //                 padding: const EdgeInsets.only(top: 10, left: 0.0),
  //                 child: GenericTextWidget(
  //                   state.errorText!,
  //                   style: TextStyle(
  //                     color: AppThemePreferences.errorColor,
  //                   ),
  //                 ),
  //               )
  //             : Container(),
  //       );
  //     },
  //     validator: (value) {
  //       if (_totalImages < 1) {
  //         return UtilityMethods.getLocalizedString("upload_at_least_one_image");
  //       }
  //       return null;
  //     },
  //   );
  // }
  //
  // chooseImageOption(BuildContext context) {
  //   ShowDialogBoxWidget(
  //     context,
  //     title: UtilityMethods.getLocalizedString("select_image"),
  //     style: AppThemePreferences().appTheme.heading02TextStyle!,
  //     content: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         InkWell(
  //           onTap: () {
  //             getImage();
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.only(top: 5, bottom: 5),
  //               child: GenericTextWidget(
  //                 UtilityMethods.getLocalizedString("from_camera"),
  //                   style: AppThemePreferences().appTheme.bodyTextStyle,
  //               )
  //           ),
  //         ),
  //         const Divider(
  //           thickness: 1,
  //         ),
  //         InkWell(
  //           onTap: () {
  //             getImageMultiple();
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.only(
  //                 top: 10,
  //                 bottom: 10,
  //               ),
  //               child: GenericTextWidget(
  //                 UtilityMethods.getLocalizedString("from_gallery"),
  //                   style: AppThemePreferences().appTheme.bodyTextStyle,
  //               )
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Future getImageMultiple() async {
  //   var pickedFiles = await picker.pickMultiImage(imageQuality: 90,maxHeight: 2000,maxWidth: 2000);
  //
  //   if (pickedFiles != null) {
  //     for (var pickedFile in pickedFiles) {
  //       File _image = File(pickedFile.path);
  //       //
  //       // final bytes = _image.readAsBytesSync().lengthInBytes;
  //       // final kb = bytes / 1024;
  //       // final mb = kb / 1024;
  //       //
  //       // print("mb:$mb");
  //       //
  //       // var _decodedImage = await decodeImageFromList(_image.readAsBytesSync());
  //       // int _imageWidth = _decodedImage.width;
  //       // int _imageHeight = _decodedImage.height;
  //       //
  //       // print("_imageWidth:$_imageWidth");
  //       // print("_imageHeight:$_imageHeight");
  //       Directory appDocumentDir = await getApplicationDocumentsDirectory();
  //       final String path = appDocumentDir.path;
  //       var fileName = basename(_image.path);
  //       final File newImage = await _image.copy('$path/$fileName');
  //
  //       /// Make a map of selected image info and add it to the List of selected images.
  //       Map<String, dynamic> _imageInfoMap = {
  //         PROPERTY_MEDIA_IMAGE_NAME : fileName,
  //         PROPERTY_MEDIA_IMAGE_PATH: newImage.path,
  //         PROPERTY_MEDIA_IMAGE_STATUS: PENDING,
  //         PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
  //       };
  //       _imageMapsList.add(_imageInfoMap);
  //     }
  //     if(mounted) setState(() {
  //       _totalImages = _imageMapsList.length;
  //       dataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
  //     });
  //
  //     if (selectedImageIndex == 0) {
  //       if(mounted) setState(() {
  //         dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
  //         _imageMapsList[0][PROPERTY_MEDIA_IMAGE_ID];
  //       });
  //     }
  //     widget.propertyMediaPageListener!(dataMap);
  //   } else {
  //     if (kDebugMode) {
  //       print('No image selected.');
  //     }
  //   }
  // }
  //
  // Future getImage() async {
  //
  //   var pickedFile = await picker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 90,
  //       maxWidth: 2000,
  //       maxHeight: 2000,
  //   );
  //
  //   if (pickedFile != null) {
  //     File _image = File(pickedFile.path);
  //
  //     // final bytes = _image.readAsBytesSync().lengthInBytes;
  //     // final kb = bytes / 1024;
  //     // final mb = kb / 1024;
  //     //
  //     // print("mb:$mb");
  //     //
  //     // var _decodedImage = await decodeImageFromList(_image.readAsBytesSync());
  //     // int _imageWidth = _decodedImage.width;
  //     // int _imageHeight = _decodedImage.height;
  //     //
  //     // print("_imageWidth:$_imageWidth");
  //     // print("_imageHeight:$_imageHeight");
  //
  //
  //     Directory appDocumentDir = await getApplicationDocumentsDirectory();
  //     final String path = appDocumentDir.path;
  //     var fileName = basename(_image.path);
  //     final File newImage = await _image.copy('$path/$fileName');
  //
  //     /// Make a map of selected image info and add it to the List of selected images.
  //     Map<String, dynamic> _imageInfoMap = {
  //       PROPERTY_MEDIA_IMAGE_NAME: fileName,
  //       PROPERTY_MEDIA_IMAGE_PATH: newImage.path,
  //       PROPERTY_MEDIA_IMAGE_STATUS: PENDING,
  //       PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
  //     };
  //
  //     if(mounted) setState(() {
  //       //_image = newImage;
  //       _imageMapsList.add(_imageInfoMap);
  //       _totalImages = _imageMapsList.length;
  //       dataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
  //     });
  //
  //     if (selectedImageIndex == 0) {
  //       if(mounted) setState(() {
  //         dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
  //             _imageMapsList[0][PROPERTY_MEDIA_IMAGE_ID];
  //       });
  //     }
  //
  //     widget.propertyMediaPageListener!(dataMap);
  //   } else {
  //     if (kDebugMode) {
  //       print('No image selected.');
  //     }
  //   }
  // }

  Widget mediaTextWidget(BuildContext context) {
    return headingWidget(text: UtilityMethods.getLocalizedString("media"));
  }

  Widget videoTextWidget(BuildContext context) {
    return headingWidget(text: UtilityMethods.getLocalizedString("video"));
  }

  Widget addVideoUrl(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("video_url"),
        hintText: UtilityMethods.getLocalizedString("youtube_vimeo_swf_file_and_mov_file_are_supported"),
        additionalHintText: UtilityMethods.getLocalizedString("for_example") + PROPERTY_MEDIA_EXAMPLE_URL,
        controller: _videoURLTextController,
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            if(mounted) setState(() {
              dataMap[ADD_PROPERTY_VIDEO_URL] = value;
            });
            widget.propertyMediaPageListener!(dataMap);
          }

          return null;
        },
      ),
    );
  }

  // Widget _buildGridView(BuildContext context) {
  //   return GridView.count(
  //     physics: const NeverScrollableScrollPhysics(),
  //     shrinkWrap: true,
  //     crossAxisCount: 3,
  //     childAspectRatio: 0.8,
  //     children: _imageMapsList.map((item) {
  //       var index = _imageMapsList.indexOf(item);
  //       return CardWidget(
  //         color: Colors.grey[100],
  //         clipBehavior: Clip.antiAlias,
  //         child: Stack(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(top: 30),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(5),
  //                 child: item[PROPERTY_MEDIA_IMAGE_STATUS] == UPLOADED
  //                     ? Image.network(
  //                         item[PROPERTY_MEDIA_IMAGE_PATH],
  //                         fit: BoxFit.cover,
  //                         width: AppThemePreferences.propertyMediaGridViewImageWidth,
  //                         height: AppThemePreferences.propertyMediaGridViewImageHeight,
  //                       )
  //                     : Image.file(
  //                         File(item[PROPERTY_MEDIA_IMAGE_PATH]),
  //                         fit: BoxFit.cover,
  //                         width: AppThemePreferences.propertyMediaGridViewImageWidth,
  //                         height: AppThemePreferences.propertyMediaGridViewImageHeight,
  //                       ),
  //               ),
  //             ),
  //             Positioned(
  //               right: 5,
  //               top: 0,
  //               child: InkWell(
  //                 child: Icon(
  //                   AppThemePreferences.removeCircleIcon,
  //                   color: AppThemePreferences.removeCircleIconColor,
  //                 ),
  //                 onTap: () {
  //                   ShowDialogBoxWidget(
  //                     context,
  //                     title: UtilityMethods.getLocalizedString("delete"),
  //                     content: GenericTextWidget(UtilityMethods.getLocalizedString("delete_confirmation")),
  //                     actions: <Widget>[
  //                       TextButtonWidget(
  //                         onPressed: () => Navigator.pop(context),
  //                         child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
  //                       ),
  //                       TextButtonWidget(
  //                         onPressed: () async {
  //                           var _imageId = item[PROPERTY_MEDIA_IMAGE_ID];
  //                           String _imageStatus = item[PROPERTY_MEDIA_IMAGE_STATUS];
  //                           if(_imageStatus == UPLOADED){
  //                             Map<String, dynamic> deleteImageInfo = {
  //                               "thumb_id": _imageId,
  //                               "prop_id": propertyId,
  //                             };
  //                             final response = _propertyBloc.fetchDeleteImageFromEditProperty(deleteImageInfo, nonce);
  //                             if (response != null) {
  //                               updateImageList(context, item, index);
  //                             }
  //                           }else{
  //                             updateImageList(context, item, index);
  //                           }
  //                         },
  //                         child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
  //                       ),
  //                     ],
  //                   );
  //                 },
  //               ),
  //             ),
  //             Positioned(
  //               left: 5,
  //               top: 0,
  //               child: InkWell(
  //                 child: Icon(
  //                   selectedImageIndex == index
  //                       ? AppThemePreferences.starFilledIcon
  //                       : AppThemePreferences.starOutlinedIcon,
  //                   size: AppThemePreferences.featuredImageStarIconSize,
  //                   color: AppThemePreferences.starIconColor,
  //                 ),
  //                 onTap: () => selectFeaturedImage(index),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }
  //
  // updateImageList(BuildContext context, dynamic item, int index){
  //   if(mounted) setState(() {
  //     _imageMapsList.remove(item);
  //     _totalImages -= 1;
  //     //if deleted index was featured image, we need to set the featured image to 0.
  //     if (selectedImageIndex == index) {
  //       selectedImageIndex = 0;
  //       if (_imageMapsList.length > 1) {
  //         selectFeaturedImage(0);
  //       }
  //     }
  //   });
  //   Navigator.pop(context);
  // }
  //
  // selectFeaturedImage(int index) {
  //   setState(() {
  //     selectedImageIndex = index;
  //     Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageMapsList[index]);
  //     var status = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
  //     if (status == UPLOADED) {
  //       var imageId = _imageMap[PROPERTY_MEDIA_IMAGE_ID];
  //
  //       dataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = imageId;
  //       dataMap.remove(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID);
  //
  //     } else {
  //       dataMap.remove(ADD_PROPERTY_FEATURED_IMAGE_ID);
  //       dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
  //       _imageMap[PROPERTY_MEDIA_IMAGE_ID];
  //     }
  //     _imageMapsList[index] = _imageMap;
  //   });
  //   widget.propertyMediaPageListener!(dataMap);
  // }
  //
  // _showToast(BuildContext context){
  //   ShowToastWidget(
  //     buildContext: context,
  //     text: UtilityMethods.getLocalizedString("you_have_reached_the_limit"),
  //   );
  // }
}

typedef AddPropertyMediaWidgetListener = Function(Map<String, dynamic> dataMap);

class AddPropertyMediaWidget extends StatefulWidget {
  final Map<String, dynamic>? propertyInfoMap;
  final bool isPropertyForUpdate;
  final bool performValidation;
  final EdgeInsetsGeometry? padding;
  final AddPropertyMediaWidgetListener listener;

  const AddPropertyMediaWidget({
    Key? key,
    this.propertyInfoMap,
    this.performValidation = true,
    this.isPropertyForUpdate = false,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    required this.listener,
  }) : super(key: key);

  @override
  State<AddPropertyMediaWidget> createState() => _AddPropertyMediaWidgetState();
}

class _AddPropertyMediaWidgetState extends State<AddPropertyMediaWidget> {

  int _totalImages = 0;
  int selectedImageIndex = 0;
  String nonce = "";
  var propertyId;
  List<dynamic> _imageMapsList = [];
  Map<String, dynamic> dataMap = {};
  final picker = ImagePicker();
  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void initState() {
    super.initState();
    // List<dynamic> _pendingImageMapsList = [];
    // List<dynamic> _alreadyUploadedImageMapsList = [];

    Map? tempMap = widget.propertyInfoMap;
    if (tempMap != null) {
      propertyId = tempMap[UPDATE_PROPERTY_ID];

      if (tempMap.containsKey(ADD_PROPERTY_PENDING_IMAGES_LIST)) {
        // _pendingImageMapsList = tempMap[ADD_PROPERTY_PENDING_IMAGES_LIST] ?? [];
        // _totalImages = _pendingImageMapsList.length;
        _imageMapsList = tempMap[ADD_PROPERTY_PENDING_IMAGES_LIST] ?? [];
        _totalImages = _imageMapsList.length;
      }
      if (tempMap.containsKey(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID)) {
        String? selectedImageId = tempMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID];
        if(selectedImageId != null){
          // int index = _pendingImageMapsList.indexWhere((element) => element[PROPERTY_MEDIA_IMAGE_ID] == selectedImageId);
          int index = _imageMapsList.indexWhere((element) => element[PROPERTY_MEDIA_IMAGE_ID] == selectedImageId);
          selectedImageIndex = index;
        }
      }

      if (tempMap.containsKey(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX)) {
        String? selectedImageId = tempMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_INDEX];
        if(selectedImageId != null){
          selectedImageIndex = int.parse(selectedImageId);
        }

        if (kDebugMode) {
          // print("selected index is $selectedImageIndex");
        }
      }

      if (widget.isPropertyForUpdate) {
        List<dynamic> propertyAlreadyUploadedImages = tempMap[UPDATE_PROPERTY_IMAGES] ?? [];
        List<dynamic> propertyAlreadyUploadedImagesId = tempMap[ADD_PROPERTY_IMAGE_IDS] ?? [];
        List<dynamic> finalList = [];

        if (propertyAlreadyUploadedImagesId.isNotEmpty) {

          for (int i = 0; i < propertyAlreadyUploadedImages.length; i++) {
            Map<String, dynamic> maps = {
              PROPERTY_MEDIA_IMAGE_NAME: "",
              PROPERTY_MEDIA_IMAGE_PATH: propertyAlreadyUploadedImages[i],
              PROPERTY_MEDIA_IMAGE_STATUS: UPLOADED,
              PROPERTY_MEDIA_IMAGE_ID: propertyAlreadyUploadedImagesId[i],
            };
            finalList.add(maps);
          }

          _imageMapsList = finalList;
          _totalImages = _imageMapsList.length;

          // _alreadyUploadedImageMapsList = finalList;
          // _imageMapsList = [..._pendingImageMapsList, ..._alreadyUploadedImageMapsList];
          // _totalImages = _imageMapsList.length;
        }
      }
    }

    fetchNonce();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchDeleteImageNonceResponse();
    if (response.success) {
      nonce = response.result;
    }
  }

  @override
  void dispose() {
    _imageMapsList = [];
    dataMap = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
            "${UtilityMethods.getLocalizedString("select_and_upload")}${widget.performValidation ? " *" : ""}",
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: GenericTextWidget(
              UtilityMethods.getLocalizedString("max_prop_images",
                  inputWords: ["$_totalImages", MAX_PROP_IMAGES_UPLOAD]),
              style: AppThemePreferences().appTheme.subBody01TextStyle,
            ),
          ),
          LightButtonWidget(
              text: UtilityMethods.getLocalizedString("upload_media"),
              fontSize: AppThemePreferences.buttonFontSize,
              onPressed: ()=> _totalImages <= 50
                  ? chooseImageOption(context)
                  : _showToast(context)
          ),
          _imageMapsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString(
                            "click_on_the_star_icon_to_select_the_cover_image"),
                        style:
                            AppThemePreferences().appTheme.subBody01TextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: _buildGridView(context),
                      ),
                    ],
                  ),
                )
              : Container(),
          if(widget.performValidation) noImageErrorWidget(context),
        ],
      ),
    );
  }


  Widget noImageErrorWidget(BuildContext context){
    return FormField<bool>(
      builder: (state) {
        return Container(
          child: state.errorText != null && _totalImages < 1
              ? Padding(
            padding: const EdgeInsets.only(top: 10, left: 0.0),
            child: GenericTextWidget(
              state.errorText!,
              style: TextStyle(
                color: AppThemePreferences.errorColor,
              ),
            ),
          )
              : Container(),
        );
      },
      validator: (value) {
        if (_totalImages < 1) {
          return UtilityMethods.getLocalizedString("upload_at_least_one_image");
        }
        return null;
      },
    );
  }

  chooseImageOption(BuildContext context) {
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
              getImage();
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: GenericTextWidget(
                  UtilityMethods.getLocalizedString("from_camera"),
                  style: AppThemePreferences().appTheme.bodyTextStyle,
                )
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              getImageMultiple();
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
                )
            ),
          ),
        ],
      ),
    );
  }

  Future getImageMultiple() async {
    var pickedFiles = await picker.pickMultiImage(imageQuality: 90,maxHeight: 2000,maxWidth: 2000);

    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        File _image = File(pickedFile.path);
        //
        // final bytes = _image.readAsBytesSync().lengthInBytes;
        // final kb = bytes / 1024;
        // final mb = kb / 1024;
        //
        // print("mb:$mb");
        //
        // var _decodedImage = await decodeImageFromList(_image.readAsBytesSync());
        // int _imageWidth = _decodedImage.width;
        // int _imageHeight = _decodedImage.height;
        //
        // print("_imageWidth:$_imageWidth");
        // print("_imageHeight:$_imageHeight");
        Directory appDocumentDir = await getApplicationDocumentsDirectory();
        final String path = appDocumentDir.path;
        var fileName = basename(_image.path);
        final File newImage = await _image.copy('$path/$fileName');

        /// Make a map of selected image info and add it to the List of selected images.
        Map<String, dynamic> _imageInfoMap = {
          PROPERTY_MEDIA_IMAGE_NAME : fileName,
          PROPERTY_MEDIA_IMAGE_PATH: newImage.path,
          PROPERTY_MEDIA_IMAGE_STATUS: PENDING,
          PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
        };
        _imageMapsList.add(_imageInfoMap);
      }
      if(mounted) setState(() {
        _totalImages = _imageMapsList.length;
        dataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
      });

      if (selectedImageIndex == 0) {
        if(mounted) setState(() {
          dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
          _imageMapsList[0][PROPERTY_MEDIA_IMAGE_ID];
        });
      }
      widget.listener(dataMap);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future getImage() async {

    var pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      maxWidth: 2000,
      maxHeight: 2000,
    );

    if (pickedFile != null) {
      File _image = File(pickedFile.path);

      // final bytes = _image.readAsBytesSync().lengthInBytes;
      // final kb = bytes / 1024;
      // final mb = kb / 1024;
      //
      // print("mb:$mb");
      //
      // var _decodedImage = await decodeImageFromList(_image.readAsBytesSync());
      // int _imageWidth = _decodedImage.width;
      // int _imageHeight = _decodedImage.height;
      //
      // print("_imageWidth:$_imageWidth");
      // print("_imageHeight:$_imageHeight");


      Directory appDocumentDir = await getApplicationDocumentsDirectory();
      final String path = appDocumentDir.path;
      var fileName = basename(_image.path);
      final File newImage = await _image.copy('$path/$fileName');

      /// Make a map of selected image info and add it to the List of selected images.
      Map<String, dynamic> _imageInfoMap = {
        PROPERTY_MEDIA_IMAGE_NAME: fileName,
        PROPERTY_MEDIA_IMAGE_PATH: newImage.path,
        PROPERTY_MEDIA_IMAGE_STATUS: PENDING,
        PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
      };

      if(mounted) setState(() {
        //_image = newImage;
        _imageMapsList.add(_imageInfoMap);
        _totalImages = _imageMapsList.length;
        dataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
      });

      if (selectedImageIndex == 0) {
        if(mounted) setState(() {
          dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
          _imageMapsList[0][PROPERTY_MEDIA_IMAGE_ID];
        });
      }

      widget.listener(dataMap);
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      children: _imageMapsList.map((item) {
        var index = _imageMapsList.indexOf(item);
        return CardWidget(
          color: Colors.grey[100],
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: item[PROPERTY_MEDIA_IMAGE_STATUS] == UPLOADED
                      ? Image.network(
                    item[PROPERTY_MEDIA_IMAGE_PATH],
                    fit: BoxFit.cover,
                    width: AppThemePreferences.propertyMediaGridViewImageWidth,
                    height: AppThemePreferences.propertyMediaGridViewImageHeight,
                  )
                      : Image.file(
                    File(item[PROPERTY_MEDIA_IMAGE_PATH]),
                    fit: BoxFit.cover,
                    width: AppThemePreferences.propertyMediaGridViewImageWidth,
                    height: AppThemePreferences.propertyMediaGridViewImageHeight,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 0,
                child: InkWell(
                  child: Icon(
                    AppThemePreferences.removeCircleIcon,
                    color: AppThemePreferences.removeCircleIconColor,
                  ),
                  onTap: () {
                    ShowDialogBoxWidget(
                      context,
                      title: UtilityMethods.getLocalizedString("delete"),
                      content: GenericTextWidget(UtilityMethods.getLocalizedString("delete_confirmation")),
                      actions: <Widget>[
                        TextButtonWidget(
                          onPressed: () => Navigator.pop(context),
                          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
                        ),
                        TextButtonWidget(
                          onPressed: () async {
                            var _imageId = item[PROPERTY_MEDIA_IMAGE_ID];
                            String _imageStatus = item[PROPERTY_MEDIA_IMAGE_STATUS];
                            if(_imageStatus == UPLOADED){
                              Map<String, dynamic> deleteImageInfo = {
                                "thumb_id": _imageId,
                                "prop_id": propertyId,
                              };
                              final response = _propertyBloc.fetchDeleteImageFromEditProperty(deleteImageInfo, nonce);
                              if (response != null) {
                                updateImageList(context, item, index);
                              }
                            }else{
                              updateImageList(context, item, index);
                            }
                          },
                          child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                left: 5,
                top: 0,
                child: InkWell(
                  child: Icon(
                    selectedImageIndex == index
                        ? AppThemePreferences.starFilledIcon
                        : AppThemePreferences.starOutlinedIcon,
                    size: AppThemePreferences.featuredImageStarIconSize,
                    color: AppThemePreferences.starIconColor,
                  ),
                  onTap: () => selectFeaturedImage(index),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  updateImageList(BuildContext context, dynamic item, int index){
    if(mounted) setState(() {
      _imageMapsList.remove(item);
      _totalImages -= 1;
      //if deleted index was featured image, we need to set the featured image to 0.
      if (selectedImageIndex == index) {
        selectedImageIndex = 0;
        if (_imageMapsList.length > 1) {
          selectFeaturedImage(0);
        }
      }
    });
    Navigator.pop(context);
  }

  selectFeaturedImage(int index) {
    if(mounted) setState(() {
      selectedImageIndex = index;
      Map<String, dynamic> _imageMap = UtilityMethods.convertMap(_imageMapsList[index]);
      var status = _imageMap[PROPERTY_MEDIA_IMAGE_STATUS];
      if (status == UPLOADED) {
        var imageId = _imageMap[PROPERTY_MEDIA_IMAGE_ID];

        dataMap[ADD_PROPERTY_FEATURED_IMAGE_ID] = imageId;
        dataMap.remove(ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID);

      } else {
        dataMap.remove(ADD_PROPERTY_FEATURED_IMAGE_ID);
        dataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
        _imageMap[PROPERTY_MEDIA_IMAGE_ID];
      }
      _imageMapsList[index] = _imageMap;
    });
    widget.listener(dataMap);
  }

  _showToast(BuildContext context){
    ShowToastWidget(
      buildContext: context,
      text: UtilityMethods.getLocalizedString("you_have_reached_the_limit"),
    );
  }
}
