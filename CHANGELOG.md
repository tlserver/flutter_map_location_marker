## [3.0.1] - Fix Bug

* Fix heading sector spin unexpectedly
* Add heading sector animation
* Improve stability by caching options in widget state to prevent re-subscripting to position stream thousand times in a second
* [LocationMarkerPlugin.centerCurrentLocationStream] accept null zoom level which indicate remaining the zoom level unchanged
* Improve user experience, auto center current location action does not stop zooming setting through [LocationMarkerPlugin.centerCurrentLocationStream] now

## [3.0.0] - Expose Position and Heading Streams

* __BRAKING CHANGE__ Remove deprecated code
* [LocationMarkerPlugin()] do not accept `locationSettings` parameters anymore. If this settings need to be changed, see [this example](../example/lib/page/geolocator_settings_example.dart)
* [LocationMarkerLayerOptions()] now accept `positionStream` and `headingStream` parameters so the application have more control of these streams.

## [2.0.2] - Improve naming

* Rename [CenterOnLocationUpdate.first] to [CenterOnLocationUpdate.once]

## [2.0.1] - Update Dependencies

* Update dependencies

## [2.0.0] - Update Dependencies

* __BRAKING CHANGE__ [LocationMarkerPlugin()] parameter is renamed from `locationOptions` to `locationSettings` and its type is changed to `LocationSettings`
* Update dependencies

## [1.0.0] - Update Dependencies

* Update dependencies

## [1.0.0-nullsafety.0] - Migrate to Null-Safety

* Migrate to null-safety
* __BRAKING CHANGE__ Remove deprecated code
  * [LocationMarkerPlugin()] do not accept `geolocationPermissions` parameter anymore

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
* [LocationMarkerPlugin()] do not need to specify permissions anymore.

## [0.0.4] - Fix Bug

* Fix [NoSuchMethodError] when calling `LocationMarkerLayerWidget(options: null)`

## [0.0.3] - New Style

* Add default value to [LocationMarkerLayerWidget()] parameters
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

[LocationMarkerPlugin.centerCurrentLocationStream]: https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/LocationMarkerPlugin/centerCurrentLocationStream.html
[LocationMarkerPlugin()]: https://pub.dev/documentation/flutter_map_location_marker/2.0.1/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html
[CenterOnLocationUpdate.first]: https://pub.dev/documentation/flutter_map_location_marker/2.0.2/flutter_map_location_marker/CenterOnLocationUpdate.html
[CenterOnLocationUpdate.once]: https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/CenterOnLocationUpdate.html
[LocationMarkerLayerWidget()]: https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/LocationMarkerLayerWidget/LocationMarkerLayerWidget.html
[LocationMarkerPlugin()]: https://pub.dev/documentation/flutter_map_location_marker/latest/flutter_map_location_marker/LocationMarkerPlugin/LocationMarkerPlugin.html
[NoSuchMethodError]: https://api.dart.dev/stable/dart-core/NoSuchMethodError-class.html
[README.md]: https://github.com/tlserver/flutter_map_location_marker/blob/master/README.md
