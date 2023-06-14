import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyInfoRepositoryProvider =
    Provider<CompanyInfoRepository>((ref) => CompanyInfoRepository());

final companyInfoStreamProvider =
    StreamProvider.autoDispose<CompanyModel>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(companyInfoRepositoryProvider)
      .getCompanyInfo(companyId: companyId);
});
