import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Color colorBateria(double porcentaje) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Si el porcentaje es bajo (verde)
  if (porcentaje <= 33.0) {
    return Color(0xFF4CAF50);
  }
  // Si está a la mitad (amarillo)
  else if (porcentaje <= 66.0) {
    return Color(0xFFFFEB3B);
  }
  // Si va rapidísimo (rojo)
  else {
    return Color(0xFFF44336);
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}