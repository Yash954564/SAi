import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';

class SavedSearchLoadingIndicatorWidget extends StatelessWidget {
  const SavedSearchLoadingIndicatorWidget({Key? key}) : super(key: key);

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