import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:geo/src/models/user_model.dart';
import 'package:geo/src/models/location_model.dart';
import 'package:geo/src/models/check_model.dart';

class ActionProvider {
  final String _url = 'https://api.nubeadm.com/panel/v1';
  final String _apikey = '08d350f56491ede7df19cfba48f57e12';

  Future<List<UserModel>> validarUsuario(String email) async {
    //print(email);

    if (email == '') return [];

    final url = Uri.parse('$_url/users/$email');
    final resp = await http.get(url, headers: {'Authorization': _apikey});
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    //print(decodedData);
    final List<UserModel> usuario = [];

    if (decodedData['total'] == 0) return [];
    //final user = new User.fromJsonList(decodedData['data']);

    decodedData['data'].forEach((details) {
      final userTemp = UserModel.fromJson(details);
      //prodTemp.id = id;

      usuario.add(userTemp);
    });

    //print(usuario[0].id);
    return usuario;
  }

  Future<List<LocationModel>> listaUbicaciones() async {
    final url = Uri.parse('$_url/locations');
    final resp = await http.get(url, headers: {'Authorization': _apikey});
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    //print(decodedData);
    final List<LocationModel> ubicaciones = [];

    if (decodedData['total'] == 0) return [];

    decodedData['data'].forEach((details) {
      final locationTemp = LocationModel.fromJson(details);

      ubicaciones.add(locationTemp);
    });

    return ubicaciones;
  }

  Future<bool> sendCheckin(CheckModel checkin) async {
    final url = Uri.parse('$_url/checkin');
    final resp = await http.post(url,
        headers: {'Authorization': _apikey}, body: checkModelToJson(checkin));
    final decodedData = json.decode(resp.body);
    //print(decodedData);

    if (decodedData['message'] == 'success') {
      return true;
    } else {
      return false;
    }
  }

  Future<List<LocationModel>> listaCheckin(String idUser) async {
    final url = Uri.parse('$_url/checkin/$idUser');
    final resp = await http.get(url, headers: {'Authorization': _apikey});
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    //print(decodedData);
    final List<LocationModel> ubicaciones = [];

    if (decodedData['total'] == 0) return [];

    decodedData['data'].forEach((details) {
      final locationTemp = LocationModel.fromJson(details);

      ubicaciones.add(locationTemp);
    });

    return ubicaciones;
  }

  Future<bool> sendCheckout(CheckModel checkout) async {
    final url = Uri.parse('$_url/checkout');
    final resp = await http.post(url,
        headers: {'Authorization': _apikey}, body: checkModelToJson(checkout));
    final decodedData = json.decode(resp.body);
    //print(decodedData);

    if (decodedData['message'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}
