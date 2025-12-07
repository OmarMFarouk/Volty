import 'package:flutter/material.dart';

class MyCustomAnimation extends StatelessWidget {
  const MyCustomAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.inverted = false,
  });
  final Widget child;
  final int? duration;
  final Curve? curve;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      curve: curve ?? Curves.elasticOut,
      tween: Tween<Offset>(
        begin: inverted ? Offset(0.3, 0) : Offset(0, 0.3),
        end: Offset.zero,
      ),
      duration: Duration(
        milliseconds: duration == null ? 400 : duration! + 100,
      ),
      builder: (context, offset, _) {
        return Transform.translate(
          offset: inverted
              ? Offset(offset.dx * MediaQuery.of(context).size.width, 0)
              : Offset(0, offset.dy * MediaQuery.of(context).size.height),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            curve: curve ?? Curves.easeInOut,
            duration: Duration(milliseconds: duration ?? 300),
            builder: (context, opacity, _) {
              return Opacity(opacity: opacity, child: child);
            },
          ),
        );
      },
    );
  }
}
