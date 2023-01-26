This update brings major breaking changes for all users. For a full list of changes, please see the
full CHANGELOG, and make use of the old and new API reference.

* Replace `LocationMarkerLayerWidget` with `CurrentLocationLayer`
    * The `LocationMarkerLayerWidget` class has been removed without deprecation.
    * To migrate, replace `LocationMarkerLayerWidget()` with `CurrentLocationLayer()`.
    * Note that the parameters of the constructor of `CurrentLocationLayer` is different from
      `LocationMarkerLayerWidget`:
        * There is no `plugin` and `options` parameters.
        * To migrate, directly pass all parameters to the constructor of `CurrentLocationLayer`
          instead of wrapping them in `LocationMarkerPlugin` or `LocationMarkerLayerOptions`
          classes.
        * Some parameters including `marker`, `markerSize`, `markerDirection`, `showAccuracyCircle`,
          `accuracyCircleColor`, `showHeadingSector`, `headingSectorRadius` and `headingSectorColor`
          is moved into a new class `LocationMarkerStyle`.
        * To migrate, create a `LocationMarkerStyle` object first and pass it in the `style`
          parameter.

Example:

* Old code:

```dart
Widget build() {
  return LocationMarkerLayerWidget(
    plugin: LocationMarkerPlugin(
      centerCurrentLocationStream: _centerCurrentLocationStreamController.stream,
      turnHeadingUpLocationStream: _turnHeadingUpStreamController.stream,
      centerOnLocationUpdate: _centerOnLocationUpdate,
      turnOnHeadingUpdate: _turnOnHeadingUpdate,
      centerAnimationDuration: const Duration(milliseconds: 200),
      centerAnimationCurve: Curves.fastOutSlowIn,
      turnAnimationDuration: const Duration(milliseconds: 200),
      turnAnimationCurve: Curves.easeInOut,
    ),
    options: LocationMarkerLayerOptions(
      positionStream: const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
      headingStream: const LocationMarkerDataStreamFactory().compassHeadingStream(),
      marker: const DefaultLocationMarker(
        child: Icon(
          Icons.navigation,
          color: Colors.white,
        ),
      ),
      markerSize: const Size.square(40),
      markerDirection: MarkerDirection.heading,
      showAccuracyCircle: true,
      accuracyCircleColor: Colors.black,
      showHeadingSector: true,
      headingSectorRadius: 80,
      headingSectorColor: Colors.black,
      moveAnimationDuration: const Duration(milliseconds: 200),
      moveAnimationCurve: Curves.fastOutSlowIn,
      rotateAnimationDuration: const Duration(milliseconds: 200),
      rotateAnimationCurve: Curves.easeInOut,
    ),
  );
}
```

* New code:

```dart
Widget build() {
  return CurrentLocationLayer(
    style: LocationMarkerStyle(
      marker: const DefaultLocationMarker(
        child: Icon(
          Icons.navigation,
          color: Colors.white,
        ),
      ),
      markerSize: const Size.square(40),
      markerDirection: MarkerDirection.heading,
      showAccuracyCircle: true,
      accuracyCircleColor: Colors.black,
      showHeadingSector: true,
      headingSectorRadius: 80,
      headingSectorColor: Colors.black,
    ),
    positionStream: const LocationMarkerDataStreamFactory().geolocatorPositionStream(),
    headingStream: const LocationMarkerDataStreamFactory().compassHeadingStream(),
    centerCurrentLocationStream: _centerCurrentLocationStreamController.stream,
    turnHeadingUpLocationStream: _turnHeadingUpStreamController.stream,
    centerOnLocationUpdate: _centerOnLocationUpdate,
    turnOnHeadingUpdate: _turnOnHeadingUpdate,
    centerAnimationDuration: const Duration(milliseconds: 200),
    centerAnimationCurve: Curves.fastOutSlowIn,
    turnAnimationDuration: const Duration(milliseconds: 200),
    turnAnimationCurve: Curves.easeInOut,
    moveAnimationDuration: const Duration(milliseconds: 200),
    moveAnimationCurve: Curves.fastOutSlowIn,
    rotateAnimationDuration: const Duration(milliseconds: 200),
    rotateAnimationCurve: Curves.easeInOut,
  );
}
```

* If the location and heading is calculated in the app, `AnimatedLocationMarkerLayer`, a light
  weight widget which does not provide map controlling function such as auto-centering and
  auto-turning, is more suitable widget compared to `CurrentLocationLayer`.
* Compare
  the [custom stream example](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/custom_stream_example.dart)
  and
  the [no stream example](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/no_stream_example.dart)