import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>((ref) {
  return UsersRepository();
});

final getUsersByCompanyAndRegionProvider =
    StreamProvider<List<UserModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;
  final region = ref.watch(filterNotifierProvider).region;
  if (region == "" || region == null) {
    return ref.watch(userRepoProvider).getAllCompanyUsers(companyId: companyId);
  }
  return ref
      .watch(userRepoProvider)
      .getAllCompanyUsersByRegionId(companyId: companyId, regionId: region);
});
