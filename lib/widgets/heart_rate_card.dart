import 'package:flutter/material.dart';
import 'gauge_painter.dart';

class HeartRateCard extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const HeartRateCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader('Heart Rate', Icons.favorite, 'bpm'),
            const Divider(color: Colors.white24, height: 20, thickness: 1),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${value.round()}', style: _valueStyle(fontSize: 40)),
                    const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Scale gauge based on available space
                          return GestureDetector(
                            onPanUpdate: (details) {
                              double newValue =
                                  value +
                                  details.delta.dx *
                                      2.0; // Increased sensitivity
                              if (newValue < 0) newValue = 0;
                              if (newValue > 200) newValue = 200; // Max HR 200
                              onChanged(newValue);
                            },
                            child: AspectRatio(
                              aspectRatio: 1.5,
                              child: CustomPaint(
                                painter: GaugePainter(
                                  value: value,
                                  min: 0,
                                  max: 200, // Max HR 200
                                ),
                              ),
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
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon, String unit) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(unit, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }

  TextStyle _valueStyle({double fontSize = 24}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF64FFDA),
      fontFamily: 'monospace',
    );
  }
}
