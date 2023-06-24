import 'package:field_zoom_pro_web/core/notifiers/quick_filter_notifier.dart';
import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) {
  return UsersRepository(ref.watch(firestoreInstanceProvider));
});

final getUsersByCompanyAndRegionProvider =
    StreamProvider<List<UserModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  final region = ref.watch(quickfilterNotifierProvider).region;
  if (region == "" || region == null) {
    return ref.watch(userRepoProvider).getAllCompanyUsers(companyId: companyId);
  }
  return ref
      .watch(userRepoProvider)
      .getAllCompanyUsersByRegionId(companyId: companyId, regionId: region);
});

final companyUsersProvider = StreamProvider.autoDispose<List<UserModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref.watch(userRepoProvider).getAllCompanyUsers(companyId: companyId);
});

final watchUserProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, id) {
  return ref.watch(userRepoProvider).watchUser(id: id);
});
