import 'package:flutter/material.dart';

import '../constants/my_colors.dart';

class AlertSystem extends StatefulWidget {
  const AlertSystem({super.key});

  @override
  State<AlertSystem> createState() => _AlertSystemState();
}

class _AlertSystemState extends State<AlertSystem> {

  @override
  Widget build(BuildContext context) {
    final pastCollisions = [
      {'date': '.....', 'location': 'Gulf Of Mexico', 'details': 'Collision with vessel X'},
      {'date': '2024-07-20', 'location': '.....', 'details': 'Collision with vessel Y'},
    ];

    final upcomingCollisions = [
      {'date': '2024-09-15', 'location': '......', 'details': 'Potential collision with vessel A'},
      {'date': '024-09-15', 'location': '.....', 'details': 'Potential collision with vessel B'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collision Reports',style: TextStyle(color: Colors.white,fontSize: 18,
          fontWeight: FontWeight.bold,)),
      backgroundColor: MyColors.primary,
    ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Past Collisions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: pastCollisions.length,
                itemBuilder: (context, index) {
                  final collision = pastCollisions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text('${collision['date']} - ${collision['location']}'),
                      subtitle: Text(collision['details']!),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Upcoming Collisions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingCollisions.length,
                itemBuilder: (context, index) {
                  final collision = upcomingCollisions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text('${collision['date']} - ${collision['location']}'),
                      subtitle: Text(collision['details']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
