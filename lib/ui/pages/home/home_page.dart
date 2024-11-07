import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo preenchendo toda a tela
          Positioned.fill(
            child: Image.asset(
              'assets/tela.png',
              fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a tela
            ),
          ),
          // Conteúdo da tela (botões) sobreposto à imagem de fundo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildNavigationButton(
                  context,
                  title: 'Pokédex',
                  routeName: '/pokedex',
                ),
                const SizedBox(height: 20),
                _buildNavigationButton(
                  context,
                  title: 'Encontro Diário',
                  routeName: '/encontroDiario',
                ),
                const SizedBox(height: 20),
                _buildNavigationButton(
                  context,
                  title: 'Meus Pokémons',
                  routeName: '/myPokemons',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context,
      {required String title, required String routeName}) {
    return SizedBox(
      width: 250, // Largura desejada para o botão
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Cor do botão alterada para vermelho
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
