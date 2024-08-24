
class AisData {
  Message? message;
  String? messageType;
  MetaData? metaData;

  AisData({this.message, this.messageType, this.metaData});

  AisData.fromJson(Map<String, dynamic> json) {
    if(json["Message"] is Map)
      this.message = json["Message"] == null ? null : Message.fromJson(json["Message"]);
    if(json["MessageType"] is String)
      this.messageType = json["MessageType"];
    if(json["MetaData"] is Map)
      this.metaData = json["MetaData"] == null ? null : MetaData.fromJson(json["MetaData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.message != null)
      data["Message"] = this.message?.toJson();
    data["MessageType"] = this.messageType;
    if(this.metaData != null)
      data["MetaData"] = this.metaData?.toJson();
    return data;
  }
}

class MetaData {
  int? mmsi;
  int? mmsiString;
  String? shipName;
  double? latitude;
  double? longitude;
  String? timeUtc;

  MetaData({this.mmsi, this.mmsiString, this.shipName, this.latitude, this.longitude, this.timeUtc});

  MetaData.fromJson(Map<String, dynamic> json) {
    if(json["MMSI"] is int)
      this.mmsi = json["MMSI"];
    if(json["MMSI_String"] is int)
      this.mmsiString = json["MMSI_String"];
    if(json["ShipName"] is String)
      this.shipName = json["ShipName"];
    if(json["latitude"] is double)
      this.latitude = json["latitude"];
    if(json["longitude"] is double)
      this.longitude = json["longitude"];
    if(json["time_utc"] is String)
      this.timeUtc = json["time_utc"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["MMSI"] = this.mmsi;
    data["MMSI_String"] = this.mmsiString;
    data["ShipName"] = this.shipName;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    data["time_utc"] = this.timeUtc;
    return data;
  }
}

class Message {
  PositionReport? positionReport;

  Message({this.positionReport});

  Message.fromJson(Map<String, dynamic> json) {
    if(json["PositionReport"] is Map)
      this.positionReport = json["PositionReport"] == null ? null : PositionReport.fromJson(json["PositionReport"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.positionReport != null)
      data["PositionReport"] = this.positionReport?.toJson();
    return data;
  }
}

class PositionReport {
  int? cog;
  int? communicationState;
  double? latitude;
  double? longitude;
  int? messageId;
  int? navigationalStatus;
  bool? positionAccuracy;
  bool? raim;
  int? rateOfTurn;
  int? repeatIndicator;
  double? sog;
  int? spare;
  int? specialManoeuvreIndicator;
  int? timestamp;
  int? trueHeading;
  int? userId;
  bool? valid;

  PositionReport({this.cog, this.communicationState, this.latitude, this.longitude, this.messageId, this.navigationalStatus, this.positionAccuracy, this.raim, this.rateOfTurn, this.repeatIndicator, this.sog, this.spare, this.specialManoeuvreIndicator, this.timestamp, this.trueHeading, this.userId, this.valid});

  PositionReport.fromJson(Map<String, dynamic> json) {
    if(json["Cog"] is int)
      this.cog = json["Cog"];
    if(json["CommunicationState"] is int)
      this.communicationState = json["CommunicationState"];
    if(json["Latitude"] is double)
      this.latitude = json["Latitude"];
    if(json["Longitude"] is double)
      this.longitude = json["Longitude"];
    if(json["MessageID"] is int)
      this.messageId = json["MessageID"];
    if(json["NavigationalStatus"] is int)
      this.navigationalStatus = json["NavigationalStatus"];
    if(json["PositionAccuracy"] is bool)
      this.positionAccuracy = json["PositionAccuracy"];
    if(json["Raim"] is bool)
      this.raim = json["Raim"];
    if(json["RateOfTurn"] is int)
      this.rateOfTurn = json["RateOfTurn"];
    if(json["RepeatIndicator"] is int)
      this.repeatIndicator = json["RepeatIndicator"];
    if(json["Sog"] is double)
      this.sog = json["Sog"];
    if(json["Spare"] is int)
      this.spare = json["Spare"];
    if(json["SpecialManoeuvreIndicator"] is int)
      this.specialManoeuvreIndicator = json["SpecialManoeuvreIndicator"];
    if(json["Timestamp"] is int)
      this.timestamp = json["Timestamp"];
    if(json["TrueHeading"] is int)
      this.trueHeading = json["TrueHeading"];
    if(json["UserID"] is int)
      this.userId = json["UserID"];
    if(json["Valid"] is bool)
      this.valid = json["Valid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["Cog"] = this.cog;
    data["CommunicationState"] = this.communicationState;
    data["Latitude"] = this.latitude;
    data["Longitude"] = this.longitude;
    data["MessageID"] = this.messageId;
    data["NavigationalStatus"] = this.navigationalStatus;
    data["PositionAccuracy"] = this.positionAccuracy;
    data["Raim"] = this.raim;
    data["RateOfTurn"] = this.rateOfTurn;
    data["RepeatIndicator"] = this.repeatIndicator;
    data["Sog"] = this.sog;
    data["Spare"] = this.spare;
    data["SpecialManoeuvreIndicator"] = this.specialManoeuvreIndicator;
    data["Timestamp"] = this.timestamp;
    data["TrueHeading"] = this.trueHeading;
    data["UserID"] = this.userId;
    data["Valid"] = this.valid;
    return data;
  }
}