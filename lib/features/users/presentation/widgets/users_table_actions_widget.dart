import 'package:field_zoom_pro_web/core/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/new_region_screen.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/new_route_screen.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/new_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class UsersTableActionsWidget extends StatelessWidget {
  const UsersTableActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const VerticalDivider(),
        TableActionWidget(
          title: "NEW USER",
          child: IconButton(
            onPressed: () =>
                context.push(const NewUserScreen(), fullscreenDialog: true),
            icon: const Icon(Icons.person),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "NEW REGION",
          child: IconButton(
            onPressed: () =>
                context.push(const NewRegionScreen(), fullscreenDialog: true),
            icon: const Icon(Icons.circle_outlined),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "NEW ROUTE",
          child: IconButton(
            onPressed: () =>
                context.push(const NewRouteScreen(), fullscreenDialog: true),
            icon: const Icon(Icons.route),
          ),
        ),
        const VerticalDivider(),
        TableActionWidget(
          title: "INSIGHTS",
          child: IconButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "TODO");
            },
            icon: const Icon(Icons.insights),
          ),
        ),
      ],
    );
  }
}
