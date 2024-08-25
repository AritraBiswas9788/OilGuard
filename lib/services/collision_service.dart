import 'dart:math';

import 'package:oil_guard/data_class/ais_data.dart';

class CollisionService {
  CollisionService._internal();

  static final CollisionService _singleton = CollisionService._internal();

  factory CollisionService() => _singleton;

  double toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  double distance(double latt1, double lng1, double latt2, double lng2) {
    double lat1 = toRadians(latt1);
    double lon1 = toRadians(lng1);
    double lat2 = toRadians(latt2);
    double lon2 = toRadians(lng2);

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a = sin(dlat / 2) * sin(dlat / 2) +
        cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double R = 6371000; // Earth radius in meters

    return R * c;
  }

  Map<String, dynamic> cpaTcpa(AisData vessel1, AisData vessel2) {
    // Convert speed and course to velocity components
    try {
      double v1x = (vessel1.message?.positionReport?.sog as double) *
          cos(toRadians(vessel1.message?.positionReport!.cog as double));
      double v1y = (vessel1.message?.positionReport?.sog as double) *
          sin(toRadians(vessel1.message?.positionReport!.cog as double));
      double v2x = (vessel2.message?.positionReport?.sog as double) *
          cos(toRadians(vessel2.message?.positionReport!.cog as double));
      double v2y = (vessel2.message?.positionReport?.sog as double) *
          sin(toRadians(vessel2.message?.positionReport!.cog as double));

      // Relative position and velocity
      double lat1 = vessel1.metaData!.latitude!;
      double lng1 = vessel1.metaData!.longitude!;
      double lat2 = vessel2.metaData!.latitude!;
      double lng2 = vessel2.metaData!.longitude!;
      double rx = lat1 - lat2;
      double ry = lng1 - lng2;
      double vx = v1x - v2x;
      double vy = v1y - v2y;

      // Calculate TCPA
      double dotProductRV = rx * vx + ry * vy;
      double dotProductVV = vx * vx + vy * vy;

      // Check if vessels are on parallel or diverging paths
      bool areParallelOrDiverging = dotProductVV == 0;

      // Ensure dotProductVV is not zero to avoid division by zero
      double tcpa = areParallelOrDiverging ? 0.0 : -dotProductRV / dotProductVV;

      // Ensure TCPA is non-negative (future event)
      tcpa = max(tcpa, 0.0);

      // // Positions at TCPA
      // LatLng vessel1AtTcpa = LatLng(
      //   vessel1.latitude! + v1x * tcpa / 3600.0,
      //   vessel1.longitude! + v1y * tcpa / 3600.0,
      // );
      // LatLng vessel2AtTcpa = LatLng(
      //   vessel2.latitude! + v2x * tcpa / 3600.0,
      //   vessel2.longitude! + v2y * tcpa / 3600.0,
      // );

      // Calculate CPA, return in meters and hours
      double cpa = distance(
        lat1 + v1x * tcpa / 3600.0,
        lng1 + v1y * tcpa / 3600.0,
        lat2 + v2x * tcpa / 3600.0,
        lng2 + v2y * tcpa / 3600.0,
      );

      // Convert TCPA to minutes and CPA to kilometers
      double tcpaInMinutes = tcpa * 60.0;
      double cpaInKilometers = cpa / 1000.0;

      print(
          "tcpa: $tcpaInMinutes minutes, cpa: $cpaInKilometers km, areParallelOrDiverging: $areParallelOrDiverging");

      // Find intersection point (if any)
      // LatLng? collisionPoint;
      // if (tcpa > 0.0) {
      //   collisionPoint = LatLng(
      //     vessel1.latitude! + v1x * tcpa / 3600.0,
      //     vessel1.longitude! + v1y * tcpa / 3600.0,
      //   );
      // }

      return {
        'cpa': cpaInKilometers,
        'tcpa': tcpaInMinutes,
        'collisionLat': lat1 + v1x * tcpa / 3600.0,
        'collisionLng': lng1 + v1y * tcpa / 3600.0,
        'areParallelOrDiverging': areParallelOrDiverging
      };
    } catch (e) {
      return {
        'cpa': 989,
        'tcpa': 78,
        'collisionLat': 3600.0,
        'collisionLng': 3600.0,
        'areParallelOrDiverging': true
      };
    }
  }
}
