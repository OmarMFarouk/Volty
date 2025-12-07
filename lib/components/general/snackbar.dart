import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:volty/src/app_string.dart';

import '../../src/app_colors.dart';

class MySnackBar {
  static void show({
    required BuildContext context,
    required bool isAlert,
    required String text,
    IconData? customIcon,
    int? duration,
  }) {
    FocusManager.instance.primaryFocus?.unfocus();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackBar(
        duration: duration ?? 4,
        isAlert: isAlert,
        text: text,
        customIcon: customIcon,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: duration ?? 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _AnimatedSnackBar extends StatefulWidget {
  final bool isAlert;
  final String text;
  final int duration;
  final IconData? customIcon;
  final VoidCallback onDismiss;

  const _AnimatedSnackBar({
    required this.isAlert,
    required this.text,
    required this.duration,
    this.customIcon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<_AnimatedSnackBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _progressController;
  late AnimationController _iconController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _progressAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    // Start animations
    _slideController.forward();
    _scaleController.forward();
    _progressController.forward();

    Future.delayed(const Duration(milliseconds: 200), () {
      _iconController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _progressController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.primaryGradient;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 50,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: widget.onDismiss,
              onPanUpdate: (details) {
                if (details.delta.dy < -5) {
                  widget.onDismiss();
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),

                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withOpacity(0.3),
                      offset: const Offset(0, 8),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: colors[1].withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 40,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: colors,
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),

                      // Glassmorphism overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),

                      // Animated background particles
                      ...List.generate(
                        5,
                        (index) => AnimatedBuilder(
                          animation: _iconController,
                          builder: (context, child) {
                            return Positioned(
                              left: 20.0 + (index * 40),
                              top: 10 + (index % 2) * 20,
                              child: Transform.scale(
                                scale:
                                    _iconAnimation.value * (0.3 + index * 0.1),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Progress indicator
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            return LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.6),
                              ),
                              minHeight: 3,
                            );
                          },
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                        child: Row(
                          spacing: 16,
                          children: [
                            // Animated icon
                            AnimatedBuilder(
                              animation: _iconAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _iconAnimation.value,
                                  child: Transform.rotate(
                                    angle: (1 - _iconAnimation.value) * 0.5,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.isAlert
                                            ? Colors.red.withOpacity(0.2)
                                            : Colors.green.withOpacity(0.2),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        widget.customIcon ??
                                            (widget.isAlert
                                                ? Icons.error_rounded
                                                : Icons.check_circle_rounded),
                                        color: widget.isAlert
                                            ? Colors.red
                                            : Colors.green,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.isAlert
                                        ? AppString.warning.tr()
                                        : AppString.success.tr(),
                                    style: TextStyle(
                                      color: widget.isAlert
                                          ? Colors.red
                                          : Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.95),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Close button
                            GestureDetector(
                              onTap: widget.onDismiss,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
