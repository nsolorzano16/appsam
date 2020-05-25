import 'package:appsam/src/providers/FirebaseNotificationService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:appsam/src/blocs/provider.dart';
import 'package:appsam/src/blocs/theme_bloc.dart';
import 'package:appsam/src/pages/error404_page.dart';
import 'package:appsam/src/routes/routes.dart';
import 'package:appsam/src/utils/storage_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageUtil.getInstance();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.red,
  ));
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
    super.initState();
    FirebaseNotificationService.instance;
  }

  @override
  Widget build(BuildContext context) {
    bool activado = StorageUtil.getBool('temaDark');
    return Provider(
      child: StreamBuilder(
        initialData: activado,
        stream: bloc.darkThemeIsEnabled,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return MaterialApp(
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
              title: 'Material App',
              initialRoute: 'login',
              routes: getApplicationRoutes(bloc),
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute(
                    builder: (context) => ErrorPageNotFound());
              },
              theme: snapshot.data
                  ? ThemeData.dark()
                  : ThemeData(
                      primaryColor: Colors.red,
                    ));
        },
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
  String get searchFieldLabel => "My hint text";
}
