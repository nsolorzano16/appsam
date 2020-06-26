import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetExamenFisicoPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final ExamenFisico _examenFisico;

  const DetExamenFisicoPage({@required preclinica, @required examenFisico})
      : _preclinica = preclinica,
        _examenFisico = examenFisico;

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
                  _itemTexto('Aspecto General:', estiloTitulos),
                  _itemTexto('${_examenFisico.aspectoGeneral}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Piel y Faneras:', estiloTitulos),
                  _itemTexto('${_examenFisico.pielFaneras}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Cabeza:', estiloTitulos),
                  _itemTexto('${_examenFisico.cabeza}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Oidos:', estiloTitulos),
                  _itemTexto('${_examenFisico.oidos}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Ojos:', estiloTitulos),
                  _itemTexto('${_examenFisico.ojos}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Nariz:', estiloTitulos),
                  _itemTexto('${_examenFisico.nariz}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Boca:', estiloTitulos),
                  _itemTexto('${_examenFisico.boca}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Cuello:', estiloTitulos),
                  _itemTexto('${_examenFisico.cuello}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Torax:', estiloTitulos),
                  _itemTexto('${_examenFisico.torax}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Abdomen:', estiloTitulos),
                  _itemTexto('${_examenFisico.abdomen}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Columna Vertebral Region Lumbar:', estiloTitulos),
                  _itemTexto('${_examenFisico.columnaVertebralRegionLumbar}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto(
                      'Miembros Superiores e Inferiores:', estiloTitulos),
                  _itemTexto('${_examenFisico.miembrosInferioresSuperiores}',
                      estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Genitales:', estiloTitulos),
                  _itemTexto('${_examenFisico.genitales}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Neurológico:', estiloTitulos),
                  _itemTexto('${_examenFisico.neurologico}', estiloTitulos),
                ]),
                TableRow(children: [
                  _itemTexto('Notas Adicionales:', estiloTitulos),
                  _itemTexto('${_examenFisico.notas}', estiloTitulos),
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
            'Examen Fisico',
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
          tag: 'examenfisicoportada',
          child: FaIcon(
            FontAwesomeIcons.diagnoses,
            size: 120,
            color: Colors.white,
          ),
        )),
  );
}
