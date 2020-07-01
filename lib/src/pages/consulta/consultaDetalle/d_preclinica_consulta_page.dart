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
          children: <Widget>[_appBar(size), _cardPrincipal(estiloTitulos)],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemTexto('Peso (lbs):', estiloTitulos),
            _itemTexto('${_preclinica.peso}', estiloTitulos),
            Divider(),
            _itemTexto('Altura (cm):', estiloTitulos),
            _itemTexto('${_preclinica.altura}', estiloTitulos),
            Divider(),
            _itemTexto('Temperatura (C°):', estiloTitulos),
            _itemTexto('${_preclinica.temperatura}', estiloTitulos),
            Divider(),
            _itemTexto('Frecuencia respiratoria/rpm:', estiloTitulos),
            _itemTexto('${_preclinica.frecuenciaRespiratoria}', estiloTitulos),
            Divider(),
            _itemTexto('Ritmo cardiaco/ppm:', estiloTitulos),
            _itemTexto('${_preclinica.ritmoCardiaco}', estiloTitulos),
            Divider(),
            _itemTexto('Presión Sistolica/mmHg:', estiloTitulos),
            _itemTexto('${_preclinica.presionSistolica}', estiloTitulos),
            Divider(),
            _itemTexto('Presión Diastolica/mmHg:', estiloTitulos),
            _itemTexto('${_preclinica.presionDiastolica}', estiloTitulos),
            Divider(),
            _itemTexto('IMC kg/m²:', estiloTitulos),
            _itemTexto('${_preclinica.imc}', estiloTitulos),
            Divider(),
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
            'Preclinica',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '${_preclinica.nombres} ${_preclinica.primerApellido} ${_preclinica.segundoApellido}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          trailing: Hero(
            tag: 'preclinicaPortada',
            child: FaIcon(
              FontAwesomeIcons.fileMedical,
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
