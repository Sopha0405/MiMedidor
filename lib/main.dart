import 'package:flutter/material.dart';
import 'view/auth/login_screen.dart';
import 'view/auth/activar_cuenta_screen.dart';
import 'view/auth/recuperar_screen.dart';
import 'view/splashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MiMedidor',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(), 
        '/login': (context) => const LoginScreen(),
        '/activar': (context) => const ActivarCuentaScreen(),
        '/recuperar': (context) => const RecuperarScreen(),
      },
    );
  }
}

