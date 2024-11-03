import 'package:flutter/material.dart';
import 'package:houzi_package/widgets/no_internet_botton_widget.dart';

class SavedSearchBottomActionWidget extends StatelessWidget {
  final bool isInternetConnected;
  final void Function()? onPressed;

  const SavedSearchBottomActionWidget({
    Key? key,
    required this.isInternetConnected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      child: SafeArea(
        child: Column(
          children: [
            if (!isInternetConnected)
              NoInternetBottomActionBarWidget(
                onPressed: onPressed,
              ),
          ],
        ),
      ),
    );
  }
}