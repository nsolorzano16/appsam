import 'package:appsam/src/models/menu_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/menu_provider.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

import 'package:icons_helper/icons_helper.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UsuarioModel usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(child: _lista(usuario)),
        Divider(),
        ListTile(
          title: Text('Salir'),
          leading: Icon(
            FontAwesomeIcons.signOutAlt,
            color: Colors.red,
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
                      //WebNotificicationsStream.instance.dispose();
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

  Widget _lista(UsuarioModel usuario) {
    // menuProvider.cargarData()
    return FutureBuilder(
      future: menuProvider.cargarData(),
      //initialData: new List<Ruta>(),
      builder: (context, AsyncSnapshot<List<Ruta>> snapshot) {
        if (snapshot.data != null) {
          return ListView(
            children: _listaItems(usuario, snapshot.data, context),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _fotoDelDrawer(UsuarioModel usuario) {
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

  List<Widget> _listaItems(
    UsuarioModel usuario,
    List<Ruta> data,
    BuildContext context,
  ) {
    final List<Widget> opciones = [];
    opciones.add(_fotoDelDrawer(usuario));
    var widgetTemp;

    data.forEach((opt) {
      opt.roles.forEach((rol) {
        if (rol.autorizados == usuario.rolId) {
          widgetTemp = ListTile(
            title: Text(opt.texto),
            leading: Icon(
              getIconUsingPrefix(name: opt.icon),
              color: Theme.of(context).primaryColor,
            ),
            trailing: (opt.texto == 'Consulta' || opt.texto == 'Agenda')
                ? GFBadge(
                    child: Text('${opt.notificaciones}'),
                    size: GFSize.SMALL,
                    borderShape: StadiumBorder(),
                  )
                : Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
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
