import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';

typedef TermCheckBoxListWidgetListener = Function(List<dynamic> selectedDataList);

class TermCheckBoxListWidget extends StatefulWidget {
  final List<dynamic> termDataList;
  final List<dynamic> selectedDataList;
  final String comparisonOnTheBasisOf;
  final TermCheckBoxListWidgetListener listener;
  final EdgeInsetsGeometry? padding;

  const TermCheckBoxListWidget({
    Key? key,
    required this.termDataList,
    required this.selectedDataList,
    required this.listener,
    this.comparisonOnTheBasisOf = TERM_ID,
    this.padding = const EdgeInsets.fromLTRB(10, 20, 10, 20),
  }) : super(key: key);

  @override
  State<TermCheckBoxListWidget> createState() => _TermCheckBoxListWidgetState();
}

class _TermCheckBoxListWidgetState extends State<TermCheckBoxListWidget> {

  List<dynamic> selectedDataList = [];

  @override
  void initState() {

    if (widget.selectedDataList.isNotEmpty) {
      selectedDataList = widget.selectedDataList;
    }

    super.initState();
  }

  @override
  void dispose() {
    selectedDataList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.termDataList.isNotEmpty) {
      return Container(
        padding: widget.padding,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.termDataList.length,
          itemBuilder: (context, index) {

            var item = widget.termDataList[index];
            String? itemName = widget.termDataList[index].name;

            return CheckboxListTile(
              title: GenericTextWidget(
                UtilityMethods.getLocalizedString(itemName!),
              ),
              activeColor: Theme.of(context).primaryColor,
              value: getValue(widget.comparisonOnTheBasisOf, item, selectedDataList),
              onChanged: (bool? value) => updateDataList(widget.comparisonOnTheBasisOf, item),
            );
          },
        ),
      );
    }
    return Container();
  }

  bool getValue(String comparisonBase, var item, List<dynamic> dataList) {
    if (comparisonBase == TERM_ID && dataList.contains(item.id)) {
      return true;
    } else if (comparisonBase == TERM_NAME && dataList.contains(item.name)) {
      return true;
    } else if (comparisonBase == TERM_SLUG && dataList.contains(item.slug)) {
      return true;
    }

    return false;
  }

  updateDataList(String comparisonBase, var item) {
    var itemToBeCompared;
    if (comparisonBase == TERM_ID) {
      itemToBeCompared = item.id;
    } else if (comparisonBase == TERM_NAME) {
      itemToBeCompared = item.name;
    } else if (comparisonBase == TERM_SLUG) {
      itemToBeCompared = item.slug;
    }

    if (itemToBeCompared != null) {
      if(mounted) {
        setState(() {
          if (selectedDataList.contains(itemToBeCompared)) {
            selectedDataList.remove(itemToBeCompared);
          } else {
            selectedDataList.add(itemToBeCompared);
          }

          widget.listener(selectedDataList);
        });
      }
    }
  }
}