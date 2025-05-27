import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class FirebaseService {
  // Instancias singleton (una sola para toda la app)
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== AUTHENTICATION ==========
  
  /// Stream para escuchar cambios de autenticación
  static Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Usuario actual de Firebase Auth
  static User? get currentUser => _auth.currentUser;
  
  /// UID del usuario actual
  static String? get currentUserId => _auth.currentUser?.uid;
  
  /// Crear cuenta con email y password
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('=== INICIANDO REGISTRO ===');
      print('Email: $email');
      print('Password length: ${password.length}');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('=== REGISTRO AUTH EXITOSO ===');
      print('UID: ${result.user?.uid}');
      
      return result;
    } catch (e) {
      print('=== ERROR EN REGISTRO AUTH ===');
      print('Error: $e');
      throw _handleAuthException(e);
    }
  }
  
  /// Iniciar sesión con email y password
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      print('=== INICIANDO LOGIN ===');
      print('Email: $email');
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('=== LOGIN EXITOSO ===');
      print('UID: ${result.user?.uid}');
      
      return result;
    } catch (e) {
      print('=== ERROR EN LOGIN ===');
      print('Error: $e');
      throw _handleAuthException(e);
    }
  }
  
  /// Cerrar sesión
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('=== LOGOUT EXITOSO ===');
    } catch (e) {
      print('=== ERROR EN LOGOUT ===');
      print('Error: $e');
      throw Exception('Error cerrando sesión: ${e.toString()}');
    }
  }

  // ========== FIRESTORE - USUARIOS ==========
  
  /// Guardar datos del usuario en Firestore
  static Future<void> saveUser(String uid, Usuario usuario) async {
    try {
      print('=== GUARDANDO USUARIO EN FIRESTORE ===');
      print('UID: $uid');
      print('Datos: ${usuario.toMap()}');
      
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .set(usuario.toMap());
          
      print('=== USUARIO GUARDADO EXITOSAMENTE ===');
    } catch (e) {
      print('=== ERROR GUARDANDO USUARIO ===');
      print('Error: $e');
      throw Exception('Error guardando usuario: ${e.toString()}');
    }
  }
  
  /// Obtener datos del usuario desde Firestore
  static Future<Usuario?> getUser(String uid) async {
    try {
      print('=== OBTENIENDO USUARIO DE FIRESTORE ===');
      print('UID: $uid');
      
      DocumentSnapshot doc = await _firestore
          .collection('usuarios')
          .doc(uid)
          .get();
          
      if (doc.exists) {
        print('=== USUARIO ENCONTRADO ===');
        Usuario usuario = Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        print('Usuario: ${usuario.nombreCompleto}');
        return usuario;
      } else {
        print('=== USUARIO NO ENCONTRADO ===');
        return null;
      }
    } catch (e) {
      print('=== ERROR OBTENIENDO USUARIO ===');
      print('Error: $e');
      throw Exception('Error obteniendo usuario: ${e.toString()}');
    }
  }
  
  /// Actualizar datos del usuario
  static Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      print('=== ACTUALIZANDO USUARIO ===');
      print('UID: $uid');
      print('Datos: $data');
      
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .update(data);
          
      print('=== USUARIO ACTUALIZADO ===');
    } catch (e) {
      print('=== ERROR ACTUALIZANDO USUARIO ===');
      print('Error: $e');
      throw Exception('Error actualizando usuario: ${e.toString()}');
    }
  }
  
  /// Eliminar usuario (marcar como inactivo)
  static Future<void> deactivateUser(String uid) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .update({'isActive': false});
    } catch (e) {
      throw Exception('Error desactivando usuario: ${e.toString()}');
    }
  }

  // ========== FIRESTORE - GENÉRICO ==========
  
  /// Crear documento en cualquier colección
  static Future<DocumentReference> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _firestore.collection(collection).add(data);
    } catch (e) {
      throw Exception('Error creando documento: ${e.toString()}');
    }
  }
  
  /// Obtener documento por ID
  static Future<DocumentSnapshot> getDocument({
    required String collection,
    required String docId,
  }) async {
    try {
      return await _firestore.collection(collection).doc(docId).get();
    } catch (e) {
      throw Exception('Error obteniendo documento: ${e.toString()}');
    }
  }
  
  /// Obtener colección completa
  static Future<QuerySnapshot> getCollection(String collection) async {
    try {
      return await _firestore.collection(collection).get();
    } catch (e) {
      throw Exception('Error obteniendo colección: ${e.toString()}');
    }
  }
  
  /// Stream para escuchar cambios en una colección
  static Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // ========== MANEJO DE ERRORES ==========
  
  /// Convertir errores de Firebase a mensajes amigables
  static String _handleAuthException(dynamic e) {
    print('=== ERROR FIREBASE DETALLADO ===');
    print('Tipo: ${e.runtimeType}');
    if (e is FirebaseAuthException) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Plugin: ${e.plugin}');
    } else {
      print('Error genérico: ${e.toString()}');
    }
    print('===============================');

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuario no encontrado';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'email-already-in-use':
          return 'El email ya está registrado';
        case 'weak-password':
          return 'La contraseña es muy débil (mínimo 6 caracteres)';
        case 'invalid-email':
          return 'Email inválido';
        case 'user-disabled':
          return 'Usuario deshabilitado';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde';
        case 'operation-not-allowed':
          return 'Operación no permitida. Verifica la configuración de Firebase';
        case 'invalid-credential':
          return 'Credenciales inválidas';
        case 'network-request-failed':
          return 'Error de conexión. Verifica tu internet';
        default:
          return 'Error de autenticación: ${e.message}';
      }
    } else {
      return 'Error inesperado: ${e.toString()}';
    }
  }
}