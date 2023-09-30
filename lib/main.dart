import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyCustomPaint(),
    );
  }
}

class MyRectangle {
  final Rect rect;
  final Color color;

  MyRectangle(this.rect, this.color);
}

class MyCircle {
  final Offset center;
  final double radius;
  final Color color;

  MyCircle(this.center, this.radius, this.color);
}

class MyCustomPaint extends StatefulWidget {
  const MyCustomPaint({Key? key}) : super(key: key);

  @override
  _MyCustomPaintState createState() => _MyCustomPaintState();
}

class _MyCustomPaintState extends State<MyCustomPaint> {
  final List<dynamic> _shapes = [];
  final TransformationController _transformationController = TransformationController();
  double _currentScale = 1.0;
  int zoomInCount = 0; // Thêm biến zoomInCount
  int zoomOutCount = 0; // Thêm biến zoomOutCount

  void onInteractionEnd(ScaleEndDetails details) {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    setState(() {
      _currentScale = currentScale;
    });
  }
  bool isScreenFullyCovered(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final screenSize = MediaQuery.of(context).size;

    // Lấy kích thước của CustomPaint trong tọa độ của màn hình
    final customPaintSize = renderBox.size;

    // So sánh kích thước của CustomPaint và kích thước của màn hình
    return customPaintSize.width >= screenSize.width &&
        customPaintSize.height >= screenSize.height;
  }


  @override
  Widget build(BuildContext context) {
    final MyPainter painter = MyPainter(
      shapes: _shapes,
      currentScale: _currentScale,
    );
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 10,
              onInteractionUpdate: (details) {
              },
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(double.infinity),
              onInteractionEnd: onInteractionEnd,
              child: Transform.translate(
                offset: Offset(
                  MediaQuery.of(context).size.width / 2,
                  MediaQuery.of(context).size.height / 2,
                ),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: painter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              color: Colors.white.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final rectWidth = Random().nextDouble() * 100 + 50;
                        final rectHeight = Random().nextDouble() * 100 + 50;
                        final screenCenterX =
                            MediaQuery.of(context).size.width / 2;
                        final screenCenterY =
                            MediaQuery.of(context).size.height / 2;
                        final rectCenter = _transformationController
                            .toScene(Offset(screenCenterX, screenCenterY));
                        final rect = Rect.fromCenter(
                          center: rectCenter,
                          width: rectWidth,
                          height: rectHeight,
                        );
                        final rectColor = Color.fromRGBO(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          1.0,
                        );
                        setState(() {
                          _shapes.add(MyRectangle(rect, rectColor));
                        });
                      },
                      child: const Text(
                        'Thêm hình chữ nhật',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        final circleRadius = Random().nextDouble() * 50 + 50;
                        final screenCenterX =
                            MediaQuery.of(context).size.width / 2;
                        final screenCenterY =
                            MediaQuery.of(context).size.height / 2;
                        final circleCenter = _transformationController
                            .toScene(Offset(screenCenterX, screenCenterY));
                        final circleColor = Color.fromRGBO(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          1.0,
                        );
                        setState(() {
                          _shapes.add(
                              MyCircle(circleCenter, circleRadius, circleColor));
                        });
                      },
                      child: const Text(
                        'Thêm hình tròn',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_in,),
                    onPressed: () {
                      setState(() {
                        _currentScale += 0.1; // Tăng tỷ lệ phóng to lên 0.1 mỗi lần nhấn
                        _transformationController.value = Matrix4.identity()..scale(_currentScale);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: () {
                      setState(() {
                        _currentScale -= 0.1; // Giảm tỷ lệ phóng to đi 0.1 mỗi lần nhấn
                        _transformationController.value = Matrix4.identity()..scale(_currentScale);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 5),

                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),

                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {
                        _currentScale = 1.0; // Đặt lại tỷ lệ phóng to về giá trị ban đầu
                        _transformationController.value = Matrix4.identity(); // Đặt lại ma trận biến đổi
                      });
                    },
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}

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