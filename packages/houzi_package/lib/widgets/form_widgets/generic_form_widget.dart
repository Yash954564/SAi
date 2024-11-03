import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:houzi_package/models/form_related/houzi_form_item.dart';
import 'package:houzi_package/models/form_related/houzi_form_page.dart';
import 'package:houzi_package/widgets/add_property_widgets/gdpr_agreement_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_additional_details_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_checkbox_list_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_contatct_info_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_custom_fields_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_drop_down_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_floor_plans_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_map_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_media_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_multi_select_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_multi_units_ids_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_multi_units_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_price_placeholder_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_radio_button_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_stepper_widget.dart';
import 'package:houzi_package/widgets/form_widgets/form_text_field_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';

typedef GenericFormWidgetListener = Function(Map<String, dynamic> dataMap);

class GenericFormWidget extends StatefulWidget{
  final Map<String, dynamic>? infoDataMap;
  final List<HouziFormSectionFields> formSectionFieldsList;
  final List<HouziFormItem>? formItemsFieldsList;
  final bool isPropertyForUpdate;
  final GlobalKey<FormState>? formStateKey;
  final EdgeInsetsGeometry? formMargin;
  final EdgeInsetsGeometry? formItemPadding;
  final GenericFormWidgetListener listener;

  const GenericFormWidget({
    Key? key,
    this.formStateKey,
    required this.formSectionFieldsList,
    this.formItemsFieldsList,
    this.infoDataMap,
    this.isPropertyForUpdate = false,
    this.formMargin = const EdgeInsets.symmetric(vertical: 0.0), //20
    this.formItemPadding = const EdgeInsets.only(top: 20.0, left: 20, right: 20),
    required this.listener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GenericFormWidgetState();

}

class GenericFormWidgetState extends State<GenericFormWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    
    super.initState();
  }


  @override
  void dispose() {
    if(mounted){
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: SingleChildScrollView(
        controller: controller,
        child: Container(
          margin: widget.formMargin,
          child: Form(
            key: widget.formStateKey ?? formKey,
            child: widget.formSectionFieldsList.isNotEmpty
                ? SectionFieldsWidget(
                    formMargin: widget.formMargin,
                    formItemPadding: widget.formItemPadding,
                    infoDataMap: widget.infoDataMap,
                    isPropertyForUpdate: widget.isPropertyForUpdate,
                    formSectionFieldsList: widget.formSectionFieldsList,
                    listener: widget.listener,
                  )
                : (widget.formItemsFieldsList != null &&
                    widget.formItemsFieldsList!.isNotEmpty)
                    ? FormWidget(
                        formMargin: widget.formMargin,
                        infoDataMap: widget.infoDataMap,
                        formItemPadding: widget.formItemPadding,
                        formItemsList: widget.formItemsFieldsList!,
                        isPropertyForUpdate: widget.isPropertyForUpdate,
                        listener: widget.listener,
                      )
                    : Container(),
          ),
        ),
      ),
    );
  }
}

class SectionFieldsWidget extends StatefulWidget {
  final List<HouziFormSectionFields> formSectionFieldsList;
  final EdgeInsetsGeometry? formMargin;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final bool isPropertyForUpdate;
  final GenericFormWidgetListener listener;

  const SectionFieldsWidget({
    super.key,
    required this.formSectionFieldsList,
    this.infoDataMap,
    this.isPropertyForUpdate = false,
    this.formMargin = const EdgeInsets.symmetric(vertical: 0.0), //20
    this.formItemPadding = const EdgeInsets.only(top: 20.0, left: 20, right: 20),
    required this.listener,
  });

  @override
  State<SectionFieldsWidget> createState() => _SectionFieldsWidgetState();
}

class _SectionFieldsWidgetState extends State<SectionFieldsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.formSectionFieldsList.map((formSectionField) {
        if (showFormSectionFieldItem(formSectionField)) {
          return CardWidget(
            child: Column(
              children: [
                /// Section Header:
                if (formSectionField.section != null &&
                    formSectionField.section!.isNotEmpty)
                  HeaderWidget(
                    text: formSectionField.section!,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            color: AppThemePreferences().appTheme.dividerColor!),
                      ),
                    ),
                  ),

                /// Fields:
                if (formSectionField.fields != null &&
                    formSectionField.fields!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: FormWidget(
                      formMargin: widget.formMargin,
                      infoDataMap: widget.infoDataMap,
                      formItemPadding: widget.formItemPadding,
                      formItemsList: formSectionField.fields!,
                      isPropertyForUpdate: widget.isPropertyForUpdate,
                      listener: widget.listener,
                    ),
                  ),
              ],
            ),
          );
        }

        return Container();

      }).toList(),
    );
  }

  bool showFormSectionFieldItem(HouziFormSectionFields formSectionFields) {
    if (formSectionFields.enable) {
      return true;
    }
    return false;
  }
}


