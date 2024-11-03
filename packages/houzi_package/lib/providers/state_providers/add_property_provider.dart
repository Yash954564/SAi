import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddPropertyProvider extends ChangeNotifier {

  bool? _newPropertyAdded;
  bool? get newPropertyAdded => _newPropertyAdded;

  static AddPropertyProvider? addPropertyProvider;

  factory AddPropertyProvider() {
    addPropertyProvider ??= AddPropertyProvider._internal();
    return addPropertyProvider!;
  }

  AddPropertyProvider._internal(){
    _newPropertyAdded = false;
    notifyListeners();
  }

  propertyAdded(){
    _newPropertyAdded = true;
    notifyListeners();
    _newPropertyAdded = false;
  }

}