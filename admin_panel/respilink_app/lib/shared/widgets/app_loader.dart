import 'package:flutter/cupertino.dart';

import '../../core/theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CupertinoActivityIndicator(color: AppColors.white, radius: 15));
  }
}
