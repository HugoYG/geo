import 'package:flutter/material.dart';

import 'package:geo/src/pages/home_page.dart';
import 'package:geo/src/pages/checkin_page.dart';
import 'package:geo/src/pages/checkout_page.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/logo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home_outlined,
              color: Colors.red,
            ),
            title: Text('Inicio'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, HomePage.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.add_location_alt_outlined,
              color: Colors.red,
            ),
            title: Text('Check-in'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, CheckinPage.routeName),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            title: Text('Check-out'),
            onTap: () =>
                Navigator.pushReplacementNamed(context, CheckoutPage.routeName),
          ),
          Divider(),
        ],
      ),
    );
  }
}
