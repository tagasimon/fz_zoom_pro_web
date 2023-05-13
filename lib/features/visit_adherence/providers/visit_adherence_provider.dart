// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nhop_hooks/nhop_hooks.dart';
// import 'package:nice_admin_web/core/providers/filter_notifier_provider.dart';

// final visitAdherenceProvider = Provider<VisitAdherenceRepository>((ref) {
//   return VisitAdherenceRepository();
// });

// final allVisitsByUserProvider = FutureProvider.family
//     .autoDispose<List<VisitAdherenceModel>, String>((ref, userId) {
//   final filter = ref.watch(filterNotifierProvider);
//   return ref.watch(visitAdherenceProvider).getAllVisitsByOnlyUser(
//       companyName: "NICE",
//       userId: userId,
//       startDate: filter.startDate,
//       endDate: filter.endDate);
// });
