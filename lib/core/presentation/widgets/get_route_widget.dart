import 'package:field_zoom_pro_web/core/providers/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetRouteWidget extends ConsumerWidget {
  final String routeId;
  const GetRouteWidget({super.key, required this.routeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionProv = ref.watch(routeByIdProvider(routeId));
    return regionProv.when(
      data: (route) => Text(route.name),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text('Error: $error'),
    );
  }
}
