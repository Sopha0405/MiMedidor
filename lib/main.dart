import 'package:flutter/material.dart';
import 'view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Registro de Consumo de Agua',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(codSocio: 1001), 
    );
  }
}