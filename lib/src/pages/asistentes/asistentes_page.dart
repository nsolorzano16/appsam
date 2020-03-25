import 'dart:async';

import 'package:appsam/src/blocs/asistentes_bloc.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/search/search_delegate.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AsistentesPage extends StatefulWidget {
  static final String routeName = 'asistentes';
  @override
  _AsistentesPageState createState() => _AsistentesPageState();
}

class _AsistentesPageState extends State<AsistentesPage> {
  AsistentesBloc asistentesBloc = new AsistentesBloc();
  ScrollController _scrollController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final int _usuarioId = StorageUtil.getInt('usuarioId');

  int totalPages = 0;

  int page = 1;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    // asistentesBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', AsistentesPage.routeName);
    asistentesBloc.cargarAsistentesPaginado(1, '', _usuarioId);
  }

  @override
  Widget build(BuildContext context) {
    final UsuarioModel _usuario = ModalRoute.of(context).settings.arguments;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        totalPages = asistentesBloc.ultimaPagina;
        print(totalPages);
        print(page);

        if (page <= totalPages) {
          fetchData(page, _usuario.usuarioId);
        }
      }
    });
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuWidget(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              }),
        ],
        title: Text('Asistentes'),
      ),
      body: Stack(
        children: <Widget>[
          _crearListaAsistentes(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => _goToCrearAsistente(_usuario),
      ),
    );
  }

  Future<Null> fetchData(int page, int doctorId) async {
    asistentesBloc.cargarAsistentesPaginado(page, '', doctorId);
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

  Widget _crearListaAsistentes() {
    return StreamBuilder(
      stream: asistentesBloc.asistentesStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: SpinKitWave(
                color: Theme.of(context).primaryColor,
              ),
            );

          default:
            final asistentes = snapshot.data;

            return ListView.builder(
                controller: _scrollController,
                itemCount: asistentes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _crearItem(context, asistentes[index]);
                });
        }
      },
    );
  }

  Widget _crearItem(
    BuildContext context,
    UsuarioModel usuario,
  ) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ListTile(
          dense: true,
          onTap: () {
            Navigator.pushReplacementNamed(context, 'asistente_detalle',
                arguments: usuario);
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          leading: Container(
              padding: EdgeInsets.only(right: 5.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.black))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: FadeInImage(
                    width: 40.0,
                    height: 40.0,
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(usuario.fotoUrl)),
              )),
          title: Container(
            child: Text(
              '${usuario.nombres} ${usuario.primerApellido} ${usuario.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: _crearSubtitle(usuario),
          trailing: Icon(Icons.arrow_forward_ios)),
    );
  }

  Widget _crearSubtitle(UsuarioModel usuario) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Container(
                    child: (usuario.activo)
                        ? _labelEstado('Activo', Colors.green)
                        : _labelEstado('Inactivo', Colors.red)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _labelEstado(String texto, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        padding: EdgeInsets.all(2.0),
        color: color,
        child: Text(
          texto,
          style: TextStyle(color: Colors.white, fontSize: 10.0),
        ),
      ),
    );
  }

  void _goToCrearAsistente(UsuarioModel usuario) {
    final _asistente = new UsuarioModel();

    _asistente.usuarioId = 0;
    _asistente.rolId = 3;
    _asistente.asistenteId = usuario.usuarioId;
    _asistente.sexo = 'M';
    _asistente.edad = 0;
    _asistente.activo = true;
    _asistente.creadoFecha = new DateTime.now();
    _asistente.creadoPor = usuario.userName;
    _asistente.modificadoFecha = new DateTime.now();
    _asistente.modificadoPor = usuario.userName;
    Navigator.pushReplacementNamed(context, 'crear-editar-asistente',
        arguments: _asistente);
  }
}
