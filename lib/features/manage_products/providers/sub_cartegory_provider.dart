import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/controllers/sub_cartegories_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final productsSubCartegoryProvider = Provider<SubCartegoryRepository>((ref) {
  return SubCartegoryRepository(ref.watch(firestoreInstanceProvider));
});

final allSubCartegoriesProvider =
    FutureProvider.autoDispose<List<SubCartegoryModel>>((ref) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .allSubCartegories(companyId: companyId);
});

final watchSubCartegoriesProvider =
    StreamProvider.autoDispose<List<SubCartegoryModel>>((ref) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .watchAllSubCartegories(companyId: companyId);
});

final watchSubCartegoriesByCartegoryIdProvider = StreamProvider.autoDispose
    .family<List<SubCartegoryModel>, String>((ref, cartegoryId) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .watchSubCartegoriesByCartegoryId(
          companyId: companyId, cartegoryId: cartegoryId);
});

final subCartegoryByIdProvider = FutureProvider.autoDispose
    .family<SubCartegoryModel, String>((ref, subCartegoryId) {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .getSubCartegoryByIdAndCartegoryId(
          id: subCartegoryId, companyId: companyId);
});

final subCartegoriesControllerProvider =
    StateNotifierProvider<SubCartegoriesController, AsyncValue>((ref) {
  final firestore = ref.watch(firestoreInstanceProvider);
  return SubCartegoriesController(firestore);
});

final numOfProductsInSubCartegoryProvider =
    FutureProvider.family<int, String>((ref, subCartId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;

  return ref.watch(productsSubCartegoryProvider).numberOfProductsInSubCartegory(
      companyId: companyId, subCartId: subCartId);
});
