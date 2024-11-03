import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';

class WaitingWidget extends StatelessWidget {
  final bool showWaitingWidget;

  const WaitingWidget({
    Key? key,
    required this.showWaitingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(showWaitingWidget) return Positioned(
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: SizedBox(
            width: 80,
            height: 20,
            child: BallBeatLoadingWidget(),
          ),
        ),
      ),
    );

    return Container();
  }
}