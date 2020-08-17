import 'package:flutter/material.dart';

import 'page/center_fab_example.dart';
import 'page/customize_marker_example.dart';
import 'page/minimum_example.dart';

void main() {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Center Fab Example'),
            onTap: () {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CenterFabExample(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Customize Marker Example'),
            onTap: () {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CustomizeMarkerExample(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Minimum Example'),
            onTap: () {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MinimumExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
