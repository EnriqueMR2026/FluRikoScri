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

String textoBateria(double porcentaje) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Si el porcentaje es bajo (números lentos), la batería descansa.
  if (porcentaje <= 33.0) {
    return "Consumo de Batería: BAJO";
  }
  // Si está a la mitad.
  else if (porcentaje <= 66.0) {
    return "Consumo de Batería: NORMAL";
  }
  // Si los números van rapidísimo.
  else {
    return "Consumo de Batería: ALTO";
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}