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

bool validarQRSeguro(String qrEscaneado) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  try {
    // 1. Decodificar Base64
    String descodificado = utf8.decode(base64Decode(qrEscaneado));

    // 2. Eliminar el ruido
    String limpio = descodificado.replaceAll("R1K0", "");

    // 3. Validar la firma inicial
    if (!limpio.startsWith("LLAVE_Encargada_")) return false;

    // 4. Extraer el tiempo límite de expiración
    List<String> partes = limpio.split('_');
    if (partes.length < 5) return false;

    String fechaFinStr = partes[4]; // ej. 202604041355

    int year = int.parse(fechaFinStr.substring(0, 4));
    int month = int.parse(fechaFinStr.substring(4, 6));
    int day = int.parse(fechaFinStr.substring(6, 8));
    int hour = int.parse(fechaFinStr.substring(8, 10));
    int minute = int.parse(fechaFinStr.substring(10, 12));

    DateTime fechaFin = DateTime(year, month, day, hour, minute);
    DateTime ahora = DateTime.now();

    // 5. Verificación de seguridad temporal
    if (ahora.isAfter(fechaFin)) return false;
    if (ahora.year != fechaFin.year ||
        ahora.month != fechaFin.month ||
        ahora.day != fechaFin.day) return false;

    return true; // Acceso concedido
  } catch (e) {
    // Si la decodificación falla (es un QR ajeno al sistema), se rechaza.
    return false;
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}