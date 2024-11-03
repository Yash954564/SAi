import 'package:houzi_package/files/hive_storage_files/hive_storage_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserLoggedProvider extends ChangeNotifier {

  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  static UserLoggedProvider? userLoggedProvider;

  factory UserLoggedProvider() {
    userLoggedProvider ??= UserLoggedProvider._internal();
    return userLoggedProvider!;
  }

  UserLoggedProvider._internal(){
    _isLoggedIn = HiveStorageManager.isUserLoggedIn();
    notifyListeners();
  }

  loggedIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  loggedOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}