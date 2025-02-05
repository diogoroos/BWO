import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../entities/player/player.dart';
import '../../domain/repositories/server_repository.dart';
import '../../utils/server_utils.dart';

class SocketIoRepository implements ServerRepository {
  io.Socket socket;
  Player _player;

  Function(String) callback;

  void initializeClient(Player player, Function(String) callback) {
    this.callback = callback;

    _player = player;

    socket = io.io(ServerUtils.server, io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());
    socket.opts['path'] = '';
    socket.connect();

    socket.onConnect((data) {
      log("Connected");
      socket.on('onSetup', onSetup);
      socket.on('disconnect', (_) => print('disconnected'));
    });
  }

  void setListener(String event, dynamic Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void socketStatus(dynamic data) {
    print("## Socket status: $data");
  }

  void onSetup(dynamic data) {
    print("## Player ID: $data");
    callback(data);
    if (socket.connected) {
      var jsonData = {
        "name": _player.name,
        "sprite": _player.spriteFolder,
        "x": _player.x.toInt(),
        "y": _player.y.toInt(),
        "hp": _player.status.getHP(),
        "lv": _player.status.getLevel(),
        "xp": _player.status.getExp()
      };
      print(jsonData);
      socket.emit("log-player", jsonData);
    }
  }

  void sendMessage(String tag, dynamic jsonData) {
    if (socket.connected) {
      socket.emit(tag, jsonData);
    } else {
      print('Not connected, fail to send message: $tag');
    }
  }
}
