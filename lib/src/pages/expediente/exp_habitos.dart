import 'package:appsam/src/models/habitos_model.dart';
import 'package:flutter/material.dart';

class ExpHabitos extends StatelessWidget {
  final Habitos _habitos;

  const ExpHabitos({@required habitos}) : _habitos = habitos;

  @override
  Widget build(BuildContext context) {
    final estiloTitulos = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          _cardPrincipal(estiloTitulos)
        ],
      ),
    );
  }

  Card _cardPrincipal(TextStyle estiloTitulos) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
              ],
            ),
            Table(
              children: [
                TableRow(children: [
                  _itemTexto('Notas: ${_habitos.notas}', estiloTitulos),
                ]),
              ],
            )
          ],
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
