import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final collectionsRepoProvider = Provider<PaymentsRepository>((ref) {
  return PaymentsRepository(ref.watch(firestoreInstanceProvider));
});

// final collectionsByOrderIdProvider = FutureProvider.family.autoDispose<List<PayementModel>, String>((ref, orderId) async {
//   f
//   return ;
// });
