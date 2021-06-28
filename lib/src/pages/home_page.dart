import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geo/src/blocs/auth_bloc.dart';
import 'package:geo/src/prefs/settings.dart';
import 'package:geo/src/services/geolocator_service.dart';

import 'package:geo/src/pages/login_page.dart';
import 'package:geo/src/widgets/menu_widget.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = new PreferenciasUsuario();
  var currentLocation;
  double lat;
  double lng;
  MapType mapType = MapType.normal;

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    prefs.ultimaPagina = HomePage.routeName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${prefs.displayName}'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                authBloc.logout().whenComplete(() {
                  Navigator.pushReplacementNamed(context, LoginPage.routeName);
                });
              },
            ),
          ),
        ],
      ),
      drawer: MenuWidget(),
      body: FutureBuilder(
        future: determinePosition(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            currentLocation = snapshot.data;
            lat = currentLocation.latitude;
            lng = currentLocation.longitude;

            final CameraPosition puntoInicial = CameraPosition(
              target: LatLng(lat, lng),
              zoom: 16.0,
              //tilt: 50,
            );

            return GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: mapType,
              initialCameraPosition: puntoInicial,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.layers),
        onPressed: () {
          if (mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }
          setState(() {});
        },
      ),
      */
    );
  }
}
