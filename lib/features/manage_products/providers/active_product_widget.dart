import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:flutter/material.dart';

class ActiveProductWidget extends StatelessWidget {
  final Function() onCopy;
  final Function() onDelete;
  const ActiveProductWidget(
      {super.key, required this.onCopy, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TableActionWidget(
          title: "COPY",
          child: IconButton(onPressed: onCopy, icon: const Icon(Icons.copy)),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "DELETE",
          child:
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        )
      ],
    );
  }
}
