# flutter_map_location_marker

[![pub package](https://img.shields.io/pub/v/flutter_map_location_marker)](https://pub.dartlang.org/packages/flutter_map_location_marker)
[![github tag](https://img.shields.io/github/v/tag/tlserver/flutter_map_location_marker?include_prereleases&sort=semver)](https://github.com/tlserver/flutter_map_location_marker)
[![license](https://img.shields.io/github/license/tlserver/flutter_map_location_marker)](https://github.com/tlserver/flutter_map_location_marker/blob/master/LICENSE)

`flutter_map_location_marker` is a [flutter_map](https://pub.dev/packages/flutter_map) plugin for
displaying device's current location on a map. It provides a simple and flexible way to add a 
customizable location marker to your map.
<br>
<img src="https://github.com/tlserver/flutter_map_location_marker/raw/main/assets/interface.jpg" alt="Interface preview" width="400">

Join [flutter_map Discord server](https://discord.gg/BwpEsjqMAH) to talk
about `flutter_map_location_marker`, get help and help others in the #plugins channel.

## Features

* **Simple**: The only thing you need to do is to add a `CurrentLocationLayer()` in to your map
  because all parameters have good default values.

* **Flexible**: The default implementation receives the device's position from
  the [geolocator](https://pub.dev/packages/geolocator) package and the device's heading from
  the [flutter_compass](https://pub.dev/packages/flutter_compass) package, but with type conversion,
  streams from other sources are also supported.

* **Auto-following**: The map follows the new location when location is updated. This feature is
  disabled by default.

* **Auto-rotating**: The map can be rotated automatically as navigation mode. This feature is
  disabled by default.

* **Customization**: The location marker can be fully customized, including the colors of the
  accuracy circle and header.

## Usage

1. Add `flutter_map_location_marker` to your `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_map_location_marker: any # or latest verion
   ```

2. Add permission by following the instructions from
   the [geolocator](https://pub.dev/packages/geolocator#usage) package.

3. Add the layer widget into `FlutterMap`:
   ```dart
   Widget build(BuildContext context) {
     return FlutterMap(
       children: [
         TileLayer(
           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
           maxZoom: 19,
         ),
         CurrentLocationLayer(), // <-- add layer here
       ],
     );
   }
   ```

4. Discover more parameters
   in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/CurrentLocationLayer-class.html)
   .

   ```dart
   Widget build() {
     return CurrentLocationLayer(
       followOnLocationUpdate: FollowOnLocationUpdate.always,
       turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
       style: LocationMarkerStyle(
         marker: const DefaultLocationMarker(
           child: Icon(
             Icons.navigation,
             color: Colors.white,
           ),
         ),
         markerSize: const Size(40, 40),
         markerDirection: MarkerDirection.heading,
       ),
     );
   }
   ```

5. Consider using either 
   the [AnimatedLocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/AnimatedLocationMarkerLayer-class.html)
   or
   the [LocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/LocationMarkerLayer-class.html)
   if multiple location markers need to be displayed.

## Examples

1. [Marker Customization](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/customize_marker_example.dart) :
   Change the marker to any widget you want.

2. [Floating Action Button to Follow Current Location](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/follow_fab_example.dart) :
   Use a floating action button to move and zoom the map to the current location.

3. [Change Geolocator Settings](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/geolocator_settings_example.dart) :
   Define Geolocator settings yourself.

4. [Selectable Distance Filter](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/selectable_distance_filter_example.dart) :
   Change Geolocator settings at the runtime.

5. [Custom Stream](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/custom_stream_example.dart) :
   Use your own stream, such as position stream from another library or predefined route, as the
   source.

6. [No Stream](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/no_stream_example.dart) :
   Use Flutter `setState()` to update position and heading.

7. [Navigation Mode](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/navigation_example.dart) :
   Rotate the map to keep heading pointing upward.

8. [Default Stream](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/default_stream_example.dart) :
   Share the default streams between your app and this plugin.

## FAQ

*Q*: How to get
the [positionStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/CurrentLocationLayer/positionStream.html)
, [headingStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/CurrentLocationLayer/headingStream.html)
or their origin streams from a CurrentLocationLayer widget?

*A*: No, you should not get these streams from a CurrentLocationLayer widget. Instead, create you
own streams with the the same types and also pass it to all the widgets which need them.
CurrentLocationLayer doesn't own the streams; it just listens to them. You can use any
implementation of position and heading streams, as long as the stream types are
Stream&lt;Position&gt; and Stream&lt;double&gt;, respectively. You may
see [this example](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/default_stream_example.dart)
to know about how to do this.
