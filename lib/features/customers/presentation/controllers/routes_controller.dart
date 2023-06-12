import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final routesControllerProvider =
    StateNotifierProvider<RoutesController, AsyncValue>((ref) {
  return RoutesController();
});

class RoutesController extends StateNotifier<AsyncValue> {
  final routesDB = "FZ_ROUTES";
  RoutesController() : super(const AsyncValue.data(null));

  // Add Routes
  Future<bool> addRoute({required RouteModel route}) async {
    try {
      state = const AsyncValue.loading();
      await FirebaseFirestore.instance.collection(routesDB).add(route.toMap());
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  Future<bool> editRoute({required RouteModel route}) async {
    try {
      state = const AsyncValue.loading();
      await FirebaseFirestore.instance
          .collection(routesDB)
          .where('id', isEqualTo: route.id)
          .get()
          .then((value) => value.docs.first.reference.update(route.toMap()));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, stk) {
      state = AsyncValue.error(e, stk);
      return false;
    }
  }

  // Future<void> toggleActiveStatus({
  //   required String routeId,
  //   required bool status,
  // }) {
  //   return FirebaseFirestore.instance
  //       .collection(routesDB)
  //       .where("id", isEqualTo: routeId)
  //       .get()
  //       .then((value) {
  //     value.docs.first.reference.update({"isActive": status});
  //   });
  // }
}
