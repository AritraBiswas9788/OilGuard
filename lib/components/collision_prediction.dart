import 'package:flutter/material.dart';
import 'package:oil_guard/constants/my_colors.dart';

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
        title: const Text('Collision Risk Strategy',
            style: TextStyle(color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.bold,)),
        backgroundColor: MyColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailRow(
              title: 'Own Vessel MMSI:',
              value: ownVesselMMSI.toString(),
              multiLine: true,
            ),
            const SizedBox(height: 10),
            DetailRow(
              title: 'Target Vessel MMSI:',
              value: targetVesselMMSI.toString(),
              multiLine: true,
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: MyColors.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailRow(
                    title: 'Closest Point of Approach (CPA):',
                    value: '$cpa nautical miles',
                    multiLine: true,
                  ),
                  const SizedBox(height: 10),
                  DetailRow(
                    title: 'Time to CPA (TCPA):',
                    value: '$tcpa minutes',
                    multiLine: true,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      isCollisionRisk ? 'Collision Risk Detected' : 'No Collision Risk Detected',
                      style: TextStyle(
                        fontSize: 16,
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
  final bool multiLine;

  const DetailRow({
    required this.title,
    required this.value,
    this.multiLine = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return multiLine
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
