import 'package:appsam/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class ErrorPageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('404 Page'),
        ),
        drawer: MenuWidget(),
        body: Center(
          child: Text('Error 404 pagina no encontrada'),
        ),
      ),
    );
  }
}
