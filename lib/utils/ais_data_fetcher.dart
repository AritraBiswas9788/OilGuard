import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oil_guard/components/MapElement.dart';
import 'package:oil_guard/data_class/ais_data.dart';
import 'package:web_socket_client/web_socket_client.dart';

class AisDataFetcher extends GetxController {
  late WebSocket socketClient;
  late Timer _kmlTimer;
  late DataHandler dataHandler;
  Map<String, AisData> aisData = {};
  static const String socketEndpoint = "wss://stream.aisstream.io/v0/stream";
  static const String transactionReq = '''{
    "APIKey": "963147f1d105d72730ec6435e9a408c66cf2fefe",
    "BoundingBoxes": [[[18,-98],[30,-81]]]
}''';

  List<LatLng> generatePolygonPoints(
      LatLng center, double width, double height) {
    final List<LatLng> points = [];

    // Calculate the offset distances
    double halfWidth = width / 2;
    double halfHeight = height / 4;
    double peakHeight =
        height * 0.6; // Top triangle height (40% of the total height)
    double rectHeight = height - peakHeight;

    // Calculate the points based on the center
    points.add(LatLng(center.latitude + peakHeight,
        center.longitude)); // Top point of the triangle
    points.add(LatLng(center.latitude + halfHeight,
        center.longitude + halfWidth)); // Right corner of the rectangle
    points.add(LatLng(center.latitude - halfHeight,
        center.longitude + halfWidth)); // Left corner of the rectangle
    points.add(LatLng(center.latitude - halfHeight,
        center.longitude - halfWidth)); // Bottom left of the rectangle
    points.add(LatLng(center.latitude + halfHeight,
        center.longitude - halfWidth));
    points.add(LatLng(center.latitude + peakHeight,
        center.longitude));// Bottom right of the rectangle

    return points;
  }

  connectSocket() async {
    try {
      const timeout = Duration(seconds: 10);
      socketClient = WebSocket(Uri.parse(socketEndpoint), timeout: timeout);
      await socketClient.connection.firstWhere(
          (state) => (state is Connected) || (state is Reconnected));
      socketClient.send(transactionReq);
      _attachTransactionRecievers();
      _startKMLGenerator();
    } catch (e) {
      print(e);
    }
  }

  void _attachTransactionRecievers() {
    try {
      socketClient.messages.listen((message) {
        String msg = String.fromCharCodes(message);
        Map<String, dynamic> jsonData = jsonDecode(msg);
        AisData data = AisData.fromJson(jsonData);
        try {
          aisData[data.message!.positionReport!.userId!] = data;
          print(aisData.length);
        } catch (e) {
          //print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  closeSocketConnection() {
    socketClient.close();
    _kmlTimer.cancel();
  }

  void setDataHandler(DataHandler handler)
  {
    dataHandler = handler;
  }

  void _startKMLGenerator() {
    _kmlTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      List<List<LatLng>> points = [];
      for (final vessel in aisData.values) {
        try {
          points.add(generatePolygonPoints(
              LatLng(vessel.message!.positionReport!.latitude!,
                  vessel.message!.positionReport!.longitude!),
              0.5,
              1));
        } catch (e) {
          print(e);
        }
      }
      print("Setting ${points.length} polygons");
      dataHandler.setNewPolygons!(points);
    });
  }

  Map<String, AisData> getAISData()
  {
    return aisData;
  }


}
