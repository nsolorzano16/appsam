import 'package:appsam/src/blocs/diagnosticos_bloc.dart';
import 'package:appsam/src/models/diagnosticos_viewmodel.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/pages/consulta/diagnosticos/search_enfermedad.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DiagnosticosPage extends StatefulWidget {
  static final String routeName = 'diagnosticos';

  @override
  _CrearDiagnosticosPageState createState() => _CrearDiagnosticosPageState();
}

class _CrearDiagnosticosPageState extends State<DiagnosticosPage> {
  final DiagnosticosBloc _diagnosticosBloc = new DiagnosticosBloc();

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();

  Future<List<DiagnosticosViewModel>> _diagnosticosFuture;

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', DiagnosticosPage.routeName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _diagnosticosFuture = _diagnosticosBloc.getDiagnosticos(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
              backgroundColor: colorFondoApp(),
              key: mScaffoldState,
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
                future: _diagnosticosFuture,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DiagnosticosViewModel>> snapshot) {
                  if (snapshot.hasData) {
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
                              title: Text('Diagnosticos'),
                              subtitle: Text(
                                  'Click en el boton \"Buscar\" para agregar'),
                            )),
                        Divider(
                          thickness: 2.0,
                          indent: 20.0,
                          endIndent: 20.0,
                        ),
                        Flexible(
                            child: ListView(
                          children: items(snapshot.data),
                        ))
                      ],
                    );
                  } else {
                    return loadingIndicator(context);
                  }
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () => Navigator.of(context).push(PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, animation, __) => FadeTransition(
                          opacity: animation,
                          child: SearchEnfemedadesPage(
                            preclinica: _preclinica,
                          ),
                        ))),
              )),
        ),
        onWillPop: () async => false);
  } //fin build

  List<Widget> items(List<DiagnosticosViewModel> lista) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Problema Clinico: ${f.problemasClinicos}',
              overflow: TextOverflow.ellipsis,
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).primaryColor,
                    size: 16.0,
                  ),
                  onPressed: () =>
                      confirmAction(context, 'Desea eliminar el registro', f),
                )
              ],
            ),
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: GFCard(
                    elevation: 3.0,
                    content: Table(
                      children: [
                        TableRow(children: [
                          Text('Enfermedad: ${f.nombreCie.toLowerCase()}'),
                        ]),
                        TableRow(children: [Divider()]),
                        TableRow(children: [
                          Text(
                            'Problema clinico: ${f.problemasClinicos}',
                            textAlign: TextAlign.justify,
                          )
                        ]),
                      ],
                    ),
                  ))
            ],
          ),
        ],
      );
    }).toList();
  }

  void _desactivar(DiagnosticosViewModel f) async {
    final ProgressDialog _pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    _pr.update(
      progress: 50.0,
      message: "Espere...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    await _pr.show();
    f.activo = false;
    bool resp = await _diagnosticosBloc.desactivar(f);
    await _pr.hide();
    if (resp) {
      mostrarFlushBar(context, Colors.redAccent, 'Info', 'Datos eliminados', 2,
          Icons.info, Colors.black);
    } else {
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
    setState(() {});
  }

  void confirmAction(
      BuildContext context, String texto, DiagnosticosViewModel f) {
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
        Navigator.pop(context);
        _desactivar(f);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(texto),
          Text('Esta acción no se podra deshacer.')
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

  showConfirmDialog(
      BuildContext context, String ruta, PreclinicaViewModel args) {
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
        Navigator.pushReplacementNamed(context, ruta, arguments: args);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Información"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Desea continuar a la siguiente pagina?'),
          Text('Esta acción no se podra deshacer.')
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
        builder: (context) {
          return alert;
        },
        barrierDismissible: false);
  }
}
