class Anime{
  final int id;
  final String title;
  final String description;
  final int episodes;

   Anime({
    required this.id,
    required this.title,
    required this.description,
    required this.episodes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'episodes': episodes,
    };
  }

  factory Anime.fromSqfliteDatabase(Map<String, dynamic> map) => Anime(
    id: map['id'].toInt() ?? 0,
    title: map['title'] ?? '',
    description: map['description'] ?? '', 
    episodes: map['episodes'].toInt() ??  0,
  );

  @override
  String toString() {
    return 'Anime{id: $id, title: $title, description: $description, episodes: $episodes}';
  }
}