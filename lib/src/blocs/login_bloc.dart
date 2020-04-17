import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:appsam/src/blocs/validators.dart';

class LoginBloc with Validators {
  // final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usuarioController = BehaviorSubject<String>();

  // recuperan datos del stream
  // Stream<String> get emailStream =>
  //     _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get usuarioStream =>
      _usuarioController.stream.transform(validarUsuario);

  Stream<bool> get formValidStream => CombineLatestStream.combine2(
      passwordStream, usuarioStream, (e, p) => true);
// agregar valorea al stream
  // Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeUsuario => _usuarioController.sink.add;

  dispose() {
    // _emailController?.close();
    _passwordController?.close();
    _usuarioController?.close();
  }

  // obtener el ultimo valor ingresado a los streams
  // String get emai => _emailController.value;
  String get password => _passwordController.value;
  String get usuario => _usuarioController.value;
}
