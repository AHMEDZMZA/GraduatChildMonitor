class ChatMessageModel {
  final String text;
  final bool isMe;

  const ChatMessageModel({required this.text, required this.isMe});
}

final List<ChatMessageModel> messages = [
  const ChatMessageModel(text: 'Hi, I need some help.', isMe: true),
  const ChatMessageModel(
    text: 'I’m here to help!\nCan you tell me what happened ?',
    isMe: false,
  ),
  const ChatMessageModel(
    text: 'Typically, you’ll want about 2 cups of flour for every egg.',
    isMe: false,
  ),
  const ChatMessageModel(text: 'And how do I mix them together?', isMe: true),
  const ChatMessageModel(
    text:
        'First, make a mound of flour on a clean surface, then create a well in the center. Crack the eggs into the well and sprinkle a little salt.',
    isMe: false,
  ),
];
