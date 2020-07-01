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
            _appBar(size),
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

  Container _appBar(Size size) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: size.height * 0.2,
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ListTile(
          title: Text(
            'Consulta General',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'consultageneralportada',
            child: FaIcon(
              FontAwesomeIcons.briefcaseMedical,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
}
