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

double calculadoraNomina(
  double sueldoSemanal,
  bool turnoActivo,
  int refresco,
  String horaEntradaOficial,
  String horaSalidaOficial,
  String horaEntradaReal,
  String horaSalidaReal,
  int diasTrabajadosSemana,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  double sueldoDiario = sueldoSemanal / 6;

  // 1. Dinero seguro de los días que ya terminó en la semana
  double dineroDiasPasados = sueldoDiario * diasTrabajadosSemana;

  // 2. Si no ha checado entrada HOY, solo le mostramos lo que lleva de la semana
  if (horaEntradaReal == null || horaEntradaReal.isEmpty)
    return dineroDiasPasados;

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

  if (salidaOficial.isBefore(entradaOficial)) {
    if (ahora.hour < entradaOficial.hour) {
      entradaOficial = entradaOficial.subtract(Duration(days: 1));
    } else {
      salidaOficial = salidaOficial.add(Duration(days: 1));
    }
  }

  int totalSegundosTurno = salidaOficial.difference(entradaOficial).inSeconds;
  if (totalSegundosTurno <= 0) return dineroDiasPasados;
  double sueldoPorSegundo = sueldoDiario / totalSegundosTurno;

  DateTime entradaReal = parseHora(horaEntradaReal, entradaOficial);
  DateTime inicioEfectivo =
      entradaReal.isAfter(entradaOficial) ? entradaReal : entradaOficial;

  DateTime finalEfectivo;
  if (turnoActivo) {
    finalEfectivo = ahora.isAfter(salidaOficial) ? salidaOficial : ahora;
  } else {
    if (horaSalidaReal == null || horaSalidaReal.isEmpty)
      return dineroDiasPasados;
    DateTime salidaReal = parseHora(horaSalidaReal, salidaOficial);
    finalEfectivo =
        salidaReal.isAfter(salidaOficial) ? salidaOficial : salidaReal;
  }

  int segundosTrabajadosHoy =
      finalEfectivo.difference(inicioEfectivo).inSeconds;
  if (segundosTrabajadosHoy <= 0) return dineroDiasPasados;

  double dineroDeHoy = segundosTrabajadosHoy * sueldoPorSegundo;

  // 3. RESULTADO FINAL: Lo de días pasados + Lo que está ganando hoy segundo a segundo
  return dineroDiasPasados + dineroDeHoy;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}