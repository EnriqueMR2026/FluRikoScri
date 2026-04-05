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

String obtenerFechaCompleta() {
  /// MODIFY CODE ONLY BELOW THIS LINE

  DateTime hoy = DateTime.now();

  // Diccionarios estrictamente en español
  List<String> dias = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábado',
    'domingo'
  ];
  List<String> meses = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre'
  ];

  // Obtenemos el nombre del día y le ponemos la primera letra mayúscula (ej. "Viernes")
  String nombreDia = dias[hoy.weekday - 1];
  nombreDia = nombreDia[0].toUpperCase() + nombreDia.substring(1);

  String diaNum = hoy.day.toString().padLeft(2, '0');
  String nombreMes = meses[hoy.month - 1];
  String anio = hoy.year.toString();

  // Matemáticas para calcular el número de semana exacto del año
  int diaDelAnio = hoy.difference(DateTime(hoy.year, 1, 1)).inDays + 1;
  int numeroSemana = ((diaDelAnio - hoy.weekday + 10) / 7).floor();
  if (numeroSemana == 0)
    numeroSemana = 52; // Por si cae en días raros de año nuevo

  // Armamos la frase exacta que diseñaste
  return "$nombreDia $diaNum de $nombreMes del $anio, semana $numeroSemana";

  /// MODIFY CODE ONLY ABOVE THIS LINE
}