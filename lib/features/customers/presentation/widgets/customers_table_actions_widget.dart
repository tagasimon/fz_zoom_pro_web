import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class CustomersTableActionsWidget extends ConsumerWidget {
  final List<CustomerModel> customers;
  const CustomersTableActionsWidget({super.key, required this.customers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const VerticalDivider(),
        TableActionWidget(
          title: "insights",
          child:
              IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: 'download',
          child: IconButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Coming Soon!');
              },
              icon: const Icon(Icons.download)),
        ),
      ],
    );
  }
}
