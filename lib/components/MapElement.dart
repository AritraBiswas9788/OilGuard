import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapElement extends StatefulWidget {
  MapElement({super.key, required this.onMapReady, required this.handlerCallback});

  Function(GoogleMapController) onMapReady;
  final Function handlerCallback;
  @override
  State<MapElement> createState() => _MapElementState();
}

class _MapElementState extends State<MapElement> {
  List<List<LatLng>> points = [];
  List<Polygon> polygon = [];
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.0, -90.0),
    zoom: 6,
  );



  void initState() {
    super.initState();
    DataHandler handler = DataHandler();
    handler.setNewPolygons = this.setNewPolygons;
    widget.handlerCallback(handler);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: widget.onMapReady,
        polygons: polygon.toSet());
  }

  void reloadMap() {
    setState(() {
      polygon.add(Polygon(polygonId: PolygonId("polygonId"),));
    });
    setState(() {
      polygon.removeLast();
    });
  }

  Polygon calculatePolygon(List<LatLng> points,int i) {
    return Polygon(
      polygonId: PolygonId("polygon $i"),
      fillColor: Colors.white,
      strokeColor: Colors.black,
      points: points,
      strokeWidth: 1
    );
  }
  setNewPolygons(List<List<LatLng>> pts)
  {
    points.clear();
    points.addAll(pts);
    calculateAllPolygons();
    reloadMap();
  }

  void calculateAllPolygons() {
    polygon.clear();
    var i = 0;
    for(List<LatLng> pt in points)
      {
        polygon.add(calculatePolygon(pt,i));
        i++;
      }
    print(polygon.toSet().length);
    print("POLYGONS DONE");
  }

}
class DataHandler {
  Function? setNewPolygons;
}
