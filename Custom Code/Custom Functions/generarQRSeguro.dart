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

String generarQRSeguro(String numEmpleado) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  DateTime ahora = DateTime.now();
  // Se suman los 5 minutos de tolerancia
  DateTime expiracion = ahora.add(Duration(minutes: 5));

  // Formato continuo: yyyyMMddHHmm
  String format(DateTime d) {
    return "${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}";
  }

  // 1. El Texto Base
  String baseTxt =
      "LLAVE_Encargada_${numEmpleado}_${format(ahora)}_${format(expiracion)}";

  // 2. Inyectar el ruido secreto ("R1K0") cada 5 caracteres
  String ruido = "R1K0";
  StringBuffer conRuido = StringBuffer();
  for (int i = 0; i < baseTxt.length; i += 5) {
    int end = (i + 5 < baseTxt.length) ? i + 5 : baseTxt.length;
    conRuido.write(baseTxt.substring(i, end));
    if (end < baseTxt.length) {
      conRuido.write(ruido);
    }
  }

  // 3. Encriptación a Base64
  String codificado = base64Encode(utf8.encode(conRuido.toString()));
  return codificado;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}