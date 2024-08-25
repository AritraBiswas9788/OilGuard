import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oil_guard/components/MapElement.dart';
import 'package:oil_guard/data_class/ais_data.dart';
import 'package:web_socket_client/web_socket_client.dart';

class AisDataFetcher extends GetxController {
  late WebSocket socketClient;
  late Timer _kmlTimer;
  var isConnected = false.obs;
  late DataHandler dataHandler;
  Map<String, AisData> aisData = {};
  static const String socketEndpoint = "wss://stream.aisstream.io/v0/stream";
  static const String transactionReq = '''{
    "APIKey": "963147f1d105d72730ec6435e9a408c66cf2fefe",
    "BoundingBoxes": [[[18,-98],[30,-81]]]
}''';
  double height = 1;
  double width = 0.5;

  // Function to rotate a point around a given center by a specific angle
  LatLng rotatePoint(LatLng point, LatLng center, double angle) {
    double radian = angle * pi / 180; // Convert angle to radians

    // Translate point to origin
    double tempLat = point.latitude - center.latitude;
    double tempLng = point.longitude - center.longitude;

    // Apply rotation
    double rotatedLat = tempLat * cos(radian) - tempLng * sin(radian);
    double rotatedLng = tempLat * sin(radian) + tempLng * cos(radian);

    // Translate back to original position
    return LatLng(rotatedLat + center.latitude, rotatedLng + center.longitude);
  }
  List<LatLng> generatePolygonPoints(
      LatLng center, double width, double height, double angle) {
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

    // Rotate each point around the center by the specified angle
    for (int i = 0; i < points.length; i++) {
      points[i] = rotatePoint(points[i], center, angle);
    }

    return points;
  }

  connectSocket() async {
    try {
      const timeout = Duration(seconds: 10);
      socketClient = WebSocket(Uri.parse(socketEndpoint), timeout: timeout);
      await socketClient.connection.firstWhere(
          (state) => (state is Connected) || (state is Reconnected));
      isConnected.value = true;
      socketClient.connection.listen((state){
        if(state is Disconnected)
          {isConnected.value = false;}
      });
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
          //print(aisData.length);
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  closeSocketConnection() {
    socketClient.close();
    _kmlTimer.cancel();
    isConnected.value = false;
  }

  void setDataHandler(DataHandler handler)
  {
    dataHandler = handler;
  }

  void _startKMLGenerator() {
    _kmlTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      List<List<LatLng>> points = [];
      List<AisData> data = [];
      for (final vessel in aisData.values) {
        try {
          points.add(generatePolygonPoints(
              LatLng(vessel.message!.positionReport!.latitude!,
                  vessel.message!.positionReport!.longitude!),
              width,
              height,
            vessel.message!.positionReport!.cog!
          ));
          data.add(vessel);
        } catch (e) {
          print(e);
        }
      }
      print("Setting ${points.length} polygons");
      dataHandler.setNewPolygons!(points,data);
    });
  }

  Map<String, AisData> getAISData()
  {
    return aisData;
  }

  void scaleUp() {
    height*=2;
    width*=2;
    List<List<LatLng>> points = [];
    List<AisData> data = [];
    for (final vessel in aisData.values) {
      try {
        points.add(generatePolygonPoints(
            LatLng(vessel.message!.positionReport!.latitude!,
                vessel.message!.positionReport!.longitude!),
            width,
            height,
            vessel.message!.positionReport!.cog!
        ));
        data.add(vessel);
      } catch (e) {
        //print(e);
      }
    }
    print("Setting ${points.length} polygons");
    dataHandler.setNewPolygons!(points,data);
  }
  void scaleDown() async {
    height/=2;
    width/=2;
    List<List<LatLng>> points = [];
    List<AisData> data = [];

    for (final vessel in aisData.values) {
      try {
        points.add(generatePolygonPoints(
            LatLng(vessel.message!.positionReport!.latitude!,
                vessel.message!.positionReport!.longitude!),
            width,
            height,
            vessel.message!.positionReport!.cog!
        ));
        data.add(vessel);
      } catch (e) {
        print(e);
      }
    }
    print("Setting ${points.length} polygons");
    dataHandler.setNewPolygons!(points,data);
  }
}
