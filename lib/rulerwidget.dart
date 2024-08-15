import 'package:flutter/material.dart';
import 'package:display_metrics/display_metrics.dart';

class RulerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Get device pixel ratio
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
        final metrics = DisplayMetrics.maybeOf(context);
    
        // Get the screen width and height
        var size = View.of(context).physicalSize;
        print('physicalSize width: ${size.width}');
        print('physicalSize height: ${size.height}');

        // Determine the orientation
        bool isPortrait = orientation == Orientation.portrait;

        size = MediaQuery.sizeOf(context);

        final screenWidthPx = size.width * devicePixelRatio;
        final screenHeightPx = size.height * devicePixelRatio;
        print('MediaQuery.sizeOf(context) size.width * devicePixelRatio $screenWidthPx');
        print('MediaQuery.sizeOf(context) size.height * devicePixelRatio $screenHeightPx');

        print('display_metrics ${metrics?.resolution.width.toStringAsFixed(2)} x ${metrics?.resolution.height.toStringAsFixed(2)}');
        print('Diagonal ${metrics?.diagonal.toStringAsFixed(2)}');
        print('display_metrics ppi ${metrics?.ppi.toStringAsFixed(0)}');
       final double pixelsPerMm = metrics?.ppi != null 
          ? (metrics!.ppi / devicePixelRatio / 25.4) 
          : 1;

        // Calculate ruler length in pixels
        double rulerLengthPx;
        if (isPortrait) {
          rulerLengthPx = metrics != null && devicePixelRatio != 0
            ? metrics.resolution.width * devicePixelRatio
            : 0; // Full width for portrait mode
        } else {
          rulerLengthPx = metrics != null && devicePixelRatio != 0
            ? metrics.resolution.height * devicePixelRatio
            : 0; // Full height for landscape mode
        }

        final rulerLengthMm = rulerLengthPx / pixelsPerMm;

        return Container(
          child: CustomPaint(
            size: Size(rulerLengthPx / devicePixelRatio, 50),
            painter: RulerPainter(pixelsPerMm: pixelsPerMm, lengthMm: rulerLengthMm),
          ),
        );
      },
    );
  }
}

class RulerPainter extends CustomPainter {
  final double pixelsPerMm;
  final double lengthMm;

  RulerPainter({required this.pixelsPerMm, required this.lengthMm});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Draw ruler
    final double rulerHeight = size.height;

    for (double mm = 0; mm <= lengthMm; mm++) {
      final double x = mm * pixelsPerMm;

      // Draw tick marks
      paint.strokeWidth = mm % 10 == 0 ? 4 : 2;
      final lineHeight = mm % 10 == 0 ? rulerHeight : rulerHeight/2;
      canvas.drawLine(Offset(x, 0), Offset(x, lineHeight), paint);

      // Draw centimeter labels
      if (mm % 10 == 0) {
        final int value = (mm/10).toInt();
        textPainter.text = TextSpan(
          text: '${value.toStringAsFixed(0)} cm',
          style: const TextStyle(color: Colors.black, fontSize: 14),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, rulerHeight + 10));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
