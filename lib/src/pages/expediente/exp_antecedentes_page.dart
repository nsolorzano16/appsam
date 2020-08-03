import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';

import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class ExpAntecedentes extends StatelessWidget {
  final AntecedentesFamiliaresPersonales _antecedentes;

  const ExpAntecedentes({@required antecedentes})
      : _antecedentes = antecedentes;

  @override
  Widget build(BuildContext context) {
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
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
              estiloTitulos),
        ],
      ),
    );
  }

  GFCard _cardItem(String titulo, String descripcion, TextStyle estiloTitulos) {
    return GFCard(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: GFListTile(
        title: Padding(
          padding: EdgeInsets.all(3),
          child: Text(
            titulo,
            style: estiloTitulos,
          ),
        ),
        subTitle: Text(
          descripcion,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
