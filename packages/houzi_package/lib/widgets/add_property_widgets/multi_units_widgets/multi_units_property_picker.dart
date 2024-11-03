import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';
import 'package:houzi_package/common/constants.dart';
import 'package:houzi_package/files/app_preferences/app_preferences.dart';
import 'package:houzi_package/models/article.dart';
import 'package:houzi_package/widgets/article_box_widgets/article_box_design.dart';
import 'package:houzi_package/widgets/custom_widgets/alert_dialog_widget.dart';
import 'package:houzi_package/widgets/custom_widgets/text_button_widget.dart';
import 'package:houzi_package/widgets/data_loading_widget.dart';
import 'package:houzi_package/widgets/generic_text_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:houzi_package/files/generic_methods/utility_methods.dart';

typedef PropertyPickerMultiSelectDialogWidgetListener = void Function(List<String> listOfSelectedItems);

class PropertyPickerMultiSelectDialogWidget extends StatefulWidget{

  final String title;
  final String selectedItems;
  final PropertyPickerMultiSelectDialogWidgetListener propertyPickerMultiSelectDialogWidgetListener;

  PropertyPickerMultiSelectDialogWidget({
    Key? key,
    required this.title,
    required this.selectedItems,
    required this.propertyPickerMultiSelectDialogWidgetListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertyPickerMultiSelectDialogWidgetState();

}

class PropertyPickerMultiSelectDialogWidgetState extends State<PropertyPickerMultiSelectDialogWidget> {

  int page = 1;

  List<dynamic> dataItemsList = [];
  List<String> selectedItemsList = [];

  bool isInternetConnected = true;
  bool _infinitePaginationStop = false;
  bool _showPaginationLoadingWidget = false;
  bool _showLoadingWidget = true;

  PropertyBloc _propertyBloc = PropertyBloc();

  ScrollController _scrollController = ScrollController();

  ArticleBoxDesign _articleBoxDesign = ArticleBoxDesign();

  @override
  void initState() {
    super.initState();

    fetchLatestProperties(page).then((value) {
      setState(() {
        _showLoadingWidget = false;
      });
      return null;
    });

    if(widget.selectedItems != null && widget.selectedItems.isNotEmpty){
      if(widget.selectedItems.contains(",")){
        selectedItemsList = widget.selectedItems.split(",");
      }else{
        selectedItemsList = [widget.selectedItems];
      }
    }

    _scrollController.addListener(() {
      if(_scrollController.offset != null && _scrollController.position.maxScrollExtent != null){
        if(_scrollController.offset == _scrollController.position.maxScrollExtent){
          print("You've reached at the bottom of List...............................");
        // if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
          if(_infinitePaginationStop == false){
            if(mounted) {
              setState(() {
                _showPaginationLoadingWidget = true;
                page += 1;
                fetchLatestProperties(page);
              });
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialogWidget(
      insetPadding: EdgeInsets.all(10), //20
      title: GenericTextWidget(widget.title),
      contentPadding: const EdgeInsets.only(top: 12.0),
      content: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: ListTileTheme(
              selectedColor: AppThemePreferences.appPrimaryColor.withOpacity(0.4),
              child: ListBody(
                children: dataItemsList.map((item) {
                  Article article = item;
                  var heroId = article.id.toString() + FILTERED;
                  int propId  = article.id!;
                  final checked = selectedItemsList.contains(propId.toString());

                  return ListTile(
                    selected: checked,
                    selectedColor: AppThemePreferences.appPrimaryColor.withOpacity(0.4),
                    title: Container(
                      padding: EdgeInsets.all(5),
                      decoration: new BoxDecoration(
                        color: checked ? AppThemePreferences.appPrimaryColor.withOpacity(0.4) : null,
                        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                      ),
                      height: _articleBoxDesign.getArticleBoxDesignHeight(design: DESIGN_01),
                      child: _articleBoxDesign.getArticleBoxDesign(
                        design: DESIGN_01,
                        buildContext: context,
                        heroId: heroId,
                        article: article,
                        isInMenu: false,
                        onTap: (){
                          _onItemCheckedChange(article, checked);
                        },
                      ),
                    ),
                    // onTap: () => _onItemCheckedChange(article, checked),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: paginationLoadingWidget(),
          ),
          loadingWidget(),
        ],
      ),
      actions: <Widget>[
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("cancel")),
          onPressed: ()=> Navigator.pop(context),
        ),
        TextButtonWidget(
          child: GenericTextWidget(UtilityMethods.getLocalizedString("ok")),
          onPressed: () {
            widget.propertyPickerMultiSelectDialogWidgetListener(selectedItemsList);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  void _onItemCheckedChange(dynamic item, bool checked) {
    setState(() {
      if (checked) {
        selectedItemsList.remove(item.id.toString());
      } else {
        selectedItemsList.add(item.id.toString());
      }
    });
  }

  Future<List<dynamic>> fetchLatestProperties(int page) async {
    List<dynamic> tempList = [];
    tempList = await _propertyBloc.fetchLatestArticles(page);
    if(tempList == null || (tempList.isNotEmpty && tempList[0] == null) || (tempList.isNotEmpty && tempList[0].runtimeType == Response)){
      if(mounted){
        setState(() {
          isInternetConnected = false;
          _showPaginationLoadingWidget = false;
        });
      }
      return tempList;
    }else{
      if (mounted) {
        setState(() {
          isInternetConnected = true;
          _showPaginationLoadingWidget = false;
          dataItemsList.addAll(tempList);
        });
      }

      if (dataItemsList.length % FETCH_LATEST_PROPERTIES_PER_PAGE != 0) {
        if(mounted){
          setState(() {
            _infinitePaginationStop = true;
          });
        }
      }
    }

    return tempList;
  }

  Widget paginationLoadingWidget(){
    return _showPaginationLoadingWidget ? Container(
      color: AppThemePreferences().appTheme.backgroundColor,
      padding: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: SizedBox(
        width: AppThemePreferences.paginationLoadingWidgetWidth,
        height: AppThemePreferences.paginationLoadingWidgetHeight,
        child: LoadingIndicator(
          indicatorType: Indicator.ballRotateChase,
          colors: [AppThemePreferences().appTheme.primaryColor!],
        ),
      ),
    ) : Container();
  }

  Widget loadingWidget() {
    return _showLoadingWidget ? Center(
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: 80,
          height: 20,
          child: BallBeatLoadingWidget(),
        ),
      ),
    ) : Container();
  }
}