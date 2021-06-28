import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class User {
  List<UserModel> detailUser = [];

  User.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    jsonList.forEach((item) {
      final user = UserModel.fromJson(item);
      detailUser.add(user);
    });
  }
}

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.tipoUsuario,
  });

  String id;
  String username;
  String email;
  String phone;
  String tipoUsuario;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        phone: json["phone"],
        tipoUsuario: json["tipo_usuario"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone": phone,
        "tipo_usuario": tipoUsuario,
      };
}
