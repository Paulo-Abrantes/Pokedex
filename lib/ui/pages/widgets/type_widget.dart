import 'package:flutter/material.dart';

class TypeWidget extends StatelessWidget {
  final String name;

  const TypeWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Alterado para branco
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.black87, // Cor de texto escura para contraste
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
