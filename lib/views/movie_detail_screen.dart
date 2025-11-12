import 'package:flutter/material.dart';
import 'package:projeto_filmes/models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do Filme
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  movie.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: Icon(Icons.movie, size: 100, color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),

            // Título
            Text(
              movie.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            // Ano e Duração (lado a lado)
            Row(
              children: [
                Text(
                  "Ano: ${movie.year.toString()}",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
                Spacer(), // Ocupa o espaço entre os dois
                Text(
                  movie.duration,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8.0),

            // Gênero e Faixa Etária
            Text(
              "${movie.genre} • ${movie.ageRating}",
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            SizedBox(height: 12.0),

            // Estrelas de Avaliação (Widget customizado)
            Row(
              children: List.generate(5, (index) {
                // A nota original (0-10) é dividida por 2 para a escala de 5 estrelas.
                double scoreInStars = movie.score / 2;

                // Lógica corrigida para meia estrela
                if (index < scoreInStars.floor()) {
                  // Estrela cheia
                  return Icon(Icons.star, color: Colors.amber, size: 25.0);
                } else if (index < scoreInStars && (scoreInStars - index) >= 0.5) {
                  // Meia estrela
                  return Icon(Icons.star_half, color: Colors.amber, size: 25.0);
                } else {
                  // Estrela vazia
                  return Icon(Icons.star_border, color: Colors.amber, size: 25.0);
                }
              }),
            ),

            SizedBox(height: 24.0), // Adicionei um espaçamento aqui

            // Título da Descrição
            Text(
              "Descrição",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            // Texto da Descrição
            Text(
              movie.description,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
