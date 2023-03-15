import 'dart:io';
import 'package:server/frontend.dart';
import 'package:server/backend.dart';
import 'package:server/sql.dart';
import 'package:sqlite3/sqlite3.dart';

void main(List<String> arguments) async {
  final uiPort = int.parse(Platform.environment['UI_PORT'] ?? '35901');
  final backendPort =
      int.parse(Platform.environment['BACKEND_PORT'] ?? '35903');
  final sqlLibPath =
      Platform.environment['SQLITE_LIBRARY_PATH'] ?? '/usr/lib/x86_64-linux-gnu/libsqlite3.so';
  final neuronPath = Platform.environment['NEURON_PATH'] ?? '/Neuron';
  final dbPath = Platform.environment['DB_PATH'] ?? '$neuronPath/neuron.db';
  print('Using sqlite3 ${sqlite3.version}');
  print('Using sqlite library from $sqlLibPath');
  print('Using neuron database at $dbPath');
  final api = SqlApi(dbPath: dbPath, sqlLibPath: sqlLibPath);
  final graph = await api.fetch();
  final frontEnd = FrontEndServer(port: uiPort, graph: graph);
  final backEnd = BackEndServer(port: backendPort, graph: graph);
  await frontEnd.init();
  await backEnd.init();
}
