import 'package:appsam/src/blocs/notifications_bloc/messageStream.dart';
import 'package:appsam/src/utils/utils.dart';
import 'package:flutter/material.dart';

class FirebaseMessageWrapper extends StatefulWidget {
  final Widget child;

  const FirebaseMessageWrapper({this.child});

  @override
  _FirebaseMessageWrapperState createState() => _FirebaseMessageWrapperState();
}

class _FirebaseMessageWrapperState extends State<FirebaseMessageWrapper> {
  MessageStream _messageStream = MessageStream.instance;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: null,
        stream: _messageStream.messageStream,
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          Map<String, dynamic> msg = snapshot.data;
          if (msg != null) {
            // check if this instance is the current route or else message will be displayed on all instances
            if (ModalRoute.of(context).isCurrent) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => _showMessage(msg, context));
            }
            // adding a null stops the previous message from being displayed again
            MessageStream.instance.addMessage(null);
          }
          return widget.child;
        });
  }

  void _showMessage(Map<String, dynamic> message, BuildContext context) {
    final title = message['notification']["title"];
    final mensaje = message['notification']["body"];

    mostrarFlushBar(
        context, Colors.black, title, mensaje, 3, Icons.info, Colors.white);
  }
}