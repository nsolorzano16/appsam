import 'package:appsam/src/models/eventos_model.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/providers/calendarioFecha_service.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AgendaDetallePage extends StatefulWidget {
  final Event evento;

  const AgendaDetallePage({Key key, @required this.evento}) : super(key: key);

  @override
  _AgendaDetallePageState createState() => _AgendaDetallePageState();
}

class _AgendaDetallePageState extends State<AgendaDetallePage> {
  final agendaService = EventosService();

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario =
        usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));
    final evento = widget.evento;
    final formatHoras = DateFormat.Hm('es_Es');
    final formatDates = DateFormat.yMMMMEEEEd('es_Es');
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: GFCard(
            elevation: 3,
            title: GFListTile(
              color: Colors.red,
              title: Center(
                child: Text(
                  'Detalle de cita',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ),
            content: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Título:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${evento.notas}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  Text(
                    'Fecha de inicio:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    formatDates.format(evento.inicio),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Fecha de finalización:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    formatDates.format(evento.fin),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  Text(
                    'Hora de inicio:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    formatHoras.format(evento.inicio),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Hora de finalización:',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    formatHoras.format(evento.fin),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Divider(
                    height: 5.0,
                  ),
                  SizedBox(
                    height: 8.0,
                  )
                ],
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _confirmDesactivar(context, evento, _usuario),
        child: Icon(Icons.delete),
      ),
    );
  }

  void _confirmDesactivar(
      BuildContext context, Event evento, UsuarioModel usuario) {
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
            onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              _delete(evento, usuario);
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
  }

  void _delete(Event evento, UsuarioModel usuario) async {
    evento.activo = false;
    evento.modificadoPor = usuario.userName;
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
    final eventoEdit = await agendaService.updateEvento(evento);
    if (eventoEdit != null) {
      await _pr.hide();
      mostrarFlushBar(context, Colors.red[400], 'Info', 'Datos eliminados', 2,
          Icons.info, Colors.black);
    } else {
      await _pr.hide();
      mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
          Icons.info, Colors.white);
    }
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.pushReplacementNamed(context, 'agenda');
    });
  }
}
