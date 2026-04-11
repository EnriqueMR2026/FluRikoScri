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

double calcularNetoAPagar(
  double sueldoAcumuladoGuardado,
  double propinas,
  double bonos,
  double reposicion,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Sumamos percepciones y restamos la deducción por daños/adelantos
  double totalNeto = sueldoAcumuladoGuardado + propinas + bonos - reposicion;

  // Failsafe: Si debía más de reposición de lo que ganó, el cheque sale en 0, no en negativo
  if (totalNeto < 0) {
    return 0.0;
  }

  return double.parse(totalNeto.toStringAsFixed(4));

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
