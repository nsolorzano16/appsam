import 'package:flutter/material.dart';

import 'package:appsam/src/pages/asistentes/tab_formeditar.dart';
import 'package:appsam/src/utils/storage_util.dart';

class EditarAsistentesPage extends StatefulWidget {
  static final String routeName = 'editar-asistente';
  @override
  _EditarAsistentesPageState createState() => _EditarAsistentesPageState();
}

class _EditarAsistentesPageState extends State<EditarAsistentesPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', EditarAsistentesPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Asistente'),
      ),
      body: SingleChildScrollView(
          child: (_currentIndex == 0) ? FormEditarPage() : Container()),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
