
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Twins Gym')),
        body: Center(child: Text('مرحبًا بك في توينز جيم')),
      ),
    );
  }
}
