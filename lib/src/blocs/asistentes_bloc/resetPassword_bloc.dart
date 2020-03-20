import 'dart:async';
//import 'package:movilsam/src/providers/usuario_provider.dart';
import 'package:appsam/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ResetPasswordBloc with Validators {
  //final _usuarioService = new UsuarioProvider();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordConfirmController =
      BehaviorSubject<String>();

  //
  //  Inputs
  //
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Function(String) get onRetypePasswordChanged =>
      _passwordConfirmController.sink.add;

  //
  // Validators
  //
  Stream<String> get password =>
      _passwordController.stream.transform(validarPassword);
  Stream<String> get confirmPassword => _passwordConfirmController.stream
          .transform(validarPassword)
          .doOnData((String c) {
        // If the password is accepted (after validation of the rules)
        // we need to ensure both password and retyped password match
        if (0 != _passwordController.value.compareTo(c)) {
          // If they do not match, add an error
          _passwordConfirmController.addError("Contraseñas no coinciden");
        }
      });

  Stream<bool> get registerValue =>
      CombineLatestStream.combine2(password, confirmPassword, (p, c) => true);

//
  // Registration button
  //
  // ValidateAllStreamsHaveDataAndNoErrors _validateAllStreamsHaveDataAndNoErrors;
  // Stream<bool> get registerValue =>
  //     _validateAllStreamsHaveDataAndNoErrors?.status;

  //
  // Initialization
  //
  // void init() {
  //   _validateAllStreamsHaveDataAndNoErrors =
  //       ValidateAllStreamsHaveDataAndNoErrors()
  //         ..listen([
  //           password,
  //           confirmPassword,
  //         ]);
  String get confirmPassValue => _passwordConfirmController.value;
  // }

  void dispose() {
    _passwordController?.close();
    _passwordConfirmController?.close();
  }
}

class ValidateAllStreamsHaveDataAndNoErrors {
  //
  // Array the memorizes the validation "result" of each stream
  //
  List<bool> errors;

  //
  // Stream which emits the actual validation result, combining
  // all the streams involved in the validation
  //
  StreamController<bool> _controller;

  //
  // Method which initializes the validation
  //
  void listen(List<Stream> streams) {
    //
    //  Initialization of the internal Stream controller
    //
    _controller = StreamController<bool>.broadcast();

    //
    // Initialization of the array that memorizes the errors
    //
    errors = List.generate(streams.length, (_) => true);

    //
    // For each of the streams to be considered, listen
    // to the type of information they are going to emit
    //
    List.generate(streams.length, (int index) {
      return streams[index].listen(
        (data) {
          // Data was emitted => this is not an error
          errors[index] = false;
          print(errors[index]);
          _validate();
        },
        onError: (_) {
          // Error was emitted
          errors[index] = true;
          _validate();
        },
      );
    });
  }

  //
  // Routine which simply checks whether there is still at least one
  // stream which does not satisfy the validation
  // Depending on this check, emits a positive or negative validation outcome
  //
  void _validate() {
    bool hasNoErrors =
        (errors.firstWhere((b) => b == true, orElse: () => null) == null);
    _controller.sink.add(hasNoErrors);
  }

  //
  // Public outcome of the validation
  //
  Stream<bool> get status => _controller.stream;

  void dispose() {
    _controller?.close();
  }
}
