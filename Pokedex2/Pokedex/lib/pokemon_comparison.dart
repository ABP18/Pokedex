import 'package:flutter/material.dart';
import 'pokemon.dart';

class PokemonComparisonScreen extends StatefulWidget {
  final List<Pokemon> allPokemon;

  PokemonComparisonScreen({required this.allPokemon});

  @override
  _PokemonComparisonScreenState createState() => _PokemonComparisonScreenState();
}

class _PokemonComparisonScreenState extends State<PokemonComparisonScreen> {
  Pokemon? selectedPokemon1;
  Pokemon? selectedPokemon2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparador de Pokémon'),
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
                '${selectedPokemon1!.name} vs ${selectedPokemon2!.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ComparisonCard(pokemon1: selectedPokemon1!, pokemon2: selectedPokemon2!),
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
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comparación:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.network(pokemon1.imageUrl, height: 100, fit: BoxFit.cover),
                    Text('${pokemon1.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Image.network(pokemon2.imageUrl, height: 100, fit: BoxFit.cover),
                    Text('${pokemon2.name}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildComparisonRow('Altura:', '${pokemon1.height / 10} m', '${pokemon2.height / 10} m'),
            _buildComparisonRow('Peso:', '${pokemon1.weight / 10} kg', '${pokemon2.weight / 10} kg'),
            _buildComparisonRow('N° Pokédex:', '${pokemon1.id}', '${pokemon2.id}'),
            _buildComparisonRow('Tipo(s):', '${pokemon1.types.join(", ")}', '${pokemon2.types.join(", ")}'),
            _buildComparisonRow('Habilidades:', '${pokemon1.abilities.join(", ")}', '${pokemon2.abilities.join(", ")}'),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value1, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value1),
          Text(value2),
        ],
      ),
    );
  }
}
