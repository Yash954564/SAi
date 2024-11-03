import 'package:flutter/material.dart';

class TopContainerWidget extends StatelessWidget {
  final double opacity;

  const TopContainerWidget({
    Key? key,
    required this.opacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(opacity > 0) return Positioned(
      top: 0.0,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 150,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor.withOpacity(opacity),
          ),
        ),
      ),
    );

    return Container();
  }
}
