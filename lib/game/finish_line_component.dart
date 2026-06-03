import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class FinishLineComponent extends PositionComponent with CollisionCallbacks {
  FinishLineComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // إضافة مستطيل استشعار الاصطدام لخط النهاية
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // رسم خط النهاية كبوابة ليزر نيونية متوهجة ومتحركة بصرياً
    final paint = Paint()
      ..color = const Color(0xff00ffcc)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final glowPaint = Paint()
      ..color = const Color(0xff00ffcc).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawRect(size.toRect(), glowPaint);
    canvas.drawRect(size.toRect(), paint);

    // رسم بعض الخطوط الداخلية لتبدو كبوابة طاقة مستقبلية
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    
    for (double i = 0; i < size.y; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.x, i + 10), linePaint);
    }
  }
}
