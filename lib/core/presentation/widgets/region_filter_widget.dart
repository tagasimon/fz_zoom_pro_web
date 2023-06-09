import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegionFilterWidget extends ConsumerWidget {
  const RegionFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsProv = ref.watch(allRegionsProvider);
    return regionsProv.when(
      data: (regionsList) {
        return Row(
          children: [
            const Text('REGION:'),
            const SizedBox(width: 8),
            DropdownButton<String?>(
                hint: const Text('Select Region'),
                value: ref.watch(quickfilterNotifierProvider).region,
                onChanged: (String? value) {
                  if (value == null) return;
                  ref
                      .read(quickfilterNotifierProvider.notifier)
                      .updateRegion(region: value);
                },
                items: regionsList
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
