import 'package:flutter/material.dart';
import 'package:oil_guard/constants/my_colors.dart';

class VesselTracking extends StatefulWidget {
  const VesselTracking({super.key});

  @override
  State<VesselTracking> createState() => _VesselTrackingState();
}

class _VesselTrackingState extends State<VesselTracking> {
  Future<String> _fetchCollisionStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Collision Possible';
  }

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
              _buildItem('Speed Over Ground: 0 knots'),
              _buildItem('Course Over Ground: 267.6°'),
              _buildItem('Navigation Status: Underway'),
              _buildItem('Rate of Turn: -128°/min'),
              _buildItem('Last Known Position: Latitude 29.7953, Longitude -93.9492'),
            ],
          ),
          _buildElevatedSection(
            title: 'Vessel Characteristics',
            items: [
              _buildItem('Ship Name: WECK DUNLAP'),
              _buildItem('MMSI: 367756210'),
              _buildItem('Time UTC: 2024-08-24 06:24:37 UTC'),
            ],
          ),
          _buildElevatedSection(
            title: 'Physical Dimensions',
            items: [
              _buildItem('Length: ...'),
              _buildItem('Width: ...'),
              _buildItem('Height: ...'),
              _buildItem('Draft: ...'),
            ],
          ),
          _buildElevatedSection(
            title: 'Portioning Details',
            items: [
              _buildItem('Fuel Level: ...'),
              _buildItem('Cargo Distribution: ...'),
              _buildItem('Ballast: ...'),
            ],
          ),
          FutureBuilder<String>(
            future: _fetchCollisionStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final status = snapshot.data ?? '';
                return _buildElevatedSection(
                  title: 'Collision Details',
                  items: [_buildCollisionItem(status)],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildElevatedSection({
    required String title,
    required List<Widget> items,
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
            children: items,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String item) {
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
  }

  Widget _buildCollisionItem(String status) {
    Color color;
    switch (status) {
      case 'Collision Detected':
        color = Colors.red;
        break;
      case 'Collision Possible':
        color = Colors.orange;
        break;
      case 'No Collision Possible':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return ListTile(
      title: Center(
        child: Text(
          status,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );
  }
}
