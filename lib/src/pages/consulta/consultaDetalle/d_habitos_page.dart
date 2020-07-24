import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetHabitosPage extends StatelessWidget {
  final Habitos _habitos;

  const DetHabitosPage({@required habitos}) : _habitos = habitos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: colorFondoApp(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _appBar(size),
            SizedBox(height: 10.0),
            _cardPrincipal(estiloTitulos)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  Card _cardPrincipal(TextStyle estiloTitulos) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  _itemTexto('Cigarrillo:', estiloTitulos),
                  _itemBoolean(_habitos.cigarrillo)
                ]),
                TableRow(children: [
                  _itemTexto('Café:', estiloTitulos),
                  _itemBoolean(_habitos.cafe)
                ]),
                TableRow(children: [
                  _itemTexto('Alcohol:', estiloTitulos),
                  _itemBoolean(_habitos.alcohol)
                ]),
                TableRow(children: [
                  _itemTexto('Droga:', estiloTitulos),
                  _itemBoolean(_habitos.drogasEstupefaciente)
                ]),
                TableRow(children: [
                  _itemTexto('Notas:', estiloTitulos),
                  _itemTexto('${_habitos.notas}', estiloTitulos),
                ]),
              ],
            )
          ],
        ),
      ),
    );
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
            'Habitos',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
              tag: 'habitosportada',
              child: FaIcon(
                FontAwesomeIcons.coffee,
                size: 50,
                color: Colors.white,
              )),
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
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _itemBoolean(bool value) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsets.all(5),
      child: (value)
          ? Icon(
              Icons.check,
              color: Colors.green,
            )
          : Icon(
              Icons.close,
              color: Colors.red,
            ),
    );
  }
}
