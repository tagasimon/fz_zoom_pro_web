import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/users/presentation/controllers/users_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final userRepoProvider = Provider<UsersRepository>(
  (ref) => UsersRepository(),
);

final getUsersByCompanyAndRegionProvider =
    StreamProvider<List<UserModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  final region = ref.watch(filterNotifierProvider).region;
  if (region == "" || region == null) {
    return ref.watch(userRepoProvider).getAllCompanyUsers(companyId: companyId);
  }
  return ref
      .watch(userRepoProvider)
      .getAllCompanyUsersByRegionId(companyId: companyId, regionId: region);
});

final userNotifierProvider =
    StateNotifierProvider<UsersController, AsyncValue>((ref) {
  return UsersController();
});

final companyUsersProvider = StreamProvider.autoDispose<List<UserModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref.watch(userRepoProvider).getAllCompanyUsers(companyId: companyId);
});

final watchUserProvider =
    StreamProvider.autoDispose.family<UserModel, String>((ref, id) {
  return ref.watch(userRepoProvider).watchUser(id: id);
});

final usersControllerProvider =
    StateNotifierProvider.autoDispose<UsersController, AsyncValue>(
  (ref) => UsersController(),
);
