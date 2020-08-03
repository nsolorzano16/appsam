import 'package:appsam/src/common/debouncer.dart';
import 'package:appsam/src/models/cie_model.dart';
import 'package:appsam/src/providers/cie_service.dart';
import 'package:flutter/material.dart';

class CieBlocNoti extends ChangeNotifier {
  final debouncer = Debouncer();
  final _cieService = CieService();
  List<CieModel> enfermedades = List();
  bool loading = false;

  String errormessage;

  void onChangedText(String text) {
    debouncer.run(
      () {
        if (text.isNotEmpty) requestSearch(text);
      },
    );
  }

  void requestSearch(String text) async {
    loading = true;
    notifyListeners();
    final enfermedadesPaginado =
        await _cieService.getEnfermedadesPaginado(1, text);
    enfermedades = enfermedadesPaginado.items;

    loading = false;
    notifyListeners();
  }
}
