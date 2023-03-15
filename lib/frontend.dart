import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'models.dart';

class FrontEndServer {
  final Graph graph;
  final int port;

  const FrontEndServer({
    required this.graph,
    required this.port,
  });

  Future<void> init() async {
    final cascade = Cascade().add(_staticHandler).add(_router);

    final server = await shelf_io.serve(
      logRequests().addHandler(cascade.handler),
      InternetAddress.anyIPv4,
      port,
    );

    print('Serving at http://${server.address.host}:${server.port}');
  }

  shelf_router.Router get _router =>
      shelf_router.Router()..get('/node/<id>', _handle);

  Response _handle(Request req, String id) {
    final path = graph.nodes.where((node) => node.id == id).first.file;
    final file = File(path);
    final text = file.readAsStringSync();
    return Response.ok(text);
  }
}

final _staticHandler =
    shelf_static.createStaticHandler('public', defaultDocument: 'index.html');
