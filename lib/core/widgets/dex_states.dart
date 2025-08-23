import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';
import 'dex_buttons.dart';
import 'dex_dino.dart';

/// 🎯 Empty State - Now with adorable Dexter dino!
class DexEmptyState extends StatelessWidget {
  final IconData? icon; // Made optional since we have dino now
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? iconColor;
  final bool useDino;

  const DexEmptyState({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.iconColor,
    this.useDino = true, // Default to using cute dino
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Cute Dexter or fallback icon
            if (useDino)
              DexDinoEmpty(
                title: title,
                message: message,
                actionText: actionText,
                onAction: onAction,
              )
            else ...[
              // Fallback icon illustration
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: (iconColor ?? tokens.primaryColor).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.help_outline,
                  size: 60,
                  color: iconColor ?? tokens.primaryColor,
                ),
              ).animate().scale(
                duration: 300.ms,
                curve: Curves.elasticOut,
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: tokens.textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 100.ms).fadeIn(
                duration: 200.ms,
              ).slideY(
                begin: 0.2,
                duration: 200.ms,
              ),
              
              const SizedBox(height: 16),
              
              // Message
              Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: tokens.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn(
                duration: 200.ms,
              ),
              
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 32),
                DexPrimaryButton(
                  text: actionText!,
                  onPressed: onAction,
                ).animate(delay: 300.ms).fadeIn(
                  duration: 200.ms,
                ).slideY(
                  begin: 0.3,
                  duration: 200.ms,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// 🎯 Loading State - Now with cute Dexter dino!
class DexLoader extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  final bool useDino;

  const DexLoader({
    super.key,
    this.message,
    this.color,
    this.size = 48,
    this.useDino = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    final loaderColor = color ?? tokens.primaryColor;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (useDino)
            DexDinoLoading(
              message: message,
              size: size * 2, // Make dino bigger than icon
            )
          else ...[
            // Fallback cute rotating blood drop
            Icon(
              Icons.water_drop,
              size: size,
              color: loaderColor,
            ).animate(onPlay: (controller) => controller.repeat())
                .rotate(
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                ),
            
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: tokens.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(
                duration: 300.ms,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

/// 🎯 Section Header - Title + optional action
class DexSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const DexSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon!,
              color: tokens.primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: tokens.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: tokens.textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null && onAction != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: tokens.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 🎯 Success Animation with Dexter Dino Celebration!
class DexSuccessAnimation extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinue;

  const DexSuccessAnimation({
    super.key,
    required this.title,
    required this.message,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: DexDinoCelebration(
        message: '$title\n$message',
        onContinue: onContinue,
      ),
    );
  }
}
