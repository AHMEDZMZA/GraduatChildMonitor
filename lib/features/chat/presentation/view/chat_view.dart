import 'package:easy_localization/easy_localization.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        } else if (state is ChatError) {
          setState(() {
            _isSending = false;
            _messages.add(
              ChatMessageModel(text: 'Error: ${state.message}', isMe: false),
            );
          });
          _scrollToBottom();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  CustomText(
                    text: 'ask_for_help'.tr(),
                    style: AppTextStyles.nunito32w900Black,
                  ),
                  SizedBox(height: 22.h),
                  Expanded(
                    child: _messages.isEmpty
                        ? Center(
                            child: Text(
                              'Start a conversation!\nAsk anything about your child.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorManager.mediumGray,
                                fontSize: 15.sp,
                              ),
                            ),
                          )
                        : ListView.separated(
                            controller: _scrollController,
                            padding: EdgeInsets.only(bottom: 12.h),
                            itemCount: _messages.length + (_isSending ? 1 : 0),
                            separatorBuilder: (_, __) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isSending) {
                                // Typing indicator
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(14.r),
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
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ChatInput(
                      controller: controller,
                      onSend: sendMessage,
                    ),
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
            padding: EdgeInsets.symmetric(horizontal: 2.w),
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

