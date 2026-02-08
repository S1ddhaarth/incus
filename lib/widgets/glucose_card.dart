import 'package:flutter/material.dart';

class GlucoseCard extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const GlucoseCard({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF0D1B2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Icon(Icons.water_drop, color: Color(0xFF1565C0), size: 24),
            const SizedBox(height: 4),
            const Text(
              'Glucose',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const Divider(color: Colors.white24, height: 16, thickness: 1),
            const Spacer(),
            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2832),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF1565C0),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Metallic Gradient Background Effect
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.8),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        // Wheel
                        ListWheelScrollView(
                          controller: FixedExtentScrollController(
                            initialItem: value - 50,
                          ),
                          itemExtent:
                              30, // Smaller extent = Higher sensitivity (more items per scroll)
                          perspective: 0.007,
                          diameterRatio: 1.5,
                          useMagnifier: true,
                          magnification: 1.3,
                          overAndUnderCenterOpacity:
                              0.3, // Fade out non-selected items
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            onChanged(50 + index);
                          },
                          children: List.generate(251, (index) {
                            final val = 50 + index;
                            return Center(
                              child: Text(
                                '$val',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF64FFDA),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            );
                          }),
                        ),
                        // Selection Lines (Glass-like overlay)
                        IgnorePointer(
                          child: Center(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: const Color(
                                      0xFF64FFDA,
                                    ).withOpacity(0.5),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: const Color(
                                      0xFF64FFDA,
                                    ).withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                color: Colors.white.withOpacity(
                                  0.05,
                                ), // Slight glass tint
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'mg/dL',
              style: TextStyle(color: Colors.grey[500], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
