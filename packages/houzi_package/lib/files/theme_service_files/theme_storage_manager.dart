import 'package:houzi_package/common/constants.dart';
import 'package:hive/hive.dart';

class ThemeStorageManager {
  static Box hiveBox = Hive.box(HIVE_BOX);

  static saveData(String key, dynamic data){
    hiveBox.put(key, data);
  }

  static readData(String key) {
    var value = hiveBox.get(key);
    return value;
  }

  static deleteData(String key) {
    hiveBox.delete(key);
  }
}