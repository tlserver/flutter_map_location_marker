import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../exceptions/argument_exception.dart';

@protected
double validateDouble(
  double value,
  String name, {
  double lt = double.nan,
  double gt = double.nan,
  double le = double.nan,
  double ge = double.nan,
  bool nan = false,
}) {
  if ((value.isNaN && !nan) ||
      value >= lt ||
      value <= gt ||
      value > le ||
      value < ge) {
    const ni = double.negativeInfinity;
    const pi = double.infinity;
    final lb = [gt, ge].where((v) => !v.isNaN).fold(ni, max);
    final ub = [lt, le].where((v) => !v.isNaN).fold(pi, min);
    final li = lb == gt ? '(' : '[';
    final ui = ub == lt ? ')' : ']';
    final nn = nan ? ' or NaN' : '';
    throw ArgumentException(
      value,
      name,
      'should be in $li${doubleToString(lb)}, ${doubleToString(ub)}$ui$nn',
    );
  }
  return value;
}

@protected
String doubleToString(double value) {
  if (value.isInfinite) {
    return value.isNegative ? '-∞' : '+∞';
  }
  final ne = value / e;
  if (ne != 0.0 && ne.roundToDouble() == ne) {
    return '${ne}e';
  }
  final npi = value / pi;
  if (npi != 0.0 && npi.roundToDouble() == npi) {
    return '$npiπ';
  }
  return value.toString();
}
