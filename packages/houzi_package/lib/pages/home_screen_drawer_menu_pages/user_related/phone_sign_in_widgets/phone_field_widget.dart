
import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/widgets/generic_text_field_widgets/text_field_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

typedef PhoneNumberFieldWidgetListener = void Function(String code, String num);

class PhoneNumberFieldWidget extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelTextStyle;
  final String? additionalHintText;
  final String? hintText;
  final bool ignorePadding;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? textFieldPadding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Color? focusedBorderColor;
  final bool hideBorder;
  final bool isCompulsory;
  final PhoneNumberFieldWidgetListener listener;

  const PhoneNumberFieldWidget({
    super.key,
    required this.listener,
    this.labelText,
    this.hintText,
    this.labelTextStyle,
    this.additionalHintText,
    this.ignorePadding = false,
    this.backgroundColor,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.textFieldPadding = const EdgeInsets.only(bottom: 10),
    this.focusedBorderColor,
    this.hideBorder = false,
    this.isCompulsory = false,
  });

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  TextStyle? labelTextStyle;
  TextStyle? hintTextStyle;
  TextStyle? additionalHintTextStyle;
  Color? backgroundColor;
  Color? focusedBorderColor;
  bool hideBorder = false;
  BorderRadius? borderRadius;
  TextFormFieldCustomizationHook? _textFormFieldCustomizationHook;

  String initialCountry = 'PK';
  String phoneNumber = "";
  String countryDialCode = "";

  @override
  void initState() {
    DefaultCountryCodeHook defaultCountryCodeHook = HooksConfigurations.defaultCountryCode;
    String defaultCountryCode = defaultCountryCodeHook();
    if (defaultCountryCode.isNotEmpty) {
      initialCountry = defaultCountryCode;
    }

    labelTextStyle = widget.labelTextStyle;
    backgroundColor = widget.backgroundColor;
    focusedBorderColor = widget.focusedBorderColor;
    hideBorder = widget.hideBorder;
    borderRadius = widget.borderRadius;

    // Overwrite from Hook
    _textFormFieldCustomizationHook = HooksConfigurations.textFormFieldCustomizationHook;
    Map<String, dynamic>? tempMap = _textFormFieldCustomizationHook!();
    if(tempMap != null && tempMap.isNotEmpty){
      if(tempMap.containsKey("labelTextStyle") && tempMap["labelTextStyle"] != null){
        labelTextStyle = tempMap["labelTextStyle"];
      }
      if(tempMap.containsKey("hintTextStyle") && tempMap["hintTextStyle"] != null){
        hintTextStyle = tempMap["hintTextStyle"];
      }
      if(tempMap.containsKey("additionalHintTextStyle") && tempMap["additionalHintTextStyle"] != null){
        additionalHintTextStyle = tempMap["additionalHintTextStyle"];
      }
      if(tempMap.containsKey("backgroundColor") && tempMap["backgroundColor"] != null){
        backgroundColor = tempMap["backgroundColor"];
      }
      if(tempMap.containsKey("focusedBorderColor") && tempMap["focusedBorderColor"] != null){
        focusedBorderColor = tempMap["focusedBorderColor"];
      }
      if(tempMap.containsKey("hideBorder") && tempMap["hideBorder"] != null){
        hideBorder = tempMap["hideBorder"];
      }
      if(tempMap.containsKey("borderRadius") && tempMap["borderRadius"] != null){
        borderRadius = tempMap["borderRadius"];
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.ignorePadding
          ? const EdgeInsets.all(0.0)
          : widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.labelText != null && widget.labelText!.isNotEmpty)
            Container(
              padding: widget.textFieldPadding,
              child: LabelWidget(
                "${UtilityMethods.getLocalizedString(widget.labelText!)}${widget.isCompulsory ? " *" : ""}",
                labelTextStyle: labelTextStyle,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius ?? BorderRadius.circular(
                  AppThemePreferences.globalRoundedCornersRadius),
            ),
            child: IntlPhoneField(
              initialCountryCode: HooksConfigurations.defaultCountryCode() ?? 'PK',
              decoration: InputDecoration(
                hintText: widget.hintText ?? UtilityMethods.getLocalizedString("phone"),
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: focusedBorderColor ?? focusedBorderColor ?? AppThemePreferences.formFieldBorderColor,
                  ),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              onChanged: (phone) {
                phoneNumber = phone.number;
                countryDialCode = phone.countryCode.replaceAll("+", "");
                widget.listener(countryDialCode, phoneNumber);
              },
              onCountryChanged: (country) {
                countryDialCode = country.dialCode;
                widget.listener(countryDialCode, phoneNumber);
              },
            ),
          ),
          if(widget.additionalHintText != null && widget.additionalHintText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: AdditionalHintWidget(
                  widget.additionalHintText!,
                  textStyle: additionalHintTextStyle
              ),
            ),
        ],
      ),
    );
    // return IntlPhoneField(
    //   initialCountryCode: HooksConfigurations.defaultCountryCode() ?? 'PK',
    //   decoration: InputDecoration(
    //     hintText: UtilityMethods.getLocalizedString("phone"),
    //     border: OutlineInputBorder(
    //       borderSide: BorderSide(),
    //     ),
    //   ),
    //   keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
    //   onChanged: (phone) {
    //     phoneNumber = phone.number;
    //     countryDialCode = phone.countryCode.replaceAll("+", "");
    //     widget.listener(countryDialCode, phoneNumber);
    //   },
    //   onCountryChanged: (country) {
    //     countryDialCode = country.dialCode;
    //     widget.listener(countryDialCode, phoneNumber);
    //   },
    // );
  }
}