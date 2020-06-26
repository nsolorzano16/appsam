import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetallePreclinicaConsultaPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;

  const DetallePreclinicaConsultaPage({@required preclinica})
      : _preclinica = preclinica;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
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
                  _itemTexto('Peso (lb):', estiloTitulos),
                  _itemTexto('${_preclinica.peso}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Altura (cm):', estiloTitulos),
                  _itemTexto('${_preclinica.altura}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Temperatura (C):', estiloTitulos),
                  _itemTexto('${_preclinica.temperatura}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Frecuencia Respiratoria:', estiloTitulos),
                  _itemTexto(
                      '${_preclinica.frecuenciaRespiratoria}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Ritmo Cardiaco:', estiloTitulos),
                  _itemTexto('${_preclinica.ritmoCardiaco}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Presión Sistolica:', estiloTitulos),
                  _itemTexto('${_preclinica.presionSistolica}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Presión Diastolica:', estiloTitulos),
                  _itemTexto('${_preclinica.presionDiastolica}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('IMC:', estiloTitulos),
                  _itemTexto('${_preclinica.imc}', estiloTitulos),
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
            'Preclinica',
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
          tag: 'preclinicaPortada',
          child: FaIcon(
            FontAwesomeIcons.fileMedical,
            size: 120,
            color: Colors.white,
          ),
        )),
  );
}
