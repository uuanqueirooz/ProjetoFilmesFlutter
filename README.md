# 🎬 Gerenciador de Filmes

Um aplicativo Flutter elegante para gerenciar sua coleção de filmes. Adicione, visualize e organize seus filmes favoritos com facilidade.

## ✨ Funcionalidades

- 📱 Interface intuitiva e responsiva
- 🎯 Adicionar, editar e deletar filmes
- 💾 Persistência de dados com SQLite
- 🎨 Design moderno com Material Design
- 📋 Listagem organizada de filmes

## 🛠️ Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter](https://flutter.dev/docs/get-started/install) (versão 3.0+)
- [Dart](https://dart.dev/get-dart) (incluído no Flutter)
- [Git](https://git-scm.com/)
- Um editor de código (VS Code, Android Studio, etc.)

## 🚀 Como Iniciar

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/projeto_filmes.git
cd projeto_filmes
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Execute o aplicativo

```bash
flutter run
```

Para executar em um dispositivo específico:

```bash
flutter devices  # Liste os dispositivos disponíveis
flutter run -d <device_id>
```

## 📂 Estrutura do Projeto

```
projeto_filmes/
├── lib/
│   ├── main.dart                 # Ponto de entrada da aplicação
│   ├── views/
│   │   └── movie_list_screen.dart # Tela principal
│   ├── services/
│   │   └── database_service.dart  # Serviço de banco de dados
│   └── models/                     # Modelos de dados
├── pubspec.yaml                    # Dependências do projeto
└── README.md                       # Este arquivo
```

## 📦 Dependências Principais

- **sqflite**: Banco de dados SQLite para Flutter
- **path_provider**: Acesso ao sistema de arquivos
- **material_design_icons**: Ícones Material Design

## 🎮 Como Usar

1. **Abra o aplicativo** no seu dispositivo/emulador
2. **Adicione um filme** pressionando o botão flutuante (+)
3. **Preencha os dados** do filme (título, descrição, etc.)
4. **Salve** o filme no banco de dados
5. **Visualize** sua coleção na lista principal

## 🔧 Desenvolvimento

### Executar testes

```bash
flutter test
```

### Build para produção

```bash
flutter build apk      # Android
flutter build ios      # iOS
```

### Verificar análise estática

```bash
flutter analyze
```

## 🐛 Solução de Problemas

**Erro ao executar `flutter run`:**
```bash
flutter clean
flutter pub get
flutter run
```

**Problema com o banco de dados:**
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

## 👤 Autor

José Wanderson,
Humberto Henrique,
Gabriel Faheina

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fork o projeto
2. Criar uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abrir um Pull Request

## 📞 Suporte

Se encontrar problemas ou tiver dúvidas, abra uma [issue](https://github.com/seu-usuario/projeto_filmes/issues).

---

**Desenvolvido com ❤️ usando Flutter**
