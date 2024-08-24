import 'package:flutter/material.dart';
import 'package:oil_guard/generated/assets.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            print("Fuck you");
          },
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.menu, color: Colors.white,),
          ),
        ),
      ),
      body: Stack(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [

            ],
          )
        ],
      ),
    ));
  }
}
