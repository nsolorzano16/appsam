import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class DetalleDiagnosticosPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final List<Diagnosticos> _diagnosticos;

  const DetalleDiagnosticosPage({@required preclinica, @required diagnosticos})
      : _preclinica = preclinica,
        _diagnosticos = diagnosticos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),
      body: ListView(
        children: _cardItem(size, _diagnosticos, estiloTitulos),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size, List<Diagnosticos> listaDiagnosticos,
      TextStyle estiloTitulos) {
    final List<Widget> lista = new List();
    final stack = Stack(
      alignment: AlignmentDirectional.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        _backCover(size),
        _titleText(size),
        _imagenPortada(size),
      ],
    );
    lista.add(stack);
    listaDiagnosticos.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: GFListTile(
            title: Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                'Diagnostico',
                style: estiloTitulos,
              ),
            ),
            subtitleText: element.problemasClinicos),
      );
      lista.add(itemTemp);
    });

    return lista;
  }

  Widget _backCover(Size size) {
    return Container(
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  }

  Widget _titleText(Size size) {
    return Positioned(
      left: 20,
      bottom: size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Diagnosticos',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${_preclinica.nombres} ${_preclinica.primerApellido} ${_preclinica.segundoApellido}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _imagenPortada(Size size) {
  return Positioned(
    top: size.height * 0.1,
    left: size.width * 0.6,
    child: Container(
        height: 130,
        width: 130,
        child: Hero(
          tag: 'diagnosticosportada',
          child: Icon(
            Icons.note,
            size: 120,
            color: Colors.white,
          ),
        )),
  );
}
