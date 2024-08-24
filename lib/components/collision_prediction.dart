import 'package:flutter/material.dart';

class CollisionPrediction extends StatefulWidget {
  const CollisionPrediction({super.key});

  @override
  State<CollisionPrediction> createState() => _CollisionPredictionState();
}

class _CollisionPredictionState extends State<CollisionPrediction> {

  @override
  Widget build(BuildContext context) {

    final double ownVesselMMSI = 123456789.0;
    final double targetVesselMMSI = 987654321.0;
    final double cpa = 0.5;
    final double tcpa = 10.2;
    final bool isCollisionRisk = cpa < 1.0 && tcpa < 15.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collision Risk Strategy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailRow(
              title: 'Own Vessel MMSI:',
              value: ownVesselMMSI.toString(),
            ),
            const SizedBox(height: 10),
            DetailRow(
              title: 'Target Vessel MMSI:',
              value: targetVesselMMSI.toString(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(
                    title: 'Closest Point of Approach (CPA):',
                    value: '$cpa nautical miles',
                  ),
                  const SizedBox(height: 10),
                  DetailRow(
                    title: 'Time to CPA (TCPA):',
                    value: '$tcpa minutes',
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      isCollisionRisk ? 'Collision Risk Detected' : 'No Collision Risk Detected',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCollisionRisk ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
