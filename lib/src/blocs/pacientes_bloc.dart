import 'package:appsam/src/blocs/validators.dart';
import 'package:appsam/src/models/paciente_model.dart';
import 'package:appsam/src/providers/pacientes_service.dart';
import 'package:rxdart/rxdart.dart';

class PacientesBloc with Validators {
  final _pacienteService = new PacientesService();
  final _pacientesController = BehaviorSubject<List<Paciente>>();
  final _pacientesBusquedaController = BehaviorSubject<List<Paciente>>();
  final _ultimaPaginaController = BehaviorSubject<int>();
  final listPacientes = new List<Paciente>();

  Stream<List<Paciente>> get pacientesListStream => _pacientesController.stream;
  Stream<List<Paciente>> get pacientesBusquedaStream =>
      _pacientesBusquedaController.stream;

  // validar form

  Function(List<Paciente>) get onChangePacientesLista =>
      _pacientesController.add;
  Function(List<Paciente>) get onChangePacientesBusqueda =>
      _pacientesBusquedaController.add;

  cargarPacientesPaginado(int page, String filter) async {
    final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
    _ultimaPaginaController.add(pacientes.totalPages);
    listPacientes.addAll(pacientes.items);
    onChangePacientesLista(listPacientes);
  }

  cargarPacientesPaginadoBusqueda(int page, String filter) async {
    final pacientes = await _pacienteService.getPacientesPaginado(page, filter);
    onChangePacientesBusqueda(pacientes.items);
  }

  Future<bool> addPaciente(Paciente paciente) async {
    return await _pacienteService.addPaciente(paciente);
  }

  void updatePaciente(Paciente paciente) async {
    await _pacienteService.updatePaciente(paciente);
  }

  dispose() {
    _pacientesController?.close();
    _ultimaPaginaController?.close();
    _pacientesController?.close();
    _pacientesBusquedaController?.close();
  }

  int get ultimaPagina => _ultimaPaginaController.value;
}
