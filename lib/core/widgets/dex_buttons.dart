import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

/// 🎯 Primary Button - Filled with Dexter Green
class DexPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const DexPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        style: ElevatedButton.styleFrom(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon!, size: 18),
                    const SizedBox(width: 6),
                  ],
                  Flexible(child: Text(text)),
                ],
              ),
      ),
    ).animate().scale(
      duration: 120.ms,
      curve: Curves.easeOut,
    );
  }
}

/// 🎯 Secondary Button - Outlined with Dexter Green
class DexSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const DexSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: isLoading ? null : () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.dexter.primaryColor,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon!, size: 18),
                    const SizedBox(width: 6),
                  ],
                  Flexible(child: Text(text)),
                ],
              ),
      ),
    ).animate().scale(
      duration: 120.ms,
      curve: Curves.easeOut,
    );
  }
}

/// 🎯 Tonal Button - Soft background with color
class DexTonalButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const DexTonalButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    final bgColor = backgroundColor ?? tokens.primaryColor.withOpacity(0.15);
    final fgColor = foregroundColor ?? tokens.primaryColor;

    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed == null ? null : () {
          HapticFeedback.lightImpact();
          onPressed?.call();
        },
        style: TextButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon!, size: 18),
              const SizedBox(width: 6),
            ],
            Text(text),
          ],
        ),
      ),
    ).animate().scale(
      duration: 120.ms,
      curve: Curves.easeOut,
    );
  }
}
