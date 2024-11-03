import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditPropertyProvider extends ChangeNotifier {

  static EditPropertyProvider? editPropertyProvider;

  factory EditPropertyProvider() {
    editPropertyProvider ??= EditPropertyProvider._internal();
    return editPropertyProvider!;
  }

  EditPropertyProvider._internal(){
    notifyListeners();
  }

}