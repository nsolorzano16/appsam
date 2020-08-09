import 'package:appsam/src/models/fotosPaciente_model.dart';
import 'package:appsam/src/providers/fotosPacienteService.dart';
import 'package:flutter/material.dart';

class FotosPacienteBloc extends ChangeNotifier {
  bool loading;
  List<FotosPacienteModel> listPhotos = List();
  final _fotosService = FotosPacienteService();
  int totalPages;

  void loadData(int page, String filter, int pacienteId) async {
    loading = true;
    notifyListeners();
    final _resp =
        await _fotosService.getFotosPacientePaginado(page, filter, pacienteId);
    totalPages = _resp.totalPages;

    if (_resp.items.length > 0) {
      listPhotos.addAll(_resp.items);
    }

    loading = false;
    notifyListeners();
  }

  Future<bool> deletePhoto(FotosPacienteModel foto) async {
    final resp = await _fotosService.updateFotosPaciente(foto);

    if (resp != null) {
      return true;
    } else {
      return false;
    }
  }
}
