import 'package:appsam/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/pages/asistentes/detalle_asistente.dart';
import 'package:appsam/src/utils/storage_util.dart';

class DataSearch extends SearchDelegate {
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
    final UserModel _usuario =
        userModelFromJson(StorageUtil.getString('usuarioGlobal'));
    // son las sugerencias que aparecen cuando la persona escribe
    final bloc = Provider.asistentesBloc(context);
    if (query.isEmpty) return Container();

    bloc.cargarAsistentesPaginadoBusqueda(1, query, _usuario.id);
    return StreamBuilder(
      stream: bloc.asistentesBusquedaStream,
      builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
        if (snapshot.hasData) {
          final asistentes = snapshot.data;
          return ListView(
              children: asistentes.map((asistente) {
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

  Widget _item(BuildContext context, UserModel usuario) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

      child: ListTile(
          dense: true,
          onTap: () {
            close(context, null);
            Navigator.pushReplacementNamed(context, AsistenteDetalle.routeName,
                arguments: usuario);
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
                    fit: BoxFit.cover,
                    width: 40.0,
                    height: 40.0,
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(usuario.fotoUrl)),
              )),
          title: Container(
            child: Text(
              '${usuario.nombres}${usuario.primerApellido} ${usuario.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //subtitle: _crearSubtitle(usuario),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              size: 20.0,
              color: Colors.redAccent,
            ),
            onPressed: () {
              close(context, null);

              Navigator.pushReplacementNamed(context, 'editar-asistente',
                  arguments: usuario);
            },
            iconSize: 25.0,
          )),

      //no
    );
  }
}
