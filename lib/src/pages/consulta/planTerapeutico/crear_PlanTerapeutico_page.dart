import 'package:appsam/src/blocs/planTerapeutico_bloc.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/planTerapeutico_model.dart';
import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/models/viaAdministracion_model.dart';
import 'package:appsam/src/providers/combos_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CrearPlanTerapeuticoPage extends StatefulWidget {
  static final String routeName = 'crear_plan_terapeutico';

  @override
  _CrearPlanTerapeuticoPageState createState() =>
      _CrearPlanTerapeuticoPageState();
}

class _CrearPlanTerapeuticoPageState extends State<CrearPlanTerapeuticoPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final PlanTerapeuticoModel _plan = new PlanTerapeuticoModel();

  final _planBloc = new PlanTerapeuticoBloc();
  final _combosService = new CombosService();
  String labelBoton = 'Guardar';

  final TextEditingController _nombreMedicamentoController =
      new TextEditingController();
  final TextEditingController _dosisController = new TextEditingController();
  final TextEditingController _horarioController = new TextEditingController();
  final TextEditingController _diasRequeridosController =
      new TextEditingController();
  final TextEditingController _notasController = new TextEditingController();
  bool _permanente = false;

  @override
  void initState() {
    super.initState();
    final UserModel _usuario =
        userModelFromJson(StorageUtil.getString('usuarioGlobal'));
    _plan.planTerapeuticoId = 0;
    _plan.activo = true;
    _plan.creadoPor = _usuario.userName;
    _plan.creadoFecha = DateTime.now();
    _plan.modificadoPor = _usuario.userName;
    _plan.modificadoFecha = DateTime.now();
    _plan.viaAdministracionId = 7;
    _plan.permanente = _permanente;
  }

  @override
  void dispose() {
    _nombreMedicamentoController.dispose();
    _dosisController.dispose();
    _horarioController.dispose();
    _diasRequeridosController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaViewModel _preclinica =
        ModalRoute.of(context).settings.arguments;

    _plan.pacienteId = _preclinica.pacienteId;
    _plan.preclinicaId = _preclinica.preclinicaId;
    _plan.doctorId = _preclinica.doctorId;

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
                        context, 'planes_terapeuticos',
                        arguments: _preclinica))
              ],
            ),
            drawer: MenuWidget(),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GFCard(
                    title: GFListTile(
                        color: Colors.red,
                        title: Text('Nuevo plan',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        icon:
                            FaIcon(FontAwesomeIcons.user, color: Colors.white)),
                    elevation: 6.0,
                    content: Form(
                        key: _formkey,
                        child: Column(children: <Widget>[
                          _crearCampoNombreMedicamento(),
                          _espacio(),
                          _crearCampoDosis(),
                          _espacio(),
                          _crearCampoHorario(),
                          _espacio(),
                          _crearCampoDiasRequeridos(),
                          _espacio(),
                          _crearDropDownViaAdministracion(),
                          _crearCampoPermamente(),
                          _espacio(),
                          _crearCampoNotas(),
                          _espacio(),
                          _crearBotones(context, _preclinica)
                        ])),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  String validaTexto(String value) {
    if (value.length < 3) {
      return 'Campo obligatorio';
    } else {
      return null;
    }
  }

  Widget _espacio() {
    return SizedBox(
      height: 10.0,
    );
  }

  Widget _crearCampoNombreMedicamento() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _nombreMedicamentoController,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _plan.nombreMedicamento = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Nombre medicamento', FontAwesomeIcons.pills),
      ),
    );
  }

  Widget _crearCampoDosis() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _dosisController,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _plan.dosis = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Dosis', FontAwesomeIcons.pills),
      ),
    );
  }

  Widget _crearCampoHorario() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _horarioController,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _plan.horario = value,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Horario', FontAwesomeIcons.pills),
      ),
    );
  }

  Widget _crearCampoPermamente() {
    return SwitchListTile(
        value: _permanente,
        title: Text('Permanente:'),
        onChanged: (value) {
          _permanente = value;
          _plan.permanente = _permanente;
          setState(() {});
        });
  }

  Widget _crearCampoDiasRequeridos() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _diasRequeridosController,
        autovalidate: true,
        validator: validaTexto,
        onSaved: (value) => _plan.diasRequeridos = value,
        keyboardType: TextInputType.text,
        decoration:
            inputsDecorations('Dias requeridos', FontAwesomeIcons.pills),
      ),
    );
  }

  Widget _crearCampoNotas() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: TextFormField(
        controller: _notasController,
        onSaved: (value) => _plan.notas = value,
        maxLines: 2,
        keyboardType: TextInputType.text,
        decoration: inputsDecorations('Notas adicionales', Icons.note),
      ),
    );
  }

  Widget _crearDropDownViaAdministracion() {
    return FutureBuilder(
      future: _combosService.getViasAdministracion(),
      builder: (BuildContext context,
          AsyncSnapshot<List<ViaAdministracionModel>> snapshot) {
        final lista = snapshot.data;
        if (lista != null) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: InputDecorator(
              decoration: inputsDecorations(
                  'Via administración', FontAwesomeIcons.flask),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                value: _plan.viaAdministracionId,
                isDense: true,
                onChanged: (value) async {
                  _plan.viaAdministracionId = value;
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                items: lista.map((x) {
                  return DropdownMenuItem(
                    value: x.viaAdministracionId,
                    child: Text(
                      x.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              )),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _crearBotones(BuildContext context, PreclinicaViewModel preclinica) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () => _guardar(context, preclinica),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(labelBoton))
      ],
    );
  }

  void _guardar(BuildContext context, PreclinicaViewModel preclinica) async {
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
    if (_nombreMedicamentoController.text.isEmpty &&
        _dosisController.text.isEmpty &&
        _horarioController.text.isEmpty &&
        _diasRequeridosController.text.isEmpty &&
        _notasController.text.isEmpty) {
      mostrarFlushBar(context, Colors.black, 'Info',
          'El formulario no puede estar vacio', 3, Icons.info, Colors.white);
    } else if (!_formkey.currentState.validate()) {
      mostrarFlushBar(context, Colors.black, 'Info', 'Revise todos los campos',
          3, Icons.info, Colors.white);
    } else {
      _formkey.currentState.save();
      await _pr.show();

      PlanTerapeuticoModel _planGuardado;
      _planGuardado = await _planBloc.addPlan(_plan);
      if (_planGuardado != null) {
        await _pr.hide();
        mostrarFlushBar(context, Colors.green, 'Info', 'Datos Guardados', 1,
            Icons.info, Colors.black);
        Future.delayed(Duration(seconds: 1)).then((_) =>
            Navigator.pushReplacementNamed(context, 'planes_terapeuticos',
                arguments: preclinica));
      } else {
        await _pr.hide();
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }
}
