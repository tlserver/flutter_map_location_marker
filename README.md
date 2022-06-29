# flutter_map_location_marker

[![pub package](https://img.shields.io/pub/v/flutter_map_location_marker)](https://pub.dartlang.org/packages/flutter_map_location_marker)
[![github tag](https://img.shields.io/github/v/tag/tlserver/flutter_map_location_marker?include_prereleases&sort=semver)](https://github.com/tlserver/flutter_map_location_marker)
[![license](https://img.shields.io/github/license/tlserver/flutter_map_location_marker)](https://github.com/tlserver/flutter_map_location_marker/blob/master/LICENSE)

A [flutter_map](https://pub.dev/packages/flutter_map) plugin for displaying device current location.
![Interface preview](https://github.com/tlserver/flutter_map_location_marker/raw/master/assets/interface.jpg)

## Features

* **Simple**: The only thing to do is adding a `LocationMarkerLayerWidget()` in to your map because
  all parameters have good default values.

* **Flexible**: The default implementation is receiving device's position from the
  [geolocator](https://pub.dev/packages/geolocator) package and receiving device's heading from the
  [flutter_compass](https://pub.dev/packages/flutter_compass) package, but with type conversion,
  streams from other source are also supported.

* **Auto-centering**: The map center on the new location when location is updated.

* **Auto-rotating**: The map can be rotated automatically as navigation mode.

* **Customization**: The location marker can be fully customized, even the colors of accuracy circle
  and header.

## Usage

Add flutter_map_location_marker to your pubspec.yaml:

```yaml
dependencies:
  flutter_map_location_marker: any // or latest verion
```

Add permission, please follow the instruction from
[geolocator](https://pub.dev/packages/geolocator#permissions) package.

Add the layer widget into `FlutterMap`:

```dart
Widget build(BuildContext context) {
  return FlutterMap(
    children: [
      TileLayerWidget(
        options: TileLayerOptions(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
      ),
      LocationMarkerLayerWidget(), // <-- add layer widget here
    ],
  );
}
```

Alternatively, you can use the old style to create the layer:

```dart
Widget build(BuildContext context) {
  return FlutterMap(
    options: MapOptions(
      plugins: [
        LocationMarkerPlugin(), // <-- add plugin here
      ],
    ),
    layers: [
      TileLayerOptions(
        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
        subdomains: ['a', 'b', 'c'],
      ),
      LocationMarkerLayerOptions(), // <-- add layer options here
    ],
  );
}
```

## Examples

1. [Marker Customization](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/customize_marker_example.dart) :
   Change the marker to any widget you want.

2. [Floating Action Button for Centering Current Location](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/center_fab_example.dart) :
   Use a floating action button to move and zoom the map to current location.

3. [Change Geolocator Settings](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/geolocator_settings_example.dart) :
   Define Geolocator settings yourself.

4. [Selectable Distance Filter](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/selectable_distance_filter_example.dart) :
   Change Geolocator settings at the runtime.

5. [Custom Stream](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/custom_stream_example.dart) :
   Use your own stream, such as position stream from other library or predefined route, as the
   source.

6. [Navigation Mode](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/navigation_example.dart) :
   Rotate the map to keep heading pointing upward.

