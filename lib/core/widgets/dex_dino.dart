import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

/// 🦕 Dexter Dino Avatar - The adorable mascot component
class DexDinoAvatar extends StatelessWidget {
  final double size;
  final bool showBloodBag;
  final bool animate;
  final VoidCallback? onTap;
  final bool showHeart;
  final String? customExpression;

  const DexDinoAvatar({
    super.key,
    this.size = 120,
    this.showBloodBag = false,
    this.animate = true,
    this.onTap,
    this.showHeart = false,
    this.customExpression,
  });

  @override
  Widget build(BuildContext context) {
    Widget dinoWidget;

    // Choose which dino image to display
    if (showBloodBag) {
      dinoWidget = Image.asset(
        'assets/images/dexterdonatingblood.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    } else {
      dinoWidget = Image.asset(
        'assets/images/dexter.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    // Add container with shadow and optional tap
    Widget container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: DexterTokens.dexLeaf.withOpacity(0.2),
            blurRadius: size * 0.15,
            offset: Offset(0, size * 0.08),
            spreadRadius: 2,
          ),
        ],
      ),
      child: dinoWidget,
    );

    // Add heart emoji for special moments
    if (showHeart) {
      container = Stack(
        alignment: Alignment.center,
        children: [
          container,
          Positioned(
            top: size * 0.1,
            right: size * 0.1,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Text(
                    '💚',
                    style: TextStyle(fontSize: size * 0.2),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // Add tap functionality
    if (onTap != null) {
      container = GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    // Add entrance animation (simplified for now)
    if (animate) {
      // We'll add this back with proper animations later
      // For now just return the container as-is
    }

    return container;
  }
}

/// 🦕 Dino Celebration Widget - For success states
class DexDinoCelebration extends StatelessWidget {
  final String message;
  final VoidCallback? onContinue;

  const DexDinoCelebration({
    super.key,
    required this.message,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Celebrating dino with confetti
        Stack(
          alignment: Alignment.center,
          children: [
            // Confetti particles
            ...List.generate(12, (index) {
              final angle = (index * 30.0) * (3.14159 / 180);
              return Transform.translate(
                offset: Offset(
                  80 * (index % 2 == 0 ? 1 : -1),
                  80 * (index < 6 ? -1 : 1),
                ),
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: [
                      DexterTokens.dexGreen,
                      DexterTokens.dexBlood,
                      DexterTokens.dexGold,
                      DexterTokens.dexBlush,
                      DexterTokens.dinoBodyLight,
                    ][index % 5],
                    shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: index % 3 != 0 ? BorderRadius.circular(2) : null,
                  ),
                ), // Simplified for now - will add animations back later
              );
            }),
            
            // Happy dino with blood bag
            DexDinoAvatar(
              size: 140,
              showBloodBag: true,
              showHeart: true,
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        Text(
          message,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: DexterTokens.dexForest,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ), // Simplified animation for now
        
        if (onContinue != null) ...[
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onContinue,
            child: const Text('Continue 🦕'),
          ), // Simplified animation for now
        ],
      ],
    );
  }
}

/// 🦕 Dino Loading Widget - Cute loading state
class DexDinoLoading extends StatefulWidget {
  final String? message;
  final double size;

  const DexDinoLoading({
    super.key,
    this.message,
    this.size = 100,
  });

  @override
  State<DexDinoLoading> createState() => _DexDinoLoadingState();
}

class _DexDinoLoadingState extends State<DexDinoLoading>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _rotationController.repeat();
    _scaleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: DexDinoAvatar(
                  size: widget.size,
                  showBloodBag: false,
                  animate: false,
                ),
              ),
            );
          },
        ),
        
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: DexterTokens.dexForest.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// 🦕 Dino Empty State - When there's no data
class DexDinoEmpty extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const DexDinoEmpty({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DexDinoAvatar(
          size: 120,
          showBloodBag: false,
          onTap: onAction,
        ),
        
        const SizedBox(height: 24),
        
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: DexterTokens.dexForest,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: DexterTokens.dexForest.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        
        if (actionText != null && onAction != null) ...[
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onAction,
            child: Text(actionText!),
          ),
        ],
      ],
    );
  }
}
