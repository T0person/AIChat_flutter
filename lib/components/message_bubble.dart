import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../providers/chat_provider.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final List<ChatMessage> messages;
  final int index;

  const MessageBubble({
    super.key,
    required this.message,
    required this.messages,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: message.isUser
                  ? const Color(0xFF1A73E8)
                  : const Color(0xFF424242),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SelectableText(
              message.cleanContent,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 13,
                locale: const Locale('ru', 'RU'),
              ),
            ),
          ),
          if (message.tokens != null || message.cost != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.tokens != null)
                    Text(
                      'Токенов: ${message.tokens}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  if (message.tokens != null && message.cost != null)
                    const SizedBox(width: 8),
                  if (message.cost != null)
                    Consumer<ChatProvider>(
                      builder: (context, chatProvider, child) {
                        final isVsetgpt =
                            chatProvider.baseUrl?.contains('api.vsegpt.ru') ==
                                true;
                        return Text(
                          message.cost! < 0.001
                              ? isVsetgpt
                                  ? 'Стоимость: <0.001₽'
                                  : 'Стоимость: <\$0.001'
                              : isVsetgpt
                                  ? 'Стоимость: ${message.cost!.toStringAsFixed(3)}₽'
                                  : 'Стоимость: \$${message.cost!.toStringAsFixed(3)}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 16),
                    color: Colors.white54,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                    onPressed: () {
                      final textToCopy = message.isUser
                          ? message.cleanContent
                          : '${messages[index - 1].cleanContent}\n\n${message.cleanContent}';
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Текст скопирован',
                              style: TextStyle(fontSize: 12)),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Копировать текст',
                  ),
                  const Spacer()
                ],
              ),
            ),
        ],
      ),
    );
  }
}
