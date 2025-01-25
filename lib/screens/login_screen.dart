import 'package:flutter/material.dart';

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
  String? _selectedValue;
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
            // Выпадающее меню
            DropdownButton<String>(
              value: _selectedValue,
              hint: const Text('Выберите значение'),
              items: const [
                DropdownMenuItem(
                  value: 'OpenRouter',
                  child: Text('OpenRouter'),
                ),
                DropdownMenuItem(
                  value: 'VSEGPT',
                  child: Text('VSEGPT'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            const SizedBox(height: 20),
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
                if (text.length != 73) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ключ должен быть 73 символа'),
                    ),
                  );
                  return;
                }

                if (!text.startsWith('sk-or-vv') &&
                    !text.startsWith('sk-or-v1')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Ключ должен начинаться с "sk-or-vv" или "sk-or-v1"'),
                    ),
                  );
                  return;
                }

                // Если проверки пройдены, можно продолжить обработку
              },
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}
