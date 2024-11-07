import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final int captureCooldown = 10; // Tempo em segundos para recaptura
  bool _isCaptureButtonDisabled = false; // Controla o estado do botão de captura

  @override
  void initState() {
    super.initState();
    try {
      _pokemonRepository = PokemonRepositoryImpl(
        apiClient: _apiClient,
        networkMapper: NetworkMapper(),
        pokemonDao: PokemonDao(),
        databaseMapper: DatabaseMapper(),
      );
      _loadSavedPokemon();
    } catch (e) {
      print("Erro ao inicializar o repositório: $e");
    }
  }

  Future<void> _loadSavedPokemon() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedId = prefs.getInt('random_pokemon_id');
      final savedDateStr = prefs.getString('random_pokemon_date');

      if (savedId != null && savedDateStr != null) {
        final savedDate = DateTime.parse(savedDateStr);
        final currentTime = DateTime.now();

        // Verifica se o último Pokémon foi capturado dentro do intervalo de 10 segundos
        if (currentTime.difference(savedDate).inSeconds < captureCooldown) {
          setState(() {
            _isCaptureButtonDisabled = true;
          });
          final response = await _apiClient.getPokemonById(savedId);
          if (response != null) {
            setState(() {
              _pokemon = response;
            });
          }
          _showMessage("Captura diária já realizada");

          // Habilita o botão novamente após o intervalo de captura
          Future.delayed(Duration(seconds: captureCooldown), () {
            setState(() {
              _isCaptureButtonDisabled = false;
            });
          });
          return;
        }
      }

      _fetchRandomPokemon();
    } catch (e) {
      print("Erro ao carregar Pokémon salvo: $e");
      _fetchRandomPokemon();
    }
  }

  Future<void> _saveRandomPokemon(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentTime = DateTime.now().toIso8601String();
      await prefs.setInt('random_pokemon_id', id);
      await prefs.setString('random_pokemon_date', currentTime);
    } catch (e) {
      print("Erro ao salvar Pokémon: $e");
    }
  }

  Future<void> _fetchRandomPokemon() async {
    try {
      int id = Random().nextInt(151) + 1;
      final response = await _apiClient.getPokemonById(id);

      if (response != null) {
        setState(() {
          _pokemon = response;
          _isCaptureButtonDisabled = true; // Desativa o botão de captura
        });
        await _saveRandomPokemon(id);
        _showMessage("Pokémon capturado");

        // Reativa o botão após 10 segundos
        Future.delayed(Duration(seconds: captureCooldown), () {
          setState(() {
            _isCaptureButtonDisabled = false;
          });
        });
      } else {
        throw Exception('Erro ao buscar Pokémon da API');
      }
    } catch (e) {
      print("Erro ao buscar Pokémon na API: $e");
      try {
        final pokemonFromDb = await _pokemonRepository.getRandomPokemon();
        setState(() {
          _pokemon = pokemonFromDb;
        });
        _showMessage("Pokémon capturado");
      } catch (dbError) {
        print("Erro ao buscar Pokémon no banco de dados: $dbError");
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
                  onPressed: _isCaptureButtonDisabled ? null : _fetchRandomPokemon,
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