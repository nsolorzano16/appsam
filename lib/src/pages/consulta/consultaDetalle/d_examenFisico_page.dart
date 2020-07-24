import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetExamenFisicoPage extends StatelessWidget {
  final ExamenFisico _examenFisico;

  const DetExamenFisicoPage({@required examenFisico})
      : _examenFisico = examenFisico;

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
            _itemTexto('Aspecto General:', estiloTitulos),
            _itemTexto('${_examenFisico.aspectoGeneral}', estiloTitulos),
            Divider(),
            _itemTexto('Piel y Faneras:', estiloTitulos),
            _itemTexto('${_examenFisico.pielFaneras}', estiloTitulos),
            Divider(),
            _itemTexto('Cabeza:', estiloTitulos),
            _itemTexto('${_examenFisico.cabeza}', estiloTitulos),
            Divider(),
            _itemTexto('Oidos:', estiloTitulos),
            _itemTexto('${_examenFisico.oidos}', estiloTitulos),
            Divider(),
            _itemTexto('Ojos:', estiloTitulos),
            _itemTexto('${_examenFisico.ojos}', estiloTitulos),
            Divider(),
            _itemTexto('Nariz:', estiloTitulos),
            _itemTexto('${_examenFisico.nariz}', estiloTitulos),
            Divider(),
            _itemTexto('Boca:', estiloTitulos),
            _itemTexto('${_examenFisico.boca}', estiloTitulos),
            Divider(),
            _itemTexto('Cuello:', estiloTitulos),
            _itemTexto('${_examenFisico.cuello}', estiloTitulos),
            Divider(),
            _itemTexto('Torax:', estiloTitulos),
            _itemTexto('${_examenFisico.torax}', estiloTitulos),
            Divider(),
            _itemTexto('Abdomen:', estiloTitulos),
            _itemTexto('${_examenFisico.abdomen}', estiloTitulos),
            Divider(),
            _itemTexto('Columna Vertebral Region Lumbar:', estiloTitulos),
            _itemTexto(
                '${_examenFisico.columnaVertebralRegionLumbar}', estiloTitulos),
            Divider(),
            _itemTexto('Miembros Superiores e Inferiores:', estiloTitulos),
            _itemTexto(
                '${_examenFisico.miembrosInferioresSuperiores}', estiloTitulos),
            Divider(),
            _itemTexto('Genitales:', estiloTitulos),
            _itemTexto('${_examenFisico.genitales}', estiloTitulos),
            Divider(),
            _itemTexto('Neurológico:', estiloTitulos),
            _itemTexto('${_examenFisico.neurologico}', estiloTitulos),
            Divider(),
            _itemTexto('Notas Adicionales:', estiloTitulos),
            _itemTexto('${_examenFisico.notas}', estiloTitulos),
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
            'Examen Físico',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'examenfisicoportada',
            child: FaIcon(
              FontAwesomeIcons.diagnoses,
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
