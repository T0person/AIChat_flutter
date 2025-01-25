import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/error_boundary.dart';
import '../components/message_bubble.dart';
import '../components/message_input.dart';
import '../providers/chat_provider.dart';

// Основной экран чата
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMessagesList(),
              ),
              _buildInputArea(context),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // Построение верхней панели приложения
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF262626),
      toolbarHeight: 48,
      title: Row(
        children: [
          _buildModelSelector(context),
          const Spacer(),
          _buildBalanceDisplay(context),
          _buildMenuButton(context),
        ],
      ),
    );
  }

  // Построение выпадающего списка для выбора модели
  Widget _buildModelSelector(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: DropdownButton<String>(
            value: chatProvider.currentModel,
            hint: const Text(
              'Выберите модель',
              style: TextStyle(color: Colors.white70, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
            dropdownColor: const Color(0xFF333333),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            isExpanded: true,
            underline: Container(
              height: 1,
              color: Colors.blue,
            ),
            onChanged: (String? newValue) {
              if (newValue != null) {
                chatProvider.setCurrentModel(newValue);
              }
            },
            items: chatProvider.availableModels
                .map<DropdownMenuItem<String>>((Map<String, dynamic> model) {
              return DropdownMenuItem<String>(
                value: model['id'],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model['name'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Tooltip(
                          message: 'Входные токены',
                          child: const Icon(Icons.arrow_upward, size: 12),
                        ),
                        Text(
                          chatProvider.formatPricing(
                              double.tryParse(model['pricing']?['prompt']) ??
                                  0.0),
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Генерация',
                          child: const Icon(Icons.arrow_downward, size: 12),
                        ),
                        Text(
                          chatProvider.formatPricing(double.tryParse(
                                  model['pricing']?['completion']) ??
                              0.0),
                          style: const TextStyle(fontSize: 10),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Контекст',
                          child: const Icon(Icons.memory, size: 12),
                        ),
                        Text(
                          ' ${model['context_length'] ?? '0'}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Отображение текущего баланса пользователя
  Widget _buildBalanceDisplay(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Row(
            children: [
              Icon(Icons.credit_card, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                chatProvider.balance,
                style: const TextStyle(
                  color: Color(0xFF33CC33),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Построение кнопки меню с дополнительными опциями
  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white, size: 16),
      color: const Color(0xFF333333),
      onSelected: (String choice) async {
        final chatProvider = context.read<ChatProvider>();
        switch (choice) {
          case 'export':
            final path = await chatProvider.exportMessagesAsJson();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('История сохранена в: $path',
                      style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.green,
                ),
              );
            }
            break;
          case 'logs':
            final path = await chatProvider.exportLogs();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Логи сохранены в: $path',
                      style: const TextStyle(fontSize: 12)),
                  backgroundColor: Colors.green,
                ),
              );
            }
            break;
          case 'clear':
            _showClearHistoryDialog(context);
            break;
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<String>(
          value: 'export',
          height: 40,
          child: Text('Экспорт истории',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const PopupMenuItem<String>(
          value: 'logs',
          height: 40,
          child: Text('Скачать логи',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const PopupMenuItem<String>(
          value: 'clear',
          height: 40,
          child: Text('Очистить историю',
              style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }

  // Построение списка сообщений чата
  Widget _buildMessagesList() {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          reverse: false,
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages[index];
            return MessageBubble(
              key: ValueKey(index),
              message: message,
              messages: chatProvider.messages,
              index: index,
            );
          },
        );
      },
    );
  }

  // Построение области ввода сообщений
  Widget _buildInputArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      color: const Color(0xFF262626),
      child: Row(
        children: [
          Expanded(
            child: MessageInput(
              key: const ValueKey('message_input'),
              onSubmitted: (String text) {
                if (text.trim().isNotEmpty) {
                  context.read<ChatProvider>().sendMessage(text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Построение панели с кнопками действий
  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      color: const Color(0xFF262626),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.save,
            label: 'Сохранить',
            color: const Color(0xFF1A73E8),
            onPressed: () async {
              final path =
                  await context.read<ChatProvider>().exportMessagesAsJson();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('История сохранена в: $path',
                        style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          _buildActionButton(
            context: context,
            icon: Icons.delete,
            label: 'Очистить',
            color: const Color(0xFFCC3333),
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
      ),
    );
  }

  // Создание отдельной кнопки действия с заданными параметрами
  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
      ),
    );
  }

  // Отображение диалога подтверждения очистки истории
  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            'Очистить историю',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          content: const Text(
            'Вы уверены? Это действие нельзя отменить.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена', style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () {
                context.read<ChatProvider>().clearHistory();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Очистить',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }
}
