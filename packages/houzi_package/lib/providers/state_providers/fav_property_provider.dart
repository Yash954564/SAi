import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FavPropertyProvider extends ChangeNotifier {

  bool? _newFavoriteAdded;
  bool? get newFavoriteAdded => _newFavoriteAdded;

  static FavPropertyProvider? favPropertyProvider;

  factory FavPropertyProvider() {
    favPropertyProvider ??= FavPropertyProvider._internal();
    return favPropertyProvider!;
  }

  FavPropertyProvider._internal(){
    _newFavoriteAdded =  false;
    notifyListeners();
  }

  favoriteAdded(){
    _newFavoriteAdded = true;
    notifyListeners();
    _newFavoriteAdded = false;
  }

}