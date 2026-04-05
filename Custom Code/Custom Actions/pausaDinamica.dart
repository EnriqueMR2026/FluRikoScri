// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';

Future pausaDinamica(int milisegundos) async {
  // Le decimos al código que se espere exactamente el tiempo que diga tu Slider
  // antes de dejar pasar a la siguiente acción.
  await Future.delayed(Duration(milliseconds: milisegundos));
}