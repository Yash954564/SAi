import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CustomStaggeredGridWidget extends StatelessWidget {
  final int crossAxisCount;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final StaggeredTile? Function(int) staggeredTileBuilder;
  final Axis scrollDirection;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  const CustomStaggeredGridWidget({
    super.key,
    required this.crossAxisCount,
    required this.itemCount,
    required this.itemBuilder,
    required this.staggeredTileBuilder,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      scrollDirection: scrollDirection,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      staggeredTileBuilder: staggeredTileBuilder,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
    );
  }
}
