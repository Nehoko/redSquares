import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:red_squares/components/enemy_spawner.dart';
import 'package:red_squares/components/health_bar.dart';
import 'package:red_squares/components/highscoreText.dart';
import 'package:red_squares/components/player.dart';
import 'package:red_squares/components/score_text.dart';
import 'package:red_squares/components/start_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/enemy.dart';
import 'components/state.dart';

class GameController extends Game {
  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  Player player;
  EnemySpawner enemySpawner;
  List<Enemy> enemies;
  HealthBar healthBar;
  int score;
  ScoreText scoreText;
  HighscoreText highscoreText;
  StartText startText;
  State state;

  Random rand;

  GameController(this.storage) {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());
    state = State.MENU;
    rand = Random();
    player = Player(this);
    enemies = List<Enemy>();
    enemySpawner = EnemySpawner(this);
    healthBar = HealthBar(this);
    score = 0;
    scoreText = ScoreText(this);
    highscoreText = HighscoreText(this);
    startText = StartText(this);
  }

  void render(Canvas c) {
    player.render(c);
    if (state == State.MENU) {
      startText.render(c);
      highscoreText.render(c);
    } else {
      enemies.forEach((Enemy enemy) => enemy.render(c));
      scoreText.render(c);
      healthBar.render(c);
    }
  }

  @override
  Color backgroundColor() {
    return Color(0xFFFAFAFA);
  }

  void update(double time) {
    if (state == State.MENU) {
      startText.update(time);
      highscoreText.update(time);
    } else {
      enemySpawner.update(time);
      player.update(time);
      enemies.forEach((Enemy enemy) => enemy.update(time));
      enemies.removeWhere((Enemy enemy) => enemy.isDead);
      scoreText.update(time);
      healthBar.update(time);
    }
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 10;
  }

  void onTapDown(TapDownDetails details) {
    if (state == State.MENU) {
      state = State.PLAYING;
    } else {
      enemies.forEach((Enemy enemy) {
        if (enemy.enemyRect.contains(details.globalPosition)) {
          enemy.onTapDown();
        }
      });
    }
  }

  void spawnEnemy() {
    double x, y;
    switch (rand.nextInt(4)) {
      case 0:
        //top
        x = rand.nextDouble() * screenSize.width;
        y = -tileSize * 2.5;
        break;
      case 1:
        //right
        x = screenSize.width + tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
      case 2:
        //bottom
        x = rand.nextDouble() * screenSize.width;
        y = screenSize.height + tileSize * 2.5;
        break;
      case 3:
        //left
        x = -tileSize * 2.5;
        y = rand.nextDouble() * screenSize.height;
        break;
    }
    enemies.add(Enemy(this, x, y));
  }
}
