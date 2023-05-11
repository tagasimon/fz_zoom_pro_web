import 'dart:developer';

import 'package:field_zoom_pro_web/core/presentation/screens/home_screen.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationRailWidget extends ConsumerStatefulWidget {
  const NavigationRailWidget({super.key});

  @override
  ConsumerState<NavigationRailWidget> createState() =>
      _NavigationRailWidgetState();
}

class _NavigationRailWidgetState extends ConsumerState<NavigationRailWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen(userInfoProvider, (_, next) {
      next.whenData((user) {
        ref.read(filterNotifierProvider.notifier).updateFilter(user: user);
      });
    });
    final filter = ref.watch(filterNotifierProvider);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            useIndicator: true,
            indicatorColor: Theme.of(context).primaryColorLight,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
              ref
                  .read(filterNotifierProvider.notifier)
                  .updateFilter(region: "Deafult");
              log(filter.toString());
            },
            labelType: NavigationRailLabelType.none,
            leading: const FlutterLogo(),
            selectedLabelTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              decorationThickness: 2,
            ),
            selectedIconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('HOME'),
                padding: EdgeInsets.only(top: 20),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_3_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('SALES ASSOCIATES'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(Icons.people_alt_rounded),
                label: Text('CUSTOMERS'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                HomeScreen(),
                Center(child: Text('SALES ASSOCIATES')),
                Center(child: Text('CUSTOMERS'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
