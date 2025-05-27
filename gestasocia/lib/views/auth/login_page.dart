import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Header
                _buildHeader(),
                SizedBox(height: 40),
                
                // Formulario de login
                _buildLoginForm(),
                SizedBox(height: 20),
                
                // Link a registro
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[800],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.medical_services,
            size: 60,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'GestAsocia',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          'Sistema de Gestión de Asociados',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 24),
            
            // Campo Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[800]!),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            
            // Campo Password
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue[800]!),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            
            // Botón Login
            Obx(() => ElevatedButton(
              onPressed: authController.isLoading.value 
                ? null 
                : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: authController.isLoading.value
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return TextButton(
      onPressed: () => Get.to(() => RegisterPage()),
      child: RichText(
        text: TextSpan(
          text: '¿No tienes cuenta? ',
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: 'Regístrate aquí',
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Por favor completa todos los campos");
      return;
    }

    bool success = await authController.login(email, password);
    
    if (success) {
      // El AuthController manejará la navegación automáticamente
      print('Login exitoso');
    }
  }
}