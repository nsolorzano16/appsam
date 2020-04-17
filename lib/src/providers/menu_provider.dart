import 'package:flutter/services.dart' show rootBundle;
import 'package:appsam/src/models/menu_model.dart';

class _MenuProvider {
  var opciones = new List<Ruta>();

  _MenuProvider();

  Future<List<Ruta>> cargarData() async {
    final resp = await rootBundle.loadString('data/menu_opts.json');
    var dataMap = menuModelFromJson(resp);
    opciones = dataMap.rutas;
    return opciones;
  }
}

final menuProvider = new _MenuProvider();
