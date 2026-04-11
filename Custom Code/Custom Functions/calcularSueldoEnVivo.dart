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

double calcularSueldoEnVivo(
  double sueldoSemanal,
  String horaEntrada,
  String horaSalida,
  double sueldoAcumuladoAyer,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  try {
    DateTime ahora = DateTime.now();

    // 1. Parsear las horas (HH:mm)
    List<String> partesEntrada = horaEntrada.split(':');
    List<String> partesSalida = horaSalida.split(':');

    DateTime dtEntrada = DateTime(ahora.year, ahora.month, ahora.day,
        int.parse(partesEntrada[0]), int.parse(partesEntrada[1]));
    DateTime dtSalida = DateTime(ahora.year, ahora.month, ahora.day,
        int.parse(partesSalida[0]), int.parse(partesSalida[1]));

    // 2. Ajuste Mágico de la Medianoche
    if (dtEntrada.isAfter(dtSalida)) {
      // El turno cruza la medianoche (ej. 20:00 a 04:00)
      if (ahora.hour < dtSalida.hour ||
          (ahora.hour == dtSalida.hour && ahora.minute < dtSalida.minute)) {
        // Son las 2:00 AM de la madrugada. Su hora de entrada (20:00) fue AYER.
        dtEntrada = dtEntrada.subtract(const Duration(days: 1));
      } else {
        // Son las 22:00 PM de la noche. Su hora de salida (04:00) es MAÑANA.
        dtSalida = dtSalida.add(const Duration(days: 1));
      }
    }

    // 3. Calcular el valor exacto de 1 segundo de trabajo
    int segundosTotalesTurno = dtSalida.difference(dtEntrada).inSeconds;
    double sueldoDiario = sueldoSemanal / 6.0;
    double valorPorSegundo = sueldoDiario / segundosTotalesTurno;

    // 4. Calcular segundos trabajados
    int segundosTrabajados = 0;

    if (ahora.isAfter(dtEntrada)) {
      if (ahora.isAfter(dtSalida)) {
        segundosTrabajados = segundosTotalesTurno; // Topado
      } else {
        segundosTrabajados = ahora.difference(dtEntrada).inSeconds; // En vivo
      }
    }

    // 5. Calcular Total Final
    double gananciaHoy = segundosTrabajados * valorPorSegundo;
    return sueldoAcumuladoAyer + gananciaHoy;
  } catch (e) {
    return sueldoAcumuladoAyer;
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}