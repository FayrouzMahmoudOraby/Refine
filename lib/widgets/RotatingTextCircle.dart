import 'dart:math';
import 'package:flutter/material.dart';

class RotatingTextCircle extends StatefulWidget {
  final String dynamicWord;

  const RotatingTextCircle({Key? key, required this.dynamicWord})
    : super(key: key);

  @override
  _RotatingTextCircleState createState() => _RotatingTextCircleState();
}

class _RotatingTextCircleState extends State<RotatingTextCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10), // Adjust speed here
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi, // Full rotation
          child: CustomPaint(
            size: Size(200, 200), // Size of the circle
            painter: CircleTextPainter(widget.dynamicWord),
          ),
        );
      },
    );
  }
}

class CircleTextPainter extends CustomPainter {
  final String text;
  final double radius = 80; // Adjust circle size

  CircleTextPainter(this.text);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < text.length; i++) {
      double angle = (i / text.length) * 2 * pi; // Angle for each letter
      Offset charOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      textPainter.text = TextSpan(
        text: text[i],
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      textPainter.layout();

      canvas.save();
      canvas.translate(charOffset.dx, charOffset.dy);
      canvas.rotate(angle + pi / 2); // Rotate letters correctly
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CircleTextPainter oldDelegate) => oldDelegate.text != text;
}
