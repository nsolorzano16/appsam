import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/pages/pacientes/paciente_detalle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    // // son las sugerencias que aparecen cuando la persona escribe
    // final bloc = Provider.pacientesBloc(context);
    // if (query.isEmpty) return Container();
    // bloc.cargarPacientesPaginadoBusqueda(1, query);
    // return StreamBuilder(
    //   stream: bloc.pacientesBusquedaStream,
    //   builder: (BuildContext context, AsyncSnapshot<List<Paciente>> snapshot) {
    //     if (snapshot.hasData) {
    //       final pacientes = snapshot.data;
    //       return ListView(
    //           children: pacientes.map((asistente) {
    //         return _item(context, asistente);
    //       }).toList());
    //     } else {
    //       return Center(
    //         child: SpinKitWave(
    //           color: Theme.of(context).primaryColor,
    //         ),
    //       );
    //     }
    //   },
    // );
  }

  // Widget _item(BuildContext context, Paciente paciente) {
  //   return Card(
  //     elevation: 10.0,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

  //     child: ListTile(
  //         dense: true,
  //         onTap: () {
  //           close(context, null);
  //           Navigator.pushReplacementNamed(context, PacienteDetalle.routeName,
  //               arguments: paciente);
  //         },
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 10.0,
  //         ),
  //         leading: Container(
  //             padding: EdgeInsets.only(right: 5.0),
  //             decoration: BoxDecoration(
  //                 border: Border(
  //                     right: BorderSide(width: 1.0, color: Colors.black))),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(30.0),
  //               child: FadeInImage(
  //                   width: 40.0,
  //                   height: 40.0,
  //                   placeholder: AssetImage('assets/jar-loading.gif'),
  //                   image: NetworkImage(paciente.fotoUrl)),
  //             )),
  //         title: Container(
  //           child: Text(
  //             '${paciente.nombres}${paciente.primerApellido} ${paciente.segundoApellido}',
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         //subtitle: _crearSubtitle(paciente),
  //         trailing: IconButton(
  //           icon: Icon(
  //             Icons.edit,
  //             size: 20.0,
  //             color: Colors.redAccent,
  //           ),
  //           onPressed: () {
  //             close(context, null);

  //             Navigator.pushReplacementNamed(context, 'editar-asistente',
  //                 arguments: paciente);
  //           },
  //           iconSize: 25.0,
  //         )),

  //     //no
  //   );
  // }
}
