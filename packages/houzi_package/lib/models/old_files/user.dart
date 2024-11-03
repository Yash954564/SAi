class UserModel{
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? password;

  UserModel({
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password
  });

  Map<String?, dynamic> toJson(){
    Map<String?, dynamic> map = {};
    map.addAll({
      'email' : email,
      'first_name' : firstName,
      'last_name' : lastName,
      'username': userName,
      'password' : password,
    });

    return map;
  }
}