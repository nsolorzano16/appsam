import 'package:appsam/src/blocs/cie_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/cie_model.dart';
import 'package:appsam/src/models/paginados/enfermedadesPaginado_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchEnfermedades extends SearchDelegate<String> {
  Future<EnfermedadesPaginadoModel> enfermedadesfuture;

  UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones de nuestro appbar
    return [
      IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final cieBloc = Provider.cieBloc(context);
    if (query.isEmpty) return Container();
    if (query.length >= 3) {
      cieBloc.cargarEnfermedadesBusqueda(1, query);
    } else {
      return Container();
    }

    return StreamBuilder(
      stream: cieBloc.enfermedadesBusquedaStream,
      builder: (BuildContext context, AsyncSnapshot<List<CieModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return loadingIndicator(context);
        if (!snapshot.hasData) return loadingIndicator(context);
        return ListView.separated(
          itemCount: snapshot.data.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) {
            return _item(context, snapshot.data[index], index);
          },
        );
      },
    );
  }

  Widget _item(BuildContext context, CieModel data, int index) {
    index++;
    return Container(
      child: ListTile(
        title: Text(
          '$index-${data.nombre.toLowerCase()}',
          textAlign: TextAlign.justify,
        ),
        subtitle: Text('${data.codigo}'),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }
}
