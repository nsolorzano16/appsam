import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/paginados/pacientesPaginado_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';

class DataSearchPacientes extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escribe
    final bloc = Provider.pacientesBloc(context);
    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    if (query.isEmpty) return Container();
    if (_usuario.rolId == 3) {
      bloc.cargarPacientesPaginadoBusqueda(1, query, _usuario.asistenteId);
    } else {
      bloc.cargarPacientesPaginadoBusqueda(1, query, _usuario.usuarioId);
    }

    return StreamBuilder(
      stream: bloc.pacientesBusquedaStream,
      builder: (BuildContext context,
          AsyncSnapshot<List<PacientesViewModel>> snapshot) {
        if (snapshot.hasData) {
          final pacientes = snapshot.data;
          return ListView(
              children: pacientes.map((asistente) {
            return _item(context, asistente);
          }).toList());
        } else {
          return Center(
            child: SpinKitWave(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  Widget _item(
    BuildContext context,
    PacientesViewModel paciente,
  ) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ListTile(
          dense: true,
          onTap: () {
            Navigator.pushReplacementNamed(context, 'paciente_detalle',
                arguments: paciente);
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          leading: Container(
              padding: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.black))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: FadeInImage(
                    width: 40.0,
                    height: 40.0,
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(paciente.fotoUrl)),
              )),
          title: Container(
            child: Text(
              '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Text('Identificación: ${paciente.identificacion}'),
          trailing: IconButton(
              icon: FaIcon(
                FontAwesomeIcons.fileMedical,
                size: 20.0,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'crear_preclinica',
                    arguments: paciente);
              })),
    );
  }
}
