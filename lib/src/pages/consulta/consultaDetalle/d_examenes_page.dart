import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';

class DetExamenesPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final List<ExamenesIndicadosViewModel> _examenes;

  const DetExamenesPage({@required preclinica, @required examenes})
      : _preclinica = preclinica,
        _examenes = examenes;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final estilo = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),
      body: ListView(
        children: _cardItem(size, _examenes, estilo),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(4, 15, 22, 1),
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size,
      List<ExamenesIndicadosViewModel> listaExamenes, TextStyle estiloTitulos) {
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
    listaExamenes.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  _itemTexto('Nombre', estiloTitulos),
                  _itemTexto('${element.nombre}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Examen Categoria', estiloTitulos),
                  _itemTexto('${element.examenCategoria}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Examen Detalle', estiloTitulos),
                  _itemTexto('${element.examenDetalle}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Notas', estiloTitulos),
                  _itemTexto('${element.notas}', estiloTitulos),
                ])
              ],
            )
          ],
        ),
      );
      lista.add(itemTemp);
    });

    return lista;
  }

  Widget _itemTexto(String texto, TextStyle estilo) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Text(
        '$texto',
        style: estilo,
      ),
    );
  }

  Widget _backCover(Size size) {
    return Container(
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 148, 198, 1),
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
            'Examenes Indicados',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(4, 15, 22, 1),
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
              color: Color.fromRGBO(4, 15, 22, 1),
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
          tag: 'examenesportada',
          child: SvgPicture.asset(
            'assets/svg/examenes.svg',
          ),
        )),
  );
}
