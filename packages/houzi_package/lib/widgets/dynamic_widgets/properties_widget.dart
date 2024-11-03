import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houzi_package/bloc/blocs/property_bloc.dart';


import 'package:houzi_package/common/constants.dart';

class PropertiesWidget extends StatefulWidget{
  final String propertyTag;

  const PropertiesWidget({Key? key, required this.propertyTag}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PropertiesWidgetState();

}

class PropertiesWidgetState extends State<PropertiesWidget> {
  int _page = 1;
  int _perPage = 16;
  String _propertyTag = "";
  bool _hasNoData = true;
  List<dynamic> _propertiesArticlesList = [];
  PropertyBloc _propertyBloc = PropertyBloc();

  @override
  Widget build(BuildContext context) {
    return _propertyTag == null || _propertyTag.isEmpty ? Container() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _propertyTag = widget.propertyTag;
    if(_propertyTag == LATEST_PROPERTIES_TAG){
      loadLatestPropertiesData();
    }else if(_propertyTag == FEATURED_PROPERTIES_TAG){
      loadFeaturedPropertiesData();
    }
  }

  loadLatestPropertiesData(){
    fetchLatestArticles(_page).then((articleData) {
      checkForData(articleData);
      return null;
    });
  }

  loadFeaturedPropertiesData(){
    fetchFeaturedArticles(_page).then((articleData) {
      checkForData(articleData);
      return null;
    });
  }

  checkForData(List<dynamic> dataList){
    if(dataList != null && dataList.isNotEmpty){
      setState(() {
        _hasNoData = false;
        _propertiesArticlesList = dataList;
      });
    }
  }


  Future<List<dynamic>> fetchLatestArticles(int page) async {
    List<dynamic> _latestArticlesList = await _propertyBloc.fetchLatestArticles(page);
    return _latestArticlesList;
  }

  Future<List<dynamic>> fetchFeaturedArticles(int page) async {
    List<dynamic> _featuredArticlesList = await _propertyBloc.fetchFeaturedArticles(page);
    return _featuredArticlesList;
  }

  Future<List<dynamic>> fetchArticlesInCity(int cityId, int page, int perPage) async {
    List<dynamic> _latestArticlesInCity = await _propertyBloc.fetchPropertiesInCityList(cityId, page, perPage);
    return _latestArticlesInCity;
  }

  Future<List<dynamic>> fetchPropertiesInCityByType(int propertyId, int typeId, int page, int perPage) async {
    List<dynamic> _propertiesInCityByType = await _propertyBloc.fetchPropertiesInCityByTypeList(propertyId, typeId, page, perPage);
    return _propertiesInCityByType;
  }
}

