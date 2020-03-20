import 'package:appsam/src/models/menu_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/menu_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(child: _lista()),
    );
  }

  Widget _lista() {
    // menuProvider.cargarData()
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: new List<Ruta>(),
      builder: (context, AsyncSnapshot<List<Ruta>> snapshot) {
        return ListView(
          children: _listaItems(snapshot.data, context),
        );
      },
    );
  }

  Widget _fotoDelDrawer() {
    final UsuarioModel usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    if (usuario != null) {
      return UserAccountsDrawerHeader(
          accountName: Text(
            '${usuario.nombres} ${usuario.primerApellido} ${usuario.segundoApellido}',
            overflow: TextOverflow.ellipsis,
          ),
          accountEmail: Text('${usuario.email}'),
          currentAccountPicture: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              child: FadeInImage(
                  fit: BoxFit.fill,
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage(usuario.fotoUrl)),
            ),
          ));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  List<Widget> _listaItems(List<Ruta> data, BuildContext context) {
    // rol 1 => lenght = 2
    // rol 2 => lenght = 1
    final UsuarioModel usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    final List<Widget> opciones = [];
    opciones.add(_fotoDelDrawer());
    var widgetTemp;
    data.forEach((opt) {
      opt.roles.forEach((rol) {
        if (rol.autorizados == usuario.rolId) {
          widgetTemp = ListTile(
            title: Row(
              children: <Widget>[
                Icon(Icons.gesture),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(opt.texto),
                ),
              ],
            ),
            onTap: () {
              if (opt.ruta.toString().contains('login')) {
                mostrarDialogConfirm(context, 'Desea completar esta acción',
                    opt.ruta.toString());
              }
              Navigator.pushReplacementNamed(context, opt.ruta.toString(),
                  arguments: usuario);
            },
          );
          opciones..add(widgetTemp)..add(Divider());
          widgetTemp = null;
        }
      });
    });

    return opciones;
  }

  void mostrarDialogConfirm(BuildContext context, String mensaje, String ruta) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Información'),
            content: Text(mensaje),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
              FlatButton(
                  onPressed: () {
                    StorageUtil.removeAll();
                    StorageUtil.removeUsuario();
                    Navigator.pushReplacementNamed(context, ruta);
                    StorageUtil.putString('ultimaPagina', ruta);
                  },
                  child: Text('Si')),
            ],
          );
        });
  }
}
