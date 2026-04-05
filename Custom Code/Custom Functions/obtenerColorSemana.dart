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

Color obtenerColorSemana(
  int indiceDia,
  List<HistorialAsistenciasRecord> historial,
  int semanasAtras,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  DateTime hoy = DateTime.now();

  // El viaje en el tiempo
  int diferencia = indiceDia - hoy.weekday - (semanasAtras * 7);
  DateTime fechaCuadro = hoy.add(Duration(days: diferencia));

  // Formateamos la fecha (ej. "04/04/2026")
  String d = fechaCuadro.day.toString().padLeft(2, '0');
  String m = fechaCuadro.month.toString().padLeft(2, '0');
  String y = fechaCuadro.year.toString();

  // CORRECCIÓN CRÍTICA 1: En tu base de datos usas diagonales (04/04/2026), no guiones.
  String fechaBusqueda = "$d/$m/$y";

  // 1. Buscamos en la base de datos
  if (historial != null && historial.isNotEmpty) {
    for (var registro in historial) {
      if (registro.fechaTextoDia == fechaBusqueda) {
        // CORRECCIÓN CRÍTICA 2: Blindaje CTO contra Nulos, Mayúsculas y Espacios en blanco
        String estado = (registro.estadoDia ?? '').toLowerCase().trim();

        if (estado == "asistencia") return Color(0xFF4CAF50); // Verde
        if (estado == "falta") return Color(0xFFF44336); // Rojo
        if (estado == "retardo") return Color(0xFFFF9800); // Naranja
        if (estado == "descanso") return Color(0xFFFFFFFF); // Blanco
      }
    }
  }

  // 2. Colores por defecto si no hay registro
  // Solo se pinta Dorado si es HOY y de la semana actual (0 semanas atrás)
  if (semanasAtras == 0 && indiceDia == hoy.weekday) {
    return Color(0xFFFFD700);
  } else if (fechaCuadro.isAfter(hoy)) {
    return Color(0xFFF5F5F5); // Futuro (Gris claro)
  } else {
    return Color(0xFFE0E0E0); // Pasado sin registro (Gris oscuro)
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}