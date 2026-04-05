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

String obtenerNumeroDia(
  int indiceDia,
  int semanasAtras,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // indiceDia será del 1 (Lunes) al 7 (Domingo)
  DateTime hoy = DateTime.now();

  // Aquí ocurre la magia del viaje en el tiempo: restamos los días correspondientes
  int diferencia = indiceDia - hoy.weekday - (semanasAtras * 7);

  DateTime fechaCuadro = hoy.add(Duration(days: diferencia));
  return fechaCuadro.day.toString();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
