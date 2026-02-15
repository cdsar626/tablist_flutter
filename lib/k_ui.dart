import 'package:flutter/material.dart';

EdgeInsets kMarginHorizontal = const EdgeInsets.symmetric(horizontal: 16.0);

Color kColorGreenBase = const Color(0x66DEFFE0);
Color kColorGreenProgressBar = const Color(0xAAC0FFC3);
Color kColorYellowBase = const Color(0x66FEFFE0);
Color kColorYellowProgressBar = const Color(0xAAFEFFC3);
Color kColorRedBase = const Color(0x66FF7A7A);
Color kColorRedProgressBar = const Color(0x66FF7A7A);
Color kColorSliderBase = const Color(0xFF000000);
Color kColorSliderDragged = const Color(0xAA777777);

TextStyle kTextStyleTaskTitle = const TextStyle(
  fontFamily: "ElMessiri",
  fontSize: 18,
  fontVariations: [FontVariation('wght', 600)],
  color: Colors.black,
);

TextStyle kTextStyleTaskSubtitle = const TextStyle(
  fontFamily: "IBMPlexMono",
  fontWeight: FontWeight.w500,
  fontSize: 10,
  color: Colors.black45,
);

InputBorder kInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(
      color: Colors.lightBlueAccent,
    ));
