import 'package:appsam/src/models/notas_model.dart';
import 'package:appsam/src/models/paginados/preclinica_paginadoVM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getflutter/getflutter.dart';

class DetNotasPage extends StatelessWidget {
  final PreclinicaViewModel _preclinica;
  final List<Notas> _notas;

  const DetNotasPage({@required preclinica, @required notas})
      : _preclinica = preclinica,
        _notas = notas;

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
      body: ListView(
        children: _cardItem(size, _notas, estiloTitulos),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(219, 84, 97, 1),
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(
      Size size, List<Notas> listaNotas, TextStyle estiloTitulos) {
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
    listaNotas.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: GFListTile(
            title: Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                'Notas',
                style: estiloTitulos,
              ),
            ),
            subtitleText: element.notas),
      );
      lista.add(itemTemp);
    });

    return lista;
  }

  Widget _backCover(Size size) {
    return Container(
      height: size.height * 0.30,
      decoration: BoxDecoration(
        color: Color.fromRGBO(219, 84, 97, 1),
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
            'Notas',
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
          tag: 'notasportada',
          child: SvgPicture.asset(
            'assets/svg/notas.svg',
          ),
        )),
  );
}
