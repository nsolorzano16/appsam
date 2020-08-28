import 'package:appsam/src/blocs/fotosPaciente_bloc.dart';
import 'package:appsam/src/pages/expediente/expediente_page.dart';
import 'package:appsam/src/pages/expediente/gallery/exp_galleryDetail.dart';
import 'package:appsam/src/pages/expediente/gallery/exp_uploadPhoto.dart';
import 'package:appsam/src/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExpGalleryPage extends StatefulWidget {
  final int pacienteId;
  final String doctorId;

  const ExpGalleryPage(
      {Key key, @required this.pacienteId, @required this.doctorId})
      : super(key: key);

  @override
  _ExpGalleryPageState createState() => _ExpGalleryPageState();
}

class _ExpGalleryPageState extends State<ExpGalleryPage> {
  int get _pacienteId => widget.pacienteId;
  String get _doctorId => widget.doctorId;
  final FotosPacienteBloc bloc = FotosPacienteBloc();
  final _scrollController = new ScrollController();

  int page = 1;

  @override
  void initState() {
    bloc.loadData(page, '', _pacienteId);
    _scrollController.addListener(_onListener);
    super.initState();
  }

  void _onListener() {
    if ((_scrollController.offset >=
            _scrollController.position.maxScrollExtent) &&
        !bloc.loading) {
      page++;

      if (page <= bloc.totalPages) {
        bloc.loadData(page, '', _pacienteId);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Galeria '),
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
                          child: ExpedientePage(
                              pacienteId: _pacienteId, doctorId: _doctorId),
                        ),
                      ),
                    )),
          ],
        ),
        drawer: MenuWidget(),
        body: AnimatedBuilder(
          animation: bloc,
          builder: (BuildContext context, Widget child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: StaggeredGridView.countBuilder(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 4,
                    itemCount: bloc.listPhotos.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (_, animation, __) =>
                                  SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0.0, 1.0),
                                  end: Offset(0.0, 0.0),
                                ).animate(animation),
                                child: GalleryDetailPhotoUrlPage(
                                  foto: bloc.listPhotos[index],
                                  pacienteId: widget.pacienteId,
                                  doctorId: widget.doctorId,
                                ),
                              ),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 1), // changes position of shadow
                              ),
                            ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error,
                                        stackTrace) =>
                                    Text('No se ha podido cargar la imagen'),
                                placeholder:
                                    AssetImage('assets/jar-loading.gif'),
                                image: NetworkImage(
                                    bloc.listPhotos[index].fotoUrl),
                              ),
                            ),
                          ),
                        )),
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(2, index.isEven ? 2 : 3),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                ),
                bloc.loading
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : Container(),
              ],
            );

            // PinterestGrid(
            //     lista: bloc.listPhotos,
            //   );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, animation, __) => SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0.0, 1.0),
                  end: Offset(0.0, 0.0),
                ).animate(animation),
                child: GalleryUploadPhotoPage(
                  doctorId: _doctorId,
                  pacienteId: _pacienteId,
                ),
              ),
            ),
          ),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
