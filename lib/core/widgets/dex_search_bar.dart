import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/dexter_theme.dart';

class DexSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;
  final FocusNode? focusNode;

  const DexSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
    this.focusNode,
  });

  @override
  State<DexSearchBar> createState() => _DexSearchBarState();
}

class _DexSearchBarState extends State<DexSearchBar>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _shakeController;
  late Animation<double> _focusAnimation;
  late Animation<double> _shakeAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _focusAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    widget.focusNode?.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusController.dispose();
    _shakeController.dispose();
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    final isFocused = widget.focusNode?.hasFocus ?? false;
    if (isFocused != _isFocused) {
      setState(() => _isFocused = isFocused);
      if (isFocused) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    }
  }

  void _onClear() {
    widget.controller.clear();
    widget.onClear?.call();
    _shakeController.forward().then((_) => _shakeController.reset());
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<DexterTokens>();
    
    return AnimatedBuilder(
      animation: Listenable.merge([_focusAnimation, _shakeAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _focusAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
              color: Colors.white.withOpacity(0.9),
              border: Border.all(
                color: _isFocused 
                    ? DexterTokens.dexGreen.withOpacity(0.5)
                    : DexterTokens.dexLeaf.withOpacity(0.2),
                width: _isFocused ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused
                      ? DexterTokens.dexGreen.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: _isFocused ? 20 : 10,
                  spreadRadius: 0,
                  offset: Offset(0, _isFocused ? 8 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DexterTokens.radiusLarge),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.95),
                      Colors.white.withOpacity(0.85),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: _isFocused 
                          ? DexterTokens.dexGreen 
                          : DexterTokens.dexLeaf.withOpacity(0.6),
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        onChanged: widget.onChanged,
                        style: TextStyle(
                          color: DexterTokens.dexInk,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            color: DexterTokens.dexLeaf.withOpacity(0.5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    if (widget.showClearButton && widget.controller.text.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _onClear,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: DexterTokens.dexLeaf.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.close,
                            color: DexterTokens.dexLeaf,
                            size: 18,
                          ),
                        ),
                      ).animate().scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.elasticOut,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    ).slideY(
      begin: 0.2,
      end: 0.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
    );
  }
}
