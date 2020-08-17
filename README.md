# flutter_map_location_marker

A flutter map plugin for displaying device current location.

## Usage

Add flutter_map_location_marker to your pubspec.yaml:
 
```yaml
dependencies:
  flutter_map_location_marker: any // or latest verion
```

Add the plugin and the layer option into `FlutterMap`:

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
        maxZoom: 19,
      ),
      LocationMarkerLayerOptions(), // <-- add layer options here
    ],
  );
}
```

## Examples

1. Marker Customization
Change the marker to any widget you want.
[example/lib/page/customize_marker_example.dart](./example/lib/page/customize_marker_example.dart)

2. Floating Action Button for Center Current Location
Use a floating Action Button to move and zoom the map to current location. 
[example/lib/page/center_fab_example.dart](./example/lib/page/center_fab_example.dart)
