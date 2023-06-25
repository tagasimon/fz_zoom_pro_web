import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/core/providers/firebase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final customersRepoProvider = Provider<CustomersRepository>((ref) {
  return CustomersRepository(ref.watch(firestoreInstanceProvider));
});

final customersProviderProvider = FutureProvider<List<CustomerModel>>((ref) {
  final session = ref.watch(sessionNotifierProvider);
  return ref
      .watch(customersRepoProvider)
      .getAllCompanyCustomers(companyId: session.loggedInUser!.companyId);
});
