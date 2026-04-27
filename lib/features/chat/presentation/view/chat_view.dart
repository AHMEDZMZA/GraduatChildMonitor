import 'package:flutter/material.dart';
import '../../../../../core/managers/app_text_styles.dart';
import '../../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../model/chat_message_model.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      messages.add(ChatMessageModel(text: controller.text.trim(), isMe: true));
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorManager.backgroundWhite,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 16),
                const CustomText(
                  text: 'Ask for help',
                  style: AppTextStyles.nunito32w900Black,
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: messages.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return ChatBubble(message: messages[index]);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ChatInput(controller: controller, onSend: sendMessage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
