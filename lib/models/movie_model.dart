class Movie {
  final int? id;
  final String imageUrl;
  final String title;
  final String genre;
  final String ageRating; // Faixa Etária
  final String duration;
  final double score;     // Pontuação
  final String description;
  final int year;

  Movie({
    this.id,
    required this.imageUrl,
    required this.title,
    required this.genre,
    required this.ageRating,
    required this.duration,
    required this.score,
    required this.description,
    required this.year,
  });

  // NOVO: Converte um Map vindo do DB para um objeto Movie
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int?,
      imageUrl: map['imageUrl'] as String,
      title: map['title'] as String,
      genre: map['genre'] as String,
      ageRating: map['ageRating'] as String,
      duration: map['duration'] as String,
      score: map['score'] as double,
      description: map['description'] as String,
      year: map['year'] as int,
    );
  }

  // ATUALIZAÇÃO: Método toMap (vamos garantir que o id não seja enviado ao criar)
  Map<String, dynamic> toMap() {
    return {
      // id é gerenciado pelo DB, não precisa estar no map para inserção
      'imageUrl': imageUrl,
      'title': title,
      'genre': genre,
      'ageRating': ageRating,
      'duration': duration,
      'score': score,
      'description': description,
      'year': year,
    };
  }
}