import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? labelText;
  final TextStyle? labelTextStyle;
  final String? additionalHintText;
  final bool ignorePadding;
  final String? initialValue;
  final int? maxLines;
  final String? hintText;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? val)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final void Function(String?)? onFieldSubmitted;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? textFieldPadding;
  final bool enabled;
  final Color? backgroundColor;
  final Color? focusedBorderColor;
  final bool hideBorder;
  final BorderRadius? borderRadius;
  final bool isCompulsory;
  final FocusNode? focusNode;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintTextStyle;
  final EdgeInsets? scrollPadding;
  final Iterable<String>? autofillHints;
  const TextFormFieldWidget({
    Key? key,
    this.labelText,
    this.labelTextStyle,
    this.additionalHintText,
    this.ignorePadding = false,
    this.initialValue,
    this.maxLines = 1,
    this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.enabled = true,
    this.backgroundColor,
    this.focusedBorderColor,
    this.hideBorder = false,
    this.isCompulsory = false,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
    this.textFieldPadding = const EdgeInsets.only(bottom: 10),
    this.focusNode,
    this.maxLength,
    this.contentPadding,
    this.hintTextStyle,
    this.scrollPadding,
    this.autofillHints,
  }) : super(key: key);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  TextStyle? labelTextStyle;
  TextStyle? hintTextStyle;
  TextStyle? additionalHintTextStyle;
  Color? backgroundColor;
  Color? focusedBorderColor;
  bool hideBorder = false;
  BorderRadius? borderRadius;

  TextFormFieldCustomizationHook? _textFormFieldCustomizationHook;

  Widget? _widget;

  @override
  void initState() {

    labelTextStyle = widget.labelTextStyle;
    hintTextStyle = widget.hintTextStyle;
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

    _widget = HooksConfigurations.textFormFieldWidgetHook!(
      context,
      widget.labelText,
      widget.hintText,
      widget.additionalHintText,
      widget.suffixIcon,
      widget.initialValue,
      widget.maxLines,
      widget.readOnly,
      widget.obscureText,
      widget.controller,
      widget.keyboardType,
      widget.inputFormatters,
      widget.validator,
      widget.onSaved,
      widget.onChanged,
      widget.onFieldSubmitted,
      widget.onTap,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_widget != null){
      return Container(child: _widget);
    }else {
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
              child: TextFormField(
                scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
                maxLength: widget.maxLength,
                focusNode: widget.focusNode,
                enabled: widget.enabled,
                initialValue: widget.initialValue,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                validator: widget.validator,
                decoration: AppThemePreferences.formFieldDecoration(
                  hintText: widget.hintText != null
                      ? UtilityMethods.getLocalizedString(widget.hintText!)
                      : widget.hintText,
                  suffixIcon: widget.suffixIcon,
                  hideBorder: hideBorder,
                  borderRadius: borderRadius,
                  hintTextStyle: hintTextStyle,
                  focusedBorderColor: focusedBorderColor,
                  contentPadding: widget.contentPadding,
                ),
                onSaved: widget.onSaved ?? (string) {},
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onFieldSubmitted,
                maxLines: widget.maxLines,
                autofillHints: widget.autofillHints,
                readOnly: widget.readOnly,
                inputFormatters: widget.inputFormatters,
                obscureText: widget.obscureText,
                onTap: widget.onTap,
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
    }
  }
}

class LabelWidget extends StatelessWidget {
  final String text;
  final TextStyle? labelTextStyle;

  const LabelWidget(
      this.text, {
        Key? key,
        this.labelTextStyle,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GenericTextWidget(
      UtilityMethods.getLocalizedString(text),
      style: labelTextStyle ?? AppThemePreferences().appTheme.labelTextStyle,
    );
  }
}

class AdditionalHintWidget extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;

  const AdditionalHintWidget(
      this.text, {
        Key? key,
        this.textStyle,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericTextWidget(
      UtilityMethods.getLocalizedString(text),
      style: textStyle ?? AppThemePreferences().appTheme.hintTextStyle,
    );
  }
}
