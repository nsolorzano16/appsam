import 'package:appsam/src/blocs/fotosPaciente_bloc.dart';
import 'package:appsam/src/models/fotosPaciente_model.dart';
import 'package:appsam/src/pages/expediente/gallery/exp_gallery.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';

class GalleryDetailPhotoUrlPage extends StatelessWidget {
  final FotosPacienteModel foto;
  final int pacienteId;
  final int doctorId;

  const GalleryDetailPhotoUrlPage(
      {Key key,
      @required this.foto,
      @required this.pacienteId,
      @required this.doctorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FotosPacienteBloc bloc = FotosPacienteBloc();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (_, animation, __) => SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0.0, 1.0),
                      end: Offset(0.0, 0.0),
                    ).animate(animation),
                    child: ExpGalleryPage(
                      pacienteId: pacienteId,
                      doctorId: doctorId,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Descripcion: ${foto.notas}',
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: PhotoView(
                    minScale: PhotoViewComputedScale.contained * 1,
                    maxScale: PhotoViewComputedScale.covered * 1.8,
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    loadingBuilder: (context, event) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    imageProvider: NetworkImage(foto.fotoUrl),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _confirmDesactivar(context, bloc),
          child: Icon(Icons.delete),
        ),
      ),
    );
  }

  void _confirmDesactivar(BuildContext context, FotosPacienteBloc bloc) {
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
              _desactivar(context, bloc);
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

  void _desactivar(BuildContext context, FotosPacienteBloc bloc) async {
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
    foto.activo = false;
    final resp = await bloc.deletePhoto(foto);
    await _pr.hide();
    if (resp) {
      mostrarFlushBar(context, Colors.redAccent, 'Info', 'Datos eliminados', 2,
          Icons.info, Colors.black);

      await Future.delayed(const Duration(milliseconds: 1000));

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) => SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0.0, 1.0),
              end: Offset(0.0, 0.0),
            ).animate(animation),
            child: ExpGalleryPage(
              pacienteId: pacienteId,
              doctorId: doctorId,
            ),
          ),
        ),
      );
    }
  }
}
