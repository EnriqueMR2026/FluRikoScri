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

double calculadoraRetardos(
  double sueldoSemanal,
  String horaEntradaOficial,
  String horaSalidaOficial,
  String horaEntradaReal,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Si no ha checado entrada, el retardo es $0.00 por ahora (eso lo maneja la falta)
  if (horaEntradaReal == null || horaEntradaReal.isEmpty) return 0.00;

  // 2. Regla estricta: Dividimos entre 6 días laborables
  double sueldoDiario = sueldoSemanal / 6;

  // --- MINIFUNCIÓN PARA LEER LAS HORAS ---
  DateTime parseHora(String texto, DateTime base) {
    List<String> partes = texto.split(':');
    int h = int.parse(partes[0]);
    int m = int.parse(partes[1]);
    return DateTime(base.year, base.month, base.day, h, m);
  }

  DateTime ahora = DateTime.now();
  DateTime entradaOficial = parseHora(horaEntradaOficial, ahora);
  DateTime salidaOficial = parseHora(horaSalidaOficial, ahora);
  DateTime entradaReal = parseHora(horaEntradaReal, entradaOficial);

  // 3. MAGIA PARA TURNOS CRUZADOS
  if (salidaOficial.isBefore(entradaOficial)) {
    if (ahora.hour < entradaOficial.hour) {
      entradaOficial = entradaOficial.subtract(Duration(days: 1));
    } else {
      salidaOficial = salidaOficial.add(Duration(days: 1));
    }
  }

  // Calculamos el valor de cada segundo de su turno
  int totalSegundosTurno = salidaOficial.difference(entradaOficial).inSeconds;
  if (totalSegundosTurno <= 0) return 0.00;
  double sueldoPorSegundo = sueldoDiario / totalSegundosTurno;

  // 4. CÁLCULO DEL RETARDO
  // Si la hora a la que llegó es DESPUÉS de su hora oficial, calculamos la pérdida.
  if (entradaReal.isAfter(entradaOficial)) {
    int segundosRetardo = entradaReal.difference(entradaOficial).inSeconds;
    return segundosRetardo * sueldoPorSegundo;
  }

  // Si llegó temprano o exacto a su hora, no hay retardo.
  return 0.00;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}