// import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_map_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fz_hooks/fz_hooks.dart';

// class CustomersBottomSheetWidget extends ConsumerWidget {
//   final List<CustomerModel> customers;
//   const CustomersBottomSheetWidget({super.key, required this.customers});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final scrollController = ScrollController();
//     if (scrollController.hasClients) {
//       scrollController.jumpTo(50.0);
//     }
//     return CallbackShortcuts(
//       bindings: <ShortcutActivator, VoidCallback>{
//         const SingleActivator(LogicalKeyboardKey.escape): () =>
//             context.pop(false),
//       },
//       child: Focus(
//         autofocus: true,
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: customersMapWidget(customers: customers),
//             ),
//             const VerticalDivider(thickness: 1, width: 1),
//             Expanded(
//               flex: 1,
//               child: Scrollbar(
//                 thumbVisibility: true,
//                 controller: scrollController,
//                 child: SingleChildScrollView(
//                   controller: scrollController,
//                   child: Column(
//                     children: [
//                       SfDonutChart(
//                         chartData: CustomerChartUtils.customersPerDistrict(
//                             customers: customers),
//                         // isInverted: false,
//                         title: 'DISTRICTS',
//                         // axisTitle: "",
//                         // height: 400,
//                       ),
//                       SfPieChart(
//                         chartData: CustomerChartUtils.customersPerBusinessType(
//                             customers: customers),
//                         // isInverted: false,
//                         title: 'BUSINESS TYPES',
//                         // axisTitle: "",
//                         // height: 400,
//                       ),
//                       SfBarChart(
//                         chartData: CustomerChartUtils.customersPerRoute(
//                             customers: customers),
//                         isInverted: false,
//                         title: 'TOP ROUTES',
//                         axisTitle: "",
//                         height: 400,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
