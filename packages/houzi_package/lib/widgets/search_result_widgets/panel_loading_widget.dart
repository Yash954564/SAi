import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:shimmer/shimmer.dart';

class PanelLoadingWidget extends StatelessWidget {
  const PanelLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 30),
      child: SizedBox(
        height: 710,
        child: Shimmer.fromColors(
          baseColor: AppThemePreferences().appTheme.shimmerEffectBaseColor!,
          highlightColor: AppThemePreferences().appTheme.shimmerEffectHighLightColor!,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: [
                  DummyPadding(padding: const EdgeInsets.only(bottom: 10.0)),
                  // DummyContainer(
                  //   height: 90.0,
                  //   decoration: BoxDecoration(
                  //     color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  // ),
                  DummyPadding(padding: const EdgeInsets.only(bottom: 40.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DummyContainer(
                        width: 160.0,
                        height: 210.0,
                        decoration: BoxDecoration(
                          color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      DummyPadding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(width: 80, height: 18.0),
                          ],
                        ),
                      )
                    ],
                  ),
                  DummyPadding(padding: const EdgeInsets.only(bottom: 20.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DummyContainer(
                        width: 160.0,
                        height: 210.0,
                        decoration: BoxDecoration(
                          color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      DummyPadding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(width: 80, height: 18.0),
                          ],
                        ),
                      )
                    ],
                  ),
                  DummyPadding(padding: const EdgeInsets.only(bottom: 20.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DummyContainer(
                        width: 160.0,
                        height: 210.0,
                        decoration: BoxDecoration(
                          color: AppThemePreferences.shimmerLoadingWidgetContainerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      DummyPadding(padding: const EdgeInsets.symmetric(horizontal: 8.0)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(),
                            DummyPadding(),
                            DummyContainer(width: 80, height: 18.0),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            itemCount: 1,
          ),
        ),
      ),
    );
  }

  Widget DummyPadding({
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 10.0),
  }){
    return Padding(padding: padding);
  }

  Widget DummyContainer({
    double width = double.infinity,
    double height = 18.0,
    Decoration decoration = const BoxDecoration(color: Colors.white),
    // Decoration decoration = const BoxDecoration(color: AppThemePreferences.shimmerLoadingWidgetContainerColor),
  }){
    return Container(width: width, height: height, decoration: decoration);
  }
}
