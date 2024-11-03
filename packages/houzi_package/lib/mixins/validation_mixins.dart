import 'package:houzi_package/files/generic_methods/utility_methods.dart';
import 'package:houzi_package/files/hooks_files/hooks_configurations.dart';

mixin ValidationMixin {

  String? validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
    }
    return null;
  }

  String? validateEmail(String? value) {
    bool isEmailValid = false;

    if(value != null && value.isNotEmpty) {
      isEmailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(value);
    }

    if(!isEmailValid){
      return UtilityMethods.getLocalizedString("enter_valid_email");
    }

    return null;
  }

  String? validatePassword(String? value) {
    int minimumLength = HooksConfigurations.minimumPasswordLengthHook() ?? 8;
    if (value == null || value.isEmpty || value.length < minimumLength) {
      return UtilityMethods.getLocalizedString("password_length_at_least_eight",
          inputWords: [minimumLength.toString()]);
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return UtilityMethods.getLocalizedString("enter_phone");
    }else if (!regExp.hasMatch(value)) {
      return UtilityMethods.getLocalizedString("enter_valid_phone");
    }

    return null;
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return UtilityMethods.getLocalizedString("this_field_cannot_be_empty");
    } else {
      if (value.length < 2) {
        return UtilityMethods.getLocalizedString("user_name_at_least_three");
      }
      if (value.contains(' ')) {
        return UtilityMethods.getLocalizedString("remove_whitespace");
      }
    }

    return null;
  }

}
