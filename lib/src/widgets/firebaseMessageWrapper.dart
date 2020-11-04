import 'package:flutter/material.dart';

class FirebaseMessageWrapper extends StatefulWidget {
  final Widget child;

  const FirebaseMessageWrapper({this.child});

  @override
  _FirebaseMessageWrapperState createState() => _FirebaseMessageWrapperState();
}

class _FirebaseMessageWrapperState extends State<FirebaseMessageWrapper> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
