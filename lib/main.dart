import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Wakelock.enable();

  await Flame.device.fullScreen();
  await Flame.device.setPortraitUpOnly();
  var gameController = await GameController();
  await gameController.init();
  runApp(GameWidget(game: gameController));
}
