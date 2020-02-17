import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:red_squares/game_controller.dart';

class Enemy {

  final GameController gameController;
  int health;
  int damage;
  double speed;
  Rect enemyRect;
  bool isDead = false;

  Enemy(this.gameController, double x, double y) {
    health = 1;
    damage = 1;
    speed = gameController.tileSize * 2;
    enemyRect = Rect.fromLTWH(
        x,
        y,
        gameController.tileSize * 1.2,
        gameController.tileSize * 1.2
    );
  }

  void render(Canvas c) {
    Color color;
    switch (health) {
      case 1:
        color = Colors.red;
        break;
      default:
        color = Color(0xFFFF0000);
    }

    Paint enemyColor = Paint()..color = color;

    c.drawRect(enemyRect, enemyColor);
  }

  void update(double time) {
    if (!isDead) {
      double stepDistance = speed * time;
      Offset toPlayer = gameController.player.playerRect.center - enemyRect.center;
      if (stepDistance <= toPlayer.distance - gameController.tileSize * 1.25) {
        Offset stepToPlayer = Offset.fromDirection(toPlayer.direction, stepDistance);
        enemyRect = enemyRect.shift(stepToPlayer);
      }
      else {
        attack();
      }
    }
  }

  void onTapDown() {
    if (!isDead) {
      health--;
      if (health <= 0) {
        isDead = true;
        gameController.score++;
        print(gameController.score);
        if (gameController.score > (gameController.storage.getInt('highscore') ?? 0)) {
          gameController.storage.setInt("highscore", gameController.score);
        }
      }
    }
  }


  void attack() {
    if (!gameController.player.isDead) {
      gameController.player.currenthealth -= damage;
    }
  }
}