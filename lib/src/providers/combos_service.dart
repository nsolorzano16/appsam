import 'dart:convert';
import 'package:appsam/src/models/anticonceptivos_model.dart';
import 'package:appsam/src/models/examenCategoria_model.dart';
import 'package:appsam/src/models/examenDetalle_model.dart';
import 'package:appsam/src/models/examenTipo_model.dart';
import 'package:appsam/src/models/viaAdministracion_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:http/http.dart' as http;

import 'package:appsam/src/models/departamento_model.dart';
import 'package:appsam/src/models/escolaridad_model.dart';
import 'package:appsam/src/models/grupoEtnico_model.dart';
import 'package:appsam/src/models/grupoSanguineo_model.dart';
import 'package:appsam/src/models/municipio_model.dart';
import 'package:appsam/src/models/pais_model.dart';
import 'package:appsam/src/models/profesion_model.dart';
import 'package:appsam/src/models/religion_model.dart';
import 'package:appsam/src/utils/utils.dart';

class CombosService {
  final _apiURL = EnviromentVariables().getApiURL();

  Future<List<DepartamentoModel>> getDepartamentos() async {
    final List<DepartamentoModel> lista = new List();
    final url = '$_apiURL/api/Departamentos';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((depto) {
        final deptoTemp = DepartamentoModel.fromJson(depto);
        lista.add(deptoTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<EscolaridadModel>> getEscolaridades() async {
    final List<EscolaridadModel> lista = new List();
    final url = '$_apiURL/api/Escolaridad';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((escolaridad) {
        final escolaridadTemp = EscolaridadModel.fromJson(escolaridad);
        lista.add(escolaridadTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<GrupoEtnicoModel>> getGruposEtnicos() async {
    final List<GrupoEtnicoModel> lista = new List();
    final url = '$_apiURL/api/GrupoEtnico';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((grupo) {
        final grupoTemp = GrupoEtnicoModel.fromJson(grupo);
        lista.add(grupoTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<GrupoSanguineoModel>> getGrupoSanguineos() async {
    final List<GrupoSanguineoModel> lista = new List();
    final url = '$_apiURL/api/GrupoSanguineo';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((grupo) {
        final grupoTemp = GrupoSanguineoModel.fromJson(grupo);
        lista.add(grupoTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<MunicipioModel>> getMunicipiosXDepartamento(
      int departamentoId) async {
    final List<MunicipioModel> lista = new List();
    final url = '$_apiURL/api/Municipios/$departamentoId';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((municipio) {
        final municipioTemp = MunicipioModel.fromJson(municipio);
        lista.add(municipioTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<ProfesionModel>> getProfesiones() async {
    final List<ProfesionModel> lista = new List();
    final url = '$_apiURL/api/Profesion';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((profesion) {
        final profesionTemp = ProfesionModel.fromJson(profesion);
        lista.add(profesionTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<ReligionModel>> getReligiones() async {
    final List<ReligionModel> lista = new List();
    final url = '$_apiURL/api/Religion';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((religion) {
        final religionTemp = ReligionModel.fromJson(religion);
        lista.add(religionTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<PaisModel>> getPaises() async {
    final List<PaisModel> lista = new List();
    final url = '$_apiURL/api/Pais';
    final resp = await http.get(url);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((pais) {
        final paisTemp = PaisModel.fromJson(pais);
        lista.add(paisTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<ExamenCategoriaModel>> getCategoriasExamenes() async {
    final String token = StorageUtil.getString('token');
    final List<ExamenCategoriaModel> lista = new List();
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url = '$_apiURL/api/ExamenCategoria';
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((categoria) {
        final categoriaTemp = ExamenCategoriaModel.fromJson(categoria);
        lista.add(categoriaTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<ExamenTipoModel>> getTiposExamenes(int categoriaId) async {
    final String token = StorageUtil.getString('token');
    final List<ExamenTipoModel> lista = new List();
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };

    final url = '$_apiURL/api/ExamenTipo/categoriaid/$categoriaId';
    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((tipo) {
        final tipoTemp = ExamenTipoModel.fromJson(tipo);
        lista.add(tipoTemp);
      });
      return lista;
    }

    return [];
  }

  Future<List<ExamenDetalleModel>> getDetalleExamenes(
      int tipoId, int categoriaId) async {
    final List<ExamenDetalleModel> lista = new List();
    final String token = StorageUtil.getString('token');
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
      'authorization': 'Bearer $token',
    };
    final url =
        '$_apiURL/api/ExamenDetalle/examentipoid/$tipoId/examencategoriaid/$categoriaId';

    if (tipoId == null || categoriaId == null) {
      return [];
    }

    final resp = await http.get(url, headers: headers);
    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((detalle) {
        final detalleTemp = ExamenDetalleModel.fromJson(detalle);
        lista.add(detalleTemp);
      });
      return lista;
    }
    return [];
  }

  Future<List<ViaAdministracionModel>> getViasAdministracion() async {
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    final url = '$_apiURL/api/ViaAdministracion';
    final List<ViaAdministracionModel> lista = new List();
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((detalle) {
        final detalleTemp = ViaAdministracionModel.fromJson(detalle);
        lista.add(detalleTemp);
      });

      return lista;
    }
    return [];
  }

  Future<List<AnticonceptivosModel>> getAnticonceptivos() async {
    final headers = {
      "content-type": "application/json",
      "accept": "application/json",
    };

    final url = '$_apiURL/api/Anticonceptivos';
    final List<AnticonceptivosModel> lista = new List();
    final resp = await http.get(url, headers: headers);

    if (resp.statusCode == 200 && resp.body.isNotEmpty) {
      final decodeResp = json.decode(resp.body);
      decodeResp.forEach((detalle) {
        final detalleTemp = AnticonceptivosModel.fromJson(detalle);
        lista.add(detalleTemp);
      });

      return lista;
    }
    return [];
  }
}
