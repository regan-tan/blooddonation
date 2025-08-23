import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

/// 🎯 Dexter Card - Rounded with soft shadow and optional header
class DexCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final IconData? headerIcon;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool showBorder;

  const DexCard({
    super.key,
    required this.child,
    this.title,
    this.headerIcon,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    
    Widget cardContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? tokens.surfaceColor,
        borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        border: showBorder 
            ? Border.all(color: DexterTokens.dexLeaf, width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: DexterTokens.dexLeaf.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DexterTokens.dexLeaf.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: DexterTokens.dexLeaf.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (headerIcon != null) ...[
                      Icon(
                        headerIcon!,
                        color: DexterTokens.dexLeaf,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        title!,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: DexterTokens.dexForest,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: padding ?? const EdgeInsets.all(20),
              child: child,
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
          child: cardContent,
        ),
      );
    }

    return cardContent.animate().fadeIn(
      duration: 200.ms,
      curve: Curves.easeOut,
    ).slideY(
      begin: 0.1,
      duration: 200.ms,
      curve: Curves.easeOut,
    );
  }
}

/// 🎯 Stat Pill - For streak count / lives saved
class DexStatPill extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? color;
  final bool isLarge;

  const DexStatPill({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    final statColor = color ?? tokens.primaryColor;
    
    return Container(
      padding: EdgeInsets.all(isLarge ? 20 : 16),
      decoration: BoxDecoration(
        color: statColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(DexterTokens.radiusMedium),
        border: Border.all(
          color: statColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: statColor,
            size: isLarge ? 32 : 24,
          ),
          SizedBox(height: isLarge ? 12 : 8),
          Text(
            value,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: statColor,
              fontWeight: FontWeight.bold,
              fontSize: isLarge ? 32 : 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: tokens.textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().scale(
      duration: 180.ms,
      curve: Curves.elasticOut,
    );
  }
}

/// 🎯 Badge - Small rounded badge for levels/achievements
class DexBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isPulse;

  const DexBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isPulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.dexter;
    final bgColor = backgroundColor ?? tokens.accentColor;
    final fgColor = textColor ?? Colors.white;
    
    Widget badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(DexterTokens.radiusSmall),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: fgColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (isPulse) {
      badge = badge.animate(onPlay: (controller) => controller.repeat())
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 1000.ms,
            curve: Curves.easeInOut,
          );
    }

    return badge;
  }
}
