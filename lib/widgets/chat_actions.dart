import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatActions extends StatelessWidget {
  const ChatActions({super.key});

  @override
  Widget build(BuildContext context) {
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
            icon: Icons.analytics,
            label: 'Аналитика',
            color: const Color(0xFF33CC33),
            onPressed: () => _showAnalyticsDialog(context),
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

  void _showAnalyticsDialog(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF333333),
          title: const Text(
            'Статистика',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Всего сообщений: ${chatProvider.messages.length}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Баланс: ${chatProvider.balance}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Использование по моделям:',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                const SizedBox(height: 8),
                ...chatProvider.messages
                    .fold<Map<String, Map<String, dynamic>>>(
                      {},
                      (map, msg) {
                        if (msg.modelId != null) {
                          if (!map.containsKey(msg.modelId)) {
                            map[msg.modelId!] = {
                              'count': 0,
                              'tokens': 0,
                              'cost': 0.0,
                            };
                          }
                          map[msg.modelId]!['count'] =
                              map[msg.modelId]!['count']! + 1;
                          if (msg.tokens != null) {
                            map[msg.modelId]!['tokens'] =
                                map[msg.modelId]!['tokens']! + msg.tokens!;
                          }
                          if (msg.cost != null) {
                            map[msg.modelId]!['cost'] =
                                map[msg.modelId]!['cost']! + msg.cost!;
                          }
                        }
                        return map;
                      },
                    )
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.only(left: 12, bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Сообщений: ${entry.value['count']}',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                              if (entry.value['tokens'] > 0) ...[
                                Text(
                                  'Токенов: ${entry.value['tokens']}',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                                Consumer<ChatProvider>(
                                  builder: (context, chatProvider, child) {
                                    final isVsetgpt = chatProvider.baseUrl
                                            ?.contains('vsegpt.ru') ==
                                        true;
                                    return Text(
                                      isVsetgpt
                                          ? 'Стоимость: ${entry.value['cost'] < 1e-8 ? '0.0' : entry.value['cost'].toStringAsFixed(8)}₽'
                                          : 'Стоимость: ${entry.value['cost'] < 1e-8 ? '0.0' : entry.value['cost'].toStringAsFixed(8)}₽',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть', style: TextStyle(fontSize: 12)),
            ),
          ],
        );
      },
    );
  }

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
