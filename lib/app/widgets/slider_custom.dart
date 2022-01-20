import 'package:flutter/material.dart';

class SliderCustom extends StatefulWidget {
  final Color? borderTrackColor;
  final double radius;
  final double trackHeight;
  final double thumbSize;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  const SliderCustom({
    Key? key,
    this.borderTrackColor,
    this.radius = 0,
    this.trackHeight = 10,
    this.thumbSize = 15,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
  }) : super(key: key);

  @override
  _SliderCustomState createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: widget.trackHeight,
          inactiveTrackColor: Colors.white,
          activeTrackColor: Colors.black,
          overlayColor: Colors.transparent,
          thumbShape: CustomSliderThumb(
            thumbSize: widget.thumbSize,
          ),
          trackShape: CustomSliderTrack(
            radius: widget.radius,
            borderTrackColor: widget.borderTrackColor,
          ),
        ),
        child: Slider(
          min: widget.min,
          max: widget.max,
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

class CustomSliderThumb extends SliderComponentShape {
  final double thumbSize;

  CustomSliderThumb({
    required this.thumbSize,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    double barHeight = thumbSize;
    final double playedPart = center.dx;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(playedPart - barHeight / 2, center.dy - barHeight),
          Offset(playedPart + barHeight / 2, center.dy + barHeight),
        ),
        const Radius.circular(0.0),
      ),
      Paint()..color = Colors.white,
    );

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final a = Offset(playedPart - barHeight / 2, center.dy - barHeight);
    final b = Offset(playedPart + barHeight / 2, center.dy + barHeight);
    final rect = Rect.fromPoints(a, b);
    canvas.drawRect(rect, paint);

    canvas.drawRect(
      Rect.fromPoints(
        Offset(playedPart - (barHeight / 2) * .4, center.dy - barHeight / 2),
        Offset(playedPart - (barHeight / 2) * .4, center.dy + barHeight / 2),
      ),
      paint,
    );

    canvas.drawRect(
      Rect.fromPoints(
        Offset(playedPart + (barHeight / 2) * .4, center.dy - barHeight / 2),
        Offset(playedPart + (barHeight / 2) * .4, center.dy + barHeight / 2),
      ),
      paint,
    );
  }
}

class CustomSliderTrack extends SliderTrackShape {
  const CustomSliderTrack({
    this.disabledThumbGapWidth = 2.0,
    this.radius = 0,
    this.borderTrackColor,
  });

  final double disabledThumbGapWidth;
  final double radius;
  final Color? borderTrackColor;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight ?? 0;

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;

    final double trackWidth = parentBox.size.width - overlayWidth;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    double horizontalAdjustment = 0.0;
    if (!isEnabled) {
      final double disabledThumbRadius =
          sliderTheme.thumbShape!.getPreferredSize(false, isDiscrete).width /
              2.0;
      final double gap = disabledThumbGapWidth * (1.0 - enableAnimation.value);
      horizontalAdjustment = disabledThumbRadius + gap;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    //Modify this side
    final RRect leftTrackSegment = RRect.fromLTRBR(
        trackRect.left,
        trackRect.top,
        thumbCenter.dx - horizontalAdjustment,
        trackRect.bottom,
        Radius.circular(radius));
    context.canvas.drawRRect(leftTrackSegment, leftTrackPaint);
    final RRect rightTrackSegment = RRect.fromLTRBR(
        thumbCenter.dx + horizontalAdjustment,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        Radius.circular(radius));
    context.canvas.drawRRect(rightTrackSegment, rightTrackPaint);

    final paint = Paint()
      ..color =
          borderTrackColor ?? activeTrackColorTween.evaluate(enableAnimation)!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    context.canvas.drawRRect(rightTrackSegment, paint);
  }
}
