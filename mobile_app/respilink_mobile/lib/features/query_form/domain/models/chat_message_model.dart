enum ChatSender { user, support }

class ChatMessageModel {
  final int id;
  final String text;
  final ChatSender sender;
  final String timeLabel;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.sender,
    required this.timeLabel,
  });
}
