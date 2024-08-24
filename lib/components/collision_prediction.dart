import 'package:flutter/material.dart';

class CollisionPrediction extends StatefulWidget {
  const CollisionPrediction({super.key});

  @override
  State<CollisionPrediction> createState() => _CollisionPredictionState();
}

class _CollisionPredictionState extends State<CollisionPrediction> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("collision prediction"),);
  }
}
