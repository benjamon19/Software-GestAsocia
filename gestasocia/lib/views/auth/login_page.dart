import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';
import 'register_page.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  
  // Focus nodes para las animaciones
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  
  // Estados para las animaciones y funcionalidades
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    
    // Cargar datos guardados si existen
    _loadSavedCredentials();
    
    // Listeners para los focus nodes
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
  }

  // Cargar credenciales guardadas
  _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? savedRememberMe = prefs.getBool('remember_me');
    String? savedEmail = prefs.getString('saved_email');
    
    if (savedRememberMe == true && savedEmail != null) {
      setState(() {
        rememberMe = true;
        emailController.text = savedEmail;
      });
    }
  }

  // Guardar credenciales
  _saveCredentials(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', email);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('remember_me');
    }
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
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
                      Text(
                        'GestAsocia',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Sistema de Gestión de Asociados',
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
                            _buildFeatureItem(Icons.people_outline, 'Gestión completa de asociados'),
                            SizedBox(height: 16),
                            _buildFeatureItem(Icons.family_restroom, 'Control de cargas familiares'),
                            SizedBox(height: 16),
                            _buildFeatureItem(Icons.calendar_today, 'Sistema de reservas médicas'),
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
                padding: EdgeInsets.all(40),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: _buildLoginForm(),
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
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        color: Colors.white,
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo para móvil
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF4299E1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.medical_services,
                size: 40,
                color: Color(0xFF4299E1),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'GestAsocia',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 40),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Ingresa a tu cuenta para continuar',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF718096),
          ),
        ),
        SizedBox(height: 40),
        
        // Campo Email con animación (como estaba originalmente)
        TextField(
          controller: emailController,
          focusNode: emailFocusNode,
          decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
            hintText: 'ejemplo@correo.com',
            hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: isEmailFocused ? Color(0xFF4299E1) : Color(0xFF718096),
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
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {}); // Para actualizar colores dinámicos
          },
        ),
        SizedBox(height: 24),
        
        // Campo Password con la misma implementación
        TextField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
            hintText: '••••••••',
            hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: isPasswordFocused ? Color(0xFF4299E1) : Color(0xFF718096),
              size: 20,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
        ),
        SizedBox(height: 20),
        
        // Opciones adicionales
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Transform.scale(
                  scale: 0.9,
                  child: Checkbox(
                    value: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: Color(0xFF4299E1),
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: rememberMe ? Color(0xFF4299E1) : Color(0xFFE2E8F0),
                      width: 2,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  child: Text(
                    'Recordarme',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.snackbar(
                  'Recuperar contraseña',
                  'Función próximamente disponible',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFFF7FAFC),
                  colorText: Color(0xFF2D3748),
                  margin: EdgeInsets.all(20),
                  borderRadius: 8,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: Color(0xFF4299E1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        
        // Botón Login
        GetBuilder<AuthController>(
          builder: (controller) => ElevatedButton(
            onPressed: controller.isLoading.value 
              ? null 
              : _handleLogin,
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
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          ),
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
                'o',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
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
        SizedBox(height: 32),
        
        // Link a registro
        Center(
          child: TextButton(
            onPressed: () => Get.to(() => RegisterPage()),
            child: RichText(
              text: TextSpan(
                text: '¿No tienes una cuenta? ',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'Regístrate',
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



  Widget _buildFeatureItem(IconData icon, String text) {
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

  void _handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error", 
        "Por favor completa todos los campos",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
      return;
    }

    try {
      bool success = await authController.login(email, password);
      
      if (success) {
        // Guardar credenciales si el login fue exitoso
        await _saveCredentials(email);
        
        print('Login exitoso');
        if (rememberMe) {
          print('Usuario será recordado');
        }
      }
    } catch (e) {
      print('Error en login: $e');
      Get.snackbar(
        "Error", 
        "Ocurrió un error al iniciar sesión",
        backgroundColor: Color(0xFFFEF5F5),
        colorText: Color(0xFF991B1B),
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 8,
        margin: EdgeInsets.all(20),
      );
    }
  }
}

// Custom Painter para el fondo estático
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