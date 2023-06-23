import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyInfoRepositoryProvider = Provider<CompanyInfoRepository>((ref) {
  return CompanyInfoRepository(ref.watch(firestoreInstanceProvider));
});

final companyInfoStreamProvider =
    StreamProvider.autoDispose<CompanyModel>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(companyInfoRepositoryProvider)
      .getCompanyInfo(companyId: companyId);
});
