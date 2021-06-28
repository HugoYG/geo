import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:geo/src/blocs/auth_bloc.dart';
import 'package:geo/src/prefs/settings.dart';
import 'package:geo/src/provider/actions_provider.dart';
import 'package:geo/src/models/user_model.dart';

import 'package:geo/src/pages/login_page.dart';
import 'package:geo/src/pages/home_page.dart';

class ValidateUserPage extends StatelessWidget {
  static final String routeName = 'validate_user';
  final prefs = new PreferenciasUsuario();
  final actions = new ActionProvider();

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    prefs.ultimaPagina = ValidateUserPage.routeName;

    return Scaffold(
      body: FutureBuilder(
        future: actions.validarUsuario(prefs.userEmail.toString()),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.hasData) {
            final usuarios = snapshot.data;

            if (usuarios.length == 0) {
              return _accesoDenegado(context, authBloc);
            } else {
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, i) =>
                    _accesoPermitido(context, usuarios[i]),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  _accesoPermitido(BuildContext context, UserModel usuario) {
    prefs.idUser = usuario.id;
    //return Navigator.pushReplacementNamed(context, HomePage.routeName);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 180.0),
      child: Column(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(prefs.photoUrl),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Center(
            child: Text(
              'Bienvenido ${prefs.displayName}',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
            child: Text(
              'Continuar',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accesoDenegado(BuildContext context, authBloc) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 180.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.highlight_off_sharp,
            size: 150.0,
            color: Colors.red,
          ),
          Center(
            child: Text(
              'Acceso Denegado',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
            ),
            onPressed: () {
              authBloc.logout().whenComplete(() {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              });
            },
            child: Text(
              'Salir',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
