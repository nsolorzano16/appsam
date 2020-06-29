import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetConsultaGeneralPage extends StatelessWidget {
  final ConsultaGeneralModel _consulta;

  const DetConsultaGeneralPage({@required consulta}) : _consulta = consulta;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
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
            _cardItem('Motivo Consulta', '${_consulta.motivoConsulta}',
                estiloTitulos),
            _cardItem('Historia de la enfermedad actual', '${_consulta.hea}',
                estiloTitulos),
            _cardItem('Funciones Orgánicas Generales', '${_consulta.fog}',
                estiloTitulos),
            _cardItem('Notas Adicionales', '${_consulta.notas}', estiloTitulos),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  GFCard _cardItem(String titulo, String descripcion, TextStyle estiloTitulos) {
    return GFCard(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: GFListTile(
          title: Padding(
            padding: EdgeInsets.all(3),
            child: Text(
              titulo,
              style: estiloTitulos,
            ),
          ),
          subtitleText: descripcion),
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
}

Widget _imagenPortada(Size size) {
  return Positioned(
    top: size.height * 0.1,
    left: size.width * 0.6,
    child: Container(
        height: 130,
        width: 130,
        child: Hero(
          tag: 'consultageneralportada',
          child: FaIcon(
            FontAwesomeIcons.briefcaseMedical,
            size: 120,
            color: Colors.white,
          ),
        )),
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
          'Consulta General',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    ),
  );
}
