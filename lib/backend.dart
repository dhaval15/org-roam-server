import 'dart:io';
import 'dart:convert';

import 'models.dart';

class BackEndServer {
  final Graph graph;
  final int port;

  const BackEndServer({
    required this.graph,
    required this.port,
  });

  Future<void> init() async {
    final socket = await HttpServer.bind('localhost', port);
    socket.transform(WebSocketTransformer()).listen(_handle);

    print('Serving at http://${socket.address.host}:${socket.port}');
  }

  void _handle(WebSocket client) async {
    client.add(JsonEncoder().convert(variables));
    client.add(JsonEncoder().convert({
      'type': 'graphdata',
      'data': graph.toJson(),
    }));
  }
}

Map<String, dynamic> variables = {
  "type": "variables",
  "data": {
    "subDirs": [],
    "dailyDir": "",
    "attachDir": "data/",
    "useInheritance": "selective",
    "roamDir": "/data",
    "katexMacros": null
  }
};
