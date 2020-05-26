import 'dart:async';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:appsam/src/blocs/preclinica_bloc.dart';
import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/models/usuario_model.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class PreclinicaPage extends StatefulWidget {
  static final String routeName = 'preclinica';

  @override
  _PreclinicaPageState createState() => _PreclinicaPageState();
}

class _PreclinicaPageState extends State<PreclinicaPage> {
  PreclinicaBloc _preclinicaBloc = new PreclinicaBloc();
  ScrollController _scrollController = new ScrollController();
  final UsuarioModel _usuario =
      usuarioModelFromJson(StorageUtil.getString('usuarioGlobal'));

  int totalPages = 0;
  int page = 1;
  @override
  void initState() {
    StorageUtil.putString('ultimaPagina', PreclinicaPage.routeName);
    _preclinicaBloc.cargarPreclinicasPaginado(1, _usuario.usuarioId, 0);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PreclinicaBloc _preclinicaBloc = Provider.preclinicaBloc(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        totalPages = _preclinicaBloc.ultimaPagina;

        if (page <= totalPages) {
          fetchData(
            page,
          );
        }
      }
    });

    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            drawer: MenuWidget(),
            appBar: AppBar(
              title: Text('Preclinica'),
            ),
            body: Stack(
              children: <Widget>[
                _crearListaPreclinicas(context),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }

  Future<Null> fetchData(int page) async {
    _preclinicaBloc.cargarPreclinicasPaginado(page, _usuario.usuarioId, 0);
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

  Widget _crearListaPreclinicas(BuildContext context) {
    return StreamBuilder(
      stream: _preclinicaBloc.preclinicasListStream,
      builder: (context, AsyncSnapshot<List<PreclinicaViewModel>> snapshot) {
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
            final preclinicas = snapshot.data;

            return (preclinicas.length == 0)
                ? Center(
                    child: Text('No hay registros para mostrar'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: preclinicas.length,
                    itemBuilder: (context, int index) {
                      return _crearItem(context, preclinicas[index]);
                    });
        }
      },
    );
  }

  Widget _crearItem(
    BuildContext context,
    PreclinicaViewModel preclinica,
  ) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ListTile(
          onTap: () => Navigator.pushReplacementNamed(
              context, 'preclinica_detalle', arguments: preclinica),
          dense: true,
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
                    image: NetworkImage(preclinica.fotoUrl)),
              )),
          title: Container(
            child: Text(
              '${preclinica.nombres} ${preclinica.primerApellido} ${preclinica.segundoApellido}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          subtitle: Row(
            children: <Widget>[
              Text(
                'Identificación: ${preclinica.identificacion}',
              ),
            ],
          ),
          trailing: Icon(Icons.arrow_forward_ios)),
    );
  }
}
