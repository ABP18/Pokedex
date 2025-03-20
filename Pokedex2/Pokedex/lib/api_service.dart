import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemon.dart';

List<Pokemon> allPokemon = []; // Lista global
bool isLoadingAll = false; // Evita cargar dos veces

Future<void> loadPokemonBatch(int batchSize) async {
  if (isLoadingAll) return;
  isLoadingAll = true;

  int offset = allPokemon.length; // Empezamos donde terminamos
  if (offset >= 1302) return; // Si ya cargamos todos, no hacer nada

  final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$batchSize'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<Future<Pokemon>> futurePokemons = [];

    for (var item in data['results']) {
      futurePokemons.add(_fetchSinglePokemon(item['url']));
    }

    List<Pokemon> newPokemons = await Future.wait(futurePokemons);

    allPokemon.addAll(newPokemons);
  }

  isLoadingAll = false;
}

Future<Pokemon> _fetchSinglePokemon(String url) async {
  final pokeResponse = await http.get(Uri.parse(url));
  if (pokeResponse.statusCode == 200) {
    final pokeData = jsonDecode(pokeResponse.body);

    // Obtener la descripción en español
    final speciesResponse = await http.get(Uri.parse(pokeData['species']['url']));
    String description = 'Sin información';

    if (speciesResponse.statusCode == 200) {
      final speciesData = jsonDecode(speciesResponse.body);
      for (var entry in speciesData['flavor_text_entries']) {
        if (entry['language']['name'] == 'es') {
          description = entry['flavor_text'].replaceAll('\n', ' ');
          break;
        }
      }
    }

    return Pokemon.fromJson(pokeData, description);
  } else {
    throw Exception('Error al cargar un Pokémon');
  }
}
