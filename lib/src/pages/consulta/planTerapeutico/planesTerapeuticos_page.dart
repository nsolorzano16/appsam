import 'package:appsam/src/blocs/planTerapeutico_bloc.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:appsam/src/pages/consulta/planTerapeutico/edit_PlanTerapeutico_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class PlanesTerapeuticosPage extends StatefulWidget {
  static final String routeName = 'planes_terapeuticos';

  @override
  _PlanesTerapeuticosPageState createState() => _PlanesTerapeuticosPageState();
}

class _PlanesTerapeuticosPageState extends State<PlanesTerapeuticosPage> {
  final PlanTerapeuticoBloc _planBloc = new PlanTerapeuticoBloc();
  final List<PlanTerapeuticoViewModel> _lista = new List();

  @override
  Widget build(BuildContext context) {
    StorageUtil.putString('ultimaPagina', PlanesTerapeuticosPage.routeName);
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    Future<List<PlanTerapeuticoViewModel>> _planesFuture;

    _planesFuture = _planBloc.getPlanes(
        _preclinica.pacienteId, _preclinica.doctorId, _preclinica.preclinicaId);

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
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
              future: _planesFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<PlanTerapeuticoViewModel>> snapshot) {
                if (snapshot.hasData) {
                  _lista.clear();
                  _lista.addAll(snapshot.data);
                }
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
                            title: Text('Plan Terapeutico'),
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
                        children: items(_lista, context, _preclinica),
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
              onPressed: () => Navigator.pushReplacementNamed(
                  context, 'crear_plan_terapeutico',
                  arguments: _preclinica),
              child: Icon(Icons.add),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  List<Widget> items(List<PlanTerapeuticoViewModel> lista, BuildContext context,
      PreclinicaViewModel preclinica) {
    return lista.map((f) {
      return Column(
        children: <Widget>[
          ExpansionTile(
            title: Text(
              'Plan: ${f.nombreMedicamento}',
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
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPlanTerapeuticoPage(
                                  plan: f,
                                  preclinica: preclinica,
                                )))),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).primaryColor,
                      size: 16.0,
                    ),
                    onPressed: () => confirmAction(
                        context, 'Desea eliminar el registro', f)),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Via administración:'),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(f.viaAdministracion),
                                Divider()
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 30.0, child: Text('Dosis:')),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 30.0, child: Text(f.dosis)),
                                Divider(),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    height: 30.0, child: Text('Horario:')),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 30.0, child: Text(f.horario)),
                                Divider(),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    height: 30.0,
                                    child: Text('Dias requeridos:')),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    height: 30.0,
                                    child: Text(f.diasRequeridos)),
                                Divider(),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Permanente:'),
                                Divider(),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                (f.permanente)
                                    ? Icon(
                                        Icons.check_circle,
                                        size: 16.0,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.timesCircle,
                                        size: 16.0,
                                        color: Colors.red,
                                      ),
                                Divider(),
                              ],
                            ),
                          ]),
                          TableRow(children: [
                            Text('Notas:'),
                            Text((f.notas != null) ? f.notas : ''),
                          ])
                        ],
                      )))
            ],
          ),
        ],
      );
    }).toList();
  }

  void _desactivar(BuildContext context, PlanTerapeuticoViewModel plan) async {
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
    plan.activo = false;
    final resp = await _planBloc.updatePlan(plan);

    if (resp != null) {
      await _pr.hide();
      mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 2,
          Icons.info, Colors.black);
    } else {
      await _pr.hide();

      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 3,
          Icons.info, Colors.black);
    }
    setState(() {});
  }

  void confirmAction(
      BuildContext context, String texto, PlanTerapeuticoViewModel f) {
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
        _desactivar(context, f);
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
}
