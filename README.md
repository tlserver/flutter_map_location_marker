# flutter_map_location_marker

[![pub package](https://img.shields.io/pub/v/flutter_map_location_marker)](https://pub.dartlang.org/packages/flutter_map_location_marker)
[![github tag](https://img.shields.io/github/v/tag/tlserver/flutter_map_location_marker?include_prereleases&sort=semver)](https://github.com/tlserver/flutter_map_location_marker)
[![license](https://img.shields.io/github/license/tlserver/flutter_map_location_marker)](https://github.com/tlserver/flutter_map_location_marker/blob/master/LICENSE)

A [flutter_map](https://pub.dev/packages/flutter_map) plugin for displaying device current location.
![Interface preview](https://github.com/tlserver/flutter_map_location_marker/raw/master/assets/interface.jpg)

## Features

* **Customization**: The location marker can be fully customized. The colors of accuracy circle and
header are also customizable.

* **Simple**: Not depend on other layer. No `MapController` or `MarkerLayer` are needed.

## Usage

Add flutter_map_location_marker to your pubspec.yaml:

```yaml
dependencies:
  flutter_map_location_marker: any // or latest verion
```

Add permission, please follow the instruction from [geolocation](https://pub.dev/packages/geolocator) package.

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

1. [Marker Customization](./example/lib/page/customize_marker_example.dart)
Change the marker to any widget you want.

2. [Floating Action Button for Centering Current Location](./example/lib/page/center_fab_example.dart)
Use a floating action button to move and zoom the map to current location.

3. [Change Geolocator Settings](./example/lib/page/geolocator_settings_example.dart)
Define Geolocator settings yourself.

4. [Selectable Distance Filter](./example/lib/page/selectable_distance_filter_example.dart)
Change Geolocator settings at the runtime.

5. [Custom Stream](./example/lib/page/custom_stream_example.dart)
Use your own stream, such as position stream from other library or predefined route, as the source.
