import 'package:appsam/src/blocs/asistentes_bloc/create_edit_asistentes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;
  final bloc = new CrearEditarAsistentesBloc();

  void cerrarStreams() {
    bloc.dispose();
  }

  static Future getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }

  static get ultimaPagina {
    return _preferences.getString('ultimaPagina') ?? 'login';
  }

  // put string
  static Future putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  // get int
  static int getInt(String key, {int defValue = 0}) {
    if (_preferences == null) return defValue;
    return _preferences.getInt(key) ?? defValue;
  }

  // put int
  static Future putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences.setInt(key, value);
  }

  // get bool
  static bool getBool(String key, {bool defValue = false}) {
    if (_preferences == null) return defValue;
    return _preferences.getBool(key) ?? defValue;
  }

  // put bool
  static Future putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }

  static void removeAll() {
    _preferences.remove('token');
    _preferences.remove('usuarioId');
    _preferences.remove('rolId');
    _preferences.remove('userName');
    _preferences.remove('email');
    _preferences.remove('nombres');
    _preferences.remove('primerApellido');
    _preferences.remove('segundoApellido');
    _preferences.remove('fotoUrl');
    //_preferences.remove('temaDark');
  }

  static void removeUsuario() {
    _preferences.remove('usuarioGlobal');
  }
}
