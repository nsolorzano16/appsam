import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetalleAntecedentesConsultaPage extends StatelessWidget {
  final AntecedentesFamiliaresPersonales _antecedentes;

  const DetalleAntecedentesConsultaPage({@required antecedentes})
      : _antecedentes = antecedentes;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: colorFondoApp(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _appBar(size),
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
            _cardItem(
                'Antecedentes Inmuno Alérgicos',
                '${_antecedentes.antecedentesInmunoAlergicosPersonales}',
                estiloTitulos)
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
        title: Text(
          titulo,
          style: estiloTitulos,
        ),
        subTitle: Text(
          descripcion,
          textAlign: TextAlign.justify,
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
            'Antecedentes Personales',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'antecedentesPortada',
            child: FaIcon(
              FontAwesomeIcons.heartbeat,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
