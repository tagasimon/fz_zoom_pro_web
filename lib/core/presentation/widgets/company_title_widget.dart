import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompanyTitleWidget extends ConsumerWidget {
  const CompanyTitleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companyInfoProv = ref.watch(companyInfoProvider);
    return companyInfoProv.when(
      data: (data) => Text(data.companyName),
      error: (e, s) => const Text("Errorr"),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
