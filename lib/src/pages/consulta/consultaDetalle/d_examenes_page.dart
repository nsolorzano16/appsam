import 'package:appsam/src/models/examenesIndicados_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetExamenesPage extends StatelessWidget {
  final List<ExamenesIndicadosViewModel> _examenes;

  const DetExamenesPage({@required examenes}) : _examenes = examenes;

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
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size,
      List<ExamenesIndicadosViewModel> listaExamenes, TextStyle estiloTitulos) {
    final List<Widget> lista = new List();
    final stack = _appBar(size);
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

  Container _appBar(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: size.height * 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ListTile(
          title: Text(
            'Examenes Indicados',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'examenesportada',
            child: FaIcon(
              FontAwesomeIcons.flask,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
}
