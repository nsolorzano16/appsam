import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class ExpFarmacos extends StatelessWidget {
  final List<FarmacosUsoActual> _farmacos;

  const ExpFarmacos({@required farmacos}) : _farmacos = farmacos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    final estiloItems = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return ListView(
      children: _cardItem(size, _farmacos, estiloTitulos, estiloItems),
    );
  }

  List<Widget> _cardItem(Size size, List<FarmacosUsoActual> listaFarmacos,
      TextStyle estiloTitulos, TextStyle estiloItems) {
    final List<Widget> lista = new List();

    listaFarmacos.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  _itemTexto('Nombre:', estiloItems),
                  _itemTexto('${element.nombre}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Concentración:', estiloItems),
                  _itemTexto('${element.concentracion}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Dosis:', estiloItems),
                  _itemTexto('${element.dosis}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Tiempo:', estiloItems),
                  _itemTexto('${element.tiempo}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Notas adicionales:', estiloItems),
                  _itemTexto('${element.notas}', estiloItems),
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
}
