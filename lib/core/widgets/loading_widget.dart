import 'dart:math';
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final String message;
  final bool isPart;

  const LoadingWidget({super.key, this.message = '로딩중...', this.isPart = false});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController aniCon;
  late Animation<double> rotation;

  @override
  void initState() {
    super.initState();
    aniCon = AnimationController(duration: Duration(seconds: 1), vsync: this)
      ..repeat(reverse: true);
    rotation = Tween<double>(
      begin: -8 * pi / 180,
      end: 8 * pi / 180,
    ).animate(CurvedAnimation(parent: aniCon, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    aniCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.isPart ? Colors.white : Colors.black54,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: rotation,
                child: Image.asset('assets/images/img_loading.png', width: 60),
                builder: (context, child) {
                  return Transform.rotate(angle: rotation.value, child: child);
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                widget.message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: widget.isPart ? Colors.black87 :Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
