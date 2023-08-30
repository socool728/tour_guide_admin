import 'dart:math';

extension NumExtensions on double{
  double roundToNum (int x) {
    int decimals = x;
    num fac = pow(10, decimals);
    double d = this;
    d = (d * fac).round() / fac;
    return d;
  }

  double toPercentValue(double percentage) => (this * percentage/100);
}