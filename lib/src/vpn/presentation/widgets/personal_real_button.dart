import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PersonalRealisticButton extends StatefulWidget {
  final double size;
  final bool isActive; // New parameter to control color
  final Function(bool value) onchange;
  final String label;

  const PersonalRealisticButton({
    super.key,
    required this.size,
    required this.onchange,
    required this.isActive, // Replace initialValue with isActive
    required this.label,
  });

  @override
  State<PersonalRealisticButton> createState() => _RealisticButtonState();
}

class _RealisticButtonState extends State<PersonalRealisticButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 2,
                    offset: Offset(-2, 2),
                  )
                ],
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.size / 2)),
                border: Border.all(
                  width: widget.size / 10,
                  color: const Color(0xff393b3b),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2C2C5), Color(0xFFEEEEEF)],
                ),
              ),
            ),
            Container(
              width: widget.size / 20 * 13,
              height: widget.size / 20 * 13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(widget.size / 20 * 13 / 2)),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEEEEEF), Color(0xFFC2C2C5)],
                ),
              ),
            ),
            Transform.scale(
              scale: _scale,
              child: Container(
                width: widget.size / 7 * 4,
                height: widget.size / 7 * 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(widget.size / 7 * 4 / 2)),
                  border: Border.all(color: Colors.black38),
                  gradient: const RadialGradient(
                    colors: [Color(0xFF48494F), Color(0xFF5C5C64)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: widget.size / 28 * 5,
                      height: widget.size / 28,
                      margin: EdgeInsets.all(widget.size / 28),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.size / 28 / 2),
                        ),
                        color: widget.isActive
                            ? Colors.lightGreenAccent
                            : Colors.redAccent,
                        boxShadow: [
                          BoxShadow(
                            color: widget.isActive
                                ? Colors.lightGreenAccent
                                : Colors.redAccent,
                            blurRadius: widget.size / 28 / 2 * 4,
                            spreadRadius: widget.size / 28 / 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: widget.size / 7 * 4 - widget.size / 28 * 12,
                      width: widget.size / 7 * 3,
                      child: AutoSizeText(
                        widget.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 200,
                          color: Colors.white70,
                        ),
                        minFontSize: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onchange(!widget.isActive); // Notify parent of toggle intent
  }
}
