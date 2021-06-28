import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del login
  get login {
    return _prefs.getBool('login') ?? false;
  }

  set login(bool value) {
    _prefs.setBool('login', value);
  }

  // GET y SET del Nombre
  get displayName {
    return _prefs.getString('displayName') ?? '';
  }

  set displayName(String value) {
    _prefs.setString('displayName', value);
  }

  // GET y SET del Email
  get userEmail {
    return _prefs.getString('userEmail') ?? '';
  }

  set userEmail(String value) {
    _prefs.setString('userEmail', value);
  }

  // GET y SET del Foto
  get photoUrl {
    return _prefs.getString('photoUrl') ?? '';
  }

  set photoUrl(String value) {
    _prefs.setString('photoUrl', value);
  }

  // GET y SET de la ultima pagina
  get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  // GET y SET de ID nube
  get idUser {
    return _prefs.getString('idUser') ?? '0';
  }

  set idUser(String value) {
    _prefs.setString('idUser', value);
  }
}
