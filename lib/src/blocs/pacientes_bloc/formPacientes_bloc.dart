import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:appsam/src/blocs/validators.dart';

class FormPacientesBloc with Validators {
  //******controles del formulario crear paciente */

  final _paisIdController = BehaviorSubject<int>();
  final _profesionIdController = BehaviorSubject<int>();
  final _escolaridadIdController = BehaviorSubject<int>();
  final _religionIdController = BehaviorSubject<int>();
  final _grupoSanguineoIdController = BehaviorSubject<int>();
  final _grupoEtnicoIdController = BehaviorSubject<int>();
  final _depatamentoIdController = BehaviorSubject<int>();
  final _municipioIdController = BehaviorSubject<int>();
  final _departamentoResidenciaIdController = BehaviorSubject<int>();
  final _municipioResidenciaIdController = BehaviorSubject<int>();
  final _nombresController = BehaviorSubject<String>();
  final _primerApellidoController = BehaviorSubject<String>();
  final _segundoApellidoController = BehaviorSubject<String>();
  final _identificacionController = BehaviorSubject<String>();
  final _sexoController = BehaviorSubject<String>();
  final _fechaNacimientoController = BehaviorSubject<DateTime>();
  final _estadoCivilController = BehaviorSubject<String>();
  final _direccionController = BehaviorSubject<String>();
  final _telefono1Controller = BehaviorSubject<String>();
  final _telefono2Controller = BehaviorSubject<String>();
  final _nombreEmergenciaController = BehaviorSubject<String>();
  final _telefonoEmergenciaController = BehaviorSubject<String>();
  final _parentescoController = BehaviorSubject<String>();
  final _menorDeEdadController = BehaviorSubject<bool>();
  final _nombreMadreController = BehaviorSubject<String>();
  final _identificacionMadreController = BehaviorSubject<String>();
  final _nombrePadreController = BehaviorSubject<String>();
  final _identificacionPadreController = BehaviorSubject<String>();
  final _carneVacunaController = BehaviorSubject<String>();
  final _notasController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();

  final _formController = BehaviorSubject<FormState>();

  // ********contrless del formulario

  // *****STREAMS DEL FORM *********

  Stream<int> get paisIdStream => _paisIdController.stream;
  Stream<int> get profesionIdStream => _profesionIdController.stream;
  Stream<int> get escolaridadIdStream => _escolaridadIdController.stream;
  Stream<int> get religionIdStream => _religionIdController.stream;
  Stream<int> get grupoSanguineoIdStream => _grupoSanguineoIdController.stream;
  Stream<int> get grupoEtnicoIdStream => _grupoEtnicoIdController.stream;
  Stream<int> get departamentoIdStream => _depatamentoIdController.stream;
  Stream<int> get municipioIdStream => _municipioIdController.stream;
  Stream<int> get departamendoResidenciaIdStream =>
      _departamentoResidenciaIdController.stream;
  Stream<int> get municipioResidenciaIdStream =>
      _municipioResidenciaIdController.stream;
  Stream<String> get nombresStream => _nombresController.stream;
  Stream<String> get primerApellidoStream => _primerApellidoController.stream;
  Stream<String> get segundoApellidoStream => _segundoApellidoController.stream;
  Stream<String> get identificacionStream => _identificacionController.stream;
  Stream<String> get sexoStream => _sexoController.stream;
  Stream<DateTime> get fechaNacimientoStream =>
      _fechaNacimientoController.stream;
  Stream<String> get estadoCivilStream => _estadoCivilController.stream;
  Stream<String> get direccionStream => _direccionController.stream;
  Stream<String> get telefono1Stream => _telefono1Controller.stream;
  Stream<String> get telefono2Stream => _telefono2Controller.stream;
  Stream<String> get nombreEmergenciaStream =>
      _nombreEmergenciaController.stream;
  Stream<String> get telefonoEmergenciaStream =>
      _telefonoEmergenciaController.stream;
  Stream<String> get parentescoStream => _parentescoController.stream;
  Stream<bool> get menorDeEdadStream => _menorDeEdadController.stream;
  Stream<String> get nombreMadreStream => _nombreMadreController.stream;
  Stream<String> get identificacionMadreStream =>
      _identificacionMadreController.stream;
  Stream<String> get nombrePadreStream => _nombrePadreController.stream;
  Stream<String> get identificacionPadreStream =>
      _identificacionPadreController.stream;
  Stream<String> get carneVacunaStream => _carneVacunaController.stream;
  Stream<String> get notasStream => _notasController.stream;
  Stream<String> get emailStream => _emailController.stream;

  Stream<FormState> get formStream => _formController.stream;

  //+*++++***+**+++++++

  // *******ON CHANGES *****

