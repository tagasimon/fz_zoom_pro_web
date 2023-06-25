import 'package:field_zoom_pro_web/core/notifiers/session_notifier.dart';
import 'package:field_zoom_pro_web/features/authentication/providers/user_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/screens/customer_universe.dart';
import 'package:field_zoom_pro_web/features/dashboard/presentation/screens/home_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/screens/products_screen.dart';
import 'package:field_zoom_pro_web/features/setup/presentation/screens/company_home.dart';
import 'package:field_zoom_pro_web/features/users/presentation/screens/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavigationRailWidget extends ConsumerStatefulWidget {
  const NavigationRailWidget({super.key});

  @override
  ConsumerState<NavigationRailWidget> createState() =>
      _NavigationRailWidgetState();
}

class _NavigationRailWidgetState extends ConsumerState<NavigationRailWidget> {
  int _selectedIndex = 0;
  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(userInfoProvider, (_, next) {
      next.whenData((user) {
        ref
            .read(sessionNotifierProvider.notifier)
            .updateSession(loggedInUser: user);
      });
    });
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isExtended,
            useIndicator: true,
            indicatorColor: Theme.of(context).primaryColorLight,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.none,
            // trailing: const CustomSwitchWidget(),
            leading: Row(
              children: [
                IconButton(
                    onPressed: () => setState(() => isExtended = !isExtended),
                    icon: const Icon(Icons.menu_sharp)),
              ],
            ),
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
                label: Text('FIELD FORCE'),
              ),
              NavigationRailDestination(
                icon: Icon(FontAwesomeIcons.earthAfrica),
                selectedIcon: Icon(FontAwesomeIcons.earthOceania),
                label: Text('CUSTOMERS'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_bag_outlined),
                selectedIcon: Icon(Icons.shopping_bag_sharp),
                label: Text('PRODUCTS'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('MANAGE'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: const [
                HomeScreen(),
                UsersScreen(),
                CustomerUniverse(),
                ProductsScreen(),
                CompanyHomeScreen()
              ],
            ),
          )
        ],
      ),
    );
  }
}
