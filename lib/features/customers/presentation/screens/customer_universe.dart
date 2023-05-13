// import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
// import 'package:field_zoom_pro_web/features/customers/models/customer_data_source_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class CustomerUniverse extends ConsumerWidget {
//   const CustomerUniverse({Key? key}) : super(key: key);
//   static const routeName = "registered_customers";

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final comapanyId = ref.watch(filterNotifierProvider).user!.companyId;
//     final agentCustomersProv = ref.watch(agentCustomersProvider);
//     return agentCustomersProv.when(
//       data: (customers) {
//         final myData = CustomerDataSourceModel(
//           data: customers,
//           selectedCustomers: {},
//           onSelected: (cust) {},
//         );
//         return Scaffold(
//             appBar: AppBar(
//               title: const Text("CUSTOMERS"),
//             ),
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   // const FilterWidget(
//                   //   showRegionFilter: true,
//                   //   showAgentFilter: true,
//                   //   showRouteFilter: true,
//                   //   showAssociateFilter: false,
//                   //   showEndDateFilter: false,
//                   //   showStartDateFilter: false,
//                   // ),
//                   PaginatedDataTable(
//                     columns: const [
//                       DataColumn(label: Text("CONTACT NAME")),
//                       DataColumn(label: Text("BUSINESS NAME")),
//                       DataColumn(label: Text("BUSINESS TYPE")),
//                       DataColumn(label: Text("REGION")),
//                       DataColumn(label: Text("ROUTE")),
//                       DataColumn(label: Text("PHONE 1")),
//                       DataColumn(label: Text("PHONE 2")),
//                       DataColumn(label: Text("DISTRICT")),
//                       DataColumn(label: Text("LOC")),
//                     ],
//                     source: myData,
//                     header:
//                         Text("${agent.toUpperCase()} (${customers.length})"),
//                     rowsPerPage: 10,
//                     sortColumnIndex: 0,
//                     sortAscending: false,
//                     actions: const [
//                       // CustomersTableActionsWidget(customers: customers)
//                     ],
//                   )
//                 ],
//               ),
//             ));
//       },
//       loading: () => Scaffold(
//         appBar: AppBar(title: const Text('CUSTOMERS')),
//         body: const Center(child: CircularProgressIndicator()),
//       ),
//       error: (error, stack) {
//         return Scaffold(
//           appBar: AppBar(title: const Text('CUSTOMERS')),
//           body: Center(child: Text("Error: $error")),
//         );
//       },
//     );
//   }
// }
