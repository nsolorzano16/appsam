import 'package:appsam/src/models/historialGineco_viewmodel.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DetHistorialGinecologico extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final HistorialGinecoViewModel _historial;

  const DetHistorialGinecologico({@required preclinica, @required historial})
      : _preclinica = preclinica,
        _historial = historial;

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
            Stack(
              alignment: AlignmentDirectional.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                _backCover(size),
                _titleText(size),
                _imagenPortada(size),
              ],
            ),
            SizedBox(height: 10.0),
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
            'Historial Ginecológico',
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
          tag: 'historialginecologicoportada',
          child: FaIcon(
            FontAwesomeIcons.female,
            size: 120,
            color: Colors.white,
          ),
        )),
  );
}
