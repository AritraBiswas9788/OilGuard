import 'dart:convert';
import 'package:get/get.dart';
import 'package:oil_guard/data_class/ais_data.dart';
import 'package:web_socket_client/web_socket_client.dart';


class AisDataFetcher extends GetxController {
  late WebSocket socketClient;
  Map<String,AisData> aisData = {};
  static const String socketEndpoint = "wss://stream.aisstream.io/v0/stream";
  static const String transactionReq = '''{
    "APIKey": "963147f1d105d72730ec6435e9a408c66cf2fefe",
    "BoundingBoxes": [[[18,-98],[30,-81]]]
}''';

  connectSocket() async
  {
    try{
      const timeout = Duration(seconds: 10);
      socketClient = WebSocket(Uri.parse(socketEndpoint), timeout: timeout);
      await socketClient.connection.firstWhere(
              (state) => (state is Connected) || (state is Reconnected));
      socketClient.send(transactionReq);
      _attachTransactionRecievers();
    }
    catch(e)
    {
      print(e);
    }
  }

  void _attachTransactionRecievers() {
    try{
      socketClient.messages.listen((message) {
        String msg = String.fromCharCodes(message);
        Map<String,dynamic> jsonData = jsonDecode(msg);
        AisData data = AisData.fromJson(jsonData);
        try {
          aisData[data.message!.positionReport!.userId!] = data;
          print(aisData.length);
        }
        catch(e){
          //print(e);
        }
      });
    }catch(e)
    {
      print(e);
    }
  }

  closeSocketConnection() {
    socketClient.close();
  }
}