// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nice_admin_web/core/presentation/widgets/table_action_widget.dart';
// import 'package:nice_admin_web/features/visit_adherence/presentation/widgets/associate_visits_widget.dart';

// class NiceTwoTableActionsWidget extends ConsumerWidget {
//   final String selectedUserId;
//   const NiceTwoTableActionsWidget({super.key, required this.selectedUserId});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Row(
//       children: [
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "visits",
//           child: IconButton(
//               onPressed: () async {
//                 await showModalBottomSheet(
//                   isScrollControlled: true,
//                   isDismissible: false,
//                   showDragHandle: true,
//                   enableDrag: false,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   context: context,
//                   builder: (builder) =>
//                       AssociatesVisitsWidget(selectedUserId: selectedUserId),
//                 );
//               },
//               icon: const Icon(Icons.accessibility_sharp)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "sales",
//           child: IconButton(
//               onPressed: () {}, icon: const Icon(Icons.money_outlined)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "orders  ",
//           child: IconButton(
//               onPressed: () {}, icon: const Icon(Icons.money_outlined)),
//         ),
//         const VerticalDivider(),
//         TableActionWidget(
//           title: "maps",
//           child: IconButton(onPressed: () {}, icon: const Icon(Icons.map)),
//         ),
//         const VerticalDivider(),
//       ],
//     );
//   }
// }
