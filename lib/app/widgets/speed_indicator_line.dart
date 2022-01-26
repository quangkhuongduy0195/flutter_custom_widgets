import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedIndicatorLine extends StatefulWidget {
  final Function? tapLeft;
  final Function? tapRight;
  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final Color activeColor;

  final double speedWidth;

  final Color inactiveColor;

  final bool animate;
  final Duration duration;
  final int fractionDigits;
  final double heightLine;

  final Widget? child;

  SpeedIndicatorLine({
    GlobalKey? key,
    this.speed = 0,
    this.speedTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 60,
      fontWeight: FontWeight.bold,
    ),
    this.unitOfMeasurement = '',
    this.unitOfMeasurementTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w600,
    ),
    required this.minSpeed,
    required this.maxSpeed,
    this.activeColor = Colors.green,
    this.speedWidth = 10,
    this.inactiveColor = Colors.black12,
    this.animate = false,
    this.duration = const Duration(milliseconds: 400),
    this.fractionDigits = 0,
    this.child,
    this.heightLine = 100,
    this.tapLeft,
    this.tapRight,
  }) : super(key: key);
  @override
  SpeedIndicatorLineState createState() => SpeedIndicatorLineState();
}

class SpeedIndicatorLineState extends State<SpeedIndicatorLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  SpeedIndicatorLineState();

  double _current = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: widget.speed).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    )..addListener(() {
        setState(() {
          _current = _animation.value;
        });
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(SpeedIndicatorLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.speed != widget.speed) {
      if (_controller != null) {
        _animation = Tween(
          begin: oldWidget.speed,
          end: widget.speed,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeIn,
          ),
        );
        _controller.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
  }

  _updateProgress() {
    setState(() => _current = widget.speed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      willChange: true,
      painter: _SpeedIndicatorCustomPainter(
        _current,
        widget.speedTextStyle,
        widget.unitOfMeasurement,
        widget.unitOfMeasurementTextStyle,
        widget.minSpeed,
        widget.maxSpeed,
        widget.activeColor,
        widget.speedWidth,
        widget.inactiveColor,
        widget.fractionDigits,
        context,
        widget.heightLine,
        widget.tapLeft,
        widget.tapRight,
      ),
      child: widget.child ??
          Container(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: widget.heightLine * 0.75,
                  width: widget.speedWidth * 0.25,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTapDown: (i) {
                      // if (controller.count.value > 0) {
                      //   controller.count.value =
                      //       controller.count.value - 1;
                      // }
                      widget.tapLeft?.call();
                    },
                    onLongPress: () {
                      // controller.onDown();
                    },
                    onLongPressEnd: (detail) {
                      // print(detail.localPosition);
                      // controller.onDown(isEnd: true);
                    },
                  ),
                ),
                Container(
                  height: widget.heightLine * 0.75,
                  width: widget.speedWidth * 0.25,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () {},
                    onTapDown: (i) {
                      widget.tapRight?.call();
                    },
                    onLongPress: () {
                      // controller.isUserTouch = true;
                      // controller.onUp();
                    },
                    onLongPressEnd: (detail) {
                      // controller.onUp(isEnd: true);
                      // controller.isUserTouch = false;
                      // controller.onValueToServer();
                    },
                    onTapUp: (t) {
                      // controller.isUserTouch = false;
                      // print(controller.isUserTouch);
                      // controller.onValueToServer();
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void updateSpeed(double speed, {bool animate = false, Duration? duration}) {
    if (animate) {
      _controller.reset();
      if (duration != null) _controller.duration = duration;
      _controller.forward();
    } else {
      setState(() {
        _current = speed;
      });
    }
  }
}

class _SpeedIndicatorCustomPainter extends CustomPainter {
  //We are considering this start angle starting point for gauge view
  final double arcStartAngle = 125;
  final double arcSweepAngle = 290;
  final double heightLine;
  final Function? tapLeft;
  final Function? tapRight;

  final BuildContext context;

  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final Color activeColor;

  final double speedWidth;
  final Color inactiveColor;

  Offset? center;
  double mRadius = 200;

  final int fractionDigits;

  _SpeedIndicatorCustomPainter(
    this.speed,
    this.speedTextStyle,
    this.unitOfMeasurement,
    this.unitOfMeasurementTextStyle,
    this.minSpeed,
    this.maxSpeed,
    this.activeColor,
    this.speedWidth,
    this.inactiveColor,
    this.fractionDigits,
    this.context,
    this.heightLine,
    this.tapLeft,
    this.tapRight,
  );
  @override
  void paint(Canvas canvas, Size size) {
    //get the center of the view
    center = size.center(Offset(0, 0));

    double minDimension = size.width > size.height ? size.height : size.width;
    mRadius = minDimension / 2;

    final w = size.width;
    final h = size.height;
    Paint paint1 = Paint()..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(
      center: Offset(w / 2, h / 2),
      height: h - maxDefinedSize,
      width: w - maxDefinedSize,
    );

    //Draw Unit of Measurement
    _drawUnitOfMeasurementText(canvas, size);

    //Draw Speed Text
    _drawSpeedText(canvas, size);

    _drawIconDown(size, canvas);
    _drawIconUp(size, canvas);

    _drawStepArc(canvas, paint1, rect, size);

    _drawButtonLeft(canvas, paint1, rect, size);
    _drawButtonRight(canvas, paint1, rect, size);

    _drawCurrentStepArc(canvas, paint1, rect, size);
  }

  void _drawIconUp(Size size, Canvas canvas) {
    final icon = Icons.keyboard_arrow_up;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Colors.black,
        fontSize: heightLine / 2,
        fontFamily: icon.fontFamily,
        fontWeight: FontWeight.w400,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );
    textPainter.layout();

    var rectIcon = Offset(
        center!.dx + size.width * 0.06, center!.dy * 1.96 - heightLine / 2);

    textPainter.paint(canvas, rectIcon);
  }

  void _drawIconDown(Size size, Canvas canvas) {
    final icon = Icons.keyboard_arrow_down; //keyboard_arrow_up
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        color: Colors.black,
        fontSize: heightLine / 2,
        fontFamily: icon.fontFamily,
        fontWeight: FontWeight.w400,
        package:
            icon.fontPackage, // This line is mandatory for external icon packs
      ),
    );
    textPainter.layout();

    var rectIcon = Offset(
        center!.dx - size.width * 0.2, center!.dy * 1.96 - heightLine / 2);

    textPainter.paint(canvas, rectIcon);
  }

  void _drawStepArc(
    Canvas canvas,
    Paint paint,
    Rect rect,
    Size size,
  ) {
    var centerX = rect.center.dx;
    var centerY = rect.center.dy;
    var radius = math.min(centerX, centerY);

    var draw = (arcSweepAngle + arcStartAngle) / maxSpeed;
    var stepLine = 3;
    var step = 0;

    for (double i = arcStartAngle;
        i <= arcSweepAngle + arcStartAngle;
        i += stepLine) {
      step++;
      var outerCircleRadius = (radius - (i < draw ? 0 : heightLine / 2));
      var innerCircleRadius = (radius);

      var x1 = centerX + outerCircleRadius * math.cos(degToRad(i));
      var y1 = centerX + outerCircleRadius * math.sin(degToRad(i));
      //
      var x2 = centerX + innerCircleRadius * math.cos(degToRad(i));
      var y2 = centerX + innerCircleRadius * math.sin(degToRad(i));
      var dashBrush = paint
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }

    canvas.drawLine(
        Offset(
            centerX +
                (radius -
                        (arcSweepAngle + arcStartAngle < draw
                            ? 0
                            : heightLine / 2)) *
                    math.cos(degToRad(arcSweepAngle + arcStartAngle)),
            centerX +
                (radius -
                        (arcSweepAngle + arcStartAngle < draw
                            ? 0
                            : heightLine / 2)) *
                    math.sin(degToRad(arcSweepAngle + arcStartAngle))),
        Offset(
            centerX +
                radius * math.cos(degToRad(arcSweepAngle + arcStartAngle)),
            centerX +
                radius * math.sin(degToRad(arcSweepAngle + arcStartAngle))),
        paint
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1);

    var i = 90;
    var outerCircleRadius = (radius - (i < draw ? 0 : heightLine / 2));
    var innerCircleRadius = (radius);

    var x1 = centerX + outerCircleRadius * math.cos(degToRad(i));
    var y1 = centerX + outerCircleRadius * math.sin(degToRad(i));
    //
    var x2 = centerX + innerCircleRadius * math.cos(degToRad(i));
    var y2 = centerX + innerCircleRadius * math.sin(degToRad(i));
    var dashBrush = paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);

    final paintC = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var startLine = 125;
    var endLine = -70;

    canvas.drawArc(
        Rect.fromCircle(center: center!, radius: mRadius),
        degToRad(startLine) as double,
        degToRad(endLine) as double,
        false,
        paintC);

    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(center!.dx, center!.dy),
            radius: mRadius - heightLine / 2),
        degToRad(startLine) as double,
        degToRad(endLine) as double,
        false,
        paintC);
  }

  void _drawCurrentStepArc(
    Canvas canvas,
    Paint paint,
    Rect rect,
    Size size,
  ) {
    var centerX = rect.center.dx;
    var centerY = rect.center.dy;
    var radius = math.min(centerX, centerY);

    var phanTramValue = (((speed - minSpeed) / (maxSpeed - minSpeed))) * 100;
    var viTriHienThi =
        (phanTramValue * (arcSweepAngle) + arcStartAngle * 100) / 100;

    if (viTriHienThi > (arcSweepAngle + arcStartAngle)) {
      viTriHienThi = (arcSweepAngle + arcStartAngle);
    }
    if (viTriHienThi < arcStartAngle) {
      viTriHienThi = arcStartAngle;
    }
    var ii = viTriHienThi; //arcStartAngle + _getAngleOfSpeed(speed);

    var outerCircleRadius2 = (radius - (heightLine * 0.7));
    var innerCircleRadius2 = (radius);
    var x1Current = centerX + outerCircleRadius2 * math.cos(degToRad(ii));
    var y1Current = centerX + outerCircleRadius2 * math.sin(degToRad(ii));
    //
    var x2Current = centerX + innerCircleRadius2 * math.cos(degToRad(ii));
    var y2Current = centerX + innerCircleRadius2 * math.sin(degToRad(ii));
    var dashBrush2 = paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 7;
    canvas.drawLine(
        Offset(x1Current, y1Current), Offset(x2Current, y2Current), dashBrush2);
  }

  void _drawButtonLeft(
    Canvas canvas,
    Paint paint,
    Rect rect,
    Size size,
  ) {
    var startLine = 125;
    var endLine = -70;
    paint.strokeWidth = heightLine / 2;
    paint.strokeCap = StrokeCap.butt;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.transparent;
    canvas.drawArc(
      Rect.fromCircle(center: center!, radius: mRadius - heightLine * 0.25),
      degToRad(startLine) as double,
      degToRad(endLine / 2) as double,
      false,
      paint,
    );
  }

  void _drawButtonRight(
    Canvas canvas,
    Paint paint,
    Rect rect,
    Size size,
  ) {
    var startLine = 125;
    var endLine = -70;
    paint.strokeWidth = heightLine / 2;
    paint.strokeCap = StrokeCap.butt;
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.transparent;
    canvas.drawArc(
      Rect.fromCircle(center: center!, radius: mRadius - heightLine * 0.25),
      degToRad(startLine + endLine / 2) as double,
      degToRad(endLine / 2) as double,
      false,
      paint,
    );
  }

  double get maxDefinedSize {
    return math.max(1, math.max(0, 0));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

  double _getAngleOfSpeed(double speed) {
    //limit speed to max speed
    return (speed < maxSpeed ? speed : maxSpeed) /
        ((maxSpeed - minSpeed) / arcSweepAngle);
  }

  void _drawUnitOfMeasurementText(Canvas canvas, Size size) {
    //Get the center point of the minSpeed and maxSpeed label
    //that would be center of the unit of measurement text

    Offset unitOfMeasurementOffset = Offset(center!.dx, center!.dy * 0.65);

    TextSpan span = new TextSpan(
        style: unitOfMeasurementTextStyle, text: unitOfMeasurement);
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset = unitOfMeasurementOffset.translate(
        -textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }

  void _drawSpeedText(Canvas canvas, Size size) {
    Offset? unitOfMeasurementOffset = Offset(center!.dx, center!.dy * 1.1);

    TextSpan span = new TextSpan(
        style: speedTextStyle, text: speed.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset = unitOfMeasurementOffset.translate(
        -textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }

  static num degToRad(num deg) => deg * (math.pi / 180.0);
}
