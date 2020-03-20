import 'package:flutter/material.dart';

class ErrorPageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('404 Page'),
      ),
      body: Center(
        child: Text('Error 404 pagina no encontrada'),
      ),
    );
  }
}
