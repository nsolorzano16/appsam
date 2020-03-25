import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/pacientes_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/providers/pacientes_service.dart';
import 'package:rxdart/rxdart.dart';

class PacientesBloc with Validators {
  final _pacienteService = new PacientesService();
  final _comboService = new CombosService();
  final _pacientesController = BehaviorSubject<List<PacienteModel>>();
  final _pacientesBusquedaController = BehaviorSubject<List<PacienteModel>>();
  final _municipiosController = BehaviorSubject<List<MunicipioModel>>();
  final _ultimaPaginaController = BehaviorSubject<int>();
  final listPacientes = new List<PacienteModel>();

  final _cargandoMunicipiosController = BehaviorSubject<bool>();
  Stream<List<PacienteModel>> get pacientesListStream =>
      _pacientesController.stream;
  Stream<List<PacienteModel>> get pacientesBusquedaStream =>
      _pacientesBusquedaController.stream;

  Stream<List<MunicipioModel>> get municipiosListStream =>
      _municipiosController.stream;

  Function(List<PacienteModel>) get onChangePacientesLista =>
      _pacientesController.add;
  Function(List<PacienteModel>) get onChangePacientesBusqueda =>
      _pacientesBusquedaController.add;

  Function(List<MunicipioModel>) get onChangeListMunicipios =>
      _municipiosController.add;

  cargarMunicipios(int deptoId) async {
    _cargandoMunicipiosController.sink.add(true);
    final municipios = await _comboService.getMunicipiosXDepartamento(deptoId);
    onChangeListMunicipios(municipios);
    _cargandoMunicipiosController.sink.add(false);
  }

  cargarPacientesPaginado(int page, String filter) async {
    // final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
    // _ultimaPaginaController.add(pacientes.totalPages);
    // // listPacientes.addAll(pacientes.items);
    // onChangePacientesLista(listPacientes);
  }

  cargarPacientesPaginadoBusqueda(int page, String filter) async {
    // final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
    // onChangePacientesBusqueda(pacientes.items);
  }

  Future<bool> addPaciente(PacienteModel paciente) async {
    return await _pacienteService.addPaciente(paciente);
  }

  // void updatePaciente(PacienteModel paciente) async {
  //   await _pacienteService.updatePaciente(paciente);
  // }

  dispose() {
    _pacientesController?.close();
    _ultimaPaginaController?.close();
    _pacientesController?.close();
    _pacientesBusquedaController?.close();
    _municipiosController?.close();
    _cargandoMunicipiosController?.close();
  }

  int get ultimaPagina => _ultimaPaginaController.value;
  bool get cargando => _cargandoMunicipiosController.value;
}
