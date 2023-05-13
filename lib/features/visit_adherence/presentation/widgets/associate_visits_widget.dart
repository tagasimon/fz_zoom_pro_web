// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nhop_hooks/nhop_hooks.dart';
// import 'package:nice_admin_web/core/presentation/widgets/filter_widget.dart';
// import 'package:nice_admin_web/features/visit_adherence/presentation/widgets/google_maps_widget.dart';
// import 'package:nice_admin_web/features/visit_adherence/providers/visit_adherence_provider.dart';

// class AssociatesVisitsWidget extends ConsumerWidget {
//   final String selectedUserId;
//   const AssociatesVisitsWidget({super.key, required this.selectedUserId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userVisitsProv = ref.watch(allVisitsByUserProvider(selectedUserId));

//     return userVisitsProv.when(
//       data: (userVisits) {
//         final totalVisits =
//             VisitAdherenceUtils.totalNumberOfVisits(data: userVisits);
//         final totalDistictCustomers =
//             VisitAdherenceUtils.totalDistictCustomersVisits(data: userVisits);
//         final distictAgents =
//             VisitAdherenceUtils.allDistictAgents(data: userVisits);

//         if (userVisits.isEmpty) {
//           return const Center(child: Text('No Visits Found'));
//         }

//         return Stack(children: [
//           const FilterWidget(
//             showStartDateFilter: true,
//             showEndDateFilter: true,
//           ),
//           getMap(visits: userVisits),
//           Positioned(
//             // bottom left
//             bottom: 0,
//             left: 0,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Card(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       DataTable(
//                         showBottomBorder: true,
//                         columns: const [
//                           DataColumn(label: Text('KPI')),
//                           DataColumn(label: Text('#')),
//                         ],
//                         rows: [
//                           DataRow(cells: [
//                             const DataCell(Text('Total Visits')),
//                             DataCell(Text('$totalVisits')),
//                           ]),
//                           DataRow(cells: [
//                             const DataCell(Text('Distict Customers')),
//                             DataCell(Text('$totalDistictCustomers')),
//                           ]),
//                         ],
//                       ),
//                       const VerticalDivider(),
//                       DataTable(
//                         showBottomBorder: true,
//                         columns: const [
//                           DataColumn(label: Text('AGENT')),
//                           DataColumn(label: Text('#VISITS')),
//                         ],
//                         rows: [
//                           for (var r in distictAgents)
//                             DataRow(cells: [
//                               DataCell(Text(r)),
//                               DataCell(Text(
//                                   '${VisitAdherenceUtils.totalNumberOfVisitsByAgent(data: userVisits, agent: r)}')),
//                             ]),
//                         ],
//                       ),
//                       const VerticalDivider(),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ]);
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, stack) => Center(child: Text(error.toString())),
//     );
//   }
// }
