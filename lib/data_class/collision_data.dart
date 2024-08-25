

class CollisionData {
  final String vessel1Name;
  final String vessel1Lat;
  final String vessel1Lng;
  final String vessel2Name;
  final String vessel2Lat;
  final String vessel2Lng;
  final String riskLevel;
  final double cpa;
  final double tcpa;

  CollisionData({
    required this.vessel1Name,
    required this.vessel1Lat,
    required this.vessel1Lng,
    required this.vessel2Name,
    required this.vessel2Lat,
    required this.vessel2Lng,
    required this.riskLevel,
    required this.cpa,
    required this.tcpa
  });
}
