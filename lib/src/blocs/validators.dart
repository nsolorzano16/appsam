import 'dart:async';

class Validators {
  // es donde van los stream transformers

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Mas de 6 caracteres');
    }
  });

  final validarIdentificacion = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 13) {
      sink.add(password);
    } else {
      sink.addError('Complete información');
    }
  });

  final validarCampoTexto =
      StreamTransformer<String, String>.fromHandlers(handleData: (campo, sink) {
    if (campo.length >= 3) {
      sink.add(campo);
    } else {
      sink.addError('Este campo es obligatorio');
    }
  });

  final validarUsuario = StreamTransformer<String, String>.fromHandlers(
      handleData: (usuario, sink) {
    if (usuario.length > 3) {
      sink.add(usuario);
    } else {
      sink.addError('Mas de 3 caracteres en este campo');
    }
  });

  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email no es correcto');
    }
  });
}
