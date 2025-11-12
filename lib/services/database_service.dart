import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// Importe seu modelo
import 'package:projeto_filmes/models/movie_model.dart';

class DatabaseService {
  // Instância Singleton
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Se _database é null, inicializa
    _database = await _initDatabase();
    return _database!;
  }

  // Inicializa o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movie_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Cria a tabela "movies" quando o DB é criado
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageUrl TEXT NOT NULL,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        ageRating TEXT NOT NULL,
        duration TEXT NOT NULL,
        score REAL NOT NULL,
        description TEXT NOT NULL,
        year INTEGER NOT NULL
      )
    ''');
  }

  // --- MÉTODOS CRUD ---

  // Create (Cadastrar)
  Future<int> createMovie(Movie movie) async {
    final db = await database;
    return await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read (Buscar todos)
  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

  // Update (Alterar)
  Future<int> updateMovie(Movie movie) async {
    final db = await database;
    return await db.update(
      'movies',
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  // Delete (Deletar)
  Future<int> deleteMovie(int id) async {
    final db = await database;
    return await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}