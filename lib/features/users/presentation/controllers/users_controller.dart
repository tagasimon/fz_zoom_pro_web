import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

class UsersController extends StateNotifier<AsyncValue> {
  UsersController() : super(const AsyncData(null));

  Future<bool> updateUserStatus(
      {required bool isActive, required String id}) async {
    final userRepo = UsersRepository();
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => userRepo.updateUserStatus(isActive: isActive, id: id));
    return state.hasError ? false : true;
  }
}
