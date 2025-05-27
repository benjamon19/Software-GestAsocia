import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  // Variables observables
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<Usuario> currentUser = Rxn<Usuario>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('=== INICIALIZANDO AUTH CONTROLLER ===');
    
    // Escuchar cambios en el estado de autenticación
    firebaseUser.bindStream(FirebaseService.authStateChanges);
    
    // Cuando el usuario de Firebase cambia, cargar sus datos
    ever(firebaseUser, _handleAuthChanged);
  }

  // Manejar cambios de autenticación
  void _handleAuthChanged(User? user) async {
    print('=== CAMBIO DE ESTADO AUTH ===');
    print('Usuario: ${user?.email ?? "null"}');
    
    if (user != null) {
      // Usuario logueado - cargar sus datos
      await _loadUserData(user.uid);
    } else {
      // Usuario deslogueado - limpiar datos
      currentUser.value = null;
      print('=== USUARIO DESLOGUEADO ===');
    }
  }

  // Cargar datos del usuario
  Future<void> _loadUserData(String uid) async {
    try {
      print('=== CARGANDO DATOS DEL USUARIO ===');
      Usuario? usuario = await FirebaseService.getUser(uid);
      currentUser.value = usuario;
      print('=== DATOS CARGADOS: ${usuario?.nombreCompleto} ===');
    } catch (e) {
      print('=== ERROR CARGANDO DATOS ===');
      print('Error: $e');
      Get.snackbar("Error", "No se pudieron cargar los datos del usuario");
    }
  }

  // Registro de usuario
  Future<bool> register({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String telefono,
    required String rut,
    required String departamento,
  }) async {
    try {
      print('=== INICIANDO PROCESO DE REGISTRO ===');
      isLoading.value = true;

      // Validar RUT
      if (!Usuario.validarRUT(rut)) {
        Get.snackbar(
          "Error", 
          "RUT inválido. Formato: 12345678-9",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        return false;
      }

      // Paso 1: Crear usuario en Firebase Auth
      print('=== PASO 1: CREANDO AUTH ===');
      UserCredential result = await FirebaseService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Paso 2: Crear objeto Usuario
      print('=== PASO 2: CREANDO OBJETO USUARIO ===');
      Usuario nuevoUsuario = Usuario(
        nombre: nombre,
        apellido: apellido,
        email: email,
        telefono: telefono,
        rut: rut,
        departamento: departamento,
        fechaCreacion: DateTime.now(),
      );

      // Paso 3: Guardar en Firestore
      print('=== PASO 3: GUARDANDO EN FIRESTORE ===');
      await FirebaseService.saveUser(result.user!.uid, nuevoUsuario);

      print('=== REGISTRO COMPLETADO EXITOSAMENTE ===');
      Get.snackbar(
        "¡Éxito!", 
        "Usuario registrado correctamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      return true;

    } catch (e) {
      print('=== ERROR EN REGISTRO COMPLETO ===');
      print('Error: $e');
      Get.snackbar(
        "Error de Registro", 
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Login de usuario
  Future<bool> login(String email, String password) async {
    try {
      print('=== INICIANDO LOGIN ===');
      isLoading.value = true;

      // Validaciones
      if (email.trim().isEmpty) {
        Get.snackbar("Error", "El email es requerido");
        return false;
      }

      if (password.isEmpty) {
        Get.snackbar("Error", "La contraseña es requerida");
        return false;
      }

      // Iniciar sesión
      await FirebaseService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      Get.snackbar(
        "¡Éxito!", 
        "Sesión iniciada correctamente",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
      return true;

    } catch (e) {
      print('=== ERROR EN LOGIN ===');
      print('Error: $e');
      Get.snackbar(
        "Error de Login", 
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await FirebaseService.signOut();
      Get.snackbar("Sesión cerrada", "Has cerrado sesión correctamente");
    } catch (e) {
      Get.snackbar("Error", "Error al cerrar sesión");
    }
  }

  // Getters útiles
  bool get isSignedIn => firebaseUser.value != null;
  String? get currentUserId => FirebaseService.currentUserId;
  String get userDisplayName => currentUser.value?.nombreCompleto ?? 'Usuario';
  String get userEmail => currentUser.value?.email ?? '';
}