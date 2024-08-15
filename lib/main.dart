import 'package:demoruler/rulerwidget.dart';
import 'package:display_metrics/display_metrics.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
   Widget build(BuildContext context) {
    return DisplayMetricsWidget(
      child: MaterialApp(
        title: 'Ruler Widget App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Ruler Widget Example'),
          ),
          body: RulerWidget(),
        ),
      ),
    );
  }
}
