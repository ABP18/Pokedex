import 'package:flutter/material.dart';
import 'pokemon.dart';

class PokemonComparisonScreen extends StatefulWidget {
  final List<Pokemon> allPokemon;

  PokemonComparisonScreen({required this.allPokemon});

  @override
  _PokemonComparisonScreenState createState() =>
      _PokemonComparisonScreenState();
}

class _PokemonComparisonScreenState extends State<PokemonComparisonScreen> {
  Pokemon? selectedPokemon1;
  Pokemon? selectedPokemon2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparación de Pokémon'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<Pokemon>(
                    hint: Text('Selecciona Pokémon 1'),
                    value: selectedPokemon1,
                    onChanged: (Pokemon? newPokemon) {
                      setState(() {
                        selectedPokemon1 = newPokemon;
                      });
                    },
                    items: widget.allPokemon.map((pokemon) {
                      return DropdownMenuItem(
                        value: pokemon,
                        child: Text(pokemon.name),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<Pokemon>(
                    hint: Text('Selecciona Pokémon 2'),
                    value: selectedPokemon2,
                    onChanged: (Pokemon? newPokemon) {
                      setState(() {
                        selectedPokemon2 = newPokemon;
                      });
                    },
                    items: widget.allPokemon.map((pokemon) {
                      return DropdownMenuItem(
                        value: pokemon,
                        child: Text(pokemon.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          if (selectedPokemon1 != null && selectedPokemon2 != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Comparando: ${selectedPokemon1!.name} vs ${selectedPokemon2!.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ComparisonCard(
                pokemon1: selectedPokemon1!, pokemon2: selectedPokemon2!),
          ],
        ],
      ),
    );
  }
}

class ComparisonCard extends StatelessWidget {
  final Pokemon pokemon1;
  final Pokemon pokemon2;

  ComparisonCard({required this.pokemon1, required this.pokemon2});

  @override
  Widget build(BuildContext context) {
    // GIFs de los Pokémon
    String gifPokemon1 = pokemon1.generationSprites["black-white"]?["gif"] ??
        pokemon1.imageUrl;
    String gifPokemon2 = pokemon2.generationSprites["black-white"]?["gif"] ??
        pokemon2.imageUrl;

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparación de Atributos:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Imagen y nombre del Pokémon 1
                Column(
                  children: [
                    Image.network(
                      gifPokemon1,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    Text('${pokemon1.name}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                // Imagen y nombre del Pokémon 2
                Column(
                  children: [
                    Image.network(
                      gifPokemon2,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    Text('${pokemon2.name}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // Comparación de atributos
            Row(
              children: [
                Text('Altura:',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('${pokemon1.height / 10} m vs ${pokemon2.height / 10} m'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Peso:',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('${pokemon1.weight / 10} kg vs ${pokemon2.weight / 10} kg'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Número en la Pokédex:',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('${pokemon1.id} vs ${pokemon2.id}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Tipo(s):',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('${pokemon1.types.join(", ")} vs ${pokemon2.types.join(", ")}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Habilidades:',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Text('${pokemon1.abilities.join(", ")} vs ${pokemon2.abilities.join(", ")}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
