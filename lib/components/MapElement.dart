import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../data_class/ais_data.dart';
import '../generated/assets.dart';

class MapElement extends StatefulWidget {
  MapElement({super.key, required this.onMapReady, required this.handlerCallback});

  Function(GoogleMapController) onMapReady;
  final Function handlerCallback;
  @override
  State<MapElement> createState() => _MapElementState();
}

class _MapElementState extends State<MapElement> {
  List<List<LatLng>> points = [];
  List<AisData> aisData = [];
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
      consumeTapEvents: true,
      fillColor: Colors.white,
      strokeColor: Colors.black,
      points: points,
      strokeWidth: 1,
      onTap: () {
        Get.dialog(
            Center(
              child: Material(
                borderRadius: BorderRadius.circular(35.0),
                child: Container(
                  width: 500,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Assets.assetsShip,width: 50.0,height: 50.0,),
                            SizedBox(width: 20.0,),
                            Text(
                              '${aisData[i].metaData?.shipName.toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey,),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildItem('Speed Over Ground : ', aisData[i].message?.positionReport?.sog.toString()),
                                _buildItem('Course Over Ground : ', aisData[i].message?.positionReport?.cog.toString()),
                                _buildItem('Navigation Status : ', aisData[i].message?.positionReport?.navigationalStatus.toString()),
                                _buildItem('Rate of Turn : ', aisData[i].message?.positionReport?.rateOfTurn.toString()),
                                _buildItem('Last Known Position : ', 'Latitude ${aisData[i].message?.positionReport?.latitude.toString()}, Longitude ${aisData[i].message?.positionReport?.longitude.toString()}'),
                                _buildItem('Ship Name : ', aisData[i].metaData?.shipName.toString()),
                                _buildItem('MMSI : ', aisData[i].metaData?.mmsi.toString()),
                                _buildItem('Time UTC : ', aisData[i].metaData?.timeUtc.toString()),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      }
    );
  }
  Widget _buildElevatedSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      width: 100,
      height: 100,
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
           Column(
             mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Assets.assetsShip,width: 50.0,height: 50.0,),
                    SizedBox(width: 20.0,),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: items,
                )
              ],
            ),

        ],
      ),
    );
  }

  Widget _buildItem(String label, String? value) {
    return Container(
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
  setNewPolygons(List<List<LatLng>> pts,List<AisData> ais)
  {
    points.clear();
    points.addAll(pts);
    aisData.addAll(ais);
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
