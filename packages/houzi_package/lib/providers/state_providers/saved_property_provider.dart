import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SavedPropertyProvider extends ChangeNotifier {

  bool? _newSavedSearchAdded;
  bool? get newSavedSearchAdded => _newSavedSearchAdded;

  static SavedPropertyProvider? favPropertyProvider;

  factory SavedPropertyProvider() {
    favPropertyProvider ??= SavedPropertyProvider._internal();
    return favPropertyProvider!;
  }

  SavedPropertyProvider._internal(){
    _newSavedSearchAdded = false;
    notifyListeners();
  }

  searchAdded(){
    _newSavedSearchAdded = true;
    notifyListeners();
    _newSavedSearchAdded = false;
  }

}