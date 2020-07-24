import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:appsam/src/widgets/drawer.dart';
import 'package:appsam/src/widgets/firebaseMessageWrapper.dart';

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
    return WillPopScope(
        child: FirebaseMessageWrapper(
          child: Scaffold(
            backgroundColor: colorFondoApp(),
            appBar: AppBar(
              title: Text('Editar Asistente'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, 'asistentes'))
              ],
            ),
            drawer: MenuWidget(),
            body: SingleChildScrollView(
                child: (_currentIndex == 0) ? FormEditarPage() : Container()),
          ),
        ),
        onWillPop: () async => false);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
