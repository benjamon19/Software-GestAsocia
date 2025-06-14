import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  
  final AuthController authController = Get.find<AuthController>();

  // Focus nodes para las animaciones
  final FocusNode nombreFocusNode = FocusNode();
  final FocusNode apellidoFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode telefonoFocusNode = FocusNode();
  final FocusNode rutFocusNode = FocusNode();

  // Estados para las funcionalidades
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool acceptTerms = false;

  // Estados para focus
  bool isNombreFocused = false;
  bool isApellidoFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isConfirmPasswordFocused = false;
  bool isTelefonoFocused = false;
  bool isRutFocused = false;

  @override
  void initState() {
    super.initState();
    
    // Listeners para los focus nodes
    nombreFocusNode.addListener(() {
      setState(() {
        isNombreFocused = nombreFocusNode.hasFocus;
      });
    });
    
    apellidoFocusNode.addListener(() {
      setState(() {
        isApellidoFocused = apellidoFocusNode.hasFocus;
      });
    });
    
    emailFocusNode.addListener(() {
      setState(() {
        isEmailFocused = emailFocusNode.hasFocus;
      });
    });
    
    passwordFocusNode.addListener(() {
      setState(() {
        isPasswordFocused = passwordFocusNode.hasFocus;
      });
    });
    
    confirmPasswordFocusNode.addListener(() {
      setState(() {
        isConfirmPasswordFocused = confirmPasswordFocusNode.hasFocus;
      });
    });
    
    telefonoFocusNode.addListener(() {
      setState(() {
        isTelefonoFocused = telefonoFocusNode.hasFocus;
      });
    });
    
    rutFocusNode.addListener(() {
      setState(() {
        isRutFocused = rutFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    // Dispose controllers
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    telefonoController.dispose();
    rutController.dispose();
    
    // Dispose focus nodes
    nombreFocusNode.dispose();
    apellidoFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    telefonoFocusNode.dispose();
    rutFocusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 800;

    return Scaffold(
      body: Container(
        color: Color(0xFFF5F6FA),
        child: isSmallScreen 
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Panel izquierdo - Información
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2D3748),
            ),
            child: Stack(
              children: [
                // Patrón de fondo estático
                Positioned.fill(
                  child: CustomPaint(
                    painter: BackgroundPainter(),
                  ),
                ),
                // Contenido
                Padding(
                  padding: EdgeInsets.all(60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Botón de regreso
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Únete a GestAsocia',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Crea tu cuenta en minutos',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Color(0xFF4299E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildBenefitItem(Icons.security, 'Datos seguros y protegidos'),
                            SizedBox(height: 16),
                            _buildBenefitItem(Icons.speed, 'Proceso rápido y sencillo'),
                            SizedBox(height: 16),
                            _buildBenefitItem(Icons.support_agent, 'Soporte 24/7'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Panel derecho - Formulario
        Expanded(
          flex: 4,
          child: Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: _buildRegisterForm(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Header móvil
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
                  onPressed: () => Get.back(),
                ),
                SizedBox(width: 16),
                Text(
                  'Registro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Logo para móvil
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF4299E1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.person_add,
                size: 40,
                color: Color(0xFF4299E1),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Crear Nueva Cuenta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 40),
            _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Información Personal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Completa todos los campos para crear tu cuenta',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        SizedBox(height: 32),
        
        // Nombre y Apellido
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: nombreController,
                focusNode: nombreFocusNode,
                isFocused: isNombreFocused,
                label: 'Nombre',
                icon: Icons.person_outline,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: apellidoController,
                focusNode: apellidoFocusNode,
                isFocused: isApellidoFocused,
                label: 'Apellido',
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        
        // RUT
        _buildTextField(
          controller: rutController,
          focusNode: rutFocusNode,
          isFocused: isRutFocused,
          label: 'RUT',
          hint: '12345678-9',
          icon: Icons.badge_outlined,
        ),
        SizedBox(height: 20),
        
        // Email y Teléfono
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: emailController,
                focusNode: emailFocusNode,
                isFocused: isEmailFocused,
                label: 'Correo electrónico',
                hint: 'ejemplo@correo.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: telefonoController,
                focusNode: telefonoFocusNode,
                isFocused: isTelefonoFocused,
                label: 'Teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Color(0xFFE2E8F0),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Seguridad',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Color(0xFFE2E8F0),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        
        // Contraseña
        _buildPasswordField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          isFocused: isPasswordFocused,
          label: 'Contraseña',
          hint: 'Mínimo 6 caracteres',
          isVisible: isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
        SizedBox(height: 20),
        
        // Confirmar contraseña
        _buildPasswordField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          isFocused: isConfirmPasswordFocused,
          label: 'Confirmar Contraseña',
          isVisible: isConfirmPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
        ),
        SizedBox(height: 32),
        
        // Términos y condiciones
        Row(
          children: [
            Transform.scale(
              scale: 0.9,
              child: Checkbox(
                value: acceptTerms,
                onChanged: (value) {
                  setState(() {
                    acceptTerms = value ?? false;
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: Color(0xFF4299E1),
                checkColor: Colors.white,
                side: BorderSide(
                  color: acceptTerms ? Color(0xFF4299E1) : Color(0xFFE2E8F0),
                  width: 2,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    acceptTerms = !acceptTerms;
                  });
                },
                child: Text(
                  'Acepto los términos y condiciones',
                  style: TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        
        // Botón Registrar
        GetBuilder<AuthController>(
          builder: (controller) => ElevatedButton(
            onPressed: controller.isLoading.value 
              ? null 
              : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4299E1),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: Color(0xFF4299E1).withOpacity(0.6),
            ),
            child: controller.isLoading.value
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
        ),
        SizedBox(height: 32),
        
        // Link para volver al login
        Center(
          child: TextButton(
            onPressed: () => Get.back(),
            child: RichText(
              text: TextSpan(
                text: '¿Ya tienes una cuenta? ',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Inicia sesión',
                    style: TextStyle(
                      color: Color(0xFF4299E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required String label,
    String? hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A5568),
        ),
        hintText: hint,
        hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
        prefixIcon: Icon(
          icon,
          color: isFocused ? Color(0xFF4299E1) : Color(0xFF718096),
          size: 20,
        ),
        filled: true,
        fillColor: Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF4299E1), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {}); // Para actualizar colores dinámicos
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isFocused,
    required String label,
    String? hint,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4A5568),
        ),
        hintText: hint ?? '••••••••',
        hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: isFocused ? Color(0xFF4299E1) : Color(0xFF718096),
          size: 20,
        ),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Color(0xFF718096),
            size: 20,
          ),
          splashRadius: 20,
        ),
        filled: true,
        fillColor: Color(0xFFF7FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF4299E1), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: (value) {
        setState(() {}); // Para actualizar colores dinámicos
      },
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF4299E1),
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegister() async {
    // Validaciones básicas
    if (_isFormValid()) {
      try {
        bool success = await authController.register(
          email: emailController.text.trim(),
          password: passwordController.text,
          nombre: nombreController.text.trim(),
          apellido: apellidoController.text.trim(),
          telefono: telefonoController.text.trim(),
          rut: rutController.text.trim(),
        );

        if (success) {
          Get.back(); // Volver al login
          Get.snackbar(
            "Éxito", 
            "Cuenta creada correctamente. Por favor inicia sesión.",
            backgroundColor: Color(0xFFF0FDF4),
            colorText: Color(0xFF166534),
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 8,
            margin: EdgeInsets.all(20),
          );
        }
      } catch (e) {
        print('Error en registro: $e');
        Get.snackbar(
          "Error", 
          "Ocurrió un error al crear la cuenta",
          backgroundColor: Color(0xFFFEF5F5),
          colorText: Color(0xFF991B1B),
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 8,
          margin: EdgeInsets.all(20),
        );
      }
    }
  }

  bool _isFormValid() {
    if (nombreController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "El nombre es requerido",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (apellidoController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "El apellido es requerido",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (rutController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "El RUT es requerido",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error", 
        "El email es requerido",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (passwordController.text.length < 6) {
      Get.snackbar(
        "Error", 
        "La contraseña debe tener al menos 6 caracteres",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error", 
        "Las contraseñas no coinciden",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    if (!acceptTerms) {
      Get.snackbar(
        "Error", 
        "Debes aceptar los términos y condiciones",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return false;
    }
    
    return true;
  }
}

// Custom Painter para el fondo estático (igual que en login)
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF4299E1).withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Patrón de ondas estático
    final waveHeight = 100.0;
    final waveCount = 3;
    
    for (int i = 0; i < waveCount; i++) {
      final startY = size.height * (0.2 + i * 0.3);
      path.moveTo(0, startY);
      
      for (double x = 0; x <= size.width; x += 10) {
        final y = startY + 
          waveHeight * sin((x / size.width * 2 * pi) + (i * pi / 2));
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, paint);
      path.reset();
    }

    // Círculos decorativos estáticos
    final circlePaint = Paint()
      ..color = Color(0xFF4299E1).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.2),
      150,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.8),
      200,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}