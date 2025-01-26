import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class AnaliticScreen extends StatelessWidget {
  const AnaliticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аналитика'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Всего сообщений: ${chatProvider.messages.length}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Баланс: ${chatProvider.balance}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Использование по моделям:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      padding: const EdgeInsets.only(left: 12, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Сообщений: ${entry.value['count']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          if (entry.value['tokens'] > 0) ...[
                            Text(
                              'Токенов: ${entry.value['tokens']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              chatProvider.baseUrl?.contains('vsetgpt.ru') ==
                                      true
                                  ? 'Стоимость: ${entry.value['cost'] < 1e-8 ? '0.0' : entry.value['cost'].toStringAsFixed(8)}₽'
                                  : 'Стоимость: ${entry.value['cost'] < 1e-8 ? '0.0' : entry.value['cost'].toStringAsFixed(8)}₽',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
