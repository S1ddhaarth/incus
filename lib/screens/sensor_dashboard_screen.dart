import 'package:flutter/material.dart';

import '../widgets/blood_pressure_card.dart';
import '../widgets/spo2_card.dart';
import '../widgets/glucose_card.dart';
import '../widgets/heart_rate_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';

class SensorDashboardScreen extends StatefulWidget {
  const SensorDashboardScreen({super.key});

  @override
  State<SensorDashboardScreen> createState() => _SensorDashboardScreenState();
}

class _SensorDashboardScreenState extends State<SensorDashboardScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Sensor Values
  double _systolic = 120;
  double _diastolic = 80;
  double _spo2 = 98;
  int _glucose = 100;
  double _heartRate = 72; // Avg resting HR

  // Baseline Values (Pre-op)
  double? _baselineSystolic;
  double? _baselineDiastolic;
  double? _baselineHeartRate;
  double? _baselineSpO2;
  int? _baselineGlucose;
  bool _isBaselineSet = false;

  void _resetToHealthy() {
    setState(() {
      _systolic = 120;
      _diastolic = 80;
      _spo2 = 98;
      _glucose = 100;
      _heartRate = 72;
      _isBaselineSet = false;
      _baselineSystolic = null;
      _baselineDiastolic = null;
      _baselineHeartRate = null;
      _baselineSpO2 = null;
      _baselineGlucose = null;
    });
    _showCustomToast(
      "Vitals Reset to Healthy Norms",
      isLeft: false,
      color: const Color(0xFF2E7D32),
    );
  }

  void _setBaseline() {
    setState(() {
      _baselineSystolic = _systolic;
      _baselineDiastolic = _diastolic;
      _baselineHeartRate = _heartRate;
      _baselineSpO2 = _spo2;
      _baselineGlucose = _glucose;
      _isBaselineSet = true;
    });
    _showCustomToast(
      "Baseline Data Set (Pre-op)",
      isLeft: true,
      color: const Color(0xFF00897B),
    );
  }

  Future<void> _transmitData() async {
    if (!_isBaselineSet) {
      _showCustomToast(
        "Please Long Press to Set Baseline First",
        isLeft: true,
        color: Colors.orange,
      );
      return;
    }

    // Check Conditions
    bool shouldTransmit = false;
    List<String> violations = [];
    Map<String, dynamic> fluctuations = {};

    // HR Check: ±20%
    double hrDiff = _heartRate - _baselineHeartRate!;
    double hrLimit = _baselineHeartRate! * 0.20;
    if (hrDiff.abs() > hrLimit) {
      shouldTransmit = true;
      String sign = hrDiff > 0 ? "+" : "";
      violations.add("HR $sign${hrDiff.toInt()}");
      fluctuations['heartRate'] = hrDiff;
    }

    // BP Check: ±20%
    double sysDiff = _systolic - _baselineSystolic!;
    double sysLimit = _baselineSystolic! * 0.20;
    double diaDiff = _diastolic - _baselineDiastolic!;
    double diaLimit = _baselineDiastolic! * 0.20;

    if (sysDiff.abs() > sysLimit || diaDiff.abs() > diaLimit) {
      shouldTransmit = true;
      if (sysDiff.abs() > sysLimit) {
        String sign = sysDiff > 0 ? "+" : "";
        violations.add("SysBP $sign${sysDiff.toInt()}");
        fluctuations['systolic'] = sysDiff;
      }
      if (diaDiff.abs() > diaLimit) {
        String sign = diaDiff > 0 ? "+" : "";
        violations.add("DiaBP $sign${diaDiff.toInt()}");
        fluctuations['diastolic'] = diaDiff;
      }
    }

    // SpO2 Check: < 95
    if (_spo2 < 95) {
      shouldTransmit = true;
      double spo2Diff = _spo2 - _baselineSpO2!;
      String sign = spo2Diff > 0 ? "+" : "";
      violations.add("SpO2 $sign${spo2Diff.toInt()}");
      fluctuations['spo2'] = spo2Diff;
    }

    // Glucose Check: ±15%
    double gluDiff = (_glucose - _baselineGlucose!).toDouble();
    double gluLimit = _baselineGlucose! * 0.15;
    if (gluDiff.abs() > gluLimit) {
      shouldTransmit = true;
      String sign = gluDiff > 0 ? "+" : "";
      violations.add("Gluc $sign${gluDiff.toInt()}");
      fluctuations['glucose'] = gluDiff;
    }

    if (!shouldTransmit) {
      // Condition is stable
      _showCustomToast(
        "Condition is stable",
        isLeft: true,
        color: const Color(0xFF2E7D32), // Green for stable
      );
      return;
    }

    // If we reach here, we transmit
    final url = Uri.parse(
      'https://safepaste-2e585-default-rtdb.firebaseio.com/vitals.json',
    );
    try {
      final response = await http.put(
        url,
        body: json.encode({
          'systolic': _systolic,
          'diastolic': _diastolic,
          'spo2': _spo2,
          'glucose': _glucose,
          'heartRate': _heartRate,
          'baseline': {
            'systolic': _baselineSystolic,
            'diastolic': _baselineDiastolic,
            'spo2': _baselineSpO2,
            'glucose': _baselineGlucose,
            'heartRate': _baselineHeartRate,
          },
          'violations': violations,
          'fluctuations': fluctuations,
        }),
      );

      if (response.statusCode == 200) {
        _showCustomToast(
          "Transmission Allowed: Limits Broken (${violations.join(', ')})",
          isLeft: true,
          color: const Color(0xFFC62828), // Red for transmission/alert
        );
      } else {
        _showCustomToast(
          "Transmission Failed: ${response.statusCode}",
          isLeft: true,
          color: Colors.red,
        );
      }
    } catch (error) {
      _showCustomToast("Error: $error", isLeft: true, color: Colors.red);
    }
  }

  void _showCustomToast(
    String message, {
    required bool isLeft,
    required Color color,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom:
            90.0, // Just above the buttons (60 height + 8 padding + extra margin)
        left: isLeft ? 16.0 : null,
        right: isLeft ? null : 16.0,
        child: AnimatedToast(
          message: message,
          color: color,
          onDismiss: () {
            overlayEntry.remove();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PATIENT VITALS')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // BP Card - Flex 3
            Expanded(
              flex: 3,
              child: BloodPressureCard(
                systolic: _systolic,
                diastolic: _diastolic,
                onSystolicChanged: (val) => setState(() => _systolic = val),
                onDiastolicChanged: (val) => setState(() => _diastolic = val),
              ),
            ),
            const SizedBox(height: 12),

            // Middle Row (SpO2 & Glucose) - Flex 2
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SpO2Card(
                      value: _spo2,
                      onChanged: (val) => setState(() => _spo2 = val),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlucoseCard(
                      key: ValueKey(
                        _glucose,
                      ), // Force rebuild to update scroll position
                      value: _glucose,
                      onChanged: (val) => setState(() => _glucose = val),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Heart Rate - Flex 3
            Expanded(
              flex: 3,
              child: HeartRateCard(
                value: _heartRate,
                onChanged: (val) {
                  setState(() => _heartRate = val);
                  if (val == 0) {
                    _audioPlayer.play(AssetSource('audio/ipl.mp3'));
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            // Buttons - Fixed Height (or Flex 1 if needed, but fixed is safer for buttons)
            SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _transmitData,
                      onLongPress: _setBaseline,
                      icon: const Icon(
                        Icons.wifi_tethering,
                        color: Colors.white,
                      ),
                      label: const FittedBox(
                        child: Text(
                          'TRANSMIT DATA',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _resetToHealthy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: const FittedBox(
                        child: Text(
                          'HEALTHY',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class AnimatedToast extends StatefulWidget {
  final String message;
  final Color color;
  final VoidCallback onDismiss;

  const AnimatedToast({
    super.key,
    required this.message,
    required this.color,
    required this.onDismiss,
  });

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto dismiss
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Text(
              widget.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
