import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/users/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedUserFilterWidget extends ConsumerWidget {
  const SelectedUserFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUserProv = ref.watch(getUsersByCompanyAndRegionProvider);
    return selectedUserProv.when(
      data: (usersList) {
        return Row(
          children: [
            const Text('USER:'),
            const SizedBox(width: 8),
            DropdownButton<String?>(
                hint: const Text('Select User'),
                value: ref.watch(filterNotifierProvider).selectedUserId,
                onChanged: (String? value) {
                  if (value == null) return;
                  ref
                      .read(filterNotifierProvider.notifier)
                      .updateFilter(selectedUserId: value);
                },
                items: usersList
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.id,
                        child: Text(e.name),
                      ),
                    )
                    .toList()),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        debugPrint('Error: $error');
        debugPrint('stackTrace: $stackTrace');
        return const SizedBox.shrink();
      },
    );
  }
}
