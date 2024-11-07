import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../domain/exception/network_exception.dart';
import '../entity/http_paged_result.dart';
import '../../../domain/pokemon.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({required String baseUrl}) {
    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
  }

  // Método para buscar uma lista de Pokémon com paginação
  Future<List<PokemonEntity>> getPokemons({int? page, int? limit}) async {
    final response = await _dio.get(
      "/pokedex",
      queryParameters: {
        '_page': page,
        '_per_page': limit,
      },
    );

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw NetworkException(
        statusCode: response.statusCode!,
        message: response.statusMessage,
      );
    } else if (response.statusCode != null) {
      final receivedData =
      HttpPagedResult.fromJson(response.data as Map<String, dynamic>);

      return receivedData.data;
    } else {
      throw Exception('Unknown error');
    }
  }

  // Método para buscar um Pokémon específico pelo ID
  Future<Pokemon> getPokemonById(int id) async {
    try {
      final response = await _dio.get("/pokedex/$id");

      if (response.statusCode != null && response.statusCode! < 400) {
        return Pokemon.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw NetworkException(
          statusCode: response.statusCode!,
          message: response.statusMessage ?? 'Erro ao buscar o Pokémon',
        );
      }
    } catch (e) {
      throw Exception('Erro ao buscar o Pokémon: $e');
    }
  }
}
