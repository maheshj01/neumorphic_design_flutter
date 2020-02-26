import 'dart:async';

import 'package:neumorphism_flutter/lightsourcewidget.dart';

class ControlBloc {
  final blurController = StreamController<String>.broadcast();
  final spreadController = StreamController<String>.broadcast();
  final radiusController = StreamController<String>.broadcast();
  final intensityController = StreamController<String>.broadcast();
  final lightController = StreamController<LightSourcePosition>.broadcast();

  void dispose() {
    blurController.close();
    spreadController.close();
    radiusController.close();
    intensityController.close();
    lightController.close();
  }
}

ControlBloc bloc = ControlBloc();
