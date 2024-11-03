import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/property_manager_files/property_manager.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/properties.dart';
import 'package:houzi_package/providers/state_providers/user_log_provider.dart';
import 'package:houzi_package/pages/app_settings_pages/web_page.dart';
import 'package:houzi_package/pages/home_screen_drawer_menu_pages/user_related/user_signin.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:houzi_package/widgets/button_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/dialog_box_widget.dart';
import 'package:houzi_package/widgets/filter_page_widgets/term_picker_related/term_picker_multi_select_dialog.dart';
import 'package:houzi_package/widgets/generic_link_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/generic_add_room_widget.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:houzi_package/widgets/light_button_widget.dart';
import 'package:houzi_package/widgets/toast_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/models/api/api_response.dart';

typedef DropDownViewWidgetListener = void Function(List<dynamic>? listOfSelectedItems, List<dynamic>? listOfSelectedIdsSlugs);

class QuickAddProperty extends StatefulWidget {

  @override
  _QuickAddPropertyState createState() => _QuickAddPropertyState();
}

class _QuickAddPropertyState extends State<QuickAddProperty> {

  String _title = "";
  String _description = "";
  String _price = "";
  String _areaSize = "";
  String _address = "";
  String _sizePostfix = "";
  String _defaultCurrency = '';
  String termsAndConditionsValue = "off";

  int _totalImages = 0;
  int _bedrooms = 0;
  int _bathrooms = 0;
  int selectedImageIndex = 0;

  bool isLoggedIn = false;
  bool termsAndConditions = false;

  final picker = ImagePicker();

  final List<dynamic> _imageMapsList = [];
  final List<dynamic> _addPropertyDataMapsList = [];

  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> addPropertyDataMap = {
    ADD_PROPERTY_ACTION: 'add_property',
    ADD_PROPERTY_USER_HAS_NO_MEMBERSHIP: 'no',
    ADD_PROPERTY_MULTI_UNITS: '${0}',
    ADD_PROPERTY_FLOOR_PLANS_ENABLE: '0',
  };

  List<dynamic> _propertyTypeMetaDataList = [];
  List<dynamic> _propertyLabelMetaDataList = [];
  List<dynamic> _propertyStatusMetaDataList = [];

  List<dynamic> _selectedPropertyTypeList = [];
  List<dynamic> _selectedPropertyStatusList = [];
  List<dynamic> _selectedPropertyLabelList = [];

  List<dynamic> _selectedPropertyTypeIdsList = [];
  List<dynamic> _selectedPropertyStatusIdsList = [];
  List<dynamic> _selectedPropertyLabelIdsList = [];

  final _bedroomsTextController = TextEditingController();
  final _bathroomsTextController = TextEditingController();
  final _propertyPropertyTypeTextController = TextEditingController();
  final _propertyPropertyStatusTextController = TextEditingController();
  final _propertyPropertyLabelTextController = TextEditingController();

  String nonce = "";
  String imageNonce = "";
  final PropertyBloc _propertyBloc = PropertyBloc();

  @override
  void dispose() {
    if(_bedroomsTextController != null) _bedroomsTextController.dispose();
    if(_bathroomsTextController != null) _bathroomsTextController.dispose();
    if(_propertyPropertyTypeTextController != null) _propertyPropertyTypeTextController.dispose();
    if(_propertyPropertyStatusTextController != null) _propertyPropertyStatusTextController.dispose();
    if(_propertyPropertyLabelTextController != null) _propertyPropertyLabelTextController.dispose();
    super.dispose();
  }


  @override
  void initState() {

    if(ADD_PROP_GDPR_ENABLED == "0"){
      termsAndConditions = true;
      termsAndConditionsValue = "on";
    }

    _propertyTypeMetaDataList = HiveStorageManager.readPropertyTypesMetaData();
    _propertyLabelMetaDataList = HiveStorageManager.readPropertyLabelsMetaData();
    _propertyStatusMetaDataList = HiveStorageManager.readPropertyStatusMetaData();
    _defaultCurrency = HiveStorageManager.readDefaultCurrencyInfoData() ?? '\$';

    addPropertyDataMap[ADD_PROPERTY_CURRENCY] = _defaultCurrency;

    fetchNonce();

    super.initState();
  }

