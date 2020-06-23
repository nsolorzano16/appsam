import 'package:rxdart/rxdart.dart';
import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/pacientes_model.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/providers/pacientes_service.dart';

class PacientesBloc with Validators {
  final _pacienteService = new PacientesService();
  final _comboService = new CombosService();

  final _pacientesBusquedaController =
      BehaviorSubject<List<PacientesViewModel>>();

  final _municipiosController = BehaviorSubject<List<MunicipioModel>>();
  final _municipiosResidenciaController =
      BehaviorSubject<List<MunicipioModel>>();

  final _ultimaPaginaController = BehaviorSubject<int>();
  final listPacientes = new List<PacientesViewModel>();

  final _cargandoMunicipiosController = BehaviorSubject<bool>();
  final _cargandoMunicipiosResiController = BehaviorSubject<bool>();

  Stream<List<MunicipioModel>> get municipiosListStream =>
      _municipiosController.stream;

  Stream<List<MunicipioModel>> get municipiosResiListStream =>
      _municipiosResidenciaController.stream;

  Stream<List<PacientesViewModel>> get pacientesBusquedaStream =>
      _pacientesBusquedaController.stream;

  Stream<bool> get cargandoMunicipiosStream =>
      _cargandoMunicipiosController.stream;

  Stream<bool> get cargandoMunicipiosResiStream =>
      _cargandoMunicipiosResiController.stream;

  //********FUNCTIONS */

  Function(List<PacientesViewModel>) get onChangePacientesBusqueda =>
      _pacientesBusquedaController.sink.add;

  Function(List<MunicipioModel>) get onChangeListMunicipios =>
      _municipiosController.sink.add;

  Function(List<MunicipioModel>) get onChangeListMunicipiosResi =>
      _municipiosResidenciaController.sink.add;

  Function(bool) get onChangeCargandoMunicipios =>
      _cargandoMunicipiosResiController.sink.add;

  Function(bool) get onChangeCargandoMunicipiosResi =>
      _cargandoMunicipiosResiController.sink.add;

// ************* METODOS *********************

  cargarMunicipios(int deptoId) async {
    _cargandoMunicipiosController.sink.add(true);
    final municipios = await _comboService.getMunicipiosXDepartamento(deptoId);
    _municipiosController.sink.add(municipios);
    _cargandoMunicipiosController.sink.add(false);
  }

  cargarMunicipiosResi(int deptoId) async {
    _cargandoMunicipiosResiController.sink.add(true);
    final municipios = await _comboService.getMunicipiosXDepartamento(deptoId);
    _municipiosResidenciaController.sink.add(municipios);

    _cargandoMunicipiosResiController.sink.add(false);
  }

  // cargarPacientesPaginado(int page, String filter) async {
  //   final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
  //   _ultimaPaginaController.add(pacientes.totalPages);
  //   listPacientes.addAll(pacientes.items);

  //   onChangePacientesLista(listPacientes);
  // }

  // cargarPacientesPaginadoRefresh(int page, String filter) async {
  //   final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
  //   _ultimaPaginaController.add(pacientes.totalPages);
  //   listPacientes.clear();
  //   listPacientes.addAll(pacientes.items);
  //   onChangePacientesLista(listPacientes);
  // }

  cargarPacientesPaginadoBusqueda(int page, String filter) async {
    final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
    onChangePacientesBusqueda(pacientes.items);
  }

  Future<bool> addPaciente(PacienteModel paciente) async {
    return await _pacienteService.addPaciente(paciente);
  }

  Future<PacientesViewModel> updatePaciente(PacientesViewModel paciente) async {
    return await _pacienteService.updatePaciente(paciente);
  }

  dispose() {
    _ultimaPaginaController?.close();
    _pacientesBusquedaController?.close();
    _municipiosController?.close();
    _cargandoMunicipiosController?.close();
    _municipiosResidenciaController?.close();
    _cargandoMunicipiosResiController?.close();
  }

  int get ultimaPagina => _ultimaPaginaController.value;
  bool get cargando => _cargandoMunicipiosController.value;
  bool get cargandoMunicipiosResi => _cargandoMunicipiosResiController.value;
}
