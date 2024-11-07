import 'package:pokedex_app/data/repository/pokemon_repository.dart';

import '../../domain/pokemon.dart';
import '../database/dao/pokemon_dao.dart';
import '../database/database_mapper.dart';
import '../network/client/api_client.dart';
import '../network/network_mapper.dart';

class PokemonRepositoryImpl implements IPokemonRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final PokemonDao pokemonDao; // DAO para o Pokémon
  final DatabaseMapper databaseMapper;

  PokemonRepositoryImpl({
    required this.pokemonDao,
    required this.databaseMapper,
    required this.apiClient,
    required this.networkMapper,
  });

  @override
  Future<List<Pokemon>> getPokemons({required int page, required int limit}) async {
    // Tenta carregar a partir do banco de dados
    final dbEntities = await pokemonDao.selectAll(
        limit: limit, offset: (page * limit) - limit);

    // Se os dados já existem, carrega esses dados
    if (dbEntities.isNotEmpty) {
      return databaseMapper.toPokemons(dbEntities);
    }

    // Caso contrário, busca pela API remota
    final networkEntities =
    await apiClient.getPokemons(page: page, limit: limit);

    final pokemons = networkMapper.toPokemons(networkEntities);
    // E salva os dados no banco local para cache
    pokemonDao.insertAll(databaseMapper.toPokemonDatabaseEntities(pokemons));

    return pokemons;
  }

  // Método para pegar um Pokémon aleatório do banco de dados
  Future<Pokemon> getRandomPokemon() async {
    // Tenta pegar um Pokémon aleatório do banco de dados
    final randomEntity = await pokemonDao.selectRandom();

    if (randomEntity != null) {
      return databaseMapper.toPokemon(randomEntity); // Converte para Pokemon e retorna
    } else {
      // Caso não haja Pokémon no banco de dados, pode-se retornar um Pokémon "de erro" ou um valor padrão
      return Pokemon(
        id: 0,
        name: 'Erro',
        type: [],
        base: null,
      );
    }
  }
}
