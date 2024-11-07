import 'package:flutter/material.dart';
import 'package:pokedex_app/ui/pages/home/home_page.dart';
import 'package:pokedex_app/ui/pages/pokemon_list_page.dart';
import 'package:pokedex_app/ui/pages/pokemon_random_day.dart'; // Nova página de Encontro Diário
import 'package:pokedex_app/ui/pages/pokemon_team_page.dart'; // Nova página de Meus Pokémons
import 'package:provider/provider.dart';

import 'core/di/configure_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await ConfigureProviders.createDependencyTree();

  runApp(AppRoot(data: data));
}

class AppRoot extends StatelessWidget {
  final ConfigureProviders data;

  const AppRoot({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pokedex",
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/pokedex': (context) => PokemonListPage(),
        '/encontroDiario': (context) => PokemonRandomDay(), // Página de Encontro Diário
        '/myPokemons': (context) => PokemonTeamPage(), // Página de Meus Pokémons
        // Adicione outras rotas conforme necessário
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          elevation: 4,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade200),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF355DAA),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
    );
  }
}
