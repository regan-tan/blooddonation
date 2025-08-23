import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

class DexFloatingActionButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double size;
  final bool isExtended;

  const DexFloatingActionButton({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.size = 56.0,
    this.isExtended = false,
  });

  @override
  State<DexFloatingActionButton> createState() => _DexFloatingActionButtonState();
}

class _DexFloatingActionButtonState extends State<DexFloatingActionButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DexterTokens>();
    
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.isExtended ? 28 : widget.size / 2),
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? DexterTokens.dexGreen).withOpacity(
                    _glowAnimation.value * 0.3 + 0.2
                  ),
                  blurRadius: _isPressed ? 25 : 20,
                  spreadRadius: _isPressed ? 8 : 5,
                  offset: Offset(0, _isPressed ? 12 : 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.isExtended ? 28 : widget.size / 2),
                child: Container(
                  width: widget.isExtended ? null : widget.size,
                  height: widget.size,
                  padding: widget.isExtended 
                      ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                      : null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.isExtended ? 28 : widget.size / 2),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.backgroundColor ?? DexterTokens.dexGreen,
                        (widget.backgroundColor ?? DexterTokens.dexGreen).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: widget.isExtended
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.icon,
                              color: widget.foregroundColor ?? Colors.white,
                              size: 24,
                            ),
                            if (widget.label != null) ...[
                              const SizedBox(width: 12),
                              Text(
                                widget.label!,
                                style: TextStyle(
                                  color: widget.foregroundColor ?? Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        )
                      : Icon(
                          widget.icon,
                          color: widget.foregroundColor ?? Colors.white,
                          size: 24,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    ).scale(
      begin: const Offset(0.5, 0.5),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
    );
  }
}
