import 'dart:math';

import 'package:flutter/material.dart';

class SliderCustom extends StatefulWidget {
  const SliderCustom({
    Key? key,
  }) : super(key: key);

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  double value = 50;

  void seekToRelativePosition(Offset globalPosition) {
    final box = context.findRenderObject() as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    setState(() {
      value = max(0, min(100, relative * 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        seekToRelativePosition(details.globalPosition);
      },
      child: Container(
        height: 20,
        decoration: BoxDecoration(border: Border.all()),
        width: double.infinity,
        child: CustomPaint(
          painter: _ProgressBarPainter(100, value),
        ),
      ),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, this.total);
  final double total;
  final double value;
  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final barHeight = size.height;
    final double baseOffset = barHeight / 2 - barHeight / 2.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(size.width, baseOffset + barHeight),
        ),
        const Radius.circular(0.0),
      ),
      Paint()..color = Colors.white,
    );

    final double playedPartPercent = total / value;
    final double playedPart =
        playedPartPercent > 1 ? size.width : playedPartPercent * size.width;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, baseOffset),
          Offset(playedPart, baseOffset + barHeight),
        ),
        const Radius.circular(0.0),
      ),
      Paint()..color = Colors.black,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(playedPart, -(barHeight / 2), barHeight, barHeight * 2),
        const Radius.circular(0),
      ),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 1
        ..style = PaintingStyle.fill,
    );
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final a = Offset(playedPart, -(barHeight / 2));
    final b = Offset(playedPart + barHeight, barHeight + barHeight / 2);
    final rect = Rect.fromPoints(a, b);
    canvas.drawRect(rect, paint);
    canvas.drawRect(
      Rect.fromPoints(
        Offset(playedPart + barHeight * .3, 0),
        Offset(playedPart + barHeight * .3, barHeight),
      ),
      paint,
    );
    canvas.drawRect(
      Rect.fromPoints(
        Offset(playedPart + barHeight * .7, 0),
        Offset(playedPart + barHeight * .7, barHeight),
      ),
      paint,
    );
  }
}
