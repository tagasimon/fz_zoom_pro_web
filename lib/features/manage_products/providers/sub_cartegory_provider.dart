import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
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
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .allSubCartegories(companyId: companyId);
});

final watchSubCartegoriesProvider =
    StreamProvider.autoDispose<List<SubCartegoryModel>>((ref) {
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .watchAllSubCartegories(companyId: companyId);
});

final subCartegoryByIdProvider = FutureProvider.autoDispose
    .family<SubCartegoryModel, String>((ref, subCartegoryId) {
  final companyId = ref.watch(filterNotifierProvider).user!.companyId;
  return ref
      .watch(productsSubCartegoryProvider)
      .getSubCartegoryByIdAndCartegoryId(
          id: subCartegoryId, companyId: companyId);
});

// final subCartegoriesControllerProvider =
//     StateNotifierProvider<SubCartegoriesController, AsyncValue>((ref) {
//   return SubCartegoriesController();
// });
