import 'package:field_zoom_pro_web/core/presentation/widgets/get_region_widget.dart';
import 'package:field_zoom_pro_web/core/providers/filter_notifier_provider.dart';
import 'package:field_zoom_pro_web/core/providers/regions_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/controllers/routes_controller.dart';
import 'package:field_zoom_pro_web/features/customers/providers/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fz_hooks/fz_hooks.dart';

class NewRouteScreen extends ConsumerStatefulWidget {
  const NewRouteScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewRouteScreen> createState() => _NewRouteScreenState();
}

class _NewRouteScreenState extends ConsumerState<NewRouteScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  RegionModel? selectedRegion;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routesProv = ref.watch(watchCompanyRoutesProvider);
    final regionsProv = ref.watch(companyRegionsProv);
    final state = ref.watch(routesControllerProvider);
    ref.listen<AsyncValue>(routesControllerProvider,
        (_, state) => state.showSnackBarOnError(context));
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            context.pop(false),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
            appBar: AppBar(title: const Text("NEW ROUTE"), centerTitle: true),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    regionsProv.when(
                      data: (data) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20.0),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  DropdownButton<RegionModel>(
                                    hint: const Text("Select Region"),
                                    isExpanded: true,
                                    value: selectedRegion,
                                    items: data
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e.name)))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() => selectedRegion = value!);
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                    autofocus: true,
                                    textInputAction: TextInputAction.next,
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "Enter New Route"),
                                    validator: (String? val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Route Name Missing';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                          50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 10.0),
                                    ),
                                    onPressed: state.isLoading
                                        ? null
                                        : () async {
                                            if (selectedRegion == null) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please select a region");
                                              return;
                                            }
                                            if (_nameController.text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please enter a route name");
                                              return;
                                            }
                                            final companyId = ref
                                                .read(filterNotifierProvider)
                                                .user!
                                                .companyId;
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final route = RouteModel(
                                                id: DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString(),
                                                name: _nameController.text,
                                                companyId: companyId,
                                                description: '',
                                                regionId: selectedRegion!.id,
                                                lastUpdated: DateTime.now(),
                                                date: DateTime.now(),
                                              );

                                              final success = await ref
                                                  .read(routesControllerProvider
                                                      .notifier)
                                                  .addRoute(route: route);
                                              if (success) {
                                                _nameController.clear();
                                                Fluttertoast.showToast(
                                                    msg: "SUCCESS :)");
                                              }
                                            }
                                          },
                                    child: state.isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text(
                                            "ADD",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) => Center(
                        child: Text(
                          e.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      "ROUTES",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Expanded(
                      child: routesProv.when(
                        data: (data) {
                          return DataTable(
                              showBottomBorder: true,
                              border:
                                  TableBorder.all(color: Colors.grey.shade300),
                              columns: const [
                                DataColumn(label: Text("Id")),
                                DataColumn(label: Text("Region")),
                                DataColumn(label: Text("Route Name")),
                              ],
                              rows: data.map((e) {
                                return DataRow(cells: [
                                  DataCell(Text(e.id)),
                                  DataCell(
                                      GetRegionWidget(regionId: e.regionId)),
                                  DataCell(Text(e.name)),
                                ]);
                              }).toList());
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, s) => Center(
                          child: Text(
                            e.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
