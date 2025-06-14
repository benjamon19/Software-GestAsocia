import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AuthController authController = Get.find<AuthController>();
  bool _isDrawerOpen = true;
  int _selectedIndex = 0;

  // Lista de módulos para el menú lateral
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Dashboard',
      'icon': Icons.dashboard_outlined,
    },
    {
      'title': 'Gestión de Asociados',
      'icon': Icons.people_outline,
    },
    {
      'title': 'Cargas Familiares',
      'icon': Icons.family_restroom_outlined,
    },
    {
      'title': 'Historial Clínico',
      'icon': Icons.medical_information_outlined,
    },
    {
      'title': 'Reserva de Horas',
      'icon': Icons.schedule_outlined,
    },
    {
      'title': 'Configuración',
      'icon': Icons.settings_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Row(
        children: [
          // Menú lateral
          if (_isDrawerOpen)
            Container(
              width: 260,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                        children: [
                          // Logo
                          Container(
                            padding: EdgeInsets.all(25),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.medical_services,
                                  color: Color(0xFF4A5568),
                                  size: 32,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'GestAsocia',
                                  style: TextStyle(
                                    color: Color(0xFF2D3748),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(height: 1),
                          // Elementos del menú
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              itemCount: _menuItems.length,
                              itemBuilder: (context, index) {
                                final item = _menuItems[index];
                                final isSelected = _selectedIndex == index;
                                
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFF4299E1).withOpacity(0.1) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      item['icon'],
                                      color: isSelected ? Color(0xFF4299E1) : Color(0xFF718096),
                                      size: 22,
                                    ),
                                    title: Text(
                                      item['title'],
                                      style: TextStyle(
                                        color: isSelected ? Color(0xFF4299E1) : Color(0xFF4A5568),
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                      if (index != 0) {
                                        Get.snackbar(
                                          'En desarrollo',
                                          'Módulo de ${item['title']} próximamente',
                                          backgroundColor: Color(0xFFFEF3C7),
                                          colorText: Color(0xFF92400E),
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: EdgeInsets.all(20),
                                          borderRadius: 8,
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Barra superior
                Container(
                  height: 70,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Botón de menú
                      IconButton(
                        icon: Icon(
                          _isDrawerOpen ? Icons.menu_open : Icons.menu,
                          color: Color(0xFF4A5568),
                        ),
                        onPressed: () {
                          setState(() {
                            _isDrawerOpen = !_isDrawerOpen;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      // Título de la página
                      Text(
                        _menuItems[_selectedIndex]['title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Spacer(),
                      // Fecha
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF718096)),
                            SizedBox(width: 8),
                            Text(
                              '${DateTime.now().day} de ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}',
                              style: TextStyle(
                                color: Color(0xFF718096),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      // Notificaciones
                      IconButton(
                        icon: Stack(
                          children: [
                            Icon(Icons.notifications_outlined, color: Color(0xFF4A5568)),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 8,
                                  minHeight: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Get.snackbar(
                            'Notificaciones',
                            'No tienes notificaciones nuevas',
                            snackPosition: SnackPosition.BOTTOM,
                            margin: EdgeInsets.all(20),
                            borderRadius: 8,
                          );
                        },
                      ),
                      SizedBox(width: 12),
                      // Menú de usuario
                      PopupMenuButton<String>(
                        offset: Offset(0, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xFF4299E1),
                                radius: 18,
                                child: Text(
                                  authController.userDisplayName.isNotEmpty 
                                    ? authController.userDisplayName[0].toUpperCase() 
                                    : 'U',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    authController.userDisplayName,
                                    style: TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    authController.userEmail,
                                    style: TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_drop_down, color: Color(0xFF718096)),
                            ],
                          ),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'profile',
                            child: Row(
                              children: [
                                Icon(Icons.person_outline, color: Color(0xFF4A5568), size: 20),
                                SizedBox(width: 12),
                                Text('Mi Perfil'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'settings',
                            child: Row(
                              children: [
                                Icon(Icons.settings_outlined, color: Color(0xFF4A5568), size: 20),
                                SizedBox(width: 12),
                                Text('Configuración'),
                              ],
                            ),
                          ),
                          PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                                SizedBox(width: 12),
                                Text('Cerrar Sesión', style: TextStyle(color: Color(0xFFEF4444))),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'profile':
                              Get.snackbar(
                                'Mi Perfil',
                                'Función próximamente disponible',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: EdgeInsets.all(20),
                                borderRadius: 8,
                              );
                              break;
                            case 'settings':
                              setState(() {
                                _selectedIndex = 6;
                              });
                              break;
                            case 'logout':
                              Get.dialog(
                                AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  title: Text('Cerrar Sesión'),
                                  content: Text('¿Estás seguro de que deseas cerrar sesión?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancelar', style: TextStyle(color: Color(0xFF718096))),
                                      onPressed: () => Get.back(),
                                    ),
                                    TextButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text('Cerrar Sesión', style: TextStyle(color: Color(0xFFEF4444)),),
                                      onPressed: () {
                                        Get.back();
                                        authController.logout();
                                        Get.offAllNamed('/login'); // Redirige al login
                                      },
                                    ),
                                  ],
                                ),
                              );
                              break;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Contenido de la página
                Expanded(
                  child: _buildPageContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildExamplePage('Gestión de Asociados', Icons.people_outline);
      case 2:
        return _buildExamplePage('Cargas Familiares', Icons.family_restroom_outlined);
      case 3:
        return _buildExamplePage('Historial Clínico', Icons.medical_information_outlined);
      case 4:
        return _buildExamplePage('Reserva de Horas', Icons.schedule_outlined);
      case 5:
        return _buildExamplePage('Configuración', Icons.settings_outlined);
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen General',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Bienvenido de vuelta, aquí está tu resumen del día',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
          SizedBox(height: 30),
          // Tarjetas de estadísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Asociados',
                  '1,234',
                  Icons.people_outline,
                  Color(0xFF4299E1),
                  Color(0xFFEBF8FF),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  'Citas Hoy',
                  '47',
                  Icons.calendar_today_outlined,
                  Color(0xFF48BB78),
                  Color(0xFFF0FDF4),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  'Nuevos Registros',
                  '12',
                  Icons.person_add_outlined,
                  Color(0xFF9F7AEA),
                  Color(0xFFF9F5FF),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  'Alertas',
                  '3',
                  Icons.warning_amber_outlined,
                  Color(0xFFF56565),
                  Color(0xFFFFF5F5),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          // Actividad reciente
          Expanded(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Actividad Reciente',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Ver todo',
                          style: TextStyle(
                            color: Color(0xFF4299E1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 5,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFEBF8FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: Color(0xFF4299E1),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            'Nuevo asociado registrado',
                            style: TextStyle(
                              color: Color(0xFF2D3748),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Juan Pérez - Hace ${index + 1} horas',
                            style: TextStyle(
                              color: Color(0xFF718096),
                              fontSize: 13,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Color(0xFFCBD5E0),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color iconColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplePage(String title, IconData icon) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Color(0xFFEBF8FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: Color(0xFF4299E1),
              ),
            ),
            SizedBox(height: 30),
            Text(
              title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Esta sección está en desarrollo',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4299E1),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Volver al Dashboard',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}