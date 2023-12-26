import 'package:flutter/material.dart';

import 'page/center_fab_example.dart';
import 'page/custom_stream_example.dart';
import 'page/customize_marker_example.dart';
import 'page/default_stream_example.dart';
import 'page/geolocator_settings_example.dart';
import 'page/indicators_example.dart';
import 'page/minimum_example.dart';
import 'page/navigation_example.dart';
import 'page/no_stream_example.dart';
import 'page/selectable_distance_filter_example.dart';

// import 'page/animation_debugger.dart';
// import 'page/stream_debugger.dart';

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
          // ListTile(
          //   title: const Text('Animation Debugger'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => AnimationDebugger(),
          //       ),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Stream Debugger'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (BuildContext context) => StreamDebugger(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Minimum Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MinimumExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Customize Marker Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CustomizeMarkerExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Center FAB Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CenterFabExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Geolocator Settings Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      GeolocatorSettingsExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Selectable Distance Filter Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SelectableDistanceFilterExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Custom Stream Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CustomStreamExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('No Stream Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NoStreamExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Navigation Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NavigationExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Default Stream Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DefaultStreamExample(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Indicators Example'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => IndicatorsExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
