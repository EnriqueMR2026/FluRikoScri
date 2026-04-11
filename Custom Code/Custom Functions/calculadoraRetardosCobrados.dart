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

double calcularRetardosCobrados(
  double sueldoSemanal,
  int diasTrabajados,
  double sueldoAcumuladoGuardado,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Calculamos cuánto vale su día oficial al 100%
  double sueldoDiario = sueldoSemanal / 6.0;

  // 2. Calculamos cuánto DEBIÓ ganar en los días que sí fue a trabajar
  double sueldoEsperado = sueldoDiario * diasTrabajados;

  // 3. La diferencia entre lo que debió ganar y lo que realmente generó su cronómetro
  double dineroPerdido = sueldoEsperado - sueldoAcumuladoGuardado;

  // Failsafe: Por si la matemática da negativo por algún error de reloj, no le cobramos de más
  if (dineroPerdido < 0) {
    return 0.0;
  }

  // Redondeamos a 4 decimales para que cuadre perfecto con tu diseño
  return double.parse(dineroPerdido.toStringAsFixed(4));

  /// MODIFY CODE ONLY ABOVE THIS LINE
}
