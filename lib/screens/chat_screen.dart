import 'package:flutter/material.dart';
import 'package:nexafit/widgets/chat_bubble_ai_reply.dart';
import 'package:nexafit/widgets/chat_bubble_reply.dart';
import 'package:nexafit/widgets/chat_input_bar.dart';
import 'package:nexafit/widgets/typing_indicator.dart';
import 'package:nexafit/services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add initial greeting message
    _messages.add({
      'role': 'assistant',
      'content': 'Hi! How can I help you today?',
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': message});
      _isLoading = true;
    });

    // Scroll to bottom after adding user message
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    final response = await GeminiService.getResponse(message);

    setState(() {
      _messages.add({'role': 'assistant', 'content': response});
      _isLoading = false;
    });

    // Scroll to bottom after adding AI response
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: TypingIndicator(),
                    );
                  }
                  final message = _messages[index];
                  if (message['role'] == 'user') {
                    return ChatBubbleReply(message: message['content']!);
                  } else {
                    return ChatBubbleAIReply(message: message['content']!);
                  }
                },
              ),
            ),
            ChatInputBar(onSendMessage: _sendMessage),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
