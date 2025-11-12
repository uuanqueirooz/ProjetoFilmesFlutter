import 'package:flutter/material.dart';
// Importe seu serviço de DB
import 'package:projeto_filmes/services/database_service.dart';
// Importe sua tela principal
import 'package:projeto_filmes/views/movie_list_screen.dart';

void main() async {
  // Garante que os bindings do Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o banco de dados (opcional, mas boa prática)
  // Isso apenas "aquece" o DB.
  await DatabaseService().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieListScreen(), // Sua tela principal
    );
  }
}