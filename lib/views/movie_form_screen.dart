import 'package:flutter/material.dart';

// Importe seu modelo e serviço de DB
import 'package:projeto_filmes/models/movie_model.dart';
import 'package:projeto_filmes/services/database_service.dart';

class MovieFormScreen extends StatefulWidget {
  // Opcional: Receber um filme para edição
  final Movie? movie;

  const MovieFormScreen({Key? key, this.movie}) : super(key: key);

  @override
  _MovieFormScreenState createState() => _MovieFormScreenState();
}

class _MovieFormScreenState extends State<MovieFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbService = DatabaseService();

  // Controladores para os campos de texto
  late final TextEditingController _imageUrlController;
  late final TextEditingController _titleController;
  late final TextEditingController _genreController;
  late final TextEditingController _durationController;
  late final TextEditingController _yearController;
  late final TextEditingController _descriptionController;

  // Valores para o Dropdown e para as estrelas
  String? _selectedAgeRating;
  double _currentScore = 0.0; // Pontuação inicial

  final List<String> _ageRatings = ['Livre', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();

    // Preenche os campos se estiver editando um filme
    _imageUrlController = TextEditingController(text: widget.movie?.imageUrl ?? '');
    _titleController = TextEditingController(text: widget.movie?.title ?? '');
    _genreController = TextEditingController(text: widget.movie?.genre ?? '');
    _durationController = TextEditingController(text: widget.movie?.duration ?? '');
    _yearController = TextEditingController(text: widget.movie?.year?.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.movie?.description ?? '');
    _selectedAgeRating = widget.movie?.ageRating ?? 'Livre';
    // A nota interna é de 0 a 10, mas nosso widget é de 1 a 5. Fazemos a conversão.
    _currentScore = (widget.movie?.score ?? 0.0) / 2;
  }

  @override
  void dispose() {
    // Limpa os controladores
    _imageUrlController.dispose();
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _yearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Validador simples de campo vazio
  String? _validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo não pode ser vazio';
    }
    return null;
  }

  // Função para salvar o filme
  void _saveMovie() async {
    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      // Cria o objeto Movie com os dados dos controladores
      final movie = Movie(
        id: widget.movie?.id, // Mantém o ID se estiver editando
        imageUrl: _imageUrlController.text,
        title: _titleController.text,
        genre: _genreController.text,
        ageRating: _selectedAgeRating!,
        duration: _durationController.text,
        // Converte a nota de 1-5 de volta para 0-10 antes de salvar
        score: _currentScore * 2,
        description: _descriptionController.text,
        year: int.tryParse(_yearController.text) ?? 2000,
      );

      // Salva no banco de dados
      if (widget.movie == null) {
        // Criar novo
        await _dbService.createMovie(movie);
      } else {
        // Atualizar existente
        await _dbService.updateMovie(movie);
      }

      // Retorna para a tela anterior
      if (mounted) {
        Navigator.of(context).pop(true); // Envia 'true' para indicar sucesso
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Muda o título se for cadastro ou alteração
        title: Text(widget.movie == null ? 'Cadastrar Filme' : 'Alterar Filme'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextFormField(
                  controller: _imageUrlController,
                  label: 'Url Imagem',
                  validator: _validateNotEmpty),
              _buildTextFormField(
                  controller: _titleController,
                  label: 'Título',
                  validator: _validateNotEmpty),
              _buildTextFormField(
                  controller: _genreController,
                  label: 'Gênero',
                  validator: _validateNotEmpty),

              // Dropdown para Faixa Etária
              DropdownButtonFormField<String>(
                value: _selectedAgeRating,
                decoration: InputDecoration(
                  labelText: 'Faixa Etária',
                  border: OutlineInputBorder(),
                ),
                items: _ageRatings.map((rating) {
                  return DropdownMenuItem(
                    value: rating,
                    child: Text(rating),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedAgeRating = newValue;
                  });
                },
                validator: (value) =>
                value == null ? 'Selecione uma opção' : null,
              ),
              SizedBox(height: 16),

              _buildTextFormField(
                  controller: _durationController,
                  label: 'Duração',
                  validator: _validateNotEmpty),

              // Campo para Ano
              _buildTextFormField(
                controller: _yearController,
                label: 'Ano',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo não pode ser vazio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um ano válido';
                  }
                  return null;
                },
              ),

              // Campo para Descrição (com múltiplas linhas)
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Descrição',
                validator: _validateNotEmpty,
                maxLines: 5,
              ),

              SizedBox(height: 20),

              // Título para a seção de Nota
              Text('Nota',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
              SizedBox(height: 8),

              // Widget de Estrelas Interativo
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Centraliza a Row
                  children: List.generate(5, (index) {
                    double starValue = index + 1.0;
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          // Permite desmarcar a nota 1
                          _currentScore =
                          _currentScore == starValue ? 0 : starValue;
                        });
                      },
                      icon: Icon(
                        starValue <= _currentScore ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 35.0, // Tamanho maior para facilitar o toque
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      constraints: BoxConstraints(),
                    );
                  }),
                ),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveMovie, // Chama a função de salvar
        child: Icon(Icons.save),
      ),
    );
  }

  // Widget auxiliar para criar os campos de texto
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }
}
