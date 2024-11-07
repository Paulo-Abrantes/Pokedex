import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/widgets/pokemon_card.dart';
import '../../../domain/pokemon.dart';
import '../../data/database/dao/pokemon_dao.dart';
import '../../data/database/database_mapper.dart';
import '../../data/network/client/api_client.dart';
import '../../data/network/network_mapper.dart';
import '../../data/repository/pokemon_repository_impl.dart';

class PokemonRandomDay extends StatefulWidget {
  @override
  _PokemonRandomDayState createState() => _PokemonRandomDayState();
}

class _PokemonRandomDayState extends State<PokemonRandomDay> {
  Pokemon? _pokemon;
  final ApiClient _apiClient = ApiClient(baseUrl: "http://192.168.1.68:3000"); // Substitua com sua URL base
  late final PokemonRepositoryImpl _pokemonRepository;

  @override
  void initState() {
    super.initState();

    // Initialize the repository with the _apiClient after the instance is created
    _pokemonRepository = PokemonRepositoryImpl(
      apiClient: _apiClient,
      networkMapper: NetworkMapper(),
      pokemonDao: PokemonDao(),
      databaseMapper: DatabaseMapper(),
    );

    _fetchRandomPokemon(); // Busca automaticamente um Pokémon ao abrir a tela
  }

  // Função para buscar um Pokémon aleatório da API ou do banco de dados
  Future<void> _fetchRandomPokemon() async {
    try {
      int id = Random().nextInt(151) + 1; // Exemplo de ID entre 1 e 151
      final response = await _apiClient.getPokemonById(id); // Tenta buscar pela API

      if (response != null) {
        setState(() {
          _pokemon = response; // Se a resposta for válida, exibe o Pokémon da API
        });
      } else {
        throw Exception('Erro ao buscar Pokémon da API');
      }
    } catch (e) {
      print("Erro ao buscar Pokémon na API: $e");
      // Caso a API não retorne, tenta pegar o Pokémon aleatório do banco de dados
      try {
        final pokemonFromDb = await _pokemonRepository.getRandomPokemon();
        setState(() {
          _pokemon = pokemonFromDb; // Exibe o Pokémon do banco de dados
        });
      } catch (dbError) {
        print("Erro ao buscar Pokémon no banco: $dbError");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/mato.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_pokemon != null)
                  PokemonCard(
                    pokemon: _pokemon!,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchRandomPokemon,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                  ),
                  child: const Text(
                    'Capturar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
