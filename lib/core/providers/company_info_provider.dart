import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyProvider = Provider<CompanyInfoRepository>((ref) {
  return CompanyInfoRepository();
});

final companyInfoProvider = StreamProvider<CompanyModel>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref.watch(companyProvider).watchCompanyInfoById(companyId);
});
