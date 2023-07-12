import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesControllerProvider =
    StateNotifierProvider<RoutesController, AsyncValue>((ref) {
  return RoutesController(ref.watch(firestoreInstanceProvider));
});

class RoutesController extends StateNotifier<AsyncValue> {
  final FirebaseFirestore firestore;
  RoutesController(this.firestore) : super(const AsyncValue.data(null));
  Future<bool> addRoute({
    required RouteModel route,
  }) async {
    try {
      final routesRepo = RoutesRepository(firestore);
      state = const AsyncValue.loading();
      final bool isRegionExist =
          await routesRepo.checkIfRouteExists(route: route);
      if (isRegionExist) {
        state = AsyncError(
            "${route.name} already exists in the Region", StackTrace.current);
        return false;
      }
      await routesRepo.addNewRoute(route: route);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  Future<bool> editRoute({
    required RouteModel route,
  }) async {
    try {
      final routesRepo = RoutesRepository(firestore);
      state = const AsyncValue.loading();
      await routesRepo.updateRoute(route: route);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }
}
