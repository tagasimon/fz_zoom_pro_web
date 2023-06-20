import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyProvider = Provider<CompanyInfoRepository>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return CompanyInfoRepository(firestore);
});

final companyInfoProvider = StreamProvider<CompanyModel>((ref) {
  final user = ref.watch(filterNotifierProvider).loggedInuser;
  if (user == null) {
    return const Stream.empty();
  }
  return ref.watch(companyProvider).watchCompanyInfoById(user.companyId);
});
