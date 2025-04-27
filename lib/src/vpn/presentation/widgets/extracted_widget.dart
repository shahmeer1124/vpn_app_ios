

import 'package:flutter/cupertino.dart';
import 'package:openvpn_flutter_example/core/res/colors.dart';

class LeftColumnText extends StatelessWidget {
  const LeftColumnText({
    required this.text,
    required this.color,
    required this.fontSize,
    super.key,
  });
  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        text,
        style: appstyle(fontSize, color, FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class StatusRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  final double width;

  const StatusRow({
    Key? key,
    required this.icon,
    required this.value,
    required this.color,
    this.width = 55,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 8,
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              value,
              style: appstyle(
                8,
                color,
                FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}