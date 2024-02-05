import 'package:flutter/material.dart';
import 'package:math_quest_2_application/utils/color_utils.dart';

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
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
          reverseCurve: Curves.easeIn),
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
        child: Material(
          color: widget.unlocked
              ? hexStringToActualColor("4E899A")
              : hexStringToActualColor("E4BD1F"),
          borderRadius: BorderRadius.circular(15),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(widget.unlocked ? Icons.lock_open : Icons.lock,
                    color: Colors.white, size: 30),
                Text(
                  widget.text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
