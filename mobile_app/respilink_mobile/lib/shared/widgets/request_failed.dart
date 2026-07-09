import '../../exports.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppText.medium(label: message ?? "", textAlign: .center),
    ).applyDefaultPadding();
  }
}
