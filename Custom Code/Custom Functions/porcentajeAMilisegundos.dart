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

int porcentajeAMilisegundos(double porcentajeSlider) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // Traduce la escala: 1% = 3000ms (Lento), 100% = 100ms (Rápido)
  // Fórmula de interpolación lineal ajustada para un rango de 2900ms
  double ms = 3000.0 - ((porcentajeSlider - 1.0) * (2900.0 / 99.0));

  // Redondeamos para asegurar que salga un Integer limpio
  return ms.round();

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
