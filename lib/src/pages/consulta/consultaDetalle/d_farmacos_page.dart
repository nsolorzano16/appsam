import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetFarmacosPage extends StatelessWidget {
  final List<FarmacosUsoActual> _farmacos;

  const DetFarmacosPage({@required farmacos}) : _farmacos = farmacos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    final estiloItems = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),
      body: ListView(
        children: _cardItem(size, _farmacos, estiloTitulos, estiloItems),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size, List<FarmacosUsoActual> listaFarmacos,
      TextStyle estiloTitulos, TextStyle estiloItems) {
    final List<Widget> lista = new List();
    final stack = _appBar(size);
    lista.add(stack);
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

  Container _appBar(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: size.height * 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ListTile(
          title: Text(
            'Farmacos',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'farmacosportada',
            child: FaIcon(
              FontAwesomeIcons.capsules,
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
