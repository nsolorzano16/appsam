import 'package:appsam/src/blocs/cie_bloc.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/pages/consulta/diagnosticos/crear_diagnosticos_page.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';

class SearchEnfemedadesPage extends StatelessWidget {
  final PreclinicaViewModel preclinica;

  const SearchEnfemedadesPage({Key key, this.preclinica}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CieBlocNoti bloc = CieBlocNoti();

    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: bloc.onChangedText,
                    decoration: inputsDecorations('', Icons.search,
                        helperTexto: 'Nombre, codigo de la enfermedad.',
                        hintTexto: 'buscar'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: bloc,
                builder: (context, child) {
                  return (bloc.loading)
                      ? loadingIndicator(context)
                      : ListView.builder(
                          itemCount: bloc.enfermedades.length,
                          itemBuilder: (BuildContext context, int index) {
                            final enf = bloc.enfermedades[index];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                elevation: 2,
                                child: ListTile(
                                  onTap: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondAnimation) =>
                                            CrearDiagnosticosPage(
                                              preclinica: preclinica,
                                              cieId: enf.cieId,
                                              enfermedad: enf.nombre,
                                            ),
                                        transitionsBuilder: (context, animation,
                                            secondAnimation, child) {
                                          var begin = Offset(0.0, 1.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;
                                          var tween = Tween(
                                                  begin: begin, end: end)
                                              .chain(CurveTween(curve: curve));
                                          return SlideTransition(
                                            position: animation.drive(tween),
                                            child: child,
                                          );
                                        }),
                                  ),
                                  title: Text(
                                    enf.nombre.toLowerCase(),
                                    textAlign: TextAlign.justify,
                                  ),
                                  subtitle: Text('${enf.codigo}'),
                                  trailing: Icon(Icons.arrow_right,
                                      color: Colors.red),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ));
  }
}
