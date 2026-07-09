import '../../exports.dart';

extension PaddingExtensions on Widget {

  Widget applyDefaultPadding({double? vertical, double? horizontal}) {
    return Padding(
      padding: .symmetric(horizontal: horizontal ?? 12.w, vertical: vertical ?? 8.h),
      child: this,
    );
  }
}