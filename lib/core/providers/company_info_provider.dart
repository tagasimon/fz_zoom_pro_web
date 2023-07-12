import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final companyProvider = Provider<CompanyInfoRepository>((ref) {
  return CompanyInfoRepository(ref.watch(firestoreInstanceProvider));
});

final companyInfoProvider = StreamProvider<CompanyModel>((ref) {
  final user = ref.watch(sessionNotifierProvider).loggedInUser;
  if (user == null) {
    return const Stream.empty();
  }
  return ref.watch(companyProvider).watchCompanyInfoById(user.companyId);
});
