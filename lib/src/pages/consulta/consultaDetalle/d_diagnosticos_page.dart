import 'package:appsam/src/models/diagnosticos_viewmodel.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class DetalleDiagnosticosPage extends StatelessWidget {
  final List<DiagnosticosViewModel> _diagnosticos;

  const DetalleDiagnosticosPage({@required diagnosticos})
      : _diagnosticos = diagnosticos;

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
        children: _cardItem(size, _diagnosticos, estiloTitulos),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size,
      List<DiagnosticosViewModel> listaDiagnosticos, TextStyle estiloTitulos) {
    final List<Widget> lista = new List();
    final stack = _appBar(size);
    lista.add(stack);
    listaDiagnosticos.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: GFListTile(
            title: Text(
              'Enfermedad',
              style: estiloTitulos,
            ),
            subtitleText: '${element.nombreCie.toLowerCase()}'),
        content: Text(
          'Problema clínico: ${element.problemasClinicos} ',
          textAlign: TextAlign.justify,
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
            'Diagnosticos',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'diagnosticosportada',
            child: Icon(
              Icons.note,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
