import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { ONLINE, OFFLINE, CONNECTING }

// ChangeNotifier -> manage the notifications to the widget tree for UI changes or all widgets that use this class
// ChangeNotifier -> This can be changed by Stream Builder ( custom Stream)
class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.CONNECTING;

  final IO.Socket _socket = IO.io('http://192.168.1.72:3000', {
    'transports': ['websocket'],
    'autoConnect': true,
  });

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    this._initConfig();
  }
  void _initConfig() {
    // Dart client

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.ONLINE;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.OFFLINE;
      notifyListeners();
    });

    /* this._socket.on('new-message', (payload) {
      print(payload);
    });*/
  }
}
