import 'dart:async';

import 'package:appsam/src/blocs/pacientes_bloc.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/search/search_pacientes.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PacientesPage extends StatefulWidget {
  static final String routeName = 'pacientes';
  @override
  _PacientesPageState createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  PacientesBloc _pacientesBloc = new PacientesBloc();
  ScrollController _scrollController = new ScrollController();

  int totalPages = 0;
  int page = 1;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', PacientesPage.routeName);
    _pacientesBloc.cargarPacientesPaginado(1, '');
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario = ModalRoute.of(context).settings.arguments;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        totalPages = _pacientesBloc.ultimaPagina;
        print(totalPages);
        print(page);

        if (page <= totalPages) {
          fetchData(
            page,
          );
        }
      }
    });

    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearchPacientes());
              }),
        ],
        title: Text('Pacientes'),
      ),
      body: Stack(
        children: <Widget>[
          //_crearListaPacientes(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _goToCrearPaciente(_usuario),
      ),
    );
  }

  Future<Null> fetchData(int page) async {
    _pacientesBloc.cargarPacientesPaginado(page, '');
    final ProgressDialog pd = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    pd.update(
      progress: 50.0,
      message: "Espere...",
      progressWidget: Container(child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      messageTextStyle:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
    );
    pd.show();
    Timer(Duration(seconds: 2), () {
      pd.hide();
    });
  }

  // Widget _crearListaPacientes() {
  //   return StreamBuilder(
  //     stream: _pacientesBloc.pacientesListStream,
  //     builder: (BuildContext context, AsyncSnapshot<List<Paciente>> snapshot) {
  //       if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       }
  //       switch (snapshot.connectionState) {
  //         case ConnectionState.waiting:
  //           return Center(
  //             child: SpinKitWave(
  //               color: Theme.of(context).primaryColor,
  //             ),
  //           );

  //         default:
  //           final asistentes = snapshot.data;

  //           return ListView.builder(
  //               controller: _scrollController,
  //               itemCount: asistentes.length,
  //               itemBuilder: (BuildContext context, int index) {
  //                 return _crearItem(context, asistentes[index]);
  //               });
  //       }
  //     },
  //   );
  // }

  // Widget _crearItem(
  //   BuildContext context,
  //   Paciente paciente,
  // ) {
  //   return Card(
  //     elevation: 3.0,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  //     child: ListTile(
  //         dense: true,
  //         onTap: () {
  //           Navigator.pushReplacementNamed(context, 'paciente_detalle',
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
  //             '${paciente.nombres} ${paciente.primerApellido} ${paciente.segundoApellido}',
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         subtitle: Text('Identificación: ${paciente.identificacion}'),
  //         trailing: IconButton(
  //             icon: FaIcon(
  //               FontAwesomeIcons.fileMedical,
  //               size: 20.0,
  //               color: Theme.of(context).primaryColor,
  //             ),
  //             onPressed: () {})),
  //   );
  // }

  void _goToCrearPaciente(UsuarioModel usuario) {
    Navigator.pushReplacementNamed(context, 'crear_paciente',
        arguments: usuario);
  }
}
