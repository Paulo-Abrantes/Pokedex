import 'base_stats.dart';
import 'package:flutter/material.dart';

class Pokemon {
  final int id;
  final String name;
  final List<String> type;
  final dynamic base;  // Tornando 'base' dinâmico, caso não queira usá-lo

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    this.base,  // 'base' agora é opcional
  });

  // Sobrescrevendo o toString() para imprimir de forma mais legível o Pokémon
  @override
  String toString() {
    return 'Pokemon{id: $id, name: $name, type: $type, base: $base}';
  }

  // Método para desserializar o JSON para um objeto Pokemon com tratamento de erro
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    try {
      return Pokemon(
        // Verificando se 'id' não é nulo antes de convertê-lo para int
        id: json['id'] != null ? int.parse(json['id'].toString()) : 0,  // Usando 0 como valor padrão caso 'id' seja nulo
        name: json['name']['english'] as String,
        type: List<String>.from(json['type'] ?? []),  // Se 'type' for nulo, retorna uma lista vazia
        base: null,  // Já que não está usando o 'base', definimos como null
      );
    } catch (e) {
      // Caso haja algum erro, imprime a mensagem do erro
      print('Erro ao criar Pokémon: $e');
      // Retornando um Pokémon com valores padrão em caso de erro
      var errorPokemon = Pokemon(
        id: 0,
        name: 'Erro',
        type: [],
        base: null,  // Definindo 'base' como null para simplificação
      );
      print("Pokemon gerado com erro: $errorPokemon"); // Imprime o Pokémon de erro
      return errorPokemon;
    }
  }

  // Método para obter a cor base de acordo com o tipo
  Color? get baseColor => colorFromType(type: type[0]);

  static Color? colorFromType({required String type}) {
    switch (type) {
      case 'Normal':
        return Color(0xFFA8A878);
      case 'Fire':
        return Color(0xFFF05030);
      case 'Water':
        return Color(0xFF6890F0);
      case 'Grass':
        return Color(0xFF78C850);
      case 'Flying':
        return Color(0xFFA890F0);
      case 'Fighting':
        return Color(0xFF903028);
      case 'Poison':
        return Color(0xFFA040A0);
      case 'Electric':
        return Color(0xFFF8D030);
      case 'Ground':
        return Color(0xFFE0C068);
      case 'Rock':
        return Color(0xFFB8A038);
      case 'Psychic':
        return Color(0xFFF85888);
      case 'Ice':
        return Color(0xFF98D8D8);
      case 'Bug':
        return Color(0xFF8BD674);
      case 'Ghost':
        return Color(0xFF705898);
      case 'Steel':
        return Color(0xFFB8B8D0);
      case 'Dragon':
        return Color(0xFF7038F8);
      case 'Dark':
        return Color(0xFF705848);
      case 'Fairy':
        return Color(0xFFD685AD);
      default:
        return Colors.grey;
    }
  }
}


