import 'package:flutter/material.dart';

import 'package:appsam/src/utils/storage_util.dart';
import 'package:appsam/src/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    StorageUtil.putString('ultimaPagina', HomePage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Text(StorageUtil.getString('usuarioGlobal')),
      ),
    );
  }
}
