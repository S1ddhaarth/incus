import 'package:flutter/material.dart';

class SpO2Card extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const SpO2Card({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.air, color: Color(0xFF1565C0), size: 24),
            const SizedBox(height: 4),
            const Text(
              'SpO2',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Divider(color: Colors.white24, height: 16, thickness: 1),
            Expanded(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${value.round()}%',
                    style: _valueStyle(fontSize: 28),
                  ),
                ),
              ),
            ),
            Slider(
              value: value,
              min: 80,
              max: 100,
              divisions: 20,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
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
