// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nhop_hooks/nhop_hooks.dart';
// import 'package:nice_admin_web/core/presentation/widgets/table_action_widget.dart';

// class CustomersTableActionsWidget extends ConsumerWidget {
//   final List<CustomerModel> customers;
//   const CustomersTableActionsWidget({super.key, required this.customers});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       children: [
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "search",
//           child: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "insights",
//           child:
//               IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "map",
//           child: IconButton(onPressed: () {}, icon: const Icon(Icons.map)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: 'download',
//           child: IconButton(
//               onPressed: () {
//                 Fluttertoast.showToast(msg: 'Coming Soon!');
//               },
//               icon: const Icon(Icons.download)),
//         ),
//       ],
//     );
//   }
// }
