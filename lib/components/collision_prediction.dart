import 'package:flutter/material.dart';
import 'package:oil_guard/data_class/ais_data.dart';
import 'package:oil_guard/data_class/collision_data.dart';
import 'package:oil_guard/services/collision_service.dart';
import 'package:oil_guard/utils/ais_data_fetcher.dart';
import 'package:get/get.dart';

import '../constants/my_colors.dart';

class CollisionPrediction extends StatefulWidget {
  const CollisionPrediction({super.key});

  @override
  State<CollisionPrediction> createState() => _CollisionPredictionState();
}

class _CollisionPredictionState extends State<CollisionPrediction> {

  List<CollisionData> collisionDataList = [];

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCollisionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
              title: const Text('Collision Alerts',
                  style: TextStyle(color: Colors.black, fontSize: 18,
                    fontWeight: FontWeight.bold,)),
              backgroundColor: MyColors.primary,
      ),
      body: ListView.builder(
        itemCount: collisionDataList.length,
        itemBuilder: (context, index) {
          final alert = collisionDataList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 4,
            child: ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: _getRiskLevelColor(alert.riskLevel),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    alert.riskLevel,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, // Making heading bold
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vessel 1: ${alert.vessel1Name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Making heading bold
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Latitude: ${alert.vessel1Lat}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Longitude: ${alert.vessel1Lng}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vessel 2: ${alert.vessel2Name}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold, // Making heading bold
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Latitude: ${alert.vessel2Lat}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Longitude: ${alert.vessel2Lng}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "CPA: ${alert.cpa.toStringAsFixed(2)} km", // Display CPA with two decimal places
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "TCPA: ${alert.tcpa.toStringAsFixed(2)} minutes", // Display TCPA with two decimal places
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Risk Level: ${alert.riskLevel}",
                        style: TextStyle(
                          fontSize: 16,
                          color: _getRiskLevelColor(alert.riskLevel),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void fetchCollisionData() {
    // collisionDataList = [
    //   CollisionData(
    //     vessel1Name: "Vessel A",
    //     vessel1Lat: "12.34° N",
    //     vessel1Lng: "56.78° W",
    //     vessel2Name: "Vessel B",
    //     vessel2Lat: "12.35° N",
    //     vessel2Lng: "56.79° W",
    //     riskLevel: "High",
    //     cpa: 0.5, // Example CPA value in nautical miles
    //     tcpa: 10.0, // Example TCPA value in minutes
    //   ),
    //   CollisionData(
    //     vessel1Name: "Vessel C",
    //     vessel1Lat: "23.45° N",
    //     vessel1Lng: "67.89° W",
    //     vessel2Name: "Vessel D",
    //     vessel2Lat: "23.46° N",
    //     vessel2Lng: "67.90° W",
    //     riskLevel: "Medium",
    //     cpa: 1.2, // Example CPA value in nautical miles
    //     tcpa: 20.0, // Example TCPA value in minutes
    //   ),
    //   CollisionData(
    //     vessel1Name: "Vessel E",
    //     vessel1Lat: "34.56° N",
    //     vessel1Lng: "78.90° W",
    //     vessel2Name: "Vessel F",
    //     vessel2Lat: "34.57° N",
    //     vessel2Lng: "78.91° W",
    //     riskLevel: "Low",
    //     cpa: 2.5, // Example CPA value in nautical miles
    //     tcpa: 30.0, // Example TCPA value in minutes
    //   ),
    // ];
    // return;
    AisDataFetcher aisDataFetcher = Get.find();
    var data = aisDataFetcher.getAISData();
    List<AisData> dataList = [];
    data.forEach((_, val) => dataList.add(val));
    CollisionService collisionService = CollisionService();
    for(int i=0; i<dataList.length; i++) {
      for(int j=0; j<dataList.length; j++) {
        if(i==j) continue;
        Map res = collisionService.cpaTcpa(dataList[i], dataList[j]);
        if(res['areParallelOrDiverging'] == true) continue;
        double cpa = res['cpa'];
        double tcpa = res['tcpa'];
        String alertType = "Low";
        if(tcpa <2) continue;
        if(tcpa < 2.5) alertType = "High";
        else if(tcpa < 3.5) alertType = "Medium";
        else if(tcpa < 8) alertType = "Low";
        else continue;
        collisionDataList.add(
          CollisionData(
            vessel1Name: dataList[i].metaData!.shipName.toString(),
            vessel1Lat: dataList[i].metaData!.latitude.toString(),
            vessel1Lng: dataList[i].metaData!.longitude.toString(),
            vessel2Name: dataList[j].metaData!.shipName.toString(),
            vessel2Lat: dataList[j].metaData!.latitude.toString(),
            vessel2Lng: dataList[j].metaData!.longitude.toString(),
            riskLevel: alertType,
            tcpa: tcpa,
            cpa: cpa,
          )
        );
      }
    }
    collisionDataList.sort((d1, d2){
      return d1.tcpa.compareTo(d2.tcpa);
    });
    setState(() {

    });
  }
  // Widget build(BuildContext context) {
  //
  //   final double ownVesselMMSI = 123456789.0;
  //   final double targetVesselMMSI = 987654321.0;
  //   final double cpa = 0.5;
  //   final double tcpa = 10.2;
  //   final bool isCollisionRisk = cpa < 1.0 && tcpa < 15.0;
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: const Text('Collision Risk Strategy',
  //           style: TextStyle(color: Colors.black, fontSize: 18,
  //             fontWeight: FontWeight.bold,)),
  //       backgroundColor: MyColors.primary,
  //     ),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(14.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           DetailRow(
  //             title: 'Own Vessel MMSI:',
  //             value: ownVesselMMSI.toString(),
  //             multiLine: true,
  //           ),
  //           const SizedBox(height: 10),
  //           DetailRow(
  //             title: 'Target Vessel MMSI:',
  //             value: targetVesselMMSI.toString(),
  //             multiLine: true,
  //           ),
  //           const SizedBox(height: 14),
  //           Container(
  //             padding: const EdgeInsets.all(14.0),
  //             decoration: BoxDecoration(
  //               color: MyColors.backgroundColor,
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 DetailRow(
  //                   title: 'Closest Point of Approach (CPA):',
  //                   value: '$cpa nautical miles',
  //                   multiLine: true,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 DetailRow(
  //                   title: 'Time to CPA (TCPA):',
  //                   value: '$tcpa minutes',
  //                   multiLine: true,
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Center(
  //                   child: Text(
  //                     isCollisionRisk ? 'Collision Risk Detected' : 'No Collision Risk Detected',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: isCollisionRisk ? Colors.red : Colors.green,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
