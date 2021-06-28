import 'package:flutter/material.dart';

import 'package:geo/src/prefs/settings.dart';
import 'package:geo/src/provider/actions_provider.dart';
import 'package:geo/src/services/geolocator_service.dart';
import 'package:geo/src/models/location_model.dart';
import 'package:geo/src/models/check_model.dart';

import 'package:geo/src/widgets/menu_widget.dart';

class CheckoutPage extends StatefulWidget {
  static final String routeName = 'checkout';

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final prefs = new PreferenciasUsuario();
  var currentLocation;
  final actions = new ActionProvider();
  bool search = true;

  CheckModel checkout = new CheckModel();

  List<LocationModel> listaUbicaciones = [];

  @override
  void initState() {
    super.initState();
    Future position = determinePosition();
    Future ubicaciones = actions.listaCheckin(prefs.idUser.toString());

    position.then((value) {
      setState(() {
        currentLocation = value;
      });
    });

    ubicaciones.then((value) {
      setState(() {
        listaUbicaciones = value;
        search = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = CheckoutPage.routeName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Check-out'),
      ),
      drawer: MenuWidget(),
      body: (listaUbicaciones.isEmpty)
          ? Center(
              child: (search == true)
                  ? CircularProgressIndicator()
                  : Column(
                      children: [
                        SizedBox(
                          height: 150.0,
                        ),
                        Icon(
                          Icons.location_pin,
                          color: Colors.grey,
                          size: 80.0,
                        ),
                        Text(
                          "No hay registros.",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
            )
          : ListView.builder(
              itemCount: listaUbicaciones.length,
              itemBuilder: (_, i) => Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.green,
                ),
                onDismissed: (DismissDirection direction) async {
                  _modalCarga();
                  await _submit(listaUbicaciones[i].id);
                },
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.location_pin,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(listaUbicaciones[i].ubicacion),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
    );
  }

  _modalCarga() {
    return showDialog(
        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0.0,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        });
  }

  _submit(String idCheck) {
    checkout.client = idCheck;
    checkout.user = prefs.idUser;
    checkout.coordinates =
        "${currentLocation.latitude},${currentLocation.longitude}";

    Future send = actions.sendCheckout(checkout);

    send.then((value) {
      Navigator.pop(context);
      if (value == true) {
        String titulo = "Correcto!";
        String mensaje = "Se realizo checkout correctamente.";

        _mostrarAlerta(value, titulo, mensaje);
      } else {
        String titulo = "Error!";
        String mensaje = "No se pudo realizar el checkout.";

        _mostrarAlerta(value, titulo, mensaje);
      }
    });
  }

  void _mostrarAlerta(bool value, String titulo, String mensaje) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 800, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: AlertDialog(
              title: Text(
                titulo,
                style: TextStyle(
                  color: (value == true) ? Colors.green : Colors.red,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(mensaje),
                ],
              ),
              elevation: 24.0,
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 1000),
      barrierDismissible: false,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return;
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
