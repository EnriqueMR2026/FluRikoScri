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

double calculadoraNeto(
  double sueldoSemanal,
  bool turnoActivo,
  String horaEntradaOficial,
  String horaSalidaOficial,
  String horaEntradaReal,
  String horaSalidaReal,
  int diasTrabajadosSemana,
  int faltasAcumuladas,
  String diaDeDescanso,
  double propinas,
  double bonos,
  double reposicion,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  double sueldoDiario = sueldoSemanal / 6;

  // --- MINIFUNCIÓN PARA LEER HORAS ---
  DateTime parseHora(String texto, DateTime base) {
    if (texto == null || texto.isEmpty) return base;
    List<String> partes = texto.split(':');
    int h = int.parse(partes[0]);
    int m = int.parse(partes[1]);
    return DateTime(base.year, base.month, base.day, h, m);
  }

  DateTime ahora = DateTime.now();
  DateTime entradaOficial = parseHora(horaEntradaOficial, ahora);
  DateTime salidaOficial = parseHora(horaSalidaOficial, ahora);

  // Magia de turnos cruzados
  if (salidaOficial.isBefore(entradaOficial)) {
    if (ahora.hour < entradaOficial.hour) {
      entradaOficial = entradaOficial.subtract(Duration(days: 1));
    } else {
      salidaOficial = salidaOficial.add(Duration(days: 1));
    }
  }

  int totalSegundosTurno = salidaOficial.difference(entradaOficial).inSeconds;
  double sueldoPorSegundo =
      totalSegundosTurno > 0 ? (sueldoDiario / totalSegundosTurno) : 0.0;
  DateTime entradaReal = parseHora(horaEntradaReal, entradaOficial);

  // 1. CALCULAMOS SUELDO ACUMULADO (Solo el tiempo real trabajado)
  // Como bien dijiste, si faltó, diasTrabajadosSemana no subió, así que no se le paga ese día.
  double sueldoAcumulado = sueldoDiario * diasTrabajadosSemana;

  if (horaEntradaReal != null && horaEntradaReal.isNotEmpty) {
    DateTime inicioEfectivo =
        entradaReal.isAfter(entradaOficial) ? entradaReal : entradaOficial;
    DateTime finalEfectivo;
    if (turnoActivo) {
      finalEfectivo = ahora.isAfter(salidaOficial) ? salidaOficial : ahora;
    } else {
      DateTime salidaReal = parseHora(horaSalidaReal, salidaOficial);
      finalEfectivo =
          salidaReal.isAfter(salidaOficial) ? salidaOficial : salidaReal;
    }
    int segundosHoy = finalEfectivo.difference(inicioEfectivo).inSeconds;
    if (segundosHoy > 0) sueldoAcumulado += (segundosHoy * sueldoPorSegundo);
  }

  // 2. LA SUMA Y RESTA FINAL
  // Eliminamos el descuento de faltas y retardos. Solo sumamos bonos/propinas y restamos la reposición de caja.
  double netoFinal = (sueldoAcumulado + propinas + bonos) - reposicion;

  return netoFinal < 0 ? 0.00 : netoFinal;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}