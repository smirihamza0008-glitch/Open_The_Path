import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'player_component.dart';
import 'finish_line_component.dart';
import 'tap_obstacle_component.dart';
import 'slice_obstacle_component.dart';

class OpenThePathGame extends FlameGame with HasCollisionDetection, TapDetector, DragDetector {
  late PlayerComponent player;
  late FinishLineComponent finishLine;

  final Function() gameOver;
  final Function() onLevelComplete;

  OpenThePathGame({
    required this.gameOver,
    required this.onLevelComplete,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    startLevel();
  }

  void startLevel() {
    removeAll(children);

    // إضافة اللاعب في اليسار
    player = PlayerComponent(
      position: Vector2(50, size.y / 2 - 20),
      size: Vector2(40, 40),
      playerColor: const Color(0xfffff007f),
    );
    add(player);

    // إضافة خط النهاية في أقصى اليمين
    finishLine = FinishLineComponent(
      position: Vector2(size.x - 60, 0),
      size: Vector2(20, size.y),
    );
    add(finishLine);

    // ابتكار وتوليد العقبات في منتصف مسار اللاعب هندسياً
    // عائق النقر المتعدد الموجود في الثلث الأول من المرحلة
    add(TapObstacleComponent(
      position: Vector2(size.x * 0.3, size.y / 2 - 40),
      size: Vector2(50, 80),
    ));

    // عائق السحب الموجود في الثلث الثاني من المرحلة
    add(SlideObstacleComponent(
      position: Vector2(size.x * 0.6, size.y / 2 - 50),
      size: Vector2(40, 100),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // التحقق من الفوز
    if (player.position.x + player.size.x >= finishLine.position.x) {
      player.speed = 0;
      onLevelComplete();
    }
  }

  void triggerGameOver() {
    player.speed = 0;
    gameOver();
  }
}
