import 'dart:convert';

CheckModel checkModelFromJson(String str) =>
    CheckModel.fromJson(json.decode(str));

String checkModelToJson(CheckModel data) => json.encode(data.toJson());

class CheckModel {
  CheckModel({
    this.client,
    this.user,
    this.coordinates,
  });

  String client;
  String user;
  String coordinates;

  factory CheckModel.fromJson(Map<String, dynamic> json) => CheckModel(
        client: json["client"],
        user: json["user"],
        coordinates: json["coordinates"],
      );

  Map<String, dynamic> toJson() => {
        "client": client,
        "user": user,
        "coordinates": coordinates,
      };
}
