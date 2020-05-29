import 'package:appsam/src/models/menu_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/menu_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(child: _lista()),
        Divider(),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.gesture),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Salir'),
              ),
            ],
          ),
          onTap: () {
            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Información"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Desea completar esta acción?'),
                ],
              ),
              elevation: 24.0,
              actions: [
                FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'login', (Route<dynamic> route) => false);
                    },
                    child: Text('Aceptar'))
              ],
            );

            // show the dialog
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
                barrierDismissible: false);
          },
        ),
      ],
    ));
  }

  Widget _lista() {
    // menuProvider.cargarData()
    return FutureBuilder(
      future: menuProvider.cargarData(),
      //initialData: new List<Ruta>(),
      builder: (context, AsyncSnapshot<List<Ruta>> snapshot) {
        if (snapshot.data != null) {
          return ListView(
            children: _listaItems(snapshot.data, context),
          );
        } else {
          return Container();
        }
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
                Icon(
                  getIconUsingPrefix(name: opt.icon),
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(opt.texto),
                ),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                opt.ruta.toString(),
              );
            },
          );
          opciones..add(widgetTemp)..add(Divider());
          widgetTemp = null;
        }
      });
    });

    return opciones;
  }

  showConfirmDialog(BuildContext context, String ruta) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancelar'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Ok'),
      onPressed: () {
        StorageUtil.removeUsuario();
        StorageUtil.putString('ultimaPagina', ruta);
        Navigator.pushReplacementNamed(context, ruta);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Desea completar esta acción?'),
        ],
      ),
      elevation: 24.0,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
        barrierDismissible: false);
  }
}
