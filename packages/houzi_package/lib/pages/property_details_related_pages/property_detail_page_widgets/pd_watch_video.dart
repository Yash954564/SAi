import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/pages/property_details_related_pages/property_detail_page_widgets/pd_heading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPageWatchVideo extends StatefulWidget {
  final Article article;
  final String title;

  const PropertyDetailPageWatchVideo({
    required this.article,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PropertyDetailPageWatchVideo> createState() =>
      _PropertyDetailPageWatchVideoState();
}

class _PropertyDetailPageWatchVideoState extends State<PropertyDetailPageWatchVideo> {
  Article? _article;
  String articleYoutubeVideoLink = "";

  loadData(Article article) {
    articleYoutubeVideoLink = article.video ?? "";
    if(mounted)setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_article != widget.article) {
      _article = widget.article;
      loadData(_article!);
    }
    return watchVideoWidget(widget.title);
  }

  Widget watchVideoWidget(String title) {
    if (title.isEmpty) {
      title = "watch_video";
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: articleYoutubeVideoLink.isNotEmpty
          ? getRowWidget(
              text: UtilityMethods.getLocalizedString(title),
              onTap: navigateToYoutubeVideo,
            )
          : Container(),
    );
  }

  navigateToYoutubeVideo() async {
    await canLaunchUrl(Uri.parse(articleYoutubeVideoLink))
        ? launchUrl(Uri.parse(articleYoutubeVideoLink))
        : print("URL can't be launched.");
  }
}
