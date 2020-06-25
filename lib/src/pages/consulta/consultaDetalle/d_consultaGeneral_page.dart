import 'package:appsam/src/models/consultaGeneral_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';

class DetConsultaGeneralPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final ConsultaGeneralModel _consulta;

  const DetConsultaGeneralPage({@required preclinica, @required consulta})
      : _preclinica = preclinica,
        _consulta = consulta;

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
          backgroundColor: Color.fromRGBO(163, 133, 96, 1),
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
        color: Color.fromRGBO(242, 232, 109, 1),
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
            'Consulta General',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(163, 133, 96, 1),
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
              color: Color.fromRGBO(163, 133, 96, 1),
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
          tag: 'consultageneralportada',
          child: SvgPicture.asset(
            'assets/svg/consultageneral.svg',
          ),
        )),
  );
}