class FormWidget extends StatefulWidget {
  final List<HouziFormItem> formItemsList;
  final EdgeInsetsGeometry? formMargin;
  final EdgeInsetsGeometry? formItemPadding;
  final Map<String, dynamic>? infoDataMap;
  final bool isPropertyForUpdate;
  final GenericFormWidgetListener listener;
  
  const FormWidget({
    super.key,
    required this.formItemsList,
    this.infoDataMap,
    this.isPropertyForUpdate = false,
    this.formMargin = const EdgeInsets.symmetric(vertical: 0.0), //20
    this.formItemPadding = const EdgeInsets.only(top: 20.0, left: 20, right: 20),
    required this.listener,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  String? type;
  int? index;

  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    type = null;
    index = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.formItemsList.map((houziFormItem) {
        if (showFormItem(houziFormItem)) {
          type = houziFormItem.sectionType;
          index = widget.formItemsList.indexOf(houziFormItem);

          switch (type) {
            case formTextField: {
              return GenericFormTextFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formMultiSelectField: {
              return GenericFormMultiSelectWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formDropDownField: {
              return GenericFormDropDownWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: (dataMap) {
                  widget.listener(dataMap);
                  if (mounted) {
                    setState(() {});
                  }
                },
              );
            }
            case formMediaField: {
              return GenericFormMediaWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                isPropertyForUpdate: widget.isPropertyForUpdate,
                propertyInfoMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formStepperField: {
              return GenericFormStepperFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formAdditionalDetailsField: {
              return GenericFormAdditionalDetailsFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formCustomField: {
              return GenericFormCustomFieldWidget(
                formItemIndex: index,
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formMapField: {
              return GenericFormMapLocationWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formCheckBoxListField: {
              return GenericFormCheckboxListFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formRadioButtonField: {
              return GenericFormRadioButtonWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case floorPlansField: {
              return GenericFormFloorPlansFieldWidget(
                formItem: houziFormItem,
                isPropertyForUpdate: widget.isPropertyForUpdate,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case multiUnitsField: {
              return GenericFormMultiUnitsFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case multiUnitsIdsField: {
              return GenericFormMultiUnitsIdsFieldWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case realtorContactInformationField: {
              return GenericRealtorContactInformationWidget(
                formItem: houziFormItem,
                formItemPadding: widget.formItemPadding,
                infoDataMap: widget.infoDataMap,
                listener: widget.listener,
              );
            }
            case formGDPRAgreementField: {
              return GDPRAgreementWidget(
                isAgree: widget.isPropertyForUpdate ? true : false,
                // padding: widget.formItemPadding,
                listener: (isAgreed) {
                  // if(mounted) setState(() {
                  //   isAgree = isAgreed;
                  // });
                },
              );
            }
            case formPricePlaceHolderField: {
              return GenericFormPricePlaceholderWidget(
                  formItem: houziFormItem,
                  formItemPadding: widget.formItemPadding,
                  infoDataMap: widget.infoDataMap,
                  listener: widget.listener,
              );
            }

            default: {
              return Container();
            }
          }
        }

        return Container();
      }).toList(),
    );
  }

  bool showFormItem(HouziFormItem formItem) {
    if(formItem.enable && isFormItemAllowedForCurrentUser(formItem)) {
      return true;
    }
    return false;
  }

  bool isFormItemAllowedForCurrentUser(HouziFormItem formItem) {
    String currentUserRole = HiveStorageManager.getUserRole();
    if (formItem.allowedRoles != null && formItem.allowedRoles!.isNotEmpty) {
      if (formItem.allowedRoles!.contains(currentUserRole)) {
        return true;
      } else {
        return false;
      }
    } else {
      // show publicly
      return true;
    }



    // if(formItem.allowedRoles != null &&
    //     formItem.allowedRoles!.isNotEmpty &&
    //     formItem.allowedRoles!.contains(currentUserRole)) {
    //   return true;
    // }
    // return false;
  }
}
