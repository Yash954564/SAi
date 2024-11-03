import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/floor_plans.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';


typedef GenericFloorPlanWidgetListener = void Function(List<FloorPlanElement> updatedItemsList);

class GenericFloorPlanWidget extends StatefulWidget {
  final List<FloorPlanElement> itemsList;
  final EdgeInsetsGeometry? buttonPadding;
  final GenericFloorPlanWidgetListener listener;

  const GenericFloorPlanWidget({
    Key? key,
    required this.itemsList,
    this.buttonPadding = const EdgeInsets.fromLTRB(20, 20, 20, 20),
    required this.listener,
  }) : super(key: key);

  @override
  State<GenericFloorPlanWidget> createState() => _GenericFloorPlanWidgetState();
}

class _GenericFloorPlanWidgetState extends State<GenericFloorPlanWidget> {

  List<FloorPlanElement> itemsList = [];

  @override
  void initState() {
    itemsList = widget.itemsList;
    super.initState();
  }

  @override
  void dispose() {
    itemsList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(itemsList.isNotEmpty) Column(
          children: itemsList.map((dynamicItem) {
            int itemIndex = itemsList.indexOf(dynamicItem);
            return GenericFloorPlanWidgetBody(
              index: itemIndex,
              dataMap: dynamicItem.dataMap!,
              genericFloorPlanWidgetListener: (int index, Map<String, dynamic> itemDataMap, bool removeItem) {
                if (removeItem) {
                  if (mounted) {
                    setState(() {
                      itemsList.removeAt(index);
                    });
                  }
                } else {
                  if (mounted) {
                    setState(() {
                      itemsList[index].dataMap = itemDataMap;
                    });
                  }
                }

                widget.listener(itemsList);
              },
            );
          }).toList(),
        ),
        addNewElevatedButton(),
      ],
    );
  }

  Widget addNewElevatedButton(){
    return Container(
      padding: widget.buttonPadding,
      child: LightButtonWidget(
          text: UtilityMethods.getLocalizedString("add_new"),
          fontSize: AppThemePreferences.buttonFontSize,
          onPressed: (){
            if(mounted) {
              setState(() {
                itemsList.add(FloorPlanElement(
                  key: itemsList.isNotEmpty
                      ? "Key${itemsList.length}"
                      : "Key0",
                  dataMap: {
                    favePlanTitle: "",
                    favePlanRooms: "",
                    favePlanBathrooms: "",
                    favePlanPrice: "",
                    favePlanPricePostFix: "",
                    favePlanSize: "",
                    favePlanImage: "",
                    favePlanPendingImage: "",
                    favePlanDescription: "",
                  },
                ));
              });
            }
          }
      ),
    );
  }
}


typedef GenericFloorPlanWidgetBodyListener = void Function(
    int index, Map<String, dynamic> dataMap, bool remove);

class GenericFloorPlanWidgetBody extends StatefulWidget{
  final int index;
  final Map<String, dynamic> dataMap;
  final bool isPropertyForUpdate;
  final GenericFloorPlanWidgetBodyListener genericFloorPlanWidgetListener;

