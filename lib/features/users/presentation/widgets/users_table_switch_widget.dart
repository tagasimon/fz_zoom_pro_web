import 'package:field_zoom_pro_web/features/users/presentation/controllers/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class UsersTableSwitchWidget extends ConsumerWidget {
  final bool value;
  final UserModel nUser;
  const UsersTableSwitchWidget(
      {super.key, required this.value, required this.nUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Switch(
      value: value,
      onChanged: (val) async {
        await ref
            .read(usersControllerProvider.notifier)
            .updateUser(user: nUser);
      },
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
    );
  }
}
