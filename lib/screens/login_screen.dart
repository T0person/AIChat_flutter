import 'package:ai_chat_flutter/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthProvider {
  String? _api;
  String? _provider;

  String get api {
    return _api ?? 'None';
  }

  set api(String newApi) {
    _api = newApi;
  }

  String get provider {
    return _provider ?? 'None';
  }

  set provider(String newProvider) {
    _provider = newProvider;
  }
}

AuthProvider authProvider = AuthProvider();

// Основной класс страницы, наследуется от StatefulWidget
class LoginScreen extends StatefulWidget {
  // Конструктор с передачей ключа
  const LoginScreen({super.key});

  // Создание состояния для StatefulWidget
  @override
  State<LoginScreen> createState() => _NewPageState();
}

// Класс состояния страницы
class _NewPageState extends State<LoginScreen> {
  // Состояние для хранения выбранного значения
  // String? _selectedValue;
  // Контроллер для текстового поля
  final TextEditingController _controller = TextEditingController();

  // Основной метод построения интерфейса
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Верхняя панель приложения
      appBar: AppBar(
        // Заголовок страницы
        title: const Text('Выбор провайдера'),
      ),
      // Основное содержимое страницы
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Выберите провайдера"),
            Text("Введите API-key:"),
            Text(
                "Если ключ начинается с 'sk-or-vv-...' будет использоваться поставщик VSEGPT"),
            Text(
                "Если ключ начинается с 'sk-or-v1-...' будет поставщик OpenRouter"),
            // Поле ввода
            TextField(
              controller: _controller,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите API ключ',
              ),
            ),
            const SizedBox(height: 20),
            // Кнопка
            ElevatedButton(
              onPressed: () {
                final text = _controller.text;

                if (text.startsWith('sk-or-v1') && text.length == 73) {
                  authProvider.api = text;
                  authProvider._provider = "https://openrouter.ai/api/v1";
                  // Если проверки пройдены, устанавливаем авторизацию
                  final chatProvider =
                      Provider.of<ChatProvider>(context, listen: false);
                  chatProvider.setAuthenticated(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Успешная авторизация OpenRoute!'),
                    ),
                  );
                } else if (text.startsWith('sk-or-vv') && text.length == 73) {
                  authProvider.api = text;
                  authProvider._provider = "https://api.vsegpt.ru/v1";
                  // Если проверки пройдены, устанавливаем авторизацию
                  final chatProvider =
                      Provider.of<ChatProvider>(context, listen: false);
                  chatProvider.setAuthenticated(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Успешная авторизация VSEGPT!'),
                    ),
                  );
                  _controller.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Неверный ключ или провайдер'),
                    ),
                  );
                }
              },
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}
