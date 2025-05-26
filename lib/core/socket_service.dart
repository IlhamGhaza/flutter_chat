import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'variabeles.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  late IO.Socket _socket;
  final _storage = FlutterSecureStorage();

  SocketService._internal() {
    initSocket();
  }

  Future<void> initSocket() async {
    String token = await _storage.read(key: 'token') ?? '';
    _socket = IO.io(
      Variables.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders(
            {'Authorization': 'Bearer $token'},
          )
          .build(),
    );
    _socket.connect();
    _socket.on('connect', (_) {
      log('Socket connected : (_socket.id)');
    });
    _socket.onDisconnect((_) {
      log('Socket disconnected : (_socket.id)');
    });
    _socket.onReconnect((_) {
      log('Socket reconnected : (_socket.id)');
    });
    _socket.onReconnectAttempt((_) {
      log('Socket reconnect attempt : (_socket.id)');
    });
    _socket.onReconnectError((_) {
      log('Socket reconnect error : (_socket.id)');
    });
    _socket.onError((_) {
      log('Socket error : (_socket.id)');
    });
  }

  IO.Socket get socket => _socket;
}
