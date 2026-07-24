import 'package:respilink_mobile/features/query_form/domain/models/chat_message_model.dart';

import '../../../../exports.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const ChatMessageBubble({super.key, required this.message});

  bool get _isMe => message.sender == ChatSender.user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!_isMe) ...[
          _SupportAvatar(),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            child: Column(
              crossAxisAlignment: _isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: _isMe ? AppColors.primary : AppColors.fieldColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(_isMe ? 16.r : 4.r),
                      bottomRight: Radius.circular(_isMe ? 4.r : 16.r),
                    ),
                  ),
                  child: AppText.small(
                    label: message.text,
                    color: _isMe ? AppColors.white : AppColors.black,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                AppText.small(
                  label: message.timeLabel,
                  color: AppColors.grey,
                  fontSize: 10.sp,
                ),
              ],
            ),
          ),
        ),
        if (_isMe) SizedBox(width: 4.w),
      ],
    );
  }
}

class _SupportAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.support_agent, color: AppColors.primary, size: 15.sp),
    );
  }
}
