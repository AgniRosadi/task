
import 'dart:ui';

class AppHexColor extends Color {

  static int _getColorFromHex(String hexColor) {
    if(hexColor.isEmpty){
      hexColor = "#ffffff";
    }
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  AppHexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}