  fetchNonce() async {
    ApiResponse response = await _propertyBloc.fetchAddPropertyNonceResponse();
    if (response.success) {
      nonce = response.result;
    }

    response = await _propertyBloc.fetchAddImageNonceResponse();
    if (response.success) {
      imageNonce = response.result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Consumer<UserLoggedProvider>(
        builder: (context,login,child) {
          isLoggedIn = login.isLoggedIn!;
          return Scaffold(
            appBar: AppBarWidget(
              appBarTitle: UtilityMethods.getLocalizedString("add_property"),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    CardWidget(
                      shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
                      // color: Theme.of(context).backgroundColor,
                      child: Column(
                        children: [
                          addPropertyTitle(context),
                          addDescription(context),
                          addPrice(context),
                          addType(context),
                          addStatus(context),
                          addLabel(context),
                          addAreaInformation(context),
                          addPropertyAddress(),
                          addRoomsInformation(context),
                          addImages(context),
                          if(ADD_PROP_GDPR_ENABLED == "1")
                            termsAndConditionAgreementWidget(context),
                          addPropertyButtonWidget(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget addPropertyTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("property_title"),
        hintText: UtilityMethods.getLocalizedString("enter_your_property_title"),
        keyboardType: TextInputType.text,
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("property_title_cannot_be_empty");
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            _title = value!;
          });
        },
        onChanged: (value){
          setState(() {
            _title = value!;
          });
        },
      ),
    );
  }

  Widget addDescription(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("content"),
        hintText: UtilityMethods.getLocalizedString("description"),
        keyboardType: TextInputType.multiline,
        maxLines: 6,
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("property_description_cannot_be_empty");
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            _description = value!;
          });
        },
      ),
    );
  }

  Widget addPrice(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("sale_or_rent_price"),
        hintText: UtilityMethods.getLocalizedString("enter_the_price"),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("price_field_cannot_be_empty");
          }
          return null;
        },
        onSaved: (value) {
          setState(() {
            _price = value!;
          });
        },
      ),
    );
  }

  Widget dropDownViewWidget({
    required BuildContext context,
    required String labelText,
    required TextEditingController controller,
    required List<dynamic> dataItemsList,
    required List<dynamic> selectedItemsList,
    required List<dynamic> selectedItemsIdsList,
    // String Function(String?)? validator,
    String? Function(String? val)? validator,
    DropDownViewWidgetListener? dropDownViewWidgetListener,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 20, 20, 0),
  }){
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GenericTextWidget(
            labelText,
            style: AppThemePreferences().appTheme.labelTextStyle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextFormField(
              controller: controller,
              decoration: AppThemePreferences.formFieldDecoration(
                hintText: UtilityMethods.getLocalizedString("select"),
                suffixIcon: Icon(AppThemePreferences.dropDownArrowIcon),
              ),
              validator: validator,
              readOnly: true,
              onTap: (){
                FocusScope.of(context).requestFocus(FocusNode());
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return MultiSelectDialogWidget(
                      fromAddProperty: true,
                      title: UtilityMethods.getLocalizedString("select"),
                      dataItemsList: dataItemsList,
                      selectedItemsList: selectedItemsList,
                      selectedItemsSlugsList: selectedItemsIdsList,
                      multiSelectDialogWidgetListener: (List<dynamic> _selectedItemsList, List<dynamic> _listOfSelectedItemsIds){
                        dropDownViewWidgetListener!(_selectedItemsList, _listOfSelectedItemsIds);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String? getMultiSelectFieldValue(BuildContext context, List<dynamic> itemsList){
    if(itemsList.isNotEmpty && itemsList.toSet().toList().length == 1){
      return "${itemsList.toSet().toList().first}";
    }
    else if(itemsList.isNotEmpty && itemsList.toSet().toList().length > 1){
      return UtilityMethods.getLocalizedString("multi_select_drop_down_item_selected",inputWords: [(itemsList.toSet().toList().length.toString())]);
    }
    return null;
  }

  Widget addType(BuildContext context) {
    return _propertyTypeMetaDataList == null || _propertyTypeMetaDataList.isEmpty ? Container() :
    dropDownViewWidget(
        context: context,
        labelText: UtilityMethods.getLocalizedString("type"),
        controller: _propertyPropertyTypeTextController,
        dataItemsList: _propertyTypeMetaDataList,
        selectedItemsList: _selectedPropertyTypeList,
        selectedItemsIdsList: _selectedPropertyTypeIdsList,
        validator: (String? value) {
          if(value != null && value.isNotEmpty){
            if(mounted) {
              setState(() {
                addPropertyDataMap[ADD_PROPERTY_TYPE_NAMES_LIST] = _selectedPropertyTypeList;
                addPropertyDataMap[ADD_PROPERTY_TYPE] = _selectedPropertyTypeIdsList;
              });
            }
          }
          // else{
          //   return "This Field can not be Empty";
          // }

          return null;
        },
        dropDownViewWidgetListener: (List<dynamic>? _selectedItemsList, List<dynamic>? _listOfSelectedItemsIds){
          if(mounted) {
            setState(() {
              _selectedPropertyTypeList = _selectedItemsList!;
              _selectedPropertyTypeIdsList = _listOfSelectedItemsIds!;
              _propertyPropertyTypeTextController.text = getMultiSelectFieldValue(context, _selectedPropertyTypeList)!;
            });
          }
        }
    );
  }

  Widget addStatus(BuildContext context) {
    return _propertyStatusMetaDataList == null || _propertyStatusMetaDataList.isEmpty ? Container() :
    dropDownViewWidget(
        context: context,
        labelText: UtilityMethods.getLocalizedString("status"),
        controller: _propertyPropertyStatusTextController,
        dataItemsList: _propertyStatusMetaDataList,
        selectedItemsList: _selectedPropertyStatusList,
        selectedItemsIdsList: _selectedPropertyStatusIdsList,
        validator: (String? value) {
          if(value != null && value.isNotEmpty){
            if(mounted) {
              setState(() {
                addPropertyDataMap[ADD_PROPERTY_STATUS_NAMES_LIST] = _selectedPropertyStatusList;
                addPropertyDataMap[ADD_PROPERTY_STATUS] = _selectedPropertyStatusIdsList;
              });
            }
          }
          // else{
          //   return "This Field can not be Empty";
          // }

          return null;
        },
        dropDownViewWidgetListener: (List<dynamic>? _selectedItemsList, List<dynamic>? _listOfSelectedItemsIds){
          if(mounted) {
            setState(() {
              _selectedPropertyStatusList = _selectedItemsList!;
              _selectedPropertyStatusIdsList = _listOfSelectedItemsIds!;
              _propertyPropertyStatusTextController.text = getMultiSelectFieldValue(context, _selectedPropertyStatusList)!;
            });
          }
        }
    );
  }

  Widget addLabel(BuildContext context) {
    return _propertyLabelMetaDataList == null || _propertyLabelMetaDataList.isEmpty ? Container() :
    dropDownViewWidget(
        context: context,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        labelText: UtilityMethods.getLocalizedString("label"),
        controller: _propertyPropertyLabelTextController,
        dataItemsList: _propertyLabelMetaDataList,
        selectedItemsList: _selectedPropertyLabelList,
        selectedItemsIdsList: _selectedPropertyLabelIdsList,
        validator: (String? value) {
          if(value != null && value.isNotEmpty){
            if(mounted) {
              setState(() {
                addPropertyDataMap[ADD_PROPERTY_LABEL_NAMES_LIST] = _selectedPropertyLabelList;
                addPropertyDataMap[ADD_PROPERTY_LABELS] = _selectedPropertyLabelIdsList;
              });
            }
          }
          // else{
          //   return "This Field can not be Empty";
          // }

          return null;
        },
        dropDownViewWidgetListener: (List<dynamic>? _selectedItemsList, List<dynamic>? _listOfSelectedItemsIds){
          if(mounted) {
            setState(() {
              _selectedPropertyLabelList = _selectedItemsList!;
              _selectedPropertyLabelIdsList = _listOfSelectedItemsIds!;
              _propertyPropertyLabelTextController.text = getMultiSelectFieldValue(context, _selectedPropertyLabelList)!;
            });
          }
        }
    );
  }

  Widget addAreaInformation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addAreaSize(context)),
        Expanded(flex: 5, child: addSizePostfix(context)),
      ],
    );
  }

  Widget addPropertyAddress() {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("address")+" *",//AppLocalizations.of(context).address_star,
        hintText: UtilityMethods.getLocalizedString("enter_your_property_address"),//AppLocalizations.of(context).enter_your_property_address,
        validator: (String? value) {
          if (value?.isEmpty ?? true) {
            return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
          }
          if(value != null && value.isNotEmpty){
            if(mounted){
              setState(() {
                addPropertyDataMap[ADD_PROPERTY_MAP_ADDRESS]  = value;
              });
            }
          }
          return null;
        },
      ),
    );
  }

  Widget addAreaSize(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("area_size"),
        hintText: UtilityMethods.getLocalizedString("enter_area_size"),
        additionalHintText: UtilityMethods.getLocalizedString("only_digits"),
        onChanged: (value) {
          setState(() {
            _areaSize = value!;
          });
        },
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            setState(() {
              addPropertyDataMap[ADD_PROPERTY_SIZE] = value;
            });
          }
          return null;
        },
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        onSaved: (value) {
          setState(() {
            _areaSize = value!;
          });
        },
      ),
    );
  }

  Widget addSizePostfix(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormFieldWidget(
        labelText: UtilityMethods.getLocalizedString("size_postfix"),
        hintText: UtilityMethods.getLocalizedString("enter_size_postfix"),
        additionalHintText: UtilityMethods.getLocalizedString("for_example_Sq_Ft"),
        onChanged: (value) {
          setState(() {
            _sizePostfix = value!;
          });
        },
        validator: (String? value) {
          if (value != null && value.isNotEmpty) {
            setState(() {
              addPropertyDataMap[ADD_PROPERTY_SIZE_PREFIX] = value;
            });
          }
          return null;
        },
      ),
    );
  }

  Widget addRoomsInformation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 5, child: addNumberOfBedrooms(context)),
        Expanded(flex: 5, child: addNumberOfBathrooms(context)),
      ],
    );
  }

  Widget addNumberOfBedrooms(BuildContext context) {
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bedrooms"),
      controller: _bedroomsTextController,
      onRemovePressed: () {
        if (_bedrooms > 0) {
          setState(() {
            _bedrooms -= 1;
            _bedroomsTextController.text = _bedrooms.toString();
          });
        }
      },
      onAddPressed: () {
        if (_bedrooms >= 0) {
          setState(() {
            _bedrooms += 1;
            _bedroomsTextController.text = _bedrooms.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _bedrooms = int.parse(value);
        });
      },
      validator: (String? value) {
        if (value != null && value.isNotEmpty) {
          setState(() {
            addPropertyDataMap[ADD_PROPERTY_BEDROOMS] = value;
          });
          //widget.propertyFloorPlansPageListener(dataMap);
        }
        return null;
      },
    );
  }

  Widget addNumberOfBathrooms(BuildContext context) {
    return GenericStepperWidget(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 0),
      labelText: UtilityMethods.getLocalizedString("bathrooms"),
      controller: _bathroomsTextController,
      onRemovePressed: () {
        if (_bathrooms > 0) {
          setState(() {
            _bathrooms -= 1;
            _bathroomsTextController.text = _bathrooms.toString();
          });
        }
      },
      onAddPressed: () {
        if (_bathrooms >= 0) {
          setState(() {
            _bathrooms += 1;
            _bathroomsTextController.text = _bathrooms.toString();
          });
        }
      },
      onChanged: (value) {
        setState(() {
          _bathrooms = int.parse(value);
        });
      },
      validator: (String? value) {
        if (value != null && value.isNotEmpty) {
          setState(() {
            addPropertyDataMap[ADD_PROPERTY_BATHROOMS] = value;
          });
          //widget.propertyFloorPlansPageListener(dataMap);
        }
        return null;
      },
    );
  }

  Widget addImages(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelWidget(UtilityMethods.getLocalizedString("select_and_upload")),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: GenericTextWidget(
              "$_totalImages"+UtilityMethods.getLocalizedString("fifty_files"),
              style: AppThemePreferences().appTheme.subBody01TextStyle,
            ),
          ),
          LightButtonWidget(
              text: UtilityMethods.getLocalizedString("upload_media"),
              fontSize: AppThemePreferences.buttonFontSize,
              onPressed: ()=> _totalImages <= 50 ? chooseImageOption(context) : _showToast(context,UtilityMethods.getLocalizedString("you_have_reached_the_limit"))
          ),
          _imageMapsList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GenericTextWidget(
                        UtilityMethods.getLocalizedString("click_on_the_star_icon_to_select_the_cover_image"),
                        style: AppThemePreferences().appTheme.subBody01TextStyle,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: _buildGridView(context),
                      ),
                    ],
                  ),
                )
              : Container(),
          noImageErrorWidget(context),
        ],
      ),
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
          const Divider(thickness: 1,),
          InkWell(
            onTap: () {
              getImageMultiple();
              Navigator.pop(context);
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10,),
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
      for (var pickedFile in pickedFiles) {
        File _image = File(pickedFile.path);
        Directory appDocumentDir = await getApplicationDocumentsDirectory();
        final String path = appDocumentDir.path;
        var fileName = basename(_image.path);
        final File newImage = await _image.copy('$path/$fileName');

        /// Make a map of selected image info and add it to the List of selected images.
        Map<String, dynamic> _imageInfoMap = {
          'ImageName': fileName,
          'ImagePath': newImage.path,
          'ImageStatus': 'Pending',
          'ImageId': '${DateTime.now().millisecondsSinceEpoch}',
        };
        _imageMapsList.add(_imageInfoMap);
      }
      setState(() {
        //_image = newImage;
        _totalImages = _imageMapsList.length;
        addPropertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
      });

      if (selectedImageIndex == 0) {
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
              _imageMapsList[0]['ImageId'];
        });
      }
    } else {
      print('No image selected.');
    }
  }

  Future getImage() async {
    var pickedFile =
    await picker.pickImage(source: ImageSource.camera, imageQuality: 90);

    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      Directory appDocumentDir = await getApplicationDocumentsDirectory();
      final String path = appDocumentDir.path;
      var fileName = basename(_image.path);
      final File newImage = await _image.copy('$path/$fileName');

      /// Make a map of selected image info and add it to the List of selected images.
      Map<String, dynamic> _imageInfoMap = {
        'ImageName': fileName,
        'ImagePath': newImage.path,
        'ImageStatus': 'Pending',
        'ImageId': '${DateTime.now().millisecondsSinceEpoch}',
      };
      _imageMapsList.add(_imageInfoMap);

      setState(() {
        _totalImages = _imageMapsList.length;
        addPropertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
      });

      if (selectedImageIndex == 0) {
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] =
          _imageMapsList[0]['ImageId'];
        });
      }
    } else {
      print('No image selected.');
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
          shape: AppThemePreferences.roundedCorners(AppThemePreferences.globalRoundedCornersRadius),
          color: Colors.grey[100],
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(item['ImagePath']),
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
                            setState(() {
                              _imageMapsList.remove(item);
                              _totalImages -= 1;
                            });
                            Navigator.pop(context);
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
                    selectedImageIndex == index ? AppThemePreferences.starFilledIcon : AppThemePreferences.starOutlinedIcon,
                    size: AppThemePreferences.featuredImageStarIconSize,
                    color: AppThemePreferences.starIconColor,
                  ),
                  onTap: () {
                    setState(() {
                      selectedImageIndex = index;
                      addPropertyDataMap[ADD_PROPERTY_FEATURED_IMAGE_LOCAL_ID] = _imageMapsList[index]['ImageId'];
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget termsAndConditionAgreementWidget(BuildContext context) {
    return FormField<bool>(
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                    value: termsAndConditions,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      setState(() {
                        termsAndConditions = value!;
                        if (termsAndConditions) {
                          termsAndConditionsValue = "on";
                        }
                        state.didChange(value);
                      });
                    }),
                Expanded(
                  child: GenericLinkWidget(
                      preLinkText: UtilityMethods.getLocalizedString("i_consent_to_having_this_website_to_store_my_submitted_information_read_more_information"),
                      linkText: UtilityMethods.getLocalizedString("gdpr_agreement"),
                      onLinkPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebPage(WORDPRESS_URL_GDPR_AGREEMENT, UtilityMethods.getLocalizedString("gdpr_agreement")),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
            state.errorText != null ? Padding(
              padding: const EdgeInsets.only(top: 10,left: 20.0),
              child: GenericTextWidget(
                state.errorText!,
                style: TextStyle(
                  color: AppThemePreferences.errorColor,
                ),
              ),
            ) : Container(),
          ],
        );
      },
      validator: (value) {
        if (!termsAndConditions) {
          return UtilityMethods.getLocalizedString("please_accept_terms_text");
        }
          return null;
      },
    );
  }

  Widget noImageErrorWidget(BuildContext context){
    return FormField<bool>(
      builder: (state) {
        return Container(
          child: state.errorText != null && _totalImages < 1 ? Padding(
            padding: const EdgeInsets.only(top: 10,left: 0.0),
            child: GenericTextWidget(
              state.errorText!,
              style: TextStyle(
                color: AppThemePreferences.errorColor,
              ),
            ),
          ) : Container(),
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

  Widget addPropertyButtonWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonWidget(
            text: UtilityMethods.getLocalizedString("add_property"),
            onPressed: () {
              if (HooksConfigurations.addPropertyActionHook != null) {
                HooksConfigurations.addPropertyActionHook(
                  context: context,
                  addPropertyNonce: nonce,
                  uploadImagesNonce: imageNonce,
                  addPropertyDataMap: addPropertyDataMap,
                  defaultAddPropertyFunc: () => startAddPropertyProcess(context),
                );
              } else {
                startAddPropertyProcess(context);
              }

            },
          ),
        ],
      ),
    );
  }

  startAddPropertyProcess(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if(mounted) {
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_TITLE] = _title;
          addPropertyDataMap[ADD_PROPERTY_PRICE] = _price;
          addPropertyDataMap[ADD_PROPERTY_DESCRIPTION] = _description ?? '';
          addPropertyDataMap[ADD_PROPERTY_SIZE] = _areaSize;
          addPropertyDataMap[ADD_PROPERTY_SIZE_PREFIX] = _sizePostfix;
          addPropertyDataMap[ADD_PROPERTY_PENDING_IMAGES_LIST] = _imageMapsList;
          addPropertyDataMap[ADD_PROPERTY_LOCAL_ID] = '${DateTime.now().millisecondsSinceEpoch}';
          addPropertyDataMap[ADD_PROPERTY_BEDROOMS] = _bedrooms;
          addPropertyDataMap[ADD_PROPERTY_BATHROOMS] = _bathrooms;
        });
      }

      if (isLoggedIn == true) {
        print("Logged in value: $isLoggedIn");

        /// Assigning the Login and Pending status to the Property.
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_true';
          addPropertyDataMap[ADD_PROPERTY_UPLOAD_STATUS] = ADD_PROPERTY_UPLOAD_STATUS_PENDING;
        });
        addPropertyDataMap[ADD_PROPERTY_IMAGE_NONCE] = imageNonce;
        addPropertyDataMap[ADD_PROPERTY_NONCE] = nonce;

        // print("addPropertyDataMap: $addPropertyDataMap");

        /// Storing Property Data Map to Storage:
        _addPropertyDataMapsList.add(addPropertyDataMap);
        HiveStorageManager.storeAddPropertiesDataMaps(_addPropertyDataMapsList);

        /// Upload Property:
        PropertyManager().uploadProperty();

        /// Your Property is being uploaded Toast:
        _showToast(context, UtilityMethods.getLocalizedString("your_property_is_being_uploaded"));

        // /// Pop() the page and go back to Home Page.
        // Navigator.of(context).pop();

        /// Replace() the page with Properties and show uploading progress.
        UtilityMethods.navigateToRouteByReplacement(
          context: context,
          builder: (context) => Properties(showUploadingProgress: true),
        );

      } else if (isLoggedIn == false) {
        print("Logged in value: $isLoggedIn");

        /// Assigning the Login status to the Property.
        setState(() {
          addPropertyDataMap[ADD_PROPERTY_LOGGED_IN] = 'login_false';
        });

        /// Storing Property Data Map to Storage:
        _addPropertyDataMapsList.add(addPropertyDataMap);
        HiveStorageManager.storeAddPropertiesDataMaps(_addPropertyDataMapsList);

        _userNotLoggedInDialog(context);
      }
    }
  }

  _showToast(BuildContext context, String msg) {
    ShowToastWidget(
      buildContext: context,
      text: msg,
    );
  }

  Future _userNotLoggedInDialog(BuildContext context) {
    return ShowDialogBoxWidget(
      context,
      title: UtilityMethods.getLocalizedString("you_are_not_logged_in"),
      textAlign: TextAlign.center,
      content: ButtonWidget(
        text: UtilityMethods.getLocalizedString("login"),
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (context) => UserSignIn(
                  (String closeOption) {
                if (closeOption == CLOSE) {
                  Navigator.pop(context);
                }
              },
            ),
          );
          Navigator.pushReplacement(context, route);
        },
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 5,
    );
  }
}
