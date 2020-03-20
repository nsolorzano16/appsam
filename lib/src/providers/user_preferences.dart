import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...

*/

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

  // GET y SET del nombre
  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  void removeToken() {
    _prefs.remove('token');
  }

  // get y set usuario id

  get usuarioId {
    return _prefs.getInt('usuarioId') ?? 0;
  }

  set usuarioId(int value) {
    _prefs.setInt('usuarioId', value);
  }

  // user name
  get userName {
    return _prefs.getString('userName') ?? '';
  }

  set userName(String value) {
    _prefs.setString('userName', value);
  }

  // nombres
  get nombres {
    return _prefs.getString('nombres') ?? '';
  }

  set nombres(String value) {
    _prefs.setString('nombres', value);
  }

  // apellido

  get primerApellido {
    return _prefs.getString('primerApellido') ?? '';
  }

  set primerApellido(String value) {
    _prefs.setString('primerApellido', value);
  }

  // apellido

  get segundoApellido {
    return _prefs.getString('segundoApellido') ?? '';
  }

  set segundoApellido(String value) {
    _prefs.setString('segundoApellido', value);
  }

  // email

  get email {
    return _prefs.getString('email') ?? '';
  }

  set email(String value) {
    _prefs.setString('email', value);
  }
}
