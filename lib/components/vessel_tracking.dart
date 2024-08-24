import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oil_guard/constants/my_colors.dart';
import 'package:get/get.dart';
import 'package:oil_guard/data_class/ais_data.dart';
import 'package:oil_guard/utils/ais_data_fetcher.dart';

class VesselTracking extends StatefulWidget {
  const VesselTracking({super.key});

  @override
  State<VesselTracking> createState() => _VesselTrackingState();
}

class _VesselTrackingState extends State<VesselTracking> {
  late AisDataFetcher aisDataFetcher;

  Future<String> _fetchCollisionStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Collision Possible';
  }
  List<AisData> dataList = [];
  // String vesselID = "203999323";

  @override
  void initState() {
    super.initState();
    aisDataFetcher = Get.find();
    Timer.periodic(const Duration(seconds: 4),(timer){
      print("yes!!!!!!!!!!!!!!!!!!!!!!");
      setState(() {
        var data = aisDataFetcher.getAISData();
        dataList.clear();
        data.forEach((_, val) => dataList.add(val));
        print(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'VESSEL TRACKING',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: MyColors.primary,
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index){
          return _buildElevatedSection(
            title: 'Navigation Details',
            items: [
              _buildItem('Speed Over Ground:', dataList[index].message?.positionReport?.sog.toString()),
              _buildItem('Course Over Ground:', dataList[index].message?.positionReport?.cog.toString()),
              _buildItem('Navigation Status:', dataList[index].message?.positionReport?.navigationalStatus.toString()),
              _buildItem('Rate of Turn:', dataList[index].message?.positionReport?.rateOfTurn.toString()),
              _buildItem('Last Known Position:', 'Latitude ${dataList[index].message?.positionReport?.latitude.toString()}, Longitude ${dataList[index].message?.positionReport?.longitude.toString()}'),
              _buildItem('Ship Name:', dataList[index].metaData?.shipName.toString()),
              _buildItem('MMSI:', dataList[index].metaData?.mmsi.toString()),
              _buildItem('Time UTC:', dataList[index].metaData?.timeUtc.toString()),
            ],
          );
        },
      )
      // body: ListView(
      //   padding: EdgeInsets.zero,
      //   children: [
      //     _buildElevatedSection(
      //       title: 'Navigation Details',
      //       items: [
      //         _buildItem('Speed Over Ground:', data[vesselID]?.message?.positionReport?.sog.toString()),
      //         _buildItem('Course Over Ground:', data[vesselID]?.message?.positionReport?.cog.toString()),
      //         _buildItem('Navigation Status:', data[vesselID]?.message?.positionReport?.navigationalStatus.toString()),
      //         _buildItem('Rate of Turn:', data[vesselID]?.message?.positionReport?.rateOfTurn.toString()),
      //         _buildItem('Last Known Position:', 'Latitude ${data[vesselID]?.message?.positionReport?.latitude.toString()}, Longitude ${data[vesselID]?.message?.positionReport?.longitude.toString()}'),
      //       ],
      //     ),
      //     _buildElevatedSection(
      //       title: 'Vessel Characteristics',
      //       items: [
      //         _buildItem('Ship Name:', data[vesselID]?.metaData?.shipName.toString()),
      //         _buildItem('MMSI:', data[vesselID]?.metaData?.mmsi.toString()),
      //         _buildItem('Time UTC:', data[vesselID]?.metaData?.timeUtc.toString()),
      //       ],
      //     ),
      //     // _buildElevatedSection(
      //     //   title: 'Physical Dimensions',
      //     //   items: [
      //     //     _buildItem('Length:', '....'),
      //     //     _buildItem('Width:', '...'),
      //     //     _buildItem('Height:', '...'),
      //     //     _buildItem('Draft:', '...'),
      //     //   ],
      //     // ),
      //     _buildElevatedSection(
      //       title: 'Portioning Details',
      //       items: [
      //         _buildItem('Fuel Level:', '...'),
      //         _buildItem('Cargo Distribution:', '...'),
      //         _buildItem('Ballast:', '....'),
      //       ],
      //     ),
      //     FutureBuilder<String>(
      //       future: _fetchCollisionStatus(),
      //       builder: (context, snapshot) {
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return Center(child: CircularProgressIndicator());
      //         } else if (snapshot.hasError) {
      //           return Center(child: Text('Error: ${snapshot.error}'));
      //         } else {
      //           final status = snapshot.data ?? '';
      //           return _buildElevatedSection(
      //             title: 'Collision Details',
      //             items: [_buildCollisionItem(status)],
      //           );
      //         }
      //       },
      //     ),
      //   ],
      // ),
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

  Widget _buildItem(String label, String? value) {
    return Container(
      color: Colors.grey[200],
      child: ListTile(
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
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

    return Container(
      color: Colors.grey[200],
      child: ListTile(
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
      ),
    );
  }
}
