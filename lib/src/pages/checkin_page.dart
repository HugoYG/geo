import 'package:flutter/material.dart';

import 'package:geo/src/prefs/settings.dart';
import 'package:geo/src/services/geolocator_service.dart';
import 'package:geo/src/provider/actions_provider.dart';
import 'package:geo/src/models/location_model.dart';
import 'package:geo/src/models/check_model.dart';

import 'package:geo/src/widgets/menu_widget.dart';

class CheckinPage extends StatefulWidget {
  static final String routeName = 'checkin';

  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  final prefs = new PreferenciasUsuario();
  var currentLocation;
  final formKey = GlobalKey<FormState>();
  final actions = new ActionProvider();

  CheckModel checkin = new CheckModel();

  String _opcionSeleccionada = '1';
  List<LocationModel> listaUbicaciones = [];

  @override
  void initState() {
    super.initState();
    Future position = determinePosition();
    Future ubicaciones = actions.listaUbicaciones();

    position.then((value) {
      setState(() {
        currentLocation = value;
      });
    });

    ubicaciones.then((value) {
      setState(() {
        listaUbicaciones = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    prefs.ultimaPagina = CheckinPage.routeName;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-in'),
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
          padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 10.0),
          child: Form(
              key: formKey,
              child: (listaUbicaciones.isEmpty)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: <Widget>[
                        _selectUbicaciones(size),
                        SizedBox(
                          height: 50.0,
                        ),
                        _crearBoton(),
                      ],
                    )),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getListaUbicaciones(size) {
    List<DropdownMenuItem<String>> lista = [];

    listaUbicaciones.forEach((ubicacion) {
      lista.add(DropdownMenuItem(
        child: FittedBox(
          child: Container(
            width: size.width * 0.65,
            child: Column(
              children: <Widget>[
                Text(
                  ubicacion.ubicacion,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                ),
                Divider(),
              ],
            ),
          ),
        ),
        value: ubicacion.id,
      ));
    });

    return lista;
  }

  Widget _selectUbicaciones(size) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.location_city,
          size: 30.0,
        ),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButton(
            value: _opcionSeleccionada,
            items: getListaUbicaciones(size),
            onChanged: (value) {
              setState(() {
                _opcionSeleccionada = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _crearBoton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5.0,
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
      ),
      onPressed: () async {
        _modalCarga();
        await _submit();
      },
      child: Text('Enviar'),
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

  _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    checkin.client = _opcionSeleccionada;
    checkin.user = prefs.idUser;
    checkin.coordinates =
        "${currentLocation.latitude},${currentLocation.longitude}";

    Future send = actions.sendCheckin(checkin);

    send.then((value) {
      Navigator.pop(context);
      if (value == true) {
        String titulo = "Correcto!";
        String mensaje = "Se realizo checkin correctamente.";

        _mostrarAlerta(value, titulo, mensaje);
      } else {
        String titulo = "Error!";
        String mensaje = "No se pudo realizar el checkin.";

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
