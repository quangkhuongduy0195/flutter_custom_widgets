import 'dart:math' as math;

import 'package:flutter/material.dart';

class SpeedIndicatorLine extends StatefulWidget {
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
  }) : super(key: key);
  @override
  SpeedIndicatorLineState createState() =>
      SpeedIndicatorLineState(speed, animate);
}

class SpeedIndicatorLineState extends State<SpeedIndicatorLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double _speed;
  bool _animate;

  double lastMarkSpeed = 0;
  double _gaugeMarkSpeed = 0;

  SpeedIndicatorLineState(this._speed, this._animate);

  @override
  void initState() {
    if (_animate) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        updateSpeed(_speed, animate: _animate);
      });
    } else {
      lastMarkSpeed = _speed;
      _gaugeMarkSpeed = _speed;
    }

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _gaugeMarkSpeed =
              lastMarkSpeed + (_speed - lastMarkSpeed) * _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          lastMarkSpeed = _gaugeMarkSpeed;
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeedIndicatorCustomPainter(
        _gaugeMarkSpeed,
        widget.speedTextStyle,
        widget.unitOfMeasurement,
        widget.unitOfMeasurementTextStyle,
        widget.minSpeed,
        widget.maxSpeed,
        widget.activeColor,
        widget.speedWidth,
        widget.inactiveColor,
        widget.fractionDigits,
      ),
      child: widget.child ?? Container(),
    );
  }

  void updateSpeed(double speed, {bool animate = false, Duration? duration}) {
    if (animate) {
      this._speed = speed;
      _controller.reset();
      if (duration != null) _controller.duration = duration;
      _controller.forward();
    } else {
      setState(() {
        lastMarkSpeed = speed;
      });
    }
  }
}

class _SpeedIndicatorCustomPainter extends CustomPainter {
  //We are considering this start angle starting point for gauge view
  final double arcStartAngle = 135;
  final double arcSweepAngle = 270;

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
  );
  @override
  void paint(Canvas canvas, Size size) {
    //get the center of the view
    center = size.center(Offset(0, 0));

    double minDimension = size.width > size.height ? size.height : size.width;
    mRadius = minDimension / 2;

    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = speedWidth;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    //Draw inactive gauge view
    canvas.drawArc(
        Rect.fromCircle(center: center!, radius: mRadius),
        degToRad(arcStartAngle) as double,
        degToRad(arcSweepAngle) as double,
        false,
        paint..color = inactiveColor);

    paint.color = activeColor;

    canvas.drawArc(
        Rect.fromCircle(center: center!, radius: mRadius),
        degToRad(arcStartAngle) as double,
        degToRad(_getAngleOfSpeed(speed)) as double,
        false,
        paint);

    //Going to draw division, Subdivision and Alert Circle
    paint.style = PaintingStyle.fill;

    //Draw Unit of Measurement
    _drawUnitOfMeasurementText(canvas, size);

    //Draw Speed Text
    _drawSpeedText(canvas, size);
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

    Offset unitOfMeasurementOffset = Offset(center!.dx, center!.dy * 1.2);

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
    Offset? unitOfMeasurementOffset = Offset(center!.dx, center!.dy * 0.7);

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
