import 'dart:convert';

import 'package:appsam/src/models/departamento_model.dart';
import 'package:appsam/src/models/escolaridad_model.dart';
import 'package:appsam/src/models/grupoEtnico_model.dart';
import 'package:appsam/src/models/grupoSanguineo_model.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/pais_model.dart';
import 'package:appsam/src/models/profesion_model.dart';
import 'package:appsam/src/models/religion_model.dart';

import 'package:http/http.dart' as http;

import 'package:appsam/src/utils/utils.dart';

class CombosService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<DepartamentoModel>> getDepartamentos() async {
    final url = '$_apiURL/api/Departamentos';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<DepartamentoModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((depto) {
      final deptoTemp = DepartamentoModel.fromJson(depto);
      lista.add(deptoTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<EscolaridadModel>> getEscolaridades() async {
    final url = '$_apiURL/api/Escolaridad';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<EscolaridadModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((escolaridad) {
      final escolaridadTemp = EscolaridadModel.fromJson(escolaridad);
      lista.add(escolaridadTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<GrupoEtnicoModel>> getGruposEtnicos() async {
    final url = '$_apiURL/api/GrupoEtnico';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<GrupoEtnicoModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((grupo) {
      final grupoTemp = GrupoEtnicoModel.fromJson(grupo);
      lista.add(grupoTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<GrupoSanguineoModel>> getGrupoSanguineos() async {
    final url = '$_apiURL/api/GrupoSanguineo';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<GrupoSanguineoModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((grupo) {
      final grupoTemp = GrupoSanguineoModel.fromJson(grupo);
      lista.add(grupoTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<MunicipioModel>> getMunicipiosXDepartamento(
      int departamentoId) async {
    final url = '$_apiURL/api/Municipios/$departamentoId';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<MunicipioModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((municipio) {
      final municipioTemp = MunicipioModel.fromJson(municipio);
      lista.add(municipioTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<ProfesionModel>> getProfesiones() async {
    final url = '$_apiURL/api/Profesion';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<ProfesionModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((profesion) {
      final profesionTemp = ProfesionModel.fromJson(profesion);
      lista.add(profesionTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<ReligionModel>> getReligiones() async {
    final url = '$_apiURL/api/Religion';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<ReligionModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((religion) {
      final religionTemp = ReligionModel.fromJson(religion);
      lista.add(religionTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }

  Future<List<PaisModel>> getPaises() async {
    final url = '$_apiURL/api/Pais';
    final resp = await http.get(url);
    final decodeResp = json.decode(resp.body);

    if (decodeResp == null) return [];

    final List<PaisModel> lista = new List();

    if (decodeResp == null) return [];

    decodeResp.forEach((pais) {
      final paisTemp = PaisModel.fromJson(pais);
      lista.add(paisTemp);
    });

    if (resp.statusCode == 200 && lista != null) {
      return lista;
    }
    return [];
  }
}
