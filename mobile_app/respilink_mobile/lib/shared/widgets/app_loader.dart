import 'package:flutter/cupertino.dart';
import 'package:respilink_mobile/exports.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(color: AppColors.primary));
  }
}