  Function(int) get onChangePaisId => _paisIdController.sink.add;
  Function(int) get onChangeProfesionId => _profesionIdController.sink.add;
  Function(int) get onChangeEscolaridadId => _escolaridadIdController.sink.add;
  Function(int) get onChangeReligionId => _religionIdController.sink.add;
  Function(int) get onChangeGrupoSanguineoId =>
      _grupoSanguineoIdController.sink.add;
  Function(int) get onChangeGrupoEtnicoId => _grupoEtnicoIdController.sink.add;
  Function(int) get onChangeDepartamentoId => _depatamentoIdController.sink.add;
  Function(int) get onChangeMunicipioId => _municipioIdController.sink.add;
  Function(int) get onChangeDepartamentoResidenciaId =>
      _departamentoResidenciaIdController.sink.add;
  Function(int) get onChangeMunicipioResidenciaId =>
      _municipioResidenciaIdController.sink.add;
  Function(String) get onChangeNombres => _nombresController.sink.add;
  Function(String) get onChangePrimerApellido =>
      _primerApellidoController.sink.add;
  Function(String) get onChangeSegundoApellido =>
      _segundoApellidoController.sink.add;
  Function(String) get onChangeIdentificacion =>
      _identificacionController.sink.add;
  Function(String) get onChangeSexo => _sexoController.sink.add;
  Function(DateTime) get onChangeFechaNacimiento =>
      _fechaNacimientoController.sink.add;
  Function(String) get onChangeEstadoCivil => _estadoCivilController.sink.add;
  Function(String) get onChangeDireccion => _direccionController.sink.add;
  Function(String) get onChangeTelefono1 => _telefono1Controller.sink.add;
  Function(String) get onChangeTelefono2 => _telefono2Controller.sink.add;
  Function(String) get onChangeNombreEmergencia =>
      _nombreEmergenciaController.sink.add;
  Function(String) get onChangeTelefonoEmergencia =>
      _telefonoEmergenciaController.sink.add;
  Function(String) get onChangeParentesco => _parentescoController.sink.add;
  Function(bool) get onChangeMenorDeEdad => _menorDeEdadController.sink.add;
  Function(String) get onChangeNombreMadre => _nombreMadreController.sink.add;
  Function(String) get onChangeIdentificacionMadre =>
      _identificacionMadreController.sink.add;
  Function(String) get onChangeNombrePadre => _nombrePadreController.sink.add;
  Function(String) get onChangeIdentificacionPadre =>
      _identificacionPadreController.sink.add;
  Function(String) get onChangeCarneVacuna => _carneVacunaController.sink.add;
  Function(String) get onChangeNotas => _notasController.sink.add;
  Function(String) get onChangeEmail => _emailController.sink.add;

  Function(FormState) get onChangeForm => _formController.sink.add;

  // *****************+

  dispose() {
    _paisIdController.close();
    _profesionIdController.close();
    _escolaridadIdController.close();
    _religionIdController.close();
    _grupoSanguineoIdController.close();
    _grupoEtnicoIdController.close();
    _depatamentoIdController.close();
    _municipioIdController.close();
    _departamentoResidenciaIdController.close();
    _municipioResidenciaIdController.close();
    _nombresController.close();
    _primerApellidoController.close();
    _segundoApellidoController.close();
    _identificacionController.close();
    _sexoController.close();
    _fechaNacimientoController.close();
    _estadoCivilController.close();
    _direccionController.close();
    _telefono1Controller.close();
    _telefono2Controller.close();
    _nombreEmergenciaController.close();
    _telefonoEmergenciaController.close();
    _parentescoController.close();
    _menorDeEdadController.close();
    _nombreMadreController.close();
    _identificacionMadreController.close();
    _nombrePadreController.close();
    _identificacionPadreController.close();
    _carneVacunaController.close();
    _notasController.close();
    _formController.close();
    _emailController.close();
    print('Cerrando');
  }

  int get paisId => _paisIdController.value;
  int get profesionId => _profesionIdController.value;
  int get escolaridadId => _escolaridadIdController.value;
  int get religionId => _religionIdController.value;
  int get grupoSanguineoId => _grupoSanguineoIdController.value;
  int get grupoEtnicoId => _grupoEtnicoIdController.value;
  int get departamentoId => _depatamentoIdController.value;
  int get municipioId => _municipioIdController.value;
  int get departamentoResidenciaId => _departamentoResidenciaIdController.value;
  int get municipioResidenciaId => _municipioResidenciaIdController.value;
  String get nombres => _nombresController.value;
  String get primerApellido => _primerApellidoController.value;
  String get segundoApellido => _segundoApellidoController.value;
  String get identificacion => _identificacionController.value;
  String get sexo => _sexoController.value;
  DateTime get fechaNacimiento => _fechaNacimientoController.value;
  String get estadoCivil => _estadoCivilController.value;
  String get direccion => _direccionController.value;
  String get telefono1 => _telefono1Controller.value;
  String get telefono2 => _telefono2Controller.value;
  String get nombreEmergencia => _nombreEmergenciaController.value;
  String get telefonoEmergencia => _telefonoEmergenciaController.value;
  String get parentesco => _parentescoController.value;
  bool get menorDeEdad => _menorDeEdadController.value;
  String get nombreMadre => _nombreMadreController.value;
  String get identificacionMadre => _identificacionMadreController.value;
  String get nombrePadre => _nombrePadreController.value;
  String get identificacionPadre => _identificacionPadreController.value;
  String get carneVacuna => _carneVacunaController.value;
  String get notas => _notasController.value;
  String get email => _emailController.value;
}
