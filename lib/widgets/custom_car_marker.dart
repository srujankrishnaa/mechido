import 'package:flutter/material.dart';

class CustomCarMarker extends StatelessWidget {
  final double size;
  final double rotation;

  const CustomCarMarker({
    Key? key,
    this.size = 40,
    this.rotation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF635BFF).withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
