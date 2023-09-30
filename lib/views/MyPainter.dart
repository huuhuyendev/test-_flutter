import 'package:Cordinate/widgets/MyCircle.dart';
import 'package:Cordinate/widgets/MyRectangle.dart';
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  final List<dynamic> shapes;
  final double currentScale; // Thêm biến currentScale

  MyPainter({
    required this.shapes,
    required this.currentScale, // Truyền giá trị currentScale vào MyPainter
  });

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0/currentScale
      ..style = PaintingStyle.stroke;
    double value = 20000;

    final startPointOx = Offset(-value, 0);
    final endPointOx = Offset(value, 0);

    final startPointOy = Offset(0, -value);
    final endPointOy = Offset(0, value);

    canvas.drawLine(startPointOx, endPointOx, paint);
    canvas.drawLine(startPointOy, endPointOy, paint);

    double gap = 100 / currentScale; // Giá trị ban đầu
    int truncatedGap = gap.truncate(); // Bỏ phần thập phân

    gap = (truncatedGap / 50).ceil() * 50; // Làm tròn gap để chia hết cho 5
    if (gap<=50) {
      gap = (truncatedGap / 5).ceil() * 5;
    }

    final scaledFontSize = 14/currentScale;
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: scaledFontSize,
    );
    for (double x = 0; x <= value; x += gap) {
      final tick = Offset(x, 0);
      final text = TextPainter(
        text: TextSpan(
          text: x == 0 ? '0' : (x).toStringAsFixed(0),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      text.layout();
      if (x!=0) {
        text.paint(canvas, Offset(tick.dx - text.width / 2, tick.dy + 5));
      }
    }

    for (double x = 0; x >= -value; x -= gap) {
      final tick = Offset(x, 0);
      final text = TextPainter(
        text: TextSpan(
          text: x == 0 ? '0' : (x).toStringAsFixed(0),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      text.layout();
      if (x!=0) {
        text.paint(canvas, Offset(tick.dx - text.width / 2, tick.dy + 5));
      }
    }
    for (double y = 0; y <= value; y += gap) {
      final tick = Offset(0, -y);

      final text = TextPainter(
        text: TextSpan(
          text: y == 0 ? '0' : (y).toStringAsFixed(0),
          style: textStyle,

        ),
        textDirection: TextDirection.ltr,
      );
      text.layout();
      if (y!=0) {
        text.paint(
            canvas, Offset(tick.dx - text.width - 5, tick.dy - text.height / 2));
      }
    }

    for (double y = 0; y >= -value; y -= gap) {
      final tick = Offset(0, -y);
      final text = TextPainter(
        text: TextSpan(
          text: y == 0 ? '0' : (y).toStringAsFixed(0),
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      text.layout();
      text.paint(
          canvas, Offset(tick.dx - text.width - 5, tick.dy - text.height / 2));
    }

    final gridPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.5/currentScale;

    for (double x = gap; x <= value; x += gap) {
      final startPoint = Offset(x, value);
      final endPoint = Offset(x, -value);
      canvas.drawLine(startPoint, endPoint, gridPaint);

      final startPointNegative = Offset(-x, value);
      final endPointNegative = Offset(-x, -value);
      canvas.drawLine(startPointNegative, endPointNegative, gridPaint);
    }

    for (double y = gap; y <= value; y += gap) {
      final startPoint = Offset(value, -y);
      final endPoint = Offset(-value, -y);
      canvas.drawLine(startPoint, endPoint, gridPaint);

      final startPointNegative = Offset(value, y);
      final endPointNegative = Offset(-value, y);
      canvas.drawLine(startPointNegative, endPointNegative, gridPaint);
    }

    for (final shape in shapes) {
      final paint = Paint()..color = shape.color;
      if (shape is MyRectangle) {
        final translatedRect = shape.rect.translate(
          -size.width / 2,
          -size.height / 2,
        );
        canvas.drawRect(translatedRect, paint);
      } else if (shape is MyCircle) {
        final translatedCenter = shape.center.translate(
          -size.width / 2,
          -size.height / 2,
        );
        canvas.drawCircle(translatedCenter, shape.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
