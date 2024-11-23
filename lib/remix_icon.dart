import 'package:flutter/material.dart';

class RemixIcon extends StatelessWidget {
  final int icon;
  final double size;
  final Color color;

  const RemixIcon({
    super.key,
    required this.icon,
    this.size = 18.0,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(IconData(
    icon,
    fontFamily: 'Remix',
  ), size: size, color: color);
  }
}