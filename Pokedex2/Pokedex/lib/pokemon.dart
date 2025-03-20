class Pokemon {
  final String name;
  final String imageUrl;
  final String shinyImageUrl;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final String description;
  final List<String> abilities;
  final String cryLatest;
  final String cryLegacy;
  final List<String> forms;
  final Map<String, Map<String, String>> generationSprites; // {gen: {normal: url, shiny: url}}
  final Map<String, int> baseStats; // Estadísticas base (HP, Ataque, Defensa, etc.)

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.shinyImageUrl,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.description,
    required this.abilities,
    required this.cryLatest,
    required this.cryLegacy,
    required this.forms,
    required this.generationSprites,
    required this.baseStats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json, String description) {
    // Obtener imágenes de cada generación (priorizando GIF si existe)
    Map<String, Map<String, String>> genSprites = {
      "red-blue": {
        "normal": json["sprites"]["versions"]["generation-i"]["red-blue"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-i"]["red-blue"]["front_shiny"] ?? ""
      },
      "yellow": {
        "normal": json["sprites"]["versions"]["generation-i"]["yellow"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-i"]["yellow"]["front_shiny"] ?? ""
      },
      "gold": {
        "normal": json["sprites"]["versions"]["generation-ii"]["gold"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-ii"]["gold"]["front_shiny"] ?? ""
      },
      "silver": {
        "normal": json["sprites"]["versions"]["generation-ii"]["silver"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-ii"]["silver"]["front_shiny"] ?? ""
      },
      "crystal": {
        "normal": json["sprites"]["versions"]["generation-ii"]["crystal"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-ii"]["crystal"]["front_shiny"] ?? ""
      },
      "ruby-sapphire": {
        "normal": json["sprites"]["versions"]["generation-iii"]["ruby-sapphire"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-iii"]["ruby-sapphire"]["front_shiny"] ?? ""
      },
      "emerald": {
        "normal": json["sprites"]["versions"]["generation-iii"]["emerald"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-iii"]["emerald"]["front_shiny"] ?? ""
      },
      "firered-leafgreen": {
        "normal": json["sprites"]["versions"]["generation-iii"]["firered-leafgreen"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-iii"]["firered-leafgreen"]["front_shiny"] ?? ""
      },
      "diamond-pearl": {
        "normal": json["sprites"]["versions"]["generation-iv"]["diamond-pearl"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-iv"]["diamond-pearl"]["front_shiny"] ?? ""
      },
      "platinum": {
        "normal": json["sprites"]["versions"]["generation-iv"]["platinum"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-iv"]["platinum"]["front_shiny"] ?? ""
      },
      "black-white": {
        "normal": json["sprites"]["versions"]["generation-v"]["black-white"]["animated"]["front_default"] ??
            json["sprites"]["versions"]["generation-v"]["black-white"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-v"]["black-white"]["animated"]["front_shiny"] ??
            json["sprites"]["versions"]["generation-v"]["black-white"]["front_shiny"] ?? ""
      },
      "x-y": {
        "normal": json["sprites"]["versions"]["generation-vi"]["x-y"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-vi"]["x-y"]["front_shiny"] ?? ""
      },
      "sun-moon": {
        "normal": json["sprites"]["versions"]["generation-vii"]["ultra-sun-ultra-moon"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-vii"]["ultra-sun-ultra-moon"]["front_shiny"] ?? ""
      },
      "sword-shield": {
        "normal": json["sprites"]["versions"]["generation-viii"]["icons"]["front_default"] ?? "",
        "shiny": json["sprites"]["versions"]["generation-viii"]["icons"]["front_shiny"] ?? ""
      },
    };

    // Obtener las estadísticas base
    Map<String, int> baseStats = {};
    for (var stat in json['stats']) {
      baseStats[stat['stat']['name']] = stat['base_stat'];
    }

    return Pokemon(
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      shinyImageUrl: json['sprites']['other']['official-artwork']['front_shiny'] ?? json['sprites']['front_shiny'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List).map((type) => type['type']['name'].toString()).toList(),
      description: description,
      abilities: (json['abilities'] as List).map((ability) => ability['ability']['name'].toString()).toList(),
      cryLatest: json['cries']['latest'] ?? '',
      cryLegacy: json['cries']['legacy'] ?? '',
      forms: (json['forms'] as List).map((form) => form['name'].toString()).toList(),
      generationSprites: genSprites,
      baseStats: baseStats,
    );
  }
}
