import 'package:field_zoom_pro_web/core/notifiers/filter_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fz_hooks/fz_hooks.dart';

final customersRepoProvider =
    Provider<CustomersRepository>((ref) => CustomersRepository());

final customersProviderProvider = FutureProvider<List<CustomerModel>>((ref) {
  final filter = ref.watch(filterNotifierProvider);
  if (filter.region == null || filter.region == "") {
    return ref
        .watch(customersRepoProvider)
        .getAllCompanyCustomers(companyId: filter.loggedInuser!.companyId);
  }
  return ref.watch(customersRepoProvider).getCompanyCustomersByRegionId(
      companyId: filter.loggedInuser!.companyId, regionId: filter.region!);
});
