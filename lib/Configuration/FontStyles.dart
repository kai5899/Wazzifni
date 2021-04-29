import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle mainStyle({Color fontColor, double fontSize, FontWeight fontWeight}) {
  return GoogleFonts.yanoneKaffeesatz(
    color: fontColor ?? Colors.black45,
    fontSize: fontSize ?? 18,
    fontWeight: fontWeight ?? null,
  );
}

TextStyle montserratStyle(
    {Color fontColor, double fontSize, FontWeight fontWeight}) {
  return GoogleFonts.montserrat(
    color: fontColor ?? Colors.black,
    fontSize: fontSize ?? 18,
    fontWeight: fontWeight ?? null,
  );
}
