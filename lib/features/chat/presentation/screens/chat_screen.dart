import 'package:flutter/material.dart';
import 'package:nexafit/features/chat/presentation/widgets/chat_bubble_ai_reply.dart';
import 'package:nexafit/features/chat/presentation/widgets/chat_bubble_reply.dart';
import 'package:nexafit/features/chat/presentation/widgets/chat_input_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  ChatBubbleAIReply(
                    message: "Hello! How can I help you today?",
                  ),
                  ChatBubbleReply(
                    message: "What are some good chest workouts?",
                  ),
                  ChatBubbleAIReply(
                    message:
                        "Push-ups, bench press, and dumbbell flys are great!",
                  ),
                ],
              ),
            ),
            const ChatInputBar(),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
