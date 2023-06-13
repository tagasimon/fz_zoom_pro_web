import 'package:field_zoom_pro_web/core/presentation/widgets/app_filter_widget.dart';
import 'package:field_zoom_pro_web/core/presentation/widgets/company_title_widget.dart';
import 'package:field_zoom_pro_web/features/customers/models/customer_data_source_model.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/customers_table_actions_widget.dart';
import 'package:field_zoom_pro_web/features/customers/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerUniverse extends ConsumerWidget {
  const CustomerUniverse({Key? key}) : super(key: key);
  static const routeName = "registeredCustomersScreen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agentCustomersProv = ref.watch(customersProviderProvider);
    return agentCustomersProv.when(
      data: (customers) {
        final myData = CustomerDataSourceModel(
          data: customers,
          selectedCustomers: {},
          onSelected: (cust) {},
        );
        return Scaffold(
            appBar: AppBar(title: const CompanyTitleWidget()),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppFilterWidget(
                    showRegionFilter: true,
                    showRouteFilter: false,
                    showAssociateFilter: false,
                    showEndDateFilter: false,
                    showStartDateFilter: false,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PaginatedDataTable(
                      showCheckboxColumn: false,
                      showFirstLastButtons: true,
                      columns: const [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("CONTACT NAME")),
                        DataColumn(label: Text("BUSINESS NAME")),
                        DataColumn(label: Text("BUSINESS TYPE")),
                        DataColumn(label: Text("REGION")),
                        DataColumn(label: Text("ROUTE")),
                        DataColumn(label: Text("PHONE 1")),
                        DataColumn(label: Text("DISTRICT")),
                        DataColumn(label: Text("GPS")),
                        DataColumn(label: Text("DESC")),
                      ],
                      source: myData,
                      header: const Text("CUSTOMERS"),
                      rowsPerPage: 10,
                      sortColumnIndex: 0,
                      sortAscending: false,
                      actions: [
                        CustomersTableActionsWidget(customers: customers)
                      ],
                    ),
                  )
                ],
              ),
            ));
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('CUSTOMERS')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('CUSTOMERS')),
          body: Center(child: Text("Error: $error")),
        );
      },
    );
  }
}
