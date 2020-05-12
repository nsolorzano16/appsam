import 'package:appsam/src/blocs/examenes_bloc.dart';
import 'package:appsam/src/models/examenIndicado_Model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class ExamenesIndicadosPage extends StatelessWidget {
  static final String routeName = 'examenes_indicados';

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

    final ExamenesBloc _examenesBloc = new ExamenesBloc();

    StorageUtil.putString('ultimaPagina', ExamenesIndicadosPage.routeName);
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    Future<List<ExamenIndicadoModel>> _examenesFuture;

    _examenesFuture = _examenesBloc.getExamenesIndicados(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Consulta'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pushReplacementNamed(
                      context, 'menu_consulta',
                      arguments: _preclinica))
            ],
          ),
          drawer: MenuWidget(),
          body: FutureBuilder(
            future: _examenesFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<ExamenIndicadoModel>> snapshot) {
              final examenes = snapshot.data;
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                          left: 20.0,
                          top: 10.0,
                          right: 10.0,
                        ),
                        child: ListTile(
                          title: Text('Examenes'),
                          subtitle:
                              Text('Click en el boton \"+\" para agregar'),
                        )),
                    Divider(
                      thickness: 2.0,
                      indent: 20.0,
                      endIndent: 20.0,
                    ),
                    Flexible(
                        child: ListView(
                      children: items(examenes, context),
                    ))
                  ],
                );
              } else {
                return loadingIndicator(context);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () => Navigator.pushNamed(
                context, 'crear_examen_indicado',
                arguments: _preclinica),
            child: Icon(Icons.add),
          ),
        ),
        onWillPop: () async => false);
  }

  List<Widget> items(List<ExamenIndicadoModel> lista, BuildContext context) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Examen: ${f.nombre}',
              overflow: TextOverflow.ellipsis,
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16.0,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    onPressed: () {}),
              ],
            ),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: GFCard(
                    elevation: 3.0,
                    content: Text(
                      f.notas,
                      textAlign: TextAlign.justify,
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }
}
