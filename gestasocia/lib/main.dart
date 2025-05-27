import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'views/auth/login_page.dart';
import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase con la configuración segura
  await Firebase.initializeApp(
    options: FirebaseConfig.webOptions,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GestAsocia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue[800]!,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}