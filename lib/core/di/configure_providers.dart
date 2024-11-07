import 'package:pokedex_app/data/database/dao/pokemon_dao.dart';
import 'package:pokedex_app/data/database/database_mapper.dart';
import 'package:pokedex_app/data/network/client/api_client.dart';
import 'package:pokedex_app/data/network/network_mapper.dart';
import 'package:pokedex_app/data/repository/pokemon_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final api_client = ApiClient(baseUrl: "http://192.168.1.68:3000");
    final network_mapper = NetworkMapper();
    final database_mapper = DatabaseMapper();
    final pokemon_dao = PokemonDao();

    final pokemon_repository = PokemonRepositoryImpl(
        apiClient: api_client,
        networkMapper: network_mapper,
        databaseMapper: database_mapper,
        pokemonDao: pokemon_dao);

    return ConfigureProviders(providers: [
      Provider<ApiClient>.value(value: api_client),
      Provider<NetworkMapper>.value(value: network_mapper),
      Provider<DatabaseMapper>.value(value: database_mapper),
      Provider<PokemonDao>.value(value: pokemon_dao),
      Provider<PokemonRepositoryImpl>.value(value: pokemon_repository),
    ]);
  }
}
