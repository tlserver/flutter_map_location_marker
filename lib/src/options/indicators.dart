import 'package:flutter/material.dart';

import '../../flutter_map_location_marker.dart';

/// An object to store indicators widget for special status of
/// [CurrentLocationLayer].
@Deprecated('Use a Map directly.')
@immutable
class LocationMarkerIndicators implements Map<Type, Widget?> {
  /// A widget shown when in permission requesting status.
  final Widget? permissionRequesting;

  /// A widget shown when in permission denied status.
  final Widget? permissionDenied;

  /// A widget shown when in service disabled status.
  final Widget? serviceDisabled;

  /// Create a LocationMarkerIndicators.
  @Deprecated('Use a Map directly.')
  const LocationMarkerIndicators({
    this.permissionRequesting,
    this.permissionDenied,
    this.serviceDisabled,
  });

  @override
  Widget? operator [](Object? key) => switch (key) {
    const (PermissionRequestingException) => permissionRequesting,
    const (PermissionDeniedException) => permissionDenied,
    const (ServiceDisabledException) => serviceDisabled,
    _ => null,
  };

  @override
  void operator []=(Type key, Widget? value) {}

  @override
  void addAll(Map<Type, Widget?> other) {}

  @override
  void addEntries(Iterable<MapEntry<Type, Widget?>> newEntries) {}

  @override
  Map<RK, RV> cast<RK, RV>() {
    throw UnimplementedError();
  }

  @override
  void clear() {}

  @override
  bool containsKey(Object? key) {
    throw UnimplementedError();
  }

  @override
  bool containsValue(Object? value) {
    throw UnimplementedError();
  }

  @override
  Iterable<MapEntry<Type, Widget?>> get entries => throw UnimplementedError();

  @override
  void forEach(void Function(Type key, Widget? value) action) {}

  @override
  bool get isEmpty => throw UnimplementedError();

  @override
  bool get isNotEmpty => throw UnimplementedError();

  @override
  Iterable<Type> get keys => throw UnimplementedError();

  @override
  int get length => throw UnimplementedError();

  @override
  Map<K2, V2> map<K2, V2>(
    MapEntry<K2, V2> Function(Type key, Widget? value) convert,
  ) {
    throw UnimplementedError();
  }

  @override
  Widget? putIfAbsent(Type key, Widget? Function() ifAbsent) {
    throw UnimplementedError();
  }

  @override
  Widget? remove(Object? key) {
    throw UnimplementedError();
  }

  @override
  void removeWhere(bool Function(Type key, Widget? value) test) {}

  @override
  Widget? update(
    Type key,
    Widget? Function(Widget? value) update, {
    Widget? Function()? ifAbsent,
  }) {
    throw UnimplementedError();
  }

  @override
  void updateAll(Widget? Function(Type key, Widget? value) update) {}

  @override
  Iterable<Widget?> get values => throw UnimplementedError();
}