  const GenericFloorPlanWidgetBody({
    Key? key,
    required this.index,
    required this.dataMap,
    this.isPropertyForUpdate = false,
    required this.genericFloorPlanWidgetListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericFloorPlanWidgetBodyState();

}

class GenericFloorPlanWidgetBodyState extends State<GenericFloorPlanWidgetBody> {

  Map<String, dynamic> tempDataMap = {};

  final picker = ImagePicker();

  int _totalImages = 0;
  List<Object> _propertyImagesList = [];

  int _bedrooms = 0;
  int _bathrooms = 0;

  // int _minimumImageWidth = 800;
  // int _minimumImageHeight = 600;

  final _planTitleTextController = TextEditingController();
  final _planBedroomsTextController = TextEditingController();
  final _planBathroomsTextController = TextEditingController();
  final _planPriceTextController = TextEditingController();
  final _planPricePostFixTextController = TextEditingController();
  final _planSizeTextController = TextEditingController();
  final _planDescriptionTextController = TextEditingController();


  @override
  void dispose() {
    tempDataMap = {};
    _propertyImagesList = [];
    _planTitleTextController.dispose();
    _planBedroomsTextController.dispose();
    _planBathroomsTextController.dispose();
    _planPriceTextController.dispose();
    _planPricePostFixTextController.dispose();
    _planSizeTextController.dispose();
    _planDescriptionTextController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    if (widget.dataMap != null && !(mapEquals(widget.dataMap, tempDataMap))) {
      _planTitleTextController.text = widget.dataMap[favePlanTitle];
      _planBedroomsTextController.text = widget.dataMap[favePlanRooms];
      _planBathroomsTextController.text = widget.dataMap[favePlanBathrooms];
      _planPriceTextController.text = widget.dataMap[favePlanPrice];
      _planPricePostFixTextController.text = widget.dataMap[favePlanPricePostFix];
      _planSizeTextController.text = widget.dataMap[favePlanSize];
      _planDescriptionTextController.text = widget.dataMap[favePlanDescription];

      // if (_planBedroomsTextController.text != null &&
      //     _planBedroomsTextController.text.isNotEmpty) {
      //   _bedrooms = int.parse(_planBedroomsTextController.text);
      // }
      //
      // if (_planBathroomsTextController.text != null &&
      //     _planBathroomsTextController.text.isNotEmpty) {
      //   _bathrooms = int.parse(_planBathroomsTextController.text);
      // }

      if (widget.dataMap[favePlanPendingImage] != null &&
          widget.dataMap[favePlanPendingImage].isNotEmpty) {
        _propertyImagesList = [widget.dataMap[favePlanPendingImage]];
      }

      tempDataMap = widget.dataMap;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: CardWidget(
        shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
        child: Column(
          children: [
            addPlanTitle(context),
            addRoomsInformation(context),
            addPriceInformation(context),
            addPlanSize(context),
            addImages(context),
            addDescription(context),
            const Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 20)),
          ],
        ),
      ),
    );
  }

