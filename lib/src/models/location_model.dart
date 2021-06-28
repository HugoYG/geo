import 'dart:convert';

LocationModel locationModelFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.id,
    this.ubicacion,
    this.rfc,
    this.direccion,
    this.coordenadas,
    this.estatus,
    this.contacto,
    this.telefono,
    this.correo,
  });

  String id;
  String ubicacion;
  String rfc;
  String direccion;
  String coordenadas;
  String estatus;
  String contacto;
  String telefono;
  String correo;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        ubicacion: json["ubicacion"],
        rfc: json["rfc"],
        direccion: json["direccion"],
        coordenadas: json["coordenadas"],
        estatus: json["estatus"],
        contacto: json["contacto"],
        telefono: json["telefono"],
        correo: json["correo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ubicacion": ubicacion,
        "rfc": rfc,
        "direccion": direccion,
        "coordenadas": coordenadas,
        "estatus": estatus,
        "contacto": contacto,
        "telefono": telefono,
        "correo": correo,
      };
}
