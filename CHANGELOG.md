## [5.2.1] - Fix Bug

* Fix web supporting (#52)
* Update pubspec to specify supported platforms

## [5.2.0+2] - Update Documentation

* Update documentation

## [5.2.0+1] - Update Changelog

* Update changelog

## [5.2.0] - Improve Behavior

* Add follow screen point control feature,
  see [CurrentLocationLayer.followScreenPoint](https://pub.dev/documentation/flutter_map_location_marker/5.2.0/flutter_map_location_marker/CurrentLocationLayer/followScreenPoint.html)
  and [CurrentLocationLayer.followScreenPointOffset](https://pub.dev/documentation/flutter_map_location_marker/5.2.0/flutter_map_location_marker/CurrentLocationLayer/followScreenPointOffset.html)
* Update example project
* Fix
  [AnimatedLocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/5.2.0/flutter_map_location_marker/AnimatedLocationMarkerLayer-class.html)
  curve and duration
* Rename
  [CenterOnLocationUpdate](https://pub.dev/documentation/flutter_map_location_marker/5.2.0/flutter_map_location_marker/CenterOnLocationUpdate.html)
  to [FollowOnLocationUpdate](https://pub.dev/documentation/flutter_map_location_marker/5.2.0/flutter_map_location_marker/FollowOnLocationUpdate.html)
* Update documentation

Thank to ch-muhammad-adil

## [5.1.0+1] - Update Readme

* Update readme

## [5.1.0] - Improve Behavior

* Use lastKnownPosition as initial value of default position stream (#49)
* Auto require permission on getting default position stream
* Fix marker not showing after permission approving (#50)
* Accept null value
  for [CurrentLocationLayer.positionStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/CurrentLocationLayer/positionStream.html)
  and [CurrentLocationLayer.headingStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/CurrentLocationLayer/headingStream.html)
* Rename
  [LocationMarkerDataStreamFactory.geolocatorPositionStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/LocationMarkerDataStreamFactory/geolocatorPositionStream.html)
  to [LocationMarkerDataStreamFactory.fromGeolocatorPositionStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/LocationMarkerDataStreamFactory/fromGeolocatorPositionStream.html)
  and [LocationMarkerDataStreamFactory.compassHeadingStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/LocationMarkerDataStreamFactory/compassHeadingStream.html)
  to [LocationMarkerDataStreamFactory.fromCompassHeadingStream](https://pub.dev/documentation/flutter_map_location_marker/5.1.0/flutter_map_location_marker/LocationMarkerDataStreamFactory/fromCompassHeadingStream.html)
* Update dependencies
* Update documentation

Thank to LeonTenorio

## [5.0.0+1] - Update Changelog

* Update changelog

## [5.0.0] - Migrate to Flutter Map v3

* Migrate to `flutter_map` v3
* __BRAKING CHANGE__
  Remove [LocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/4.1.4/flutter_map_location_marker/LocationMarkerLayer-class.html)
  , [LocationMarkerLayerWidget](https://pub.dev/documentation/flutter_map_location_marker/4.1.4/flutter_map_location_marker/LocationMarkerLayerWidget-class.html)
  , [LocationMarkerPlugin](https://pub.dev/documentation/flutter_map_location_marker/4.1.4/flutter_map_location_marker/LocationMarkerPlugin-class.html)
  and [LocationMarkerLayerOptions](https://pub.dev/documentation/flutter_map_location_marker/4.1.4/flutter_map_location_marker/LocationMarkerLayerOptions-class.html)
  classes
* Add
  [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/5.0.0/flutter_map_location_marker/CurrentLocationLayer-class.html)
  , [AnimatedLocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/5.0.0/flutter_map_location_marker/AnimatedLocationMarkerLayer-class.html)
  , [LocationMarkerLayer](https://pub.dev/documentation/flutter_map_location_marker/5.0.0/flutter_map_location_marker/LocationMarkerLayer-class.html)
  and [LocationMarkerStyle](https://pub.dev/documentation/flutter_map_location_marker/5.0.0/flutter_map_location_marker/LocationMarkerLayer-class.html)
  classes

See [V5 migration note](https://github.com/tlserver/flutter_map_location_marker/blob/master/notes/migration_v5.md)

## [4.1.4] - Update Dependencies

* Update dependencies
* Update documentation

## [4.1.3] - Migrate to Flutter Map v2

* Migrate to `flutter_map` v2
* Update dependencies

## [4.1.2] - Fix Bug

* Fix MissingPluginException for web

Thank to NamanShergill

## [4.1.1] - Update Dependencies

* Update dependencies
* Update documentation

## [4.1.0] - Improve Behavior

* Support navigation mode,
  see [this example](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/navigation_example.dart)
* Update documentation

## [4.0.1+1] - Update Documentation

* Update documentation

## [4.0.1] - Update Dependencies

* Update dependencies

## [4.0.0] - Migrate to Flutter Map v1

* Migrate to `flutter_map` v1
* __BRAKING CHANGE__ Change rebuilt signal streams' type from Stream<Null> to Stream<void>
* Update dependencies

## [3.1.0] - Improve Behavior

* Add
  [LocationMarkerLayerOptions.markerDirection](https://pub.dev/documentation/flutter_map_location_marker/3.1.0/flutter_map_location_marker/LocationMarkerLayerOptions/markerDirection.html)
  option to define the behavior of the marker rotation

## [3.0.3] - Improve Behavior

* Change
  the [LocationMarkerLayerOptions.marker](https://pub.dev/documentation/flutter_map_location_marker/3.0.3/flutter_map_location_marker/LocationMarkerLayerOptions/marker.html)
  widget pointing to always phone top instead of to north
* Update dependencies

## [3.0.2] - Update Documentation

* Update documentation
* Update example project
* Fix heading sector repaint condition

Thank to Simone Masoero

## [3.0.1] - Fix Bug

* Fix heading sector spin unexpectedly
* Add heading sector animation
* Hide marker if the widget received an error event
  from [LocationMarkerLayerOptions.positionStream](https://pub.dev/documentation/flutter_map_location_marker/3.0.1/flutter_map_location_marker/LocationMarkerLayerOptions/positionStream.html)
* Improve stability by caching options in widget state to prevent re-subscripting to position stream
  thousand times in a second
* [LocationMarkerPlugin.centerCurrentLocationStream](https://pub.dev/documentation/flutter_map_location_marker/3.0.1/flutter_map_location_marker/LocationMarkerPlugin/centerCurrentLocationStream.html)
  accept null zoom level which indicate remaining the zoom level unchanged
* Improve user experience, auto center current location action does not stop zooming setting
  through [LocationMarkerPlugin.centerCurrentLocationStream](https://pub.dev/documentation/flutter_map_location_marker/3.0.1/flutter_map_location_marker/LocationMarkerPlugin/centerCurrentLocationStream.html)
  now

## [3.0.0] - Expose Position and Heading Streams

* __BRAKING CHANGE__ Remove deprecated code
    * [LocationMarkerPlugin()](https://pub.dev/documentation/flutter_map_location_marker/3.0.0/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html)
      do not accept `locationSettings` parameters anymore. If this settings need to be changed,
      see [this example](https://github.com/tlserver/flutter_map_location_marker/blob/master/example/lib/page/geolocator_settings_example.dart)
    * [LocationMarkerLayerOptions()](https://pub.dev/documentation/flutter_map_location_marker/3.0.0/flutter_map_location_marker/LocationMarkerLayerOptions/LocationMarkerLayerOptions.html)
      now accept `positionStream` and `headingStream` parameters so the application have more
      control of these streams

Thank to Ondřej Synáček

## [2.1.0] - Improve Behavior

* Accept callback for handling geolocator error
* Resubscribe position stream on location settings change

Thank to Ondřej Synáček

## [2.0.2] - Improve Naming

* Rename
  [CenterOnLocationUpdate.first](https://pub.dev/documentation/flutter_map_location_marker/2.0.2/flutter_map_location_marker/CenterOnLocationUpdate.html)
  to [CenterOnLocationUpdate.once](https://pub.dev/documentation/flutter_map_location_marker/2.0.2/flutter_map_location_marker/CenterOnLocationUpdate.html)

## [2.0.1] - Update Dependencies

* Update dependencies

## [2.0.0] - Update Dependencies

* __BRAKING
  CHANGE__ [LocationMarkerPlugin()](https://pub.dev/documentation/flutter_map_location_marker/2.0.0/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html)
  parameter is renamed from `locationOptions` to `locationSettings` and its type is changed
  to `LocationSettings`
* Update dependencies

## [1.0.0] - Update Dependencies

* Update dependencies

## [1.0.0-nullsafety.0] - Migrate to Null-Safety

* Migrate to null-safety
* __BRAKING CHANGE__ Remove deprecated code
    * [LocationMarkerPlugin()](https://pub.dev/documentation/flutter_map_location_marker/1.0.0/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html)
      do not accept `geolocationPermissions` parameter anymore

## [0.0.9] - Improve User Experience

* Wrap direction indicator into an IgnorePointer widget

## [0.0.8] - Fix Bug

* Dispose internal animation controller on map layer dispose
* Update dependencies

## [0.0.7] - Update Dependencies

* Update dependencies

## [0.0.6] - Fix Bug

* Fix possible null error

## [0.0.5] - Update Dependencies

* Update dependencies
* [LocationMarkerPlugin()](https://pub.dev/documentation/flutter_map_location_marker/0.0.5/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html)
  do not need to specify permissions anymore

## [0.0.4] - Fix Bug

* Fix [NoSuchMethodError] when calling `LocationMarkerLayerWidget(options: null)`

## [0.0.3] - New Style

* Add default value
  to [LocationMarkerLayerWidget()](https://pub.dev/documentation/flutter_map_location_marker/0.0.3/flutter_map_location_marker/LocationMarkerLayerWidget/LocationMarkerLayerWidget.html)
  parameters
* Update example project: use new style to create layer

## [0.0.2+1] - Improve ReadMe

* Add a screenshot into [README.md]

## [0.0.2] - Update Dependencies

* Improve [README.md]
* Update dependencies

## [0.0.1+1] - Reformat Code

* Format code using `dartfmt -w`

## [0.0.1] - Initial Release

* Initial release.

[NoSuchMethodError]: https://api.dart.dev/stable/dart-core/NoSuchMethodError-class.html

[README.md]: https://github.com/tlserver/flutter_map_location_marker/blob/master/README.md
