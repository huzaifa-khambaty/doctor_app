import 'package:respilink_mobile/exports.dart';
import 'package:respilink_mobile/shared/bloc/connectivity_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityWidget extends StatelessWidget {
  const ConnectivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, bool>(
      builder: (context, status) {
        return CircleAvatar(
          backgroundColor: status ? Colors.green : Colors.red,
        );
      },
    );
  }
}
