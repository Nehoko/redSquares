import 'dart:ui';

import 'package:red_squares/game_controller.dart';

class Player {
  final GameController gameController;
  int maxHealth;
  int currenthealth;
  Rect playerRect;
  bool isDead = false;

  Player(this.gameController) {
    maxHealth = currenthealth = 300;
    final size = gameController.tileSize * 1.5;
    playerRect = Rect.fromLTWH(
        gameController.screenSize.width / 2 - size / 2,
        gameController.screenSize.height / 2 - size /2,
        size,
        size
    );
  }

  void render(Canvas c) {
    Paint playerColor = Paint()..color = Color(0xFF0000FF);
    c.drawRect(playerRect, playerColor);
  }

  void update(double t) {
    if (!isDead && currenthealth <= 0) {
      isDead = true;
      gameController.initialize();
    }
  }
}