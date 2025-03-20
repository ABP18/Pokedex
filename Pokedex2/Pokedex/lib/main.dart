import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/PokemonComparisonScreen.dart';
import 'package:pokedex/api_service.dart';
import 'package:pokedex/pokemon.dart';
import 'package:pokedex/pokemon_detail.dart';

void main() {
  runApp(PokedexApp());
}

class PokedexApp extends StatefulWidget {
  @override
  _PokedexAppState createState() => _PokedexAppState();
}

class _PokedexAppState extends State<PokedexApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: PokedexScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }
}

class PokedexScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  PokedexScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> with SingleTickerProviderStateMixin {
  List<Pokemon> displayedPokemon = [];
  List<Pokemon> favoritePokemon = [];
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  bool isSearching = false;
  bool isGridView = true; // Controla si se muestra la vista de cuadrícula o lista
  bool isLoading = true;
  int batchSize = 50;
  String selectedType = "Todos";
  String sortBy = "Número";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadPokemon();
    searchController.addListener(() {
      filterPokemon();
    });
  }

  Future<void> loadPokemon() async {
    await loadPokemonBatch(batchSize);
    setState(() {
      displayedPokemon = List.from(allPokemon);
      isLoading = false;
    });
    loadMorePokemon();
  }

  Future<void> loadMorePokemon() async {
    while (allPokemon.length < 1302) {
      await loadPokemonBatch(batchSize);
      if (mounted) {
        setState(() {
          displayedPokemon = List.from(allPokemon);
        });
      }
    }
  }

  void filterPokemon() {
    String query = searchController.text.toLowerCase();
    setState(() {
      isSearching = query.isNotEmpty;
      displayedPokemon = allPokemon
          .where((pokemon) =>
      (selectedType == "Todos" || pokemon.types.contains(selectedType)) &&
          pokemon.name.toLowerCase().contains(query))
          .toList();
      sortPokemon();
    });
  }

  void sortPokemon() {
    if (sortBy == "Nombre") {
      displayedPokemon.sort((a, b) => a.name.compareTo(b.name));
    } else {
      displayedPokemon.sort((a, b) => a.id.compareTo(b.id));
    }
  }

  void showRandomPokemon() {
    if (displayedPokemon.isNotEmpty) {
      final random = Random();
      int index = random.nextInt(displayedPokemon.length);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PokemonDetail(pokemon: displayedPokemon[index]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        actions: [
          IconButton(
            icon: Icon(Icons.shuffle), // Botón de Pokémon aleatorio
            onPressed: showRandomPokemon,
          ),
          IconButton(
            icon: Icon(Icons.compare_arrows), // Botón del comparador
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonComparisonScreen(allPokemon: allPokemon),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme, // Cambia el tema
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Todos"),
            Tab(text: "Favoritos"),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar Pokémon',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedType,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                      filterPokemon();
                    });
                  },
                  items: ["Todos", "fire", "water", "grass", "electric", "ice", "fighting", "poison", "ground", "flying", "psychic", "bug", "rock", "ghost", "dragon", "dark", "steel", "fairy"]
                      .map((type) => DropdownMenuItem(value: type, child: Text(type.toUpperCase())))
                      .toList(),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: sortBy,
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                      sortPokemon();
                    });
                  },
                  items: ["Número", "Nombre"]
                      .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                      .toList(),
                ),
                IconButton(
                  icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    setState(() {
                      isGridView = !isGridView;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                isLoading ? Center(child: CircularProgressIndicator()) : _buildPokemonList(displayedPokemon),
                _buildPokemonList(favoritePokemon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonList(List<Pokemon> list) {
    if (list.isEmpty) {
      return Center(child: Text('No hay Pokémon en esta categoría.'));
    }
    return isGridView ? _buildGridView(list) : _buildListView(list);
  }

  Widget _buildGridView(List<Pokemon> list) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildPokemonCard(list[index]);
      },
    );
  }

  Widget _buildListView(List<Pokemon> list) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildPokemonCard(list[index]);
      },
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    print('Cargando imagen: ${pokemon.imageUrl}');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetail(pokemon: pokemon),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: getTypeColor(pokemon.types.first), width: 2),
        ),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                pokemon.imageUrl,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red); // Si falla, muestra un icono
                },
              ),
              SizedBox(height: 10),
              Text(
                pokemon.name.toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              IconButton(
                icon: Icon(
                  favoritePokemon.contains(pokemon) ? Icons.favorite : Icons.favorite_border,
                  color: favoritePokemon.contains(pokemon) ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (favoritePokemon.contains(pokemon)) {
                      favoritePokemon.remove(pokemon);
                    } else {
                      favoritePokemon.add(pokemon);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'grass': return Colors.green;
      case 'electric': return Colors.yellow.shade700;
      case 'ice': return Colors.cyan;
      case 'fighting': return Colors.orange;
      case 'poison': return Colors.purple;
      case 'ground': return Colors.brown;
      case 'flying': return Colors.lightBlue;
      case 'psychic': return Colors.pink;
      case 'bug': return Colors.green.shade700;
      case 'rock': return Colors.grey;
      case 'ghost': return Colors.purple.shade700;
      case 'dragon': return Colors.deepPurple;
      case 'dark': return Colors.black;
      case 'steel': return Colors.grey.shade500;
      case 'fairy': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }
}
