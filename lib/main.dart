import 'package:appsam/src/providers/FirebaseNotificationService.dart';
import 'package:appsam/src/providers/webNotifications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/pages/error404_page.dart';
import 'package:appsam/src/routes/routes.dart';
import 'package:appsam/src/utils/storage_util.dart';

//COOMENTS DSAM

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color.fromRGBO(17, 29, 74, 1),
      statusBarBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
  //
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bloc = new ThemeBloc();

  @override
  void initState() {
    FirebaseNotificationService.instance;
    WebNotificationService.instance;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          CustomLocalizationDelegate(),
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('es', 'ES'),
        ],
        title: 'SAM',
        initialRoute: 'login',
        routes: getApplicationRoutes(bloc),
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (context) => ErrorPageNotFound());
        },
        theme: ThemeData(
            primaryColor: Colors.red,
            brightness: Brightness.light,
            primarySwatch: Colors.red),
      ),
    );
  }
}

class CustomLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'es';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(const CustomLocalization());

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;

  @override
  String toString() => 'CustomLocalization.delegate(es_ES)';
}

class CustomLocalization extends DefaultMaterialLocalizations {
  const CustomLocalization();

  @override
  String get searchFieldLabel => 'Buscar...';
}
