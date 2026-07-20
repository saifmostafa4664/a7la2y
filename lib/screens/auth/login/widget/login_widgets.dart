import 'package:flutter/material.dart';

class SocialLoginButton extends StatefulWidget {
  final String iconAsset;
  final VoidCallback? onTap;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.iconAsset,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _pressController.forward();

  void _onTapUp(TapUpDetails _) {
    _pressController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() => _pressController.reverse();

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.onTap != null && !widget.isLoading;
    return Expanded(
      child: GestureDetector(
        onTapDown: isActive ? _onTapDown : null,
        onTapUp: isActive ? _onTapUp : null,
        onTapCancel: isActive ? _onTapCancel : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEFEFEF),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isLoading
                      ? const SizedBox(
                          key: ValueKey('social_loader'),
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.0,
                          ),
                        )
                      : Image.asset(
                          widget.iconAsset,
                          key: ValueKey(widget.iconAsset),
                          width: 24,
                          height: 24,
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
