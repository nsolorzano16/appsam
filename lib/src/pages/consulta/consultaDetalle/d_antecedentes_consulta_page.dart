import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetalleAntecedentesConsultaPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final AntecedentesFamiliaresPersonales _antecedentes;

  const DetalleAntecedentesConsultaPage(
      {@required preclinica, @required antecedentes})
      : _preclinica = preclinica,
        _antecedentes = antecedentes;

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
            _cardItem(
                'Antecedentes Patológicos Familiares',
                '${_antecedentes.antecedentesPatologicosFamiliares}',
                estiloTitulos),
            _cardItem(
                'Antecedentes Patológicos Personales',
                '${_antecedentes.antecedentesPatologicosPersonales}',
                estiloTitulos),
            _cardItem(
                'Antecedentes No Patológicos Familiares',
                '${_antecedentes.antecedentesNoPatologicosFamiliares}',
                estiloTitulos),
            _cardItem(
                'Antecedentes No Patológicos Personales',
                '${_antecedentes.antecedentesNoPatologicosPersonales}',
                estiloTitulos),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
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

  Widget _titleText(Size size) {
    return Positioned(
      left: 20,
      bottom: size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Antecedentes Personales',
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
          tag: 'antecedentesPortada',
          child: FaIcon(
            FontAwesomeIcons.heartbeat,
            size: 120,
            color: Colors.white,
          ),
        )),
  );
}
