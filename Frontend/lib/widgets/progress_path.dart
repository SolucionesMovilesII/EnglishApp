import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/episode.dart';

class ProgressPath extends StatefulWidget {
  final List<Episode> episodes;
  final Size screenSize;

  const ProgressPath({
    super.key,
    required this.episodes,
    required this.screenSize,
  });

  @override
  State<ProgressPath> createState() => _ProgressPathState();
}

class _ProgressPathState extends State<ProgressPath>
    with TickerProviderStateMixin {
  late AnimationController _sparkleController;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_sparkleController);

    _sparkleController.repeat();
  }

  @override
  void dispose() {
    _sparkleController.dispose();
    super.dispose();
  }

  List<Offset> _getEpisodePositions() {
    final width = widget.screenSize.width;
    final height = widget.screenSize.height;
    
    return [
      Offset(width * 0.2, height * 0.15),  // Episode 1: 20% from left, 15% from top
      Offset(width * 0.7, height * 0.25),  // Episode 2: 70% from left, 25% from top
      Offset(width * 0.25, height * 0.45), // Episode 3: 25% from left, 45% from top
      Offset(width * 0.65, height * 0.55), // Episode 4: 65% from left, 55% from top
      Offset(width * 0.45, height * 0.75), // Episode 5: 45% from left, 75% from top
    ];
  }

  @override
  Widget build(BuildContext context) {
    final positions = _getEpisodePositions();
    
    return CustomPaint(
      size: widget.screenSize,
      painter: _PathPainter(
        episodes: widget.episodes,
        positions: positions,
        sparkleAnimation: _sparkleAnimation,
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  final List<Episode> episodes;
  final List<Offset> positions;
  final Animation<double> sparkleAnimation;

  _PathPainter({
    required this.episodes,
    required this.positions,
    required this.sparkleAnimation,
  }) : super(repaint: sparkleAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final sparklePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.amber;

    // Draw winding path between episodes
    for (int i = 0; i < positions.length - 1; i++) {
      final start = positions[i];
      final end = positions[i + 1];
      final episode = episodes[i];
      
      // Path color based on next episode status
      if (episodes[i + 1].status == EpisodeStatus.locked) {
        pathPaint.color = Colors.grey.shade300;
      } else {
        pathPaint.color = Colors.grey.shade500;
      }

      // Crear path curvo (serpenteante)
      final path = Path();
      path.moveTo(start.dx, start.dy);
      
      // Control points para curva suave
      final midX = (start.dx + end.dx) / 2;
      final midY = (start.dy + end.dy) / 2;
      final controlX = midX + (i % 2 == 0 ? 30 : -30); // Alternar curvatura
      final controlY = midY;
      
      path.quadraticBezierTo(controlX, controlY, end.dx, end.dy);
      
      // Draw dashed path
      _drawDashedPath(canvas, path, pathPaint);
      
      // Add sparkle particles on completed paths
      if (episode.status == EpisodeStatus.completed && 
          episodes[i + 1].status != EpisodeStatus.locked) {
        _drawSparkles(canvas, path, sparklePaint);
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      
      while (distance < metric.length) {
        final length = draw ? dashWidth : dashSpace;
        final end = (distance + length).clamp(0.0, metric.length);
        
        if (draw) {
          final extractPath = metric.extractPath(distance, end);
          canvas.drawPath(extractPath, paint);
        }
        
        distance += length;
        draw = !draw;
      }
    }
  }

  void _drawSparkles(Canvas canvas, Path path, Paint paint) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      // Draw 3-4 particles along the path
      for (int i = 0; i < 3; i++) {
        final progress = (sparkleAnimation.value + i * 0.3) % 1.0;
        final distance = metric.length * progress;
        final tangent = metric.getTangentForOffset(distance);
        
        if (tangent != null) {
          final sparkleSize = 4.0 + 2.0 * math.sin(sparkleAnimation.value * math.pi * 2);
          canvas.drawCircle(
            tangent.position,
            sparkleSize,
            paint..color = Colors.amber.withValues(alpha: 0.8),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}