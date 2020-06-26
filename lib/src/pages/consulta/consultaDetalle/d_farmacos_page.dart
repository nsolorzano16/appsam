import 'package:appsam/src/models/farmacosUsoActual_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetFarmacosPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final List<FarmacosUsoActual> _farmacos;

  const DetFarmacosPage({@required preclinica, @required farmacos})
      : _preclinica = preclinica,
        _farmacos = farmacos;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final estiloTitulos = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    final estiloItems = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 244, 233, 1),
      body: ListView(
        children: _cardItem(size, _farmacos, estiloTitulos, estiloItems),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size, List<FarmacosUsoActual> listaFarmacos,
      TextStyle estiloTitulos, TextStyle estiloItems) {
    final List<Widget> lista = new List();
    final stack = Stack(
      alignment: AlignmentDirectional.topCenter,
      overflow: Overflow.visible,
      children: <Widget>[
        _backCover(size),
        _titleText(size),
        _imagenPortada(size),
      ],
    );
    lista.add(stack);
    listaFarmacos.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Column(
          children: <Widget>[
            Table(
              children: [
                TableRow(children: [
                  _itemTexto('Nombre:', estiloItems),
                  _itemTexto('${element.nombre}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Concentración:', estiloItems),
                  _itemTexto('${element.concentracion}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Dosis:', estiloItems),
                  _itemTexto('${element.dosis}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Tiempo:', estiloItems),
                  _itemTexto('${element.tiempo}', estiloItems),
                ]),
                TableRow(children: [
                  _itemTexto('Notas adicionales:', estiloItems),
                  _itemTexto('${element.notas}', estiloItems),
                ])
              ],
            )
          ],
        ),
      );
      lista.add(itemTemp);
    });

    return lista;
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
            'Farmacos',
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
          tag: 'farmacosportada',
          child: FaIcon(
            FontAwesomeIcons.capsules,
            size: 120,
            color: Colors.white,
          ),
        )),
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
