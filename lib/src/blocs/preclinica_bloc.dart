import 'package:rxdart/rxdart.dart';
import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/preclinica_model.dart';
import 'package:appsam/src/providers/preclinica_service.dart';

class PreclinicaBloc with Validators {
  final _preclinicaService = new PreclinicaService();
  final _preclinicaController = BehaviorSubject<List<PreclinicaViewModel>>();
  final _totalPagesController = BehaviorSubject<int>();
  final _currentPageController = BehaviorSubject<int>();
  final listPreclinicas = new List<PreclinicaViewModel>();

  Stream<List<PreclinicaViewModel>> get preclinicasListStream =>
      _preclinicaController.stream;

  Function(List<PreclinicaViewModel>) get preclinicasSink =>
      _preclinicaController.sink.add;

  cargarPreclinicasPaginado(int page, String doctorId, int atendida) async {
    final preclinicas = await _preclinicaService.getpreclinicasPaginado(
        page, doctorId, atendida);
    listPreclinicas.addAll(preclinicas.items);
    preclinicasSink(listPreclinicas);
    _totalPagesController.sink.add(preclinicas.totalPages);
    _currentPageController.sink.add(preclinicas.currentPage);
  }

  Future<bool> addPreclinica(Preclinica preclinica) async {
    return await _preclinicaService.addPreclinica(preclinica);
  }

  Future<PreclinicaViewModel> updatePreclinica(
      PreclinicaViewModel preclinica) async {
    return await _preclinicaService.updatePreclinica(preclinica);
  }

  dispose() {
    _preclinicaController.close();
    _totalPagesController.close();
    _currentPageController.close();
  }

  int get totalPages => _totalPagesController.value;
  int get currentPage => _currentPageController.value;
}
