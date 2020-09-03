import 'dart:io';

import 'package:appsam/src/models/user_model.dart';
import 'package:appsam/src/pages/expediente/gallery/exp_gallery.dart';
import 'package:appsam/src/providers/fotosPacienteService.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

class GalleryUploadPhotoPage extends StatefulWidget {
  final int pacienteId;
  final String doctorId;

  const GalleryUploadPhotoPage(
      {Key key, @required this.pacienteId, @required this.doctorId})
      : super(key: key);

  @override
  _GalleryUploadPhotoPageState createState() => _GalleryUploadPhotoPageState();
}

class _GalleryUploadPhotoPageState extends State<GalleryUploadPhotoPage> {
  final TextEditingController _descripcionController = TextEditingController();
  File foto;
  final FotosPacienteService _fotosPacienteService = FotosPacienteService();
  final UserModel _usuario =
      userModelFromJson(StorageUtil.getString('usuarioGlobal'));

  int get _pacienteId => widget.pacienteId;
  String get _doctorId => widget.doctorId;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: colorFondoApp(),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => _procesarImagen(ImageSource.camera, context)),
            IconButton(
                icon: Icon(Icons.add_photo_alternate),
                onPressed: () => _procesarImagen(ImageSource.gallery, context)),
          ],
        ),
        drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: Card(
            elevation: 2,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    child: (foto == null)
                        ? Image.asset('assets/no-image.png')
                        : Image.file(
                            foto,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _descripcionController,
                    maxLines: 4,
                    decoration: inputsDecorations('Descripcion', Icons.note),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.red,
                    onPressed: _guardar,
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
                  pacienteId: _pacienteId,
                  doctorId: _doctorId,
                ),
              ),
            ),
          ),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }

  void _procesarImagen(ImageSource origen, BuildContext context) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {
      setState(() {});
    }
  }

  void _guardar() async {
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
    if (foto == null || _descripcionController.text.isEmpty) {
      mostrarFlushBar(
          context,
          Colors.black,
          'Info',
          'Fotografía y descripción son obligatorios',
          2,
          Icons.info,
          Colors.white);
    } else {
      await _pr.show();

      final resp = await _fotosPacienteService.addFotoPaciente(
          _pacienteId,
          foto,
          _descripcionController.text,
          _usuario.userName,
          _usuario.id,
          _usuario.asistenteId);
      await _pr.hide();

      if (resp != null) {
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
                pacienteId: _pacienteId,
                doctorId: _doctorId,
              ),
            ),
          ),
        );
      } else {
        mostrarFlushBar(context, Colors.red, 'Info', 'Ha ocurrido un error', 2,
            Icons.info, Colors.white);
      }
    }
  }
}
