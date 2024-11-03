import 'package:flutter/material.dart';
import 'package:houzi_package/pages/home_page_screens/home_location_related/related_widgets/home_location_sliver_app_bar.dart';
import 'package:houzi_package/pages/home_page_screens/parent_home_related/parent_sliver_home.dart';

class HomeLocation extends ParentSliverHome {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const HomeLocation({
    Key? key,
    this.scaffoldKey
  }) : super(key: key);

  @override
  _HomeLocationState createState() => _HomeLocationState();
}

class _HomeLocationState extends ParentSliverHomeState<HomeLocation> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget getSliverAppBarWidget(){
    return HomeLocationSliverAppBarWidget(
      userLoggedIn: isLoggedIn,
      receivedNewNotifications: receivedNewNotifications,
      onLeadingIconPressed: () => widget.scaffoldKey!.currentState!.openDrawer(),
      selectedStatusIndex: super.getSelectedStatusIndex(),
      listener: ({hideNotificationDot}) {
        if (mounted && hideNotificationDot == true) {
          setState(() {
            receivedNewNotifications = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.scaffoldKey != null){
      super.scaffoldKey = widget.scaffoldKey!;
    }

    return super.build(context);
  }
}
