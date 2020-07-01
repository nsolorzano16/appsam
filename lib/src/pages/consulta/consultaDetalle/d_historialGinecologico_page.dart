import 'package:appsam/src/models/historialGineco_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DetHistorialGinecologico extends StatelessWidget {
  final HistorialGinecoViewModel _historial;

  const DetHistorialGinecologico({@required historial})
      : _historial = historial;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    final format = DateFormat.yMMMEd('es_Es');

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _appBar(size),
            _cardPrincipal(estiloTitulos, format)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  Card _cardPrincipal(TextStyle estiloTitulos, DateFormat format) {
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
                  _itemTexto('Menarquia:', estiloTitulos),
                  _itemTexto(
                      '${(_historial.fechaMenarquia == null) ? '' : format.format(_historial.fechaMenarquia)}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Ultima menstruación:', estiloTitulos),
                  _itemTexto(
                      '${(_historial.fum == null) ? '' : format.format(_historial.fum)}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Número de gesta:', estiloTitulos),
                  _itemTexto('${_historial.g}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Cesáreas:', estiloTitulos),
                  _itemTexto('${_historial.c}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Partos:', estiloTitulos),
                  _itemTexto('${_historial.p}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Hijos vivos:', estiloTitulos),
                  _itemTexto('${_historial.hv}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Hijos muertos:', estiloTitulos),
                  _itemTexto('${_historial.hm}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Anticonceptivo:', estiloTitulos),
                  _itemTexto(
                      '${_historial.anticonceptivoTexto}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Anticonceptivo descripción:', estiloTitulos),
                  _itemTexto('${_historial.descripcionAnticonceptivos}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Fecha menopausia:', estiloTitulos),
                  _itemTexto(
                      '${(_historial.fechaMenopausia == null) ? '' : format.format(_historial.fechaMenopausia)}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Notas adicionales:', estiloTitulos),
                  _itemTexto('${_historial.notas}', estiloTitulos),
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
            'Historial Ginecológico',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'historialginecologicoportada',
            child: FaIcon(
              FontAwesomeIcons.female,
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
        textAlign: TextAlign.justify,
      ),
    );
  }
}
