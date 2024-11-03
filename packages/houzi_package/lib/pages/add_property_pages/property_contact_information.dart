import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/widgets/add_property_widgets/contact_info_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/card_widget.dart';
import 'package:houzi_package/widgets/header_widget.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';

typedef PropertyContactInformationPageListener = void Function(Map<String, dynamic> _dataMap);

class PropertyContactInformationPage extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final Map<String, dynamic>? propertyInfoMap;
  final PropertyContactInformationPageListener? propertyContactInformationPageListener;

  PropertyContactInformationPage({
    Key? key,
    this.formKey,
    this.propertyInfoMap,
    this.propertyContactInformationPageListener
  }) : super(key: key);

  @override
  State<PropertyContactInformationPage> createState() => _PropertyContactInformationPageState();
}

class _PropertyContactInformationPageState extends State<PropertyContactInformationPage> {

  bool _showWaitingWidget = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children : [
          Form(
            key: widget.formKey,
            child: Column(
              children: [
                CardWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      contactInformationTextWidget(),
                      ContactInformationWidget(
                        propertyInfoMap: widget.propertyInfoMap,
                        listener: ({showWaitingWidget, updatedDataMap}) {

                          if (showWaitingWidget != null) {
                            Future.delayed(Duration.zero, () {
                              if (mounted) setState(() {
                                _showWaitingWidget = showWaitingWidget;
                              });
                            });
                          }

                          if(updatedDataMap != null) {
                            widget.propertyContactInformationPageListener!(updatedDataMap);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AddPropertyContactInfoWaitingWidget(showWidget: _showWaitingWidget),
        ],
      ),
    );
  }

  Widget contactInformationTextWidget() {
    return HeaderWidget(
      text: UtilityMethods.getLocalizedString("contact_information"),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      alignment: Alignment.topLeft,
      decoration: AppThemePreferences.dividerDecoration(),
    );
  }
}

class AddPropertyContactInfoWaitingWidget extends StatelessWidget {
  final bool showWidget;

  const AddPropertyContactInfoWaitingWidget({
    Key? key,
    this.showWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showWidget) {
      return Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: const SizedBox(
              width: 80,
              height: 20,
              child: BallBeatLoadingWidget(),
            ),
          ),
        ),
      );
    }

    return Container();
  }
}