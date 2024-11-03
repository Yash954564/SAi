import 'package:flutter/material.dart';
import 'package:houzi_package/files/generic_methods/general_notifier.dart';
import 'package:provider/provider.dart';

import 'package:houzi_package/bloc/blocs/deep_link_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/pages/main_screen_pages/my_home_page.dart';

class DeepLinkWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        MyHomePage homePage =  MyHomePage();
        if (snapshot.hasData) {
          DEEP_LINK = snapshot.data.toString();
          GeneralNotifier().publishChange(GeneralNotifier.DEEP_LINK_RECEIVED);
        }
        return homePage;
      },
    );

  }
}
