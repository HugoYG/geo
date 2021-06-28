import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:geo/src/pages/login_page.dart';
import 'package:geo/src/pages/validate_user_page.dart';
import 'package:geo/src/pages/home_page.dart';
import 'package:geo/src/pages/checkin_page.dart';
import 'package:geo/src/pages/checkout_page.dart';

import 'package:geo/src/blocs/auth_bloc.dart';
import 'package:geo/src/prefs/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Geo ComredIT',
        initialRoute: prefs.ultimaPagina,
        routes: {
          LoginPage.routeName: (BuildContext context) => LoginPage(),
          ValidateUserPage.routeName: (BuildContext context) =>
              ValidateUserPage(),
          HomePage.routeName: (BuildContext context) => HomePage(),
          CheckinPage.routeName: (BuildContext context) => CheckinPage(),
          CheckoutPage.routeName: (BuildContext context) => CheckoutPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.red,
        ),
      ),
    );
  }
}
