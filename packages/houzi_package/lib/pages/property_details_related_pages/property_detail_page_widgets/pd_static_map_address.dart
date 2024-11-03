import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/full_screen_map_view.dart';
import 'package:houzi_package/widgets/shimmer_effect_error_widget.dart';

class PropertyDetailPageStaticMapAddress extends StatefulWidget {
  final Article article;
  final List imageUrlsList;

  const PropertyDetailPageStaticMapAddress({
    required this.article,
    required this.imageUrlsList,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageStaticMapAddress> createState() =>
      _PropertyDetailPageStaticMapAddressState();
}

class _PropertyDetailPageStaticMapAddressState
    extends State<PropertyDetailPageStaticMapAddress> {
  Article? _article;

  String articleLocationLink = "";

  @override
  void initState() {
    super.initState();
    _article = widget.article;
  }

  loadData(Article article) {
    String _lat = _article!.address!.lat ?? "";
    String _lng = _article!.address!.long ?? "";
    if(_lat.isNotEmpty && _lng.isNotEmpty){
      articleLocationLink = UtilityMethods.getStaticMapUrl(lat: _lat, lng: _lng);
      if(mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return showPropertyLocationOnMap();
  }

  Widget showPropertyLocationOnMap() {
    return articleLocationLink.isEmpty ? Container() :
    Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: GestureDetector(
          child: FancyShimmerImage(
                  imageUrl: articleLocationLink,
                  boxFit: BoxFit.fill,
                  shimmerBaseColor:
                      AppThemePreferences().appTheme.shimmerEffectBaseColor,
                  shimmerHighlightColor: AppThemePreferences()
                      .appTheme
                      .shimmerEffectHighLightColor,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  errorWidget: ShimmerEffectErrorWidget(),
                ),
          onTap: navigateToFullScreenMapViewArticle,
        ),
      ),
    );
  }

  navigateToFullScreenMapViewArticle() {
    _article!.image = widget.imageUrlsList[0];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMapViewArticle(_article!),
      ),
    );
  }
}
