import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oil_guard/components/alert_system.dart';
import 'package:oil_guard/components/collision_prediction.dart';
import 'package:oil_guard/components/home.dart';
import 'package:oil_guard/components/vessel_tracking.dart';
import 'package:oil_guard/constants/my_colors.dart';
import 'package:oil_guard/generated/assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart'
    '';

import '../utils/ais_data_fetcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late GoogleMapController _mapController;
  late AisDataFetcher aisDataFetcher;

  @override
  void initState() {
    aisDataFetcher = Get.find();
    aisDataFetcher.connectSocket();
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  List<Widget> widgetList = [
    const Home(),
    const VesselTracking(),
    const CollisionPrediction(),
    const AlertSystem(),
  ];
  int i = 0;

  bool _isRightSidebarOpen = false;

  void _toggleRightSidebar() {
    setState(() {
      _isRightSidebarOpen = !_isRightSidebarOpen;
    });
  }

  // double screenWidth = 0;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   screenWidth = MediaQuery.of(context).size.width;
  // }

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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  i = 0;
                });
                // Update the state of the app.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Vessel tracking'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  i = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Collision'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  i = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Alert system'),
              onTap: () {
                setState(() {
                  i = 3;
                });
                // Update the state of the app.
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // FloatingArrow(
              //   isOpen: _isRightSidebarOpen,
              //   onTap: _toggleRightSidebar,
              // ),
              Expanded(
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: _onMapCreated,
                ),
              ),
              Transform.translate(
                offset: const Offset(-30, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: !_isRightSidebarOpen ? 30 : 30 + MediaQuery.of(context).size.width/3, // Change width based on isCollapsed
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Sidebar content goes here
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          onTap: _toggleRightSidebar,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              topRight: Radius.circular(0.0),
                              bottomRight: Radius.circular(0.0),
                            ),
                            child: Container(
                              width: 30,
                              height: 30,
                              color: MyColors.backgroundColor,
                              child: Center(
                                child: Icon(
                                  !_isRightSidebarOpen ? Icons.arrow_left : Icons.arrow_right,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          child: widgetList[i]
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),

        ],
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    addKml(_mapController);
  }

  static Future<void> addKml(GoogleMapController mapController) async {
    print('addKml');
    var mapId = mapController.mapId;
    const MethodChannel channel = MethodChannel('flutter.native/helper');
    final MethodChannel kmlchannel = MethodChannel('plugins.flutter.dev/google_maps_android_${mapId}');
    try {
      int kmlResourceId = await channel.invokeMethod('map#addKML');

      var c = kmlchannel.invokeMethod("map#addKML", <String, dynamic>{
        'resourceId': kmlResourceId,
      });
      print('addKml done${c}');
    } on PlatformException catch (e) {
      throw 'Unable to plot map: ${e.message}';
    }catch(e){
      print("error");
      throw 'Unable to plot map${e}';
    }
  }
}
