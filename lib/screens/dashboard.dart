import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'
    '';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oil_guard/components/MapElement.dart';
import 'package:oil_guard/components/alert_system.dart';
import 'package:oil_guard/components/collision_prediction.dart';
import 'package:oil_guard/components/glassbox.dart';
import 'package:oil_guard/components/home.dart';
import 'package:oil_guard/components/vessel_tracking.dart';
import 'package:oil_guard/constants/my_colors.dart';
import 'package:oil_guard/generated/assets.dart';

import '../utils/ais_data_fetcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late GoogleMapController _mapController;
  late AisDataFetcher aisDataFetcher;
  DataHandler dataHandler = DataHandler();

  @override
  void initState() {
    aisDataFetcher = Get.find();
    aisDataFetcher.connectSocket();
    //setNewData();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.assetsShip,
              fit: BoxFit.contain,
              height: 30.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            const Text(
              "OIL GUARD",
              style: TextStyle(color: Colors.white),
            ),
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
            // const DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: MyColors.backgroundColor,
            //   ),
            //   child: Text('Drawer Header'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      Assets.assetsShip,
                      width: 60,
                    ),
                  ),
                  Text(
                    'Oil Guard',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: Colors.black,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: MyColors.primary,
              ),
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  i = 0;
                });
                removeKML(_mapController);
                // Update the state of the app.
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.track_changes,
                color: MyColors.primary,
              ),
              title: const Text('Vessel tracking'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  i = 1;
                });
                removeKML(_mapController);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.crisis_alert_rounded,
                color: MyColors.primary,
              ),
              title: const Text('Collision'),
              onTap: () {
                // Update the state of the app.
                setState(() {
                  i = 2;
                });
                removeKML(_mapController);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.warning,
                color: MyColors.primary,
              ),
              title: const Text('Alert system'),
              onTap: () {
                setState(() {
                  i = 3;
                });
                addKml(_mapController);
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
                  child: MapElement(
                onMapReady: _onMapCreated,
                handlerCallback: (handler) {
                  dataHandler = handler;
                  aisDataFetcher.setDataHandler(handler);
                },
              )),
              Transform.translate(
                offset: const Offset(-30, 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: !_isRightSidebarOpen
                      ? 30
                      : MediaQuery.of(context).size.width /
                          3, // Change width based on isCollapsed
                  color: Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Sidebar content goes here
                      Container(
                        margin: const EdgeInsets.only(top: 15),
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
                                  !_isRightSidebarOpen
                                      ? Icons.arrow_left
                                      : Icons.arrow_right,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: widgetList[i]),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 100.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GlassBox(
                      height: 75.0,
                      width: 75.0,
                      child: InkWell(
                        onTap: () {
                          aisDataFetcher.scaleUp();
                        },
                        child: const Icon(
                          Icons.arrow_upward_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    GlassBox(
                      height: 75.0,
                      width: 75.0,
                      child: InkWell(
                        onTap: () {
                          aisDataFetcher.scaleDown();
                        },
                        child: const Icon(
                          Icons.arrow_downward_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    //addKml(_mapController);
  }

  static Future<void> addKml(GoogleMapController mapController) async {
    print('addKml');
    var mapId = mapController.mapId;
    const MethodChannel channel = MethodChannel('flutter.native/helper');
    final MethodChannel kmlchannel =
        MethodChannel('plugins.flutter.dev/google_maps_android_${mapId}');
    String kml = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>Untitled Polygon.kml</name>
	<StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="s_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<Style id="s_ylw-pushpin_hl">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<Placemark>
		<name>Untitled Polygon</name>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<Polygon>
			<tessellate>1</tessellate>
			<outerBoundaryIs>
				<LinearRing>
					<coordinates>
						1.968789847662598,1.032332438054204,0 2.030775501330602,0.9726693528318184,0 8.046913954073355,6.979662875552394,0 7.966524661513443,7.029284663505754,0 1.968789847662598,1.032332438054204,0 
					</coordinates>
				</LinearRing>
			</outerBoundaryIs>
		</Polygon>
	</Placemark>
</Document>
</kml>
''';
    try {
      int kmlResourceId = await channel.invokeMethod('map#addKML', kml);

      var c = kmlchannel.invokeMethod("map#addKML", <String, dynamic>{
        'resourceId': kmlResourceId,
      });
      print('addKml done${c}');
    } on PlatformException catch (e) {
      throw 'Unable to plot map: ${e.message}';
    } catch (e) {
      print("error");
      throw 'Unable to plot map${e}';
    }
  }

  static Future<void> removeKML(GoogleMapController mapController) async {
    print('removeKml');
    var mapId = mapController.mapId;
    const MethodChannel channel = MethodChannel('flutter.native/helper');
    final MethodChannel kmlchannel =
    MethodChannel('plugins.flutter.dev/google_maps_android_${mapId}');
    String kml = '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
	<name>Untitled Polygon.kml</name>
	<StyleMap id="m_ylw-pushpin">
		<Pair>
			<key>normal</key>
			<styleUrl>#s_ylw-pushpin</styleUrl>
		</Pair>
		<Pair>
			<key>highlight</key>
			<styleUrl>#s_ylw-pushpin_hl</styleUrl>
		</Pair>
	</StyleMap>
	<Style id="s_ylw-pushpin">
		<IconStyle>
			<scale>1.1</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<Style id="s_ylw-pushpin_hl">
		<IconStyle>
			<scale>1.3</scale>
			<Icon>
				<href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
			</Icon>
			<hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
		</IconStyle>
	</Style>
	<Placemark>
		<name>Untitled Polygon</name>
		<styleUrl>#m_ylw-pushpin</styleUrl>
		<Polygon>
			<tessellate>1</tessellate>
			<outerBoundaryIs>
				<LinearRing>
					<coordinates>
						1.968789847662598,1.032332438054204,0 2.030775501330602,0.9726693528318184,0 8.046913954073355,6.979662875552394,0 7.966524661513443,7.029284663505754,0 1.968789847662598,1.032332438054204,0 
					</coordinates>
				</LinearRing>
			</outerBoundaryIs>
		</Polygon>
	</Placemark>
</Document>
</kml>
''';
    try {
      int kmlResourceId = await channel.invokeMethod('map#removeKML', kml);

      var c = kmlchannel.invokeMethod("map#removeKML", <String, dynamic>{
        'resourceId': kmlResourceId,
      });
      print('removeKml done${c}');
    } on PlatformException catch (e) {
      throw 'Unable to plot map: ${e.message}';
    } catch (e) {
      print("error");
      throw 'Unable to plot map${e}';
    }
  }

  /*void setNewData() async {
    await Future.delayed(Duration(seconds: 3));
    dataHandler.setNewPolygons!([
      [LatLng(25, -90), LatLng(26, 80), LatLng(23, 85)]
    ]);
  }*/
}
