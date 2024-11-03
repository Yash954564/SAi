import 'package:houzi_package/common/constants.dart';
import 'package:hive/hive.dart';

class ItemDesignStorageManager {

  static Box hiveBox = Hive.box(HIVE_BOX);

  static saveItemDesignData(String key, dynamic data){
    hiveBox.put(key, data);
  }

  static readItemDesignData(String key) {
    var value = hiveBox.get(key);
    return value;
  }

  static deleteItemDesignData(String key) {
    hiveBox.delete(key);
  }
}