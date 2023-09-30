import 'dart:math';

import 'package:Cordinate/views/MyPainter.dart';
import 'package:Cordinate/widgets/MyCircle.dart';
import 'package:Cordinate/widgets/MyRectangle.dart';
import 'package:flutter/material.dart';

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
