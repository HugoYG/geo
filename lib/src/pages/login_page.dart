import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:geo/src/blocs/auth_bloc.dart';
import 'package:geo/src/prefs/settings.dart';

import 'package:geo/src/pages/validate_user_page.dart';

class LoginPage extends StatefulWidget {
  static final String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    prefs.ultimaPagina = LoginPage.routeName;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginBoton(context, authBloc),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color>[
          Color.fromRGBO(255, 0, 0, 1.0),
          Color.fromRGBO(255, 0, 0, 1.0),
        ]),
      ),
    );

    return Stack(
      children: <Widget>[
        fondo,
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: Image(
                  width: 100.0,
                  image: AssetImage('assets/img/logo.jpg'),
                ),
              ),
              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),
              Text(
                'ComredIT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loginBoton(BuildContext context, authBloc) {
    //final size = MediaQuery.of(context).size;

    return Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80.0),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                side: BorderSide(width: 1, color: Colors.grey),
              ),
              onPressed: () {
                authBloc.loginGoogle().whenComplete(() {
                  Navigator.pushReplacementNamed(
                      context, ValidateUserPage.routeName);
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/img/google_logo.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Inicia sesión con Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
