// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nhop_hooks/nhop_hooks.dart'
//     show CustomerModel, CustomersRepository;
// import 'package:nice_admin_web/core/providers/filter_notifier_provider.dart';

// final customersRepoProvider =
//     Provider<CustomersRepository>((ref) => CustomersRepository());

// final agentCustomersProvider = StreamProvider<List<CustomerModel>>((ref) {
//   final region = ref.watch(filterNotifierProvider).region;
//   final agent = ref.watch(filterNotifierProvider).agent;
//   final route = ref.watch(filterNotifierProvider).route ?? "";

//   if (agent != "" && route == "") {
//     return ref.watch(customersRepoProvider).watchAgentCustomers(agent: agent!);
//   }

//   if (agent == "" && route != "") {
//     return ref
//         .watch(customersRepoProvider)
//         .watchCustomersByRegionAndRoute(region: region!, route: route);
//   }

//   if (agent != "" && route != "") {
//     return ref.watch(customersRepoProvider).watchCustomersByRegionAgentRoute(
//         region: region!, route: route, agent: agent!);
//   }

//   /// If agent == "" && route == "" then wactch all customers by region
//   return ref
//       .watch(customersRepoProvider)
//       .watchAllRegionCustomersByRegion(region: region!);
// });
