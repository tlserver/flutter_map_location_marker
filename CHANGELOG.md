## [8.1.0] - Improve Behavior

* Export [IncorrectSetupException](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/IncorrectSetupException-class.html),
  [PermissionDeniedException](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/PermissionDeniedException-class.html),
  [PermissionRequestingException](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/PermissionRequestingException-class.html),
  [ServiceDisabledException](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/ServiceDisabledException-class.html) (#111)

## [8.0.8] - Fix Bug

* Fix widget reusability to allow multiple initializations (#109)

## [8.0.7] - Fix Bug

* Fix error of Geolocator.getLastKnownPosition() on web (#108)

## [8.0.6] - Fix Bug

* Fix unnecessary re-subscription on widget update (#106)
* Fix the use of unmounted widget's context (#103, #104)
* Update dependencies

Thank to stefcon & pgebert

## [8.0.5] - Fix Bug

* Fix the use of unmounted widget's context (#103)
* Fix repeated requests to enable location service (#77, #102)
* Fix error of Geolocator.getServiceStatusStream() on web (#101)
* Update dependencies
 
## [8.0.4] - Fix Bug

* Fix error about AnimationController be disposed more than once (#96)

## [8.0.3] - Improve Behavior

* Combine [followScreenPoint](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  and [followScreenPointOffset](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [focalPoint](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/focalPoint.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
  class
* Rename [followCurrentLocationStream](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignPositionStream](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignPositionStream.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [followOnLocationUpdate](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignPositionOnUpdate](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignPositionOnUpdate.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [followAnimationDuration](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignPositionAnimationDuration](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignPositionAnimationDuration.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [followAnimationCurve](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignPositionAnimationCurve](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignPositionAnimationCurve.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [turnHeadingUpLocationStream](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignDirectionStream](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [turnOnHeadingUpdate](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignDirectionOnUpdate](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [turnAnimationDuration](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignDirectionAnimationDuration](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignDirectionAnimationDuration.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Rename [turnAnimationCurve](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/CurrentLocationLayer.html)
  to [alignDirectionAnimationCurve](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer/alignDirectionAnimationCurve.html)
  in [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/8.0.3/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Update dependencies
* Update documentation

## [8.0.2] - Fix Bug

* Fix LateInitializationError when requesting permission (#92)

## [8.0.1] - Fix Bug

* Fix performance issue (#91)
* Update dependencies

## [8.0.0] - Migrate to Flutter Map v6

* Migrate to `flutter_map` v6
* Shorten default heading sector animation duration

Thank to bramp

## [7.0.5] - Update Dependencies

* Update dependencies

Thank to dpatrongomez

## [7.0.4] - Improve Behavior

* Add parameter `requestPermissionCallback` to [LocationMarkerDataStreamFactory.defaultPositionStreamSource()](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/LocationMarkerDataStreamFactory/defaultPositionStreamSource.html) (#78)
* Fix indicators

Thank to SalihCanBinboga

## [7.0.2] - Fix Bug

* Fix error with null heading (#74)

Thank to LeonTenorio

## [7.0.1] - Fix Bug

* Fix heading accuracy (#72)

## [7.0.0] - Migrate to Flutter Map v5

* Migrate to `flutter_map` v5

## [6.0.0] - Migrate to Flutter Map v4

* Migrate to `flutter_map` v4

## [5.3.0] - Improve Behavior

* Reduce unnecessary widget rebuild of
  [CurrentLocationLayer](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/CurrentLocationLayer-class.html)
* Add customize-able indicators feature,
  see [CurrentLocationLayer.indicators](https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/CurrentLocationLayer/indicators.html)
* Update example project

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
