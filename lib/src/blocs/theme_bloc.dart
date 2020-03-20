import 'dart:async';

import 'package:rxdart/rxdart.dart';

class ThemeBloc {
  final _themeStreamController = BehaviorSubject<bool>();

  // recupera datps
  Stream<bool> get darkThemeIsEnabled => _themeStreamController.stream;

  // agregar valores
  Function(bool) get changeTheTheme => _themeStreamController.sink.add;

  // ultimo valor ingresado
  bool get valorTema => _themeStreamController.value;

  dispose() {
    _themeStreamController?.close();
  }
}
