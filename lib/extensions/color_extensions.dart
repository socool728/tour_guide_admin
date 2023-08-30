import 'dart:ui';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }


  String get toHexString => '#FF${this.value.toRadixString(16).substring(2, 8).toUpperCase()}';

}


extension ColorUtils on Color {
  Color get invert {
    final r = 255 - this.red;
    final g = 255 - this.green;
    final b = 255 - this.blue;

    return Color.fromARGB((this.opacity * 255).round(), r, g, b);
  }
}