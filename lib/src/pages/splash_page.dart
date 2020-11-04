import 'package:appsam/src/pages/home_page.dart';
import 'package:appsam/src/pages/login_page.dart';
import 'package:appsam/src/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isExpired = false;

  @override
  void initState() {
    super.initState();
    final String token = StorageUtil.getString('token');
    if (token.isNotEmpty) {
      isExpired = JwtDecoder.isExpired(token);
      if (isExpired) {
        Future.delayed(const Duration(seconds: 2)).then(
          (_) => Navigator.pushReplacementNamed(context, LoginPage.routeName),
        );
      } else {
        Future.delayed(const Duration(seconds: 2)).then(
          (_) => Navigator.pushReplacementNamed(context, HomePage.routeName),
        );
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then(
        (_) => Navigator.pushReplacementNamed(context, LoginPage.routeName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Image(
                  width: 250,
                  image: AssetImage('assets/samlogo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: LinearProgressIndicator(),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
