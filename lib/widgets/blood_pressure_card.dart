import 'package:flutter/material.dart';

class BloodPressureCard extends StatelessWidget {
  final double systolic;
  final double diastolic;
  final ValueChanged<double> onSystolicChanged;
  final ValueChanged<double> onDiastolicChanged;

  const BloodPressureCard({
    super.key,
    required this.systolic,
    required this.diastolic,
    required this.onSystolicChanged,
    required this.onDiastolicChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1B2A), // Deep dark blue card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader('Blood Pressure', Icons.favorite, 'mmHg'),
            const Divider(color: Colors.white24, height: 20, thickness: 1),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Systolic',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text('${systolic.round()}', style: _valueStyle()),
              ],
            ),
            SizedBox(
              height: 30,
              child: Slider(
                value: systolic,
                min: 90,
                max: 180,
                divisions: 90,
                label: systolic.round().toString(),
                onChanged: onSystolicChanged,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Diastolic',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
                Text('${diastolic.round()}', style: _valueStyle()),
              ],
            ),
            SizedBox(
              height: 30,
              child: Slider(
                value: diastolic,
                min: 60,
                max: 120,
                divisions: 60,
                label: diastolic.round().toString(),
                onChanged: onDiastolicChanged,
              ),
            ),
            const Spacer(),
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

  TextStyle _valueStyle() {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF64FFDA), // Teal accent
      fontFamily: 'monospace',
    );
  }
}
