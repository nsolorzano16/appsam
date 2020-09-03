import 'package:appsam/src/models/fotosPaciente_model.dart';
import 'package:appsam/src/models/myinfo_viewmodel.dart';
import 'package:appsam/src/providers/fotosPacienteService.dart';
import 'package:appsam/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class FotosPacienteBloc extends ChangeNotifier {
  bool loading;
  List<FotosPacienteModel> listPhotos = List();
  final _fotosService = FotosPacienteService();
  final _userService = UsuarioProvider();
  int totalPages;
  int imagenesConsumidas;

  void loadData(int page, String filter, int pacienteId, String userId) async {
    loading = true;
    notifyListeners();
    final _resp =
        await _fotosService.getFotosPacientePaginado(page, filter, pacienteId);
    totalPages = _resp.totalPages;
    final MyInfoViewModel myinfo = await _userService.getMyInfo(userId);
    imagenesConsumidas = myinfo.imagenesConsumidas;

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
