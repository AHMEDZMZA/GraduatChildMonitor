import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/managers/app_text_styles.dart';
import '../../../../core/managers/color_manager.dart';
import '../../../auth/presentation/views/widget/custom_text.dart';
import '../../model/chat_message_model.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessageModel> _messages = [];
  String? _conversationId;
  bool _isSending = false;

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() {
      _messages.add(ChatMessageModel(text: text, isMe: true));
      _isSending = true;
    });
    controller.clear();
    _scrollToBottom();

    await context.read<ChatCubit>().sendMessage(
          text,
          conversationId: _conversationId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageSent) {
          final chatMessage = state.message;
          if (chatMessage is ChatMessage) {
            setState(() {
              _isSending = false;
              _conversationId = chatMessage.conversationId;
              // Add bot reply if available
              if (chatMessage.botReply != null &&
                  chatMessage.botReply!.isNotEmpty) {
                _messages.add(
                  ChatMessageModel(text: chatMessage.botReply!, isMe: false),
                );
              }
            });
            _scrollToBottom();
          }
        } else if (state is ChatError) {
          setState(() {
            _isSending = false;
            _messages.add(
              ChatMessageModel(
                text: 'Error: ${state.message}',
                isMe: false,
              ),
            );
          });
          _scrollToBottom();
        }
      },
      child: GestureDetector(
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
                    child: _messages.isEmpty
                        ? const Center(
                            child: Text(
                              'Start a conversation!\nAsk anything about your child.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 12),
                            itemCount:
                                _messages.length + (_isSending ? 1 : 0),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isSending) {
                                // Typing indicator
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: ColorManager.veryLightBlue,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const SizedBox(
                                      width: 40,
                                      height: 20,
                                      child: _TypingIndicator(),
                                    ),
                                  ),
                                );
                              }
                              return ChatBubble(message: _messages[index]);
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child:
                        ChatInput(controller: controller, onSend: sendMessage),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: CircleAvatar(
              radius: 4,
              backgroundColor: ColorManager.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}
