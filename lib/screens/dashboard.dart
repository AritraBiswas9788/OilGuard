import 'package:flutter/material.dart';
import 'package:oil_guard/generated/assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late GoogleMapController _mapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.assetsShip,fit: BoxFit.contain,height: 30.0,),
            const SizedBox(width: 15.0,),
            const Text("OIL GUARD",style: TextStyle(color: Colors.white),),
          ],
        ),
        leading: InkWell(
          onTap: (){
          },
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.menu, color: Colors.white,),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [

            ],
          )
        ],
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}
