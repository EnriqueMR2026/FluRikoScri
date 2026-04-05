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

String determinarEstadoEntrada(
  String horaReal,
  String horaOficial,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Separar horas y minutos (ej. "19:32" -> "19" y "32")
  List<String> realParts = horaReal.split(':');
  List<String> oficialParts = horaOficial.split(':');

  // 2. Convertir todo a minutos totales del día para una comparación perfecta
  int minutosReales = (int.parse(realParts[0]) * 60) + int.parse(realParts[1]);
  int minutosOficiales =
      (int.parse(oficialParts[0]) * 60) + int.parse(oficialParts[1]);

  // 3. El veredicto implacable
  if (minutosReales > minutosOficiales) {
    return "retardo";
  } else {
    return "asistencia";
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
