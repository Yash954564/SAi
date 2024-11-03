import 'package:flutter/material.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/widgets/app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VirtualTour extends StatefulWidget {
  final String tourLink;

  @override
  State<StatefulWidget> createState() => VirtualTourState();
  VirtualTour(this.tourLink);
}

class VirtualTourState extends State<VirtualTour> {
  String tempAddr = "";
  String temp01 = "";
  String temp02 = "";
  bool isInternetConnected = true;

  WebViewController _controller = WebViewController();

  @override
  void initState() {
    loadData();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.dataFromString(
          '<html>'
              '<body>'
              '<iframe width="100%" height="100%" src=$temp02 frameBorder="0"></iframe>'
          // ' frameborder="0" allowfullscreen="allowfullscreen" scrolling="no">'
          // '</iframe>'
              '</body>'
              '</html>',
          mimeType: 'text/html'));

    super.initState();
  }


  loadData(){
    tempAddr = widget.tourLink;
    // print("received VT link: $tempAddr");

    if(tempAddr.isNotEmpty){
      if(tempAddr.contains("src=")){
        temp01 = tempAddr.split("src=")[1];
      }
      if(temp01.contains("frameborder")){
        temp02 = temp01.split("frameborder")[0];
        if(temp02.contains("\\")){
          temp02 = temp02.replaceAll("\\", "");
        }
      }else{
        temp02 = temp01;
      }

    }


    // print("Modified VT link: $temp02");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemePreferences().appTheme.backgroundColor,
      appBar: AppBarWidget(
        appBarTitle: UtilityMethods.getLocalizedString("virtual_tour"),
      ),
      body: WebViewWidget(controller: _controller),
      // body: WebView(
      //   initialUrl: Uri.dataFromString(
      //       '<html>'
      //           '<body>'
      //           '<iframe width="100%" height="100%" src=$temp02 frameBorder="0"></iframe>'
      //       // ' frameborder="0" allowfullscreen="allowfullscreen" scrolling="no">'
      //       // '</iframe>'
      //           '</body>'
      //           '</html>',
      //       mimeType: 'text/html').toString(),
      //   javascriptMode: JavascriptMode.unrestricted,
      // ),
    );
  }
}
