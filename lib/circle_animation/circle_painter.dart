import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

class CirclePainter extends CustomPainter {
  double position;

  CirclePainter({required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.purple
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paintBack = Paint()
      ..color = const Color.fromARGB(136, 101, 101, 101)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    double finalRadian = position;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2.2),
        math.radians(-90), math.radians(360), false, paintBack);

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2.2),
        math.radians(-90), math.radians(finalRadian), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
