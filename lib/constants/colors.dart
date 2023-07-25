import 'dart:ui';

final appColorPrimaryYellow = hexToColor("#fbae0d");
final appColorSecondaryDarkBlue = hexToColor("#0d2034");
final appColorAccent0Gray = hexToColor("#f7f8f7");
final appColorAccent1Pink = hexToColor("#e0474d");
// final appColorAccent2Yellow = hexToColor("#e0474d");
final appColorAccent3Brown = hexToColor("#9f7835");
final appColorAccent4LightBrown = hexToColor("#e2b858");
final appColorBackground = hexToColor("#e7e9eb");
final appColorCardBackground = hexToColor("#fefefe");

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
