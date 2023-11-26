import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFF0FBF8),
  100: Color(0xFFDAF5ED),
  200: Color(0xFFC2EEE2),
  300: Color(0xFFA9E7D6),
  400: Color(0xFF96E1CD),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF7CD8BE),
  700: Color(0xFF71D3B6),
  800: Color(0xFF67CEAF),
  900: Color(0xFF54C5A2),
});
const int _primaryPrimaryValue = 0xFF84DCC4;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFC1FFEB),
  700: Color(0xFFA7FFE3),
});
const int _primaryAccentValue = 0xFFF4FFFB;