  Widget addPlanTitle(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 10,
              left: UtilityMethods.isRTL(context) ? 10 : 20,
              right: UtilityMethods.isRTL(context) ? 20 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              labelWidget(UtilityMethods.getLocalizedString("plan_title")),
              IconButton(
                onPressed: (){
                  widget.genericFloorPlanWidgetListener(widget.index, widget.dataMap, true);
                },
                padding: const EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.cancel_outlined,
                  color: AppThemePreferences.errorColor,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(0.0),
          child: TextFormFieldWidget(
            textFieldPadding: const EdgeInsets.all(0.0),
            controller: _planTitleTextController,
            hintText: UtilityMethods.getLocalizedString("enter_the_plan_title"),
            keyboardType: TextInputType.text,
            onChanged: (title){
              widget.dataMap[favePlanTitle]  = title;
              updateDataMap();
            },
          ),
        ),
      ],
    );
  }

  Widget addRoomsInformation(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfBedrooms(context)),
        Expanded(flex: 5, child: addNumberOfBathrooms(context)),
      ],
    );
  }

  Widget labelWidget(String text){
    return GenericTextWidget(
      text,
      style: AppThemePreferences().appTheme.labelTextStyle,
    );
  }

  Widget addNumberOfBedrooms(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("bedrooms"),
        hintText: UtilityMethods.getLocalizedString("bedrooms"),
        controller: _planBedroomsTextController,
        onChanged: (value){
          widget.dataMap[favePlanRooms]  = value;
          updateDataMap();
        },
      ),
    );
  }

  Widget addNumberOfBathrooms(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("bathrooms"),
        hintText: UtilityMethods.getLocalizedString("bathrooms"),
        controller: _planBathroomsTextController,
        onChanged: (value){
          widget.dataMap[favePlanBathrooms]  = value;
          updateDataMap();
        },
      ),
    );
  }

  // Widget addNumberOfBedrooms(BuildContext context){
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 20),
  //         child: labelWidget(AppLocalizations.of(context).bedrooms),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(top: 15),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             IconButton(
  //               iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
  //               icon: Icon(AppThemePreferences.removeCircleOutlinedIcon),
  //               onPressed: (){
  //                 if(_bedrooms > 0){
  //                   _bedrooms -= 1;
  //                   _planBedroomsTextController.text = _bedrooms.toString();
  //                   widget.dataMap[favePlanRooms]  = _planBedroomsTextController.text;
  //                   updateDataMap();
  //                 }
  //               },
  //             ),
  //
  //             SizedBox(
  //               width: 55,
  //               height: 50,
  //               child: TextFormField(
  //                 decoration: AppThemePreferences.formFieldDecoration(),
  //                 controller: _planBedroomsTextController,
  //                 keyboardType: TextInputType.number,
  //                 inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
  //                 onChanged: (value){
  //                   _bedrooms = int.parse(value);
  //                   widget.dataMap[favePlanRooms]  = value;
  //                   updateDataMap();
  //                 },
  //               ),
  //             ),
  //
  //             IconButton(
  //               iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
  //               icon: Icon(AppThemePreferences.addCircleOutlinedIcon),
  //               onPressed: (){
  //                 if(_bedrooms >= 0){
  //                   _bedrooms += 1;
  //                   _planBedroomsTextController.text = _bedrooms.toString();
  //                   widget.dataMap[favePlanRooms]  = _planBedroomsTextController.text;
  //                   updateDataMap();
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget addNumberOfBathrooms(BuildContext context){
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
  //         child: labelWidget(AppLocalizations.of(context).bathrooms),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.only(top: 15, left: 10),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: TextFormField(
  //                 decoration: AppThemePreferences.formFieldDecoration(hintText: AppLocalizations.of(context).bathrooms),
  //                 controller: _planBathroomsTextController,
  //                 onChanged: (value){
  //                   widget.dataMap[favePlanBathrooms]  = value;
  //                   updateDataMap();
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       // Padding(
  //       //   padding: const EdgeInsets.only(top: 15, left: 10),
  //       //   child: Row(
  //       //     mainAxisAlignment: MainAxisAlignment.start,
  //       //     children: [
  //       //       IconButton(
  //       //         iconSize: AppThemePreferences.addPropertyDetailsIconButtonSize,
  //       //         icon: Icon(AppThemePreferences.removeCircleOutlinedIcon),
  //       //         onPressed: (){
  //       //           if(_bathrooms > 0){
  //       //             _bathrooms -= 1;
  //       //             _planBathroomsTextController.text = _bathrooms.toString();
  //       //             widget.dataMap[favePlanBathrooms]  = _planBathroomsTextController.text;
  //       //             updateDataMap();
  //       //           }
  //       //         },
  //       //       ),
  //       //       SizedBox(
  //       //         width: 55,
  //       //         height: 50,
  //       //         child: TextFormField(
  //       //           decoration: AppThemePreferences.formFieldDecoration(),
  //       //           controller: _planBathroomsTextController,
  //       //           keyboardType: TextInputType.number,
  //       //           inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
  //       //           onChanged: (value){
  //       //             _bathrooms = int.parse(value);
  //       //             widget.dataMap[favePlanBathrooms]  = value;
  //       //             updateDataMap();
  //       //           },
  //       //           // validator: (String value) {
  //       //           //   if(value != null && value.isNotEmpty){
  //       //           //     setState(() {
  //       //           //       widget.dataMap[favePlanBathrooms]  = value;
  //       //           //     });
  //       //           //     // widget.TempPropertyFloorPlansPageListener(widget.dataMap);
  //       //           //   }
  //       //           //   return null;
  //       //           // },
  //       //         ),
  //       //       ),
  //       //       IconButton(
  //       //         iconSize:  AppThemePreferences.addPropertyDetailsIconButtonSize,
  //       //         icon: Icon(AppThemePreferences.addCircleOutlinedIcon),
  //       //         onPressed: (){
  //       //           if(_bathrooms >= 0){
  //       //             _bathrooms += 1;
  //       //             _planBathroomsTextController.text = _bathrooms.toString();
  //       //             widget.dataMap[favePlanBathrooms]  = _planBathroomsTextController.text;
  //       //             updateDataMap();
  //       //           }
  //       //         },
  //       //       ),
  //       //     ],
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  Widget addPriceInformation(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addPrice(context)),
        Expanded(flex: 5, child: addPricePostfix(context)),
      ],
    );
  }

  Widget addPrice(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("price"),
        hintText: UtilityMethods.getLocalizedString("enter_the_price"),
        controller: _planPriceTextController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        onChanged: (price){
          widget.dataMap[favePlanPrice]  = price;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPricePostfix(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("price_postfix"),
        hintText: UtilityMethods.getLocalizedString("enter_price_postfix"),
        controller: _planPricePostFixTextController,
        onChanged: (postfix){
          widget.dataMap[favePlanPricePostFix]  = postfix;
          updateDataMap();
        },
      ),
    );
  }

  Widget addPlanSize(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("plan_size"),
        hintText: UtilityMethods.getLocalizedString("enter_the_plan_size"),
        controller: _planSizeTextController,
        onChanged: (planSize){
          widget.dataMap[favePlanSize]  = planSize;
          updateDataMap();
        },
        // validator: (String value) {
        //   if(value != null && value.isNotEmpty){
        //     setState(() {
        //       widget.dataMap[favePlanSize]  = value;
        //     });
        //     // widget.TempPropertyFloorPlansPageListener(widget.dataMap);
        //   }
        //   return null;
        // },

      ),
    );
  }

  Widget addDescription(BuildContext context){
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("description"),
        hintText: UtilityMethods.getLocalizedString("enter_the_plan_description"),
        keyboardType: TextInputType.multiline,
        controller: _planDescriptionTextController,
        maxLines: 5,
        onChanged: (description){
          widget.dataMap[favePlanDescription]  = description;
          updateDataMap();
        },
      ),
    );
  }

  updateDataMap(){
    widget.genericFloorPlanWidgetListener(
        widget.index, widget.dataMap, false);
  }

  Widget addImages(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelWidget(UtilityMethods.getLocalizedString("plan_image")),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: LightButtonWidget(
              text: UtilityMethods.getLocalizedString("select_image"),
              fontSize: AppThemePreferences.buttonFontSize,
              // onPressed: ()=> getImageMultiple(),
              onPressed: ()=> chooseImageOption(context),
            ),
          ),

          _propertyImagesList.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: _buildGridView(context, _propertyImagesList),
          ) : Container(),
        ],
      ),
    );
  }

  Future chooseImageOption(BuildContext context) {
    return ShowDialogBoxWidget(
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
    var pickedFiles = await picker.pickMultiImage(imageQuality: 90);

    if (pickedFiles != null) {
      Map<String, dynamic> _imageInfoMap = {};
      for (var pickedFile in pickedFiles) {
        File _image = File(pickedFile.path);
        Directory appDocumentDir = await getApplicationDocumentsDirectory();
        final String path = appDocumentDir.path;
        var fileName = basename(_image.path);
        final File newImage = await _image.copy('$path/$fileName');

        /// Make a map of selected image info and add it to the List of selected images.
        _imageInfoMap = {
          PROPERTY_MEDIA_IMAGE_NAME : fileName,
          PROPERTY_MEDIA_IMAGE_PATH: newImage.path,
          PROPERTY_MEDIA_IMAGE_STATUS: PENDING,
          PROPERTY_MEDIA_IMAGE_ID: '${DateTime.now().millisecondsSinceEpoch}',
        };
        // _propertyImagesList = [_image];
        _propertyImagesList = [_imageInfoMap];
      }
      setState(() {
        _totalImages = _propertyImagesList.length;
        widget.dataMap[favePlanPendingImage] = _imageInfoMap;
      });
      updateDataMap();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future getImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90);

    if (pickedFile != null) {
      File _image = File(pickedFile.path);
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

      setState(() {
        // _propertyImagesList = [_image];
        _propertyImagesList = [_imageInfoMap];
        _totalImages = _propertyImagesList.length;
        widget.dataMap[favePlanPendingImage] = _imageInfoMap;
      });

      updateDataMap();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  // Future getImageMultiple() async {
  //   var pickedFiles = await picker.pickMultiImage(imageQuality: 90);
  //
  //   if (pickedFiles != null) {
  //     for (var pickedFile in pickedFiles) {
  //       File _image = File(pickedFile.path);
  //       _propertyImagesList = [_image];
  //     }
  //     setState(() {
  //       _totalImages = _propertyImagesList.length;
  //     });
  //   } else {
  //     if (kDebugMode) {
  //       print('No image selected.');
  //     }
  //   }
  // }

  // Future getImage() async {
  //   var pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     File _image = File(pickedFile.path);
  //     setState(() {
  //       _propertyImagesList = [_image];
  //       _totalImages = _propertyImagesList.length;
  //     });
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  Widget _buildGridView(BuildContext context, List list) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      children: list.map((item) {
        // var index = list.indexOf(item);
        return CardWidget(
          shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
          color: Colors.grey[100],
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  // child: Image.file(
                  //   item,
                  //   fit: BoxFit.cover,
                  //   width: AppThemePreferences.propertyMediaGridViewImageWidth,
                  //   height: AppThemePreferences.propertyMediaGridViewImageHeight,
                  // ),
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
                            if(mounted) {
                              setState(() {
                                list.remove(item);
                                _totalImages -= 1;
                              });
                            }
                            Navigator.pop(context);
                          },
                          child: GenericTextWidget(UtilityMethods.getLocalizedString("yes")),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

}