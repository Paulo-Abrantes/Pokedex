import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/widgets/stat_row_widget.dart';
import 'package:pokedex_app/ui/utils/stat_color.dart';
import '../../domain/pokemon.dart';

import '../../domain/pokemon.dart';

class PokemonDetailsPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsPage({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedId = pokemon.id.toString().padLeft(3, '0');
    String imageUrl =
        'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$formattedId.png';

    int totalStats = pokemon.base.hp +
        pokemon.base.attack +
        pokemon.base.defense +
        pokemon.base.speed +
        pokemon.base.spAttack +
        pokemon.base.spDefense;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: pokemon.baseColor,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported, size: 100),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${pokemon.name} #$formattedId',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Wrap(
                      spacing: 8,
                      children: pokemon.type.map((type) {
                        final color = pokemon.baseColor;
                        return Chip(
                          label: Text(type),
                          backgroundColor: color?.withOpacity(0.7),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Colors.transparent), // Borda removida
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BASE STATS",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: pokemon.baseColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            StatRowWidget(
                              statName: "HP",
                              statValue: pokemon.base.hp,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Attack",
                              statValue: pokemon.base.attack,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Defense",
                              statValue: pokemon.base.defense,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Speed",
                              statValue: pokemon.base.speed,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Special Atk",
                              statValue: pokemon.base.spAttack,
                              getStatColor: getStatColor,
                            ),
                            StatRowWidget(
                              statName: "Special Def",
                              statValue: pokemon.base.spDefense,
                              getStatColor: getStatColor,
                            ),
                            const SizedBox(height: 8),
                            TotalStatRowWidget(
                              statName: "TOTAL",
                              totalValue: totalStats,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
