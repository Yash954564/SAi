import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';

class BottomActionBarWidget extends StatelessWidget {
  final bool isInternetConnected;

  const BottomActionBarWidget({
    Key? key,
    required this.isInternetConnected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if(!isInternetConnected) NoInternetBottomActionBarWidget(showRetryButton: false),
          ],
        ),
      ),
    );
  }
}