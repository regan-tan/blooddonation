import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

class DexEnhancedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isInteractive;
  final double elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Duration animationDuration;

  const DexEnhancedCard({
    super.key,
    required this.child,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.isInteractive = true,
    this.elevation = 8.0,
    this.backgroundColor,
    this.borderRadius,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<DexEnhancedCard> createState() => _DexEnhancedCardState();
}

class _DexEnhancedCardState extends State<DexEnhancedCard>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
    if (widget.isInteractive) {
      _scaleController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.isInteractive) {
      _scaleController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.isInteractive) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DexterTokens>();
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                margin: widget.margin,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(DexterTokens.radiusLarge),
                  color: widget.backgroundColor ?? 
                      tokens?.textColor.withOpacity(0.02) ?? 
                      Colors.white,
                  border: Border.all(
                    color: _isHovered 
                        ? DexterTokens.dexGreen.withOpacity(0.3)
                        : DexterTokens.dexLeaf.withOpacity(0.1),
                    width: _isHovered ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DexterTokens.dexGreen.withOpacity(
                        _glowAnimation.value * 0.1 + 0.05
                      ),
                      blurRadius: widget.elevation + (_isHovered ? 8 : 0),
                      spreadRadius: _isHovered ? 2 : 0,
                      offset: Offset(0, _isHovered ? 4 : 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(DexterTokens.radiusLarge),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    ).slideY(
      begin: 0.3,
      end: 0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }
}
