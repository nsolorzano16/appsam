import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class DetNotasPage extends StatelessWidget {
  final List<Notas> _notas;

  const DetNotasPage({@required notas}) : _notas = notas;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: colorFondoApp(),
      body: ListView(
        children: _cardItem(size, _notas, estiloTitulos),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(
      Size size, List<Notas> listaNotas, TextStyle estiloTitulos) {
    final List<Widget> lista = new List();
    final stack = _appBar(size);
    lista.add(stack);
    listaNotas.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: GFListTile(
          title: Text(
            'Notas',
            style: estiloTitulos,
          ),
          subTitle: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(element.notas),
          ),
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
            'Notas',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'notasportada',
            child: Icon(
              Icons.note_add,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
