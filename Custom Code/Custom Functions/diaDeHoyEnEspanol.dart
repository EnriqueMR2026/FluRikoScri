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

String diaDeHoyEnEspanol() {
  /// MODIFY CODE ONLY BELOW THIS LINE

  int weekday = DateTime.now().weekday;
  switch (weekday) {
    case 1:
      return 'Lunes';
    case 2:
      return 'Martes';
    case 3:
      return 'Miercoles'; // Nota: Sin acento para evitar errores de tipeo en BD
    case 4:
      return 'Jueves';
    case 5:
      return 'Viernes';
    case 6:
      return 'Sabado'; // Nota: Sin acento
    case 7:
      return 'Domingo';
    default:
      return '';
  }

  /// MODIFY CODE ONLY ABOVE THIS LINE
}