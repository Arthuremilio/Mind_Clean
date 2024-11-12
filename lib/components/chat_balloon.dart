import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBalloon extends StatelessWidget {
  final String? message;
  final Image? image;
  final bool isUserMessage;
  final DateTime timestamp;

  const ChatBalloon({
    Key? key,
    this.message,
    this.image,
    required this.isUserMessage,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isUserMessage) ...[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (image != null) image!,
                    if (message != null)
                      Text(
                        message!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    const SizedBox(height: 4),
                    Align(
                      alignment:
                          Alignment.bottomRight, // Alinhando ao final (direita)
                      child: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/assets/img/user_logo.png'),
            ),
          ] else ...[
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('lib/assets/img/mind_clean_logo.png'),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null) image!,
                    if (message != null)
                      Text(
                        message!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    const SizedBox(height: 4),
                    Align(
                      alignment:
                          Alignment.bottomRight, // Alinhando ao final (direita)
                      child: Text(
                        DateFormat('dd/MM/yyyy HH:mm').format(timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
