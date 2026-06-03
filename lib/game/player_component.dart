import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'open_the_path_game.dart';

class PlayerComponent extends PositionComponent with HasGameRef<OpenThePathGame>, CollisionCallbacks {
  // سرعة حركة المجسم من اليسار إلى اليمين
  double speed = 150.0;
  
  // تلوين المجسم بناءً على ما اختاره اللاعب من المتجر لاحقاً
  final Color playerColor;

  PlayerComponent({
    required Vector2 position,
    required Vector2 size,
    required this.playerColor,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // إضافة مستطيل استشعار الاصطدام حول المجسم
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // تحريك المجسم تلقائياً من اليسار إلى اليمين بناءً على الوقت المنقضي dt
    position.x += speed * dt;

    // تأمين بقاء المجسم داخل حدود الشاشة العمودية (إن حدث أي تأثير خارجي)
    if (position.y < 0) position.y = 0;
    if (position.y > gameRef.size.y - size.y) {
      position.y = gameRef.size.y - size.y;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // رسم المجسم بشكل نيون متوهج وممتع للعين
    final paint = Paint()
      ..color = playerColor
      ..style = PaintingStyle.fill;

    // رسم ظل متوهج خلف المجسم (Glow Effect)
    final glowPaint = Paint()
      ..color = playerColor.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // رسم تأثير التوهج أولاً ثم المجسم الأساسي فوقه
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), glowPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8)), paint);
  }
}
