import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController departamentoController = TextEditingController();
  
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildRegisterForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.person_add,
          size: 80,
          color: Colors.blue[800],
        ),
        SizedBox(height: 16),
        Text(
          'Crear Nueva Cuenta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Text(
          'Completa todos los campos',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Nombre
            _buildTextField(
              controller: nombreController,
              label: 'Nombre',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            
            // Apellido
            _buildTextField(
              controller: apellidoController,
              label: 'Apellido',
              icon: Icons.person_outline,
            ),
            SizedBox(height: 16),
            
            // RUT
            _buildTextField(
              controller: rutController,
              label: 'RUT (ej: 12345678-9)',
              icon: Icons.badge,
            ),
            SizedBox(height: 16),
            
            // Email
            _buildTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            
            // Teléfono
            _buildTextField(
              controller: telefonoController,
              label: 'Teléfono',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            
            // Departamento
            _buildTextField(
              controller: departamentoController,
              label: 'Departamento',
              icon: Icons.business,
            ),
            SizedBox(height: 16),
            
            // Contraseña
            _buildTextField(
              controller: passwordController,
              label: 'Contraseña',
              icon: Icons.lock,
              obscureText: true,
            ),
            SizedBox(height: 16),
            
            // Confirmar contraseña
            _buildTextField(
              controller: confirmPasswordController,
              label: 'Confirmar Contraseña',
              icon: Icons.lock_outline,
              obscureText: true,
            ),
            SizedBox(height: 24),
            
            // Botón Registro
            Obx(() => ElevatedButton(
              onPressed: authController.isLoading.value 
                ? null 
                : _handleRegister,
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
                    'Crear Cuenta',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[800]!),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }

  void _handleRegister() async {
    // Validaciones básicas
    if (_isFormValid()) {
      bool success = await authController.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        telefono: telefonoController.text.trim(),
        rut: rutController.text.trim(),
        departamento: departamentoController.text.trim(),
      );

      if (success) {
        Get.back(); // Volver al login
      }
    }
  }

  bool _isFormValid() {
    if (nombreController.text.trim().isEmpty) {
      Get.snackbar("Error", "El nombre es requerido");
      return false;
    }
    
    if (apellidoController.text.trim().isEmpty) {
      Get.snackbar("Error", "El apellido es requerido");
      return false;
    }
    
    if (rutController.text.trim().isEmpty) {
      Get.snackbar("Error", "El RUT es requerido");
      return false;
    }
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar("Error", "El email es requerido");
      return false;
    }
    
    if (passwordController.text.length < 6) {
      Get.snackbar("Error", "La contraseña debe tener al menos 6 caracteres");
      return false;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Las contraseñas no coinciden");
      return false;
    }
    
    return true;
  }
}