import 'package:flutter/material.dart';
import 'pokemon.dart';
import 'package:audioplayers/audioplayers.dart';

class PokemonDetail extends StatefulWidget {
  final Pokemon pokemon;

  PokemonDetail({required this.pokemon});

  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  bool isShiny = false;
  bool isLocked = false;
  String? selectedGeneration;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void toggleShiny() {
    setState(() {
      isLocked = !isLocked;
      isShiny = isLocked;
    });
  }

  void playCry(String url) async {
    if (url.isNotEmpty) {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicializamos la generación con la de "Pokemon Luna"
    selectedGeneration = "sun-moon";
  }

  @override
  Widget build(BuildContext context) {
    String normalImage = widget.pokemon.generationSprites[selectedGeneration]!["normal"]!;
    String shinyImage = widget.pokemon.generationSprites[selectedGeneration]!["shiny"] ?? normalImage;

    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(widget.pokemon.name.toUpperCase(), style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Dropdown para seleccionar la generación
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: selectedGeneration,
                  onChanged: (String? newValue) {
                    setState(() => selectedGeneration = newValue!);
                  },
                  items: widget.pokemon.generationSprites.keys.map((gen) {
                    return DropdownMenuItem(value: gen, child: Text(gen.toUpperCase()));
                  }).toList(),
                  dropdownColor: Colors.white,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                ),
              ),
              SizedBox(height: 20),

              // Imagen principal cambia con generación y shiny
              MouseRegion(
                onEnter: (_) {
                  if (!isLocked) setState(() => isShiny = true);
                },
                onExit: (_) {
                  if (!isLocked) setState(() => isShiny = false);
                },
                child: GestureDetector(
                  onTap: toggleShiny,
                  child: Column(
                    children: [
                      Image.network(
                        isShiny ? shinyImage : normalImage,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      // Texto indicando si es Shiny o Normal
                      Text(
                        isShiny ? "Shiny" : "Normal",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          backgroundColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botones para reproducir sonidos
              Text("Sonidos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => playCry(widget.pokemon.cryLatest),
                    child: Text("Último Sonido"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => playCry(widget.pokemon.cryLegacy),
                    child: Text("Sonido Clásico"),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Información del Pokémon
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'N° ${widget.pokemon.id}',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      'Altura: ${widget.pokemon.height / 10} m',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      'Peso: ${widget.pokemon.weight / 10} kg',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tipos: ${widget.pokemon.types.join(', ').toUpperCase()}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Descripción: ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      widget.pokemon.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Estadísticas base
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Estadísticas Base',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    for (var stat in widget.pokemon.baseStats.entries)
                      Text(
                        '${stat.key}: ${stat.value}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Habilidades
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Habilidades',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    for (var ability in widget.pokemon.abilities)
                      Text(ability.toUpperCase(), style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Formas del Pokémon
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      'Formas',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    for (var form in widget.pokemon.forms)
                      Text(form.toUpperCase(), style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
