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

double calculadoraFaltas(
  double sueldoSemanal,
  int faltasAcumuladas,
  String horaEntradaOficial,
  String horaEntradaReal,
  String diaDeDescanso,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // 1. Calculamos cuánto vale un día de sueldo
  double sueldoDiario = sueldoSemanal / 6;

  // 2. Cobramos las faltas históricas (las de ayer o la semana)
  double faltasHistoricas = faltasAcumuladas * sueldoDiario;

  // 3. Helper para saber qué día de la semana es hoy (1=Lunes, 7=Domingo)
  int diaHoy = DateTime.now().weekday;

  // Convertimos tu texto de descanso a número para compararlo
  int numDiaDescanso = 0;
  String desc = diaDeDescanso != null ? diaDeDescanso.toLowerCase() : "";
  if (desc == "lunes")
    numDiaDescanso = 1;
  else if (desc == "martes")
    numDiaDescanso = 2;
  else if (desc == "miercoles" || desc == "miércoles")
    numDiaDescanso = 3;
  else if (desc == "jueves")
    numDiaDescanso = 4;
  else if (desc == "viernes")
    numDiaDescanso = 5;
  else if (desc == "sabado" || desc == "sábado")
    numDiaDescanso = 6;
  else if (desc == "domingo") numDiaDescanso = 7;

  // 4. Si hoy es su día libre oficial, no hay susto, solo mostramos el historial
  if (diaHoy == numDiaDescanso) {
    return faltasHistoricas;
  }

  // --- MINIFUNCIÓN PARA LEER LA HORA OFICIAL ---
  DateTime ahora = DateTime.now();
  DateTime entradaOficial = ahora; // Valor por defecto

  if (horaEntradaOficial != null && horaEntradaOficial.isNotEmpty) {
    List<String> partes = horaEntradaOficial.split(':');
    int h = int.parse(partes[0]);
    int m = int.parse(partes[1]);
    entradaOficial = DateTime(ahora.year, ahora.month, ahora.day, h, m);
  }

  // 5. EL TRUCO PSICOLÓGICO (El Susto)
  // Si ya pasó su hora oficial de entrada Y no ha checado (horaReal vacía)
  if (ahora.isAfter(entradaOficial) &&
      (horaEntradaReal == null || horaEntradaReal.isEmpty)) {
    // Le sumamos 1 falta completa al visual para asustarlo
    return faltasHistoricas + sueldoDiario;
  }

  // Si ya checó (tarde o temprano), el susto desaparece y solo quedan las faltas reales.
  return faltasHistoricas;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}