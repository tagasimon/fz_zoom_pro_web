import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
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

final customerByIdProvider =
    FutureProvider.family<CustomerModel, String>((ref, customerId) async {
  final companyId = ref.watch(sessionNotifierProvider).loggedInUser!.companyId;
  return ref
      .watch(customersRepoProvider)
      .nGetCustomerByCustomerId(customerId: customerId, companyId: companyId);
});
