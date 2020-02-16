import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';

class GameController extends Game {
  Size screenSize;
  double tileSize;

  GameController() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
  }

  void render(Canvas c) {}

  void update(double t) {}

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }
}
