import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/controllers/sub_cartegories_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final productsSubCartegoryProvider =
    Provider<SubCartegoryRepository>((ref) => SubCartegoryRepository());

// // This returns a list of product Sub catergories by Cartegory Id
// final watchSubCartegoriesByCartegoryIdProvider =
//     StreamProvider.autoDispose<List<SubCartegoryModel>>((ref) {
//   final cartegoryId = ref.watch(filterNotifierProvider).productCartegory!.id;
//   return ref
//       .watch(productsSubCartegoryProvider)
//       .watchSubCartegoriesByCartegoryId(cartegoryId: cartegoryId);
// });

final allSubCartegoriesProvider =
    FutureProvider.autoDispose<List<SubCartegoryModel>>((ref) async {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .allSubCartegories(companyId: companyId);
});

final watchSubCartegoriesProvider =
    StreamProvider.autoDispose<List<SubCartegoryModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .watchAllSubCartegories(companyId: companyId);
});

final watchSubCartegoriesByCartegoryIdProvider = StreamProvider.autoDispose
    .family<List<SubCartegoryModel>, String>((ref, cartegoryId) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .watchSubCartegoriesByCartegoryId(
          companyId: companyId, cartegoryId: cartegoryId);
});

final subCartegoryByIdProvider = FutureProvider.autoDispose
    .family<SubCartegoryModel, String>((ref, subCartegoryId) {
  final companyId = ref.watch(filterNotifierProvider).loggedInuser!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .getSubCartegoryByIdAndCartegoryId(
          id: subCartegoryId, companyId: companyId);
});

final subCartegoriesControllerProvider =
    StateNotifierProvider<SubCartegoriesController, AsyncValue>((ref) {
  return SubCartegoriesController();
});
