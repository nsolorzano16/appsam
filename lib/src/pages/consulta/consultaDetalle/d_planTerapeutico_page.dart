import 'package:appsam/src/models/planTerapeutico_viewmodel.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getflutter/getflutter.dart';

class DetPlanTerapeutico extends StatelessWidget {
  final List<PlanTerapeuticoViewModel> _plan;

  const DetPlanTerapeutico({@required plan}) : _plan = plan;

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
      backgroundColor: colorFondoApp(),
      body: ListView(
        children: _cardItem(size, _plan, estiloTitulos, estiloItems),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop()),
    );
  }

  List<Widget> _cardItem(Size size, List<PlanTerapeuticoViewModel> listaPlanes,
      TextStyle estiloTitulos, TextStyle estiloItems) {
    final List<Widget> lista = new List();
    final stack = _appBar(size);
    lista.add(stack);
    listaPlanes.forEach((element) {
      final itemTemp = GFCard(
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemTexto('Nombre medicamento:', estiloItems),
            _itemTexto('${element.nombreMedicamento}', estiloItems),
            Divider(),
            _itemTexto('Dosis:', estiloItems),
            _itemTexto('${element.dosis}', estiloItems),
            Divider(),
            _itemTexto('Horario:', estiloItems),
            _itemTexto('${element.horario}', estiloItems),
            Divider(),
            _itemTexto('Dias requeridos:', estiloItems),
            _itemTexto('${element.diasRequeridos}', estiloItems),
            Divider(),
            _itemTexto('Via administración:', estiloItems),
            _itemTexto('${element.viaAdministracion}', estiloItems),
            Divider(),
            _itemTexto('Permanente:', estiloItems),
            _itemBoolean(element.permanente),
            Divider(),
            _itemTexto('Notas:', estiloItems),
            _itemTexto('${element.notas}', estiloItems),
            Divider(),
          ],
        ),
      );
      lista.add(itemTemp);
    });

    return lista;
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
            'Plan Terapeutico',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          trailing: Hero(
            tag: 'planterapeuticoportada',
            child: FaIcon(
              FontAwesomeIcons.stickyNote,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBoolean(bool value) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      margin: EdgeInsets.all(5),
      child: (value)
          ? Icon(
              Icons.check,
              color: Colors.green,
            )
          : Icon(
              Icons.close,
              color: Colors.red,
            ),
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
}
