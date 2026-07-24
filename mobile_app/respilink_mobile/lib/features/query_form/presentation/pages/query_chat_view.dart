import 'package:respilink_mobile/features/query_form/domain/models/chat_message_model.dart';
import 'package:respilink_mobile/features/query_form/domain/models/query_item_model.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/chat_input_bar.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/chat_message_bubble.dart';
import 'package:respilink_mobile/features/query_form/presentation/widgets/query_status_badge.dart';

import '../../../../exports.dart';

/// Ticket conversation view, opened from a [QueryItemModel] card on the
/// Query screen. Purely local/UI for now — swap the seeded history and
/// [_send] for real API calls once the ticket-chat endpoint exists.
class QueryChatView extends StatefulWidget {
  final QueryItemModel query;

  const QueryChatView({super.key, required this.query});

  @override
  State<QueryChatView> createState() => _QueryChatViewState();
}

class _QueryChatViewState extends State<QueryChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  late final List<ChatMessageModel> _messages;

  @override
  void initState() {
    super.initState();
    // TODO: replace with the real ticket conversation once the chat API exists.
    _messages = [
      ChatMessageModel(
        id: 1,
        text: widget.query.title,
        sender: ChatSender.user,
        timeLabel: widget.query.submittedLabel,
      ),
      if (widget.query.status == QueryStatus.answered)
        const ChatMessageModel(
          id: 2,
          text:
              "Thanks for reaching out — we've reviewed your ticket and a "
              "resolution is on the way. Let us know if you need anything else.",
          sender: ChatSender.support,
          timeLabel: 'Support Team',
        ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessageModel(
          id: _messages.length + 1,
          text: text,
          sender: ChatSender.user,
          timeLabel: 'Just now',
        ),
      );
    });
    _messageController.clear();
    _scrollToBottom();

    // TODO: send the message to the backend once the ticket chat API exists.
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.query;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp, color: AppColors.black),
          onPressed: () => locator<NavigationService>().pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: query.iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(query.icon, color: query.iconColor, size: 16.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium(
                    label: query.title,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      AppText.small(
                        label: 'Ticket #${query.id}',
                        color: AppColors.grey,
                        fontSize: 10.sp,
                      ),
                      SizedBox(width: 6.w),
                      QueryStatusBadge(status: query.status),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                itemCount: _messages.length,
                separatorBuilder: (context, index) => SizedBox(height: 14.h),
                itemBuilder: (context, index) =>
                    ChatMessageBubble(message: _messages[index]),
              ),
            ),
            ChatInputBar(controller: _messageController, onSend: _send),
          ],
        ),
      ),
    );
  }
}
