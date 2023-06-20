import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRegionWidget extends ConsumerWidget {
  final String? regionId;
  const GetRegionWidget({super.key, required this.regionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (regionId == null || regionId!.isEmpty) {
      return const Text('Not Found');
    }
    final regionProv = ref.watch(getRegionByCompanyIdProvider(regionId!));
    return regionProv.when(
      data: (region) => Text(region.name),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text('Error'),
    );
  }
}
