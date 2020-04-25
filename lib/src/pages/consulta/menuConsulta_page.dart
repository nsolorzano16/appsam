import 'dart:convert';
import 'package:appsam/src/models/antecedentesFamiliaresPersonales_model.dart';
import 'package:appsam/src/models/consulta_model.dart';
import 'package:appsam/src/models/diagnosticos_model.dart';
import 'package:appsam/src/models/examenFisicoGinecologico_model.dart';
import 'package:appsam/src/models/examenFisico_model.dart';
import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/habitos_model.dart';
import 'package:appsam/src/models/historialGinecoObstetra_model.dart';
import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:appsam/src/pages/consulta/consulta_detalle_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class MenuConsultaPage extends StatelessWidget {
  static final String routeName = 'menu_consulta';

  final PreclinicaViewModel preclinica;

  const MenuConsultaPage({Key key, this.preclinica}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<FarmacosUsoActual> _listaFarmacos = new List();
    final List<Diagnosticos> _listaDiagnosticos = new List();
    final List<Notas> _listaNotas = new List();

    final AntecedentesFamiliaresPersonales _antecedentes =
        (StorageUtil.getString('antecedentes').isEmpty)
            ? null
            : antecedentesFamiliaresPersonalesFromJson(
                StorageUtil.getString('antecedentes'));

    final Habitos _habitos = (StorageUtil.getString('habitos').isEmpty)
        ? null
        : habitosFromJson(StorageUtil.getString('habitos'));

    final HistorialGinecoObstetra _historialObstetra =
        (StorageUtil.getString('historialObstetra').isEmpty)
            ? null
            : historialGinecoObstetraFromJson(
                StorageUtil.getString('historialObstetra'));

    if ((StorageUtil.getString('farmacos').isNotEmpty)) {
      final decodeResp = jsonDecode(StorageUtil.getString('farmacos'));
      decodeResp.forEach((f) {
        final farmacoTemp = FarmacosUsoActual.fromJson(f);
        _listaFarmacos.add(farmacoTemp);
      });
    }

    final ExamenFisico _examenFisico =
        (StorageUtil.getString('examenFisico').isEmpty)
            ? null
            : examenFisicoFromJson(StorageUtil.getString('examenFisico'));

    final ExamenFisicoGinecologico _examenGinecologico =
        (StorageUtil.getString('examenGinecologico').isEmpty)
            ? null
            : examenFisicoGinecologicoFromJson(
                StorageUtil.getString('examenGinecologico'));

    if (StorageUtil.getString('diagnosticos').isNotEmpty) {
      final decodeDiagnosticos =
          jsonDecode(StorageUtil.getString('diagnosticos'));
      decodeDiagnosticos.forEach((d) {
        final diagnosticoTemp = Diagnosticos.fromJson(d);
        _listaDiagnosticos.add(diagnosticoTemp);
      });
    }

    if (StorageUtil.getString('notas').isNotEmpty) {
      final decodeNotas = jsonDecode(StorageUtil.getString('notas'));
      decodeNotas.forEach((n) {
        final notaTemp = Notas.fromJson(n);
        _listaNotas.add(notaTemp);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Consulta'),
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Table(
              children: [
                TableRow(children: [
                  (_antecedentes == null)
                      ? _cardItem(
                          this.preclinica,
                          FontAwesomeIcons.heartbeat,
                          'Antecedentes Personales',
                          'crear_antecedentes',
                          Colors.blue,
                          context)
                      : _cardItemFake(FontAwesomeIcons.heartbeat,
                          'Antecedentes Personales', Colors.grey),
                  (_habitos == null)
                      ? _cardItem(this.preclinica, FontAwesomeIcons.coffee,
                          'Habitos', 'crear_habitos', Colors.green, context)
                      : _cardItemFake(
                          FontAwesomeIcons.coffee, 'Habitos', Colors.grey)
                ]),
                TableRow(children: [
                  (_historialObstetra == null)
                      ? _cardItem(
                          this.preclinica,
                          FontAwesomeIcons.baby,
                          'Historial Gineco Obstetra',
                          'crear_historial_gineco',
                          Colors.blueGrey,
                          context)
                      : _cardItemFake(FontAwesomeIcons.baby,
                          'Historial Gineco Obstetra', Colors.grey),
                  _cardItem(
                      this.preclinica,
                      Icons.people,
                      'Farmacos de uso Actual',
                      'crear_historial',
                      Colors.orange,
                      context)
                ]),
                TableRow(children: [
                  _cardItem(
                      this.preclinica,
                      FontAwesomeIcons.child,
                      'Examen Físico',
                      'crear_historial',
                      Colors.brown,
                      context),
                  _cardItem(
                      this.preclinica,
                      FontAwesomeIcons.female,
                      'Examen Físico Ginecológico',
                      'crear_historial',
                      Colors.purple,
                      context)
                ]),
                TableRow(children: [
                  _cardItem(this.preclinica, Icons.note, 'Diagnosticos',
                      'crear_historial', Colors.pink, context),
                  _cardItem(this.preclinica, Icons.note_add, 'Notas',
                      'crear_historial', Colors.grey, context)
                ]),
                TableRow(children: [
                  _cardItemConsultaDetalle(
                      this.preclinica,
                      _antecedentes,
                      _habitos,
                      _historialObstetra,
                      _listaFarmacos,
                      _examenFisico,
                      _examenGinecologico,
                      _listaDiagnosticos,
                      _listaNotas,
                      FontAwesomeIcons.userMd,
                      'Resumen Consulta',
                      'crear_historial',
                      Colors.pink,
                      context),
                  _cardItem(this.preclinica, FontAwesomeIcons.book, 'Receta',
                      'crear_historial', Colors.lime, context)
                ]),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cardItem(PreclinicaViewModel preclinica, IconData icon, String texto,
      String ruta, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ruta, arguments: preclinica);
      },
      child: GFCard(
        elevation: 3.0,
        height: 110.0,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: color,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardItemFake(IconData icon, String texto, Color color) {
    return GFCard(
      elevation: 3.0,
      height: 110.0,
      content: Column(
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //     shape: BoxShape.circle, color: Colors.red),
            margin: EdgeInsets.only(top: 5.0),
            child: FaIcon(
              icon,
              size: 40.0,
              color: color,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 6.0),
            child: Text(
              texto,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontSize: 15.0),
            ),
          )
        ],
      ),
    );
  }

  Widget _cardItemConsultaDetalle(
    PreclinicaViewModel preclinica,
    AntecedentesFamiliaresPersonales antecedentes,
    Habitos habitos,
    HistorialGinecoObstetra historial,
    List<FarmacosUsoActual> listaFarmacos,
    ExamenFisico examenFisico,
    ExamenFisicoGinecologico examenGinecologico,
    List<Diagnosticos> listaDiagnosticos,
    List<Notas> listaNotas,
    IconData icon,
    String texto,
    String ruta,
    Color color,
    BuildContext context,
  ) {
    final detalleConsulta = new ConsultaModel();
    detalleConsulta.antecedentesFamiliaresPersonales = antecedentes;
    detalleConsulta.habitos = habitos;
    detalleConsulta.historialGinecoObstetra = historial;
    detalleConsulta.farmacosUsoActual = listaFarmacos;
    detalleConsulta.examenFisico = examenFisico;
    detalleConsulta.examenFisicoGinecologico = examenGinecologico;
    detalleConsulta.diagnosticos = listaDiagnosticos;
    detalleConsulta.notas = listaNotas;

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ConsultaDetallePage(
                    preclinica: preclinica, consulta: detalleConsulta)));
      },
      child: GFCard(
        elevation: 3.0,
        height: 110.0,
        content: Column(
          children: <Widget>[
            Container(
              // decoration: BoxDecoration(
              //     shape: BoxShape.circle, color: Colors.red),
              margin: EdgeInsets.only(top: 5.0),
              child: FaIcon(
                icon,
                size: 40.0,
                color: color,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6.0),
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontSize: 15.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
