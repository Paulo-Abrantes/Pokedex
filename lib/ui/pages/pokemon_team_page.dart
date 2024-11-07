import 'package:flutter/material.dart';

class PokemonTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/box.png',
              fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
            ),
          ),
        ],
      ),
    );
  }
}
