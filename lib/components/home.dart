import 'package:flutter/material.dart';
import 'package:oil_guard/constants/my_colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About AIS Visualize',
        style: TextStyle(color: Colors.white,fontSize: 18,
          fontWeight: FontWeight.bold,)),
        backgroundColor: MyColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'AIS Visualize',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'AIS Visualizer utilizes open data provided by the Norwegian Coastal Administration to deliver an intuitive visualization experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 14),
            BulletPoint(text: 'Track Ships Live'),
            BulletPoint(text: 'Check Past Routes'),
            BulletPoint(text: 'Get Ship Details'),
            BulletPoint(text: 'Move Through Time'),
            BulletPoint(text: 'See Future Paths'),
            BulletPoint(text: 'Collision Risk Management Strategy'),
            BulletPoint(text: 'Change What Region You See'),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;
  const BulletPoint({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.brightness_1, size: 8, color: MyColors.backgroundColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
