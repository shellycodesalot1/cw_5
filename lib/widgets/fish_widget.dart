import 'package:flutter/material.dart';
import 'dart:math';

class FishWidget extends StatefulWidget {
  final double speed;
  final String imageUrl;
  final double size;

  FishWidget({
    required this.speed,
    required this.imageUrl,
    this.size = 50.0,
  });

  @override
  _FishWidgetState createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (10 / widget.speed).toInt()), // Speed affects animation duration
      vsync: this,
    );

    // Random movement animation
    _animation = Tween<Offset>(
      begin: Offset(random.nextDouble(), random.nextDouble()),
      end: Offset(random.nextDouble(), random.nextDouble()),
    ).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Image.network(
        widget.imageUrl,
        width: widget.size,
        height: widget.size,
        errorBuilder: (context, error, stackTrace) {
          // Display an error image or placeholder if the URL is invalid
          return Icon(
            Icons.error,
            color: Colors.red,
            size: widget.size,
          );
        },
      ),
    );
  }
}
