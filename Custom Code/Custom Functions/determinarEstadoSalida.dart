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

String determinarEstadoSalida(
  String horaRealSalida,
  String horaOficialSalida,
  String estadoActual,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Si ya tiene retardo o falta desde la mañana, no lo perdonamos. Se queda igual.
  if (estadoActual.toLowerCase() == "retardo" ||
      estadoActual.toLowerCase() == "falta") {
    return estadoActual;
  }

  // 2. Separar horas y minutos
  List<String> realParts = horaRealSalida.split(':');
  List<String> oficialParts = horaOficialSalida.split(':');

  int minutosReales = (int.parse(realParts[0]) * 60) + int.parse(realParts[1]);
  int minutosOficiales =
      (int.parse(oficialParts[0]) * 60) + int.parse(oficialParts[1]);

  // 3. Seguro de turno nocturno:
  // Si sale antes de la medianoche (ej. 23:00 = 1380m) pero su salida es en la mañana (ej. 07:30 = 450m).
  if (minutosReales > 1080 && minutosOficiales < 720) {
    return "retardo"; // Salida súper anticipada (el mismo día en la noche)
  }

  // 4. Comparación normal en la mañana (Ej. 07:20 vs 07:30)
  // Evaluamos si salió antes, ignorando el caso donde se queda a doblar turno
  if (minutosReales < minutosOficiales &&
      !(minutosReales < 720 && minutosOficiales > 1080)) {
    return "retardo"; // Salida anticipada
  }

  // 5. Si cumplió su horario o salió más tarde, conserva su asistencia verde.
  return estadoActual;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}