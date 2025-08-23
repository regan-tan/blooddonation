import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

class DexStatusIndicator extends StatefulWidget {
  final bool isOpen;
  final String label;
  final double size;
  final bool showAnimation;

  const DexStatusIndicator({
    super.key,
    required this.isOpen,
    required this.label,
    this.size = 24.0,
    this.showAnimation = true,
  });

  @override
  State<DexStatusIndicator> createState() => _DexStatusIndicatorState();
}

class _DexStatusIndicatorState extends State<DexStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _colorController;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: widget.isOpen ? DexterTokens.dexGreen : Colors.grey,
      end: widget.isOpen ? DexterTokens.dexGreen : Colors.grey,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    if (widget.showAnimation && widget.isOpen) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DexStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      _colorController.forward().then((_) => _colorController.reset());
      if (widget.isOpen && widget.showAnimation) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _colorAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _colorAnimation.value?.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _colorAnimation.value?.withOpacity(0.3) ?? Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: widget.size * 0.4,
                  height: widget.size * 0.4,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _colorAnimation.value?.withOpacity(0.4) ?? Colors.transparent,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: _colorAnimation.value,
                    fontWeight: FontWeight.w600,
                    fontSize: widget.size * 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    ).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
    );
  }
}
