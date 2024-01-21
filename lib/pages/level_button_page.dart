import 'package:flutter/material.dart';

class LevelButton extends StatefulWidget {
  final bool unlocked;
  final VoidCallback? onPressed;
  final String text;

  const LevelButton(
      {super.key,
      required this.unlocked,
      required this.onPressed,
      required this.text});

  @override
  _LevelButtonState createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _controller.forward(),
      onTapUp: (details) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.deepPurple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.text),
              if (widget.unlocked)
                const Icon(Icons.lock_open, color: Colors.green)
              else
                const Icon(Icons.lock, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}
