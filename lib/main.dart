import 'package:flutter/material.dart';
import 'screens/sensor_dashboard_screen.dart';

void main() {
  runApp(const SensorDashboardApp());
}

class SensorDashboardApp extends StatelessWidget {
  const SensorDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensor Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1565C0), // Deep Blue
          secondary: Color(0xFF0D47A1), // Darker Blue
          surface: Color(0xFF121212), // Very Dark Grey/Black for cards
          onSurface: Colors.white,
          tertiary: Color(0xFF64FFDA), // Accent for values
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: const Color(0xFF1565C0),
          inactiveTrackColor: const Color(0xFF1565C0).withOpacity(0.3),
          thumbColor: const Color(0xFF64FFDA),
          overlayColor: const Color(0xFF64FFDA).withOpacity(0.2),
          trackHeight: 4.0,
        ),
      ),
      home: const SensorDashboardScreen(),
    );
  }
}
