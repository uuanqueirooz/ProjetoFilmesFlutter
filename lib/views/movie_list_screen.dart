import 'package:flutter/material.dart';

// Importe os arquivos necessários do seu projeto
import 'package:projeto_filmes/models/movie_model.dart';
import 'package:projeto_filmes/services/database_service.dart';
import 'package:projeto_filmes/views/movie_form_screen.dart';
import 'package:projeto_filmes/views/movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final _dbService = DatabaseService();
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _loadMovies(); // Carrega os filmes ao iniciar
  }

  // Busca os filmes do banco de dados
  void _loadMovies() {
    setState(() {
      _moviesFuture = _dbService.getMovies();
    });
  }

  // Função para navegar para o formulário (para criar ou editar)
  void _navigateToForm({Movie? movie}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieFormScreen(movie: movie),
      ),
    );

    // Se o resultado for 'true' (indicando que salvou), recarrega a lista
    if (result == true) {
      _loadMovies();
    }
  }

  // Deletar o filme
  void _deleteMovie(int id) async {
    await _dbService.deleteMovie(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Filme deletado com sucesso!")),
    );
    _loadMovies(); // Recarrega a lista
  }

  // Função para mostrar o alerta da equipe
  void _showTeamAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Equipe"),
          content: Text("João da Silva\nPedro das Flores"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Função para mostrar opções ao clicar no item
  void _showItemOptions(BuildContext context, Movie movie) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Exibir Dados"),
              onTap: () {
                Navigator.of(context).pop();
                // Navega para a tela de Detalhes
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Alterar"),
              onTap: () {
                Navigator.of(context).pop();
                _navigateToForm(movie: movie); // Chama o formulário em modo de edição
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes"),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showTeamAlert(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture, // Usa o Future para construir a lista
        builder: (context, snapshot) {
          // Em carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Se erro
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar filmes."));
          }
          // Se vazio
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Nenhum filme cadastrado."));
          }

          // Se tiver dados
          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              // Widget para deletar ao arrastar
              return Dismissible(
                key: Key(movie.id.toString()),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _deleteMovie(movie.id!); // Deleta do DB
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  child: InkWell(
                    onTap: () => _showItemOptions(context, movie),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagem
                          Image.network(
                            movie.imageUrl,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                    width: 100,
                                    height: 150,
                                    color: Colors.grey[200],
                                    child: Icon(Icons.movie)),
                          ),
                          SizedBox(width: 16.0),
                          // Informações
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                Text(movie.genre),
                                SizedBox(height: 4.0),
                                Text(movie.duration),
                                SizedBox(height: 8.0),
                                // --- CÓDIGO DO WIDGET DE ESTRELAS ATUALIZADO ---
                                Row(
                                  children: List.generate(5, (index) {
                                    // A nota original (0-10) é dividida por 2 para a escala de 5 estrelas.
                                    double scoreInStars = movie.score / 2;

                                    // Lógica para meia estrela
                                    if (index < scoreInStars.floor()) {
                                      // Estrela cheia
                                      return Icon(Icons.star, color: Colors.amber, size: 20.0);
                                    } else if (index < scoreInStars && (scoreInStars - index) >= 0.5) {
                                      // Meia estrela
                                      return Icon(Icons.star_half, color: Colors.amber, size: 20.0);
                                    } else {
                                      // Estrela vazia
                                      return Icon(Icons.star_border, color: Colors.amber, size: 20.0);
                                    }
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Botão para cadastrar
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(), // Navega para o formulário de cadastro
        child: Icon(Icons.add),
      ),
    );
  }
}
