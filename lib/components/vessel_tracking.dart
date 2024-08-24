import 'package:flutter/material.dart';

class VesselTracking extends StatefulWidget {
  const VesselTracking({super.key});

  @override
  State<VesselTracking> createState() => _VesselTrackingState();
}

class _VesselTrackingState extends State<VesselTracking> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Info Drawer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
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
              'Length: N/A',
              'Width: N/A',
              'Height: N/A',
              'Draft: N/A',
            ],
          ),
          _buildElevatedSection(
            title: 'Portioning Details',
            items: [
              'Fuel Level: N/A',
              'Cargo Distribution: N/A',
              'Ballast: N/A',
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
            title: Text(title),
            children: items.map((item) {
              return ListTile(
                title: Text(item),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

