import 'package:flutter/material.dart';

/// Pulsing microphone when [listening] is true.
class VoiceIndicator extends StatefulWidget {
  const VoiceIndicator({super.key, required this.listening});

  final bool listening;

  @override
  State<VoiceIndicator> createState() => _VoiceIndicatorState();
}

class _VoiceIndicatorState extends State<VoiceIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.listening) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant VoiceIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listening) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    if (!widget.listening) {
      return Icon(Icons.mic_none_rounded, size: 40, color: color.withValues(alpha: 0.35));
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.18);
        return Transform.scale(
          scale: scale,
          child: Icon(Icons.mic_rounded, size: 40, color: color),
        );
      },
    );
  }
}
