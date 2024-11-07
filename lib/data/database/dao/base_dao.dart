import 'package:flutter/material.dart';
import 'package:pokedex_app/data/database/entity/pokemon_database_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseVersion = 1;
  static const _databaseName = 'pokemon_database.db';

  Database? _database;

  @protected
  Future<Database> getDb() async {
    _database ??= await _getDatabase();
    return _database!;
  }

  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, version) async {
        final batch = db.batch();
        _createPokemonsTableV1(batch);
        await batch.commit();
      },
      version: databaseVersion,
    );
  }

  void _createPokemonsTableV1(Batch batch) {
    batch.execute(
      '''
      CREATE TABLE ${PokemonDatabaseContract.pokemonTable} (
        ${PokemonDatabaseContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${PokemonDatabaseContract.nameColumn} TEXT NOT NULL,
        ${PokemonDatabaseContract.hpColumn} INTEGER,
        ${PokemonDatabaseContract.attackColumn} INTEGER,
        ${PokemonDatabaseContract.defenseColumn} INTEGER,
        ${PokemonDatabaseContract.spAttackColumn} INTEGER,
        ${PokemonDatabaseContract.spDefenseColumn} INTEGER,
        ${PokemonDatabaseContract.speedColumn} INTEGER,
        ${PokemonDatabaseContract.type1Column} TEXT,
        ${PokemonDatabaseContract.type2Column} TEXT
      );
      ''',
    );
  }
}
