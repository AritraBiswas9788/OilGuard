import 'package:flutter/material.dart';
import 'package:oil_guard/constants/my_colors.dart';

class VesselTracking extends StatefulWidget {
  const VesselTracking({super.key});

  @override
  State<VesselTracking> createState() => _VesselTrackingState();
}

class _VesselTrackingState extends State<VesselTracking> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vessel Tracking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.primary,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildElevatedSection(
            title: 'Navigation Details',
            items: [
              'Speed Over Ground: 0 knots',
              'Course Over Ground: 267.6°',
              'Navigation Status: Underway',
              'Rate of Turn: -128°/min',
              'Last Known Position: Latitude 29.7953, Longitude -93.9492',
            ],
          ),
          _buildElevatedSection(
            title: 'Vessel Characteristics',
            items: [
              'Ship Name: WECK DUNLAP',
              'MMSI: 367756210',
              'Time UTC: 2024-08-24 06:24:37 UTC',
            ],
          ),
          _buildElevatedSection(
            title: 'Physical Dimensions',
            items: [
              'Length: ...',
              'Width: ...',
              'Height: ...',
              'Draft: ...',
            ],
          ),
          _buildElevatedSection(
            title: 'Portioning Details',
            items: [
              'Fuel Level: ...',
              'Cargo Distribution: ...',
              'Ballast: ...',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedSection({
    required String title,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            children: items.map((item) {
              return ListTile(
                title: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
