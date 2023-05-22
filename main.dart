import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Stream<StepCount>? _stepCountStream;
  StreamSubscription<StepCount>? _streamSubscription;
  int _steps = 0;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _streamSubscription = _stepCountStream?.listen((StepCount event) {
        setState(() {
          _steps += event.steps ?? 0;
        });
      });
    } catch (e) {
      print('Error starting pedometer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Step Counter'),
        ),
        body: Center(
          child: Text(
            'Total Steps: $_steps',
            style: TextStyle(fontSize: 30),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
