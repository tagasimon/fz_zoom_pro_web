import 'package:field_zoom_pro_web/core/extensions/context_extesions.dart';
import 'package:field_zoom_pro_web/core/providers/company_info_provider.dart';
import 'package:field_zoom_pro_web/features/customers/presentation/widgets/table_action_widget.dart';
import 'package:field_zoom_pro_web/features/manage_products/models/product_data_source_model.dart';
import 'package:field_zoom_pro_web/features/manage_products/presentation/widgets/product_details_screen.dart';
import 'package:field_zoom_pro_web/features/manage_products/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  static const routeName = "registeredCustomersScreen";

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  String? selectedProductId;
  double initWidth = 0.9;
  bool animationEnded = false;
  @override
  Widget build(BuildContext context) {
    final productsProv = ref.watch(watchProductsProvider);
    return productsProv.when(
      data: (customers) {
        final myData = ProductDataSourceModel(
          data: customers,
          selectedProductId: selectedProductId,
          onSelected: (product) {
            if (selectedProductId == null) {
              setState(() {
                initWidth = 0.4;
                selectedProductId = product;
              });
              return;
            }
            setState(() {
              animationEnded = !animationEnded;
              initWidth = 0.9;
              selectedProductId = null;
            });
          },
        );
        return Scaffold(
          appBar: AppBar(
            title: Consumer(
              builder: (context, ref, _) {
                final companyInfoProv = ref.watch(companyInfoProvider);
                return companyInfoProv.when(
                    data: (data) => Text(data.companyName),
                    error: (error, stackTrace) => const Text("Error"),
                    loading: () => const Text("Loading ..."));
              },
            ),
          ),
          body: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: AnimatedContainer(
                  onEnd: () => setState(() {
                    if (initWidth == 0.9) {
                      animationEnded = false;
                    } else {
                      animationEnded = true;
                    }
                  }),
                  duration: const Duration(milliseconds: 500),
                  width: MediaQuery.of(context).size.width * initWidth,
                  child: PaginatedDataTable(
                    columns: const [
                      DataColumn(label: Text("NAME")),
                      DataColumn(label: Text("CARTEGORY")),
                      DataColumn(label: Text("SUB CARTEGORY")),
                      DataColumn(label: Text("VAR")),
                      DataColumn(label: Text("SELLING PRICE")),
                      DataColumn(label: Text("IS ACTIVE")),
                    ],
                    source: myData,
                    header: const Text("PRODUCTS"),
                    rowsPerPage: 10,
                    sortColumnIndex: 0,
                    sortAscending: false,
                    actions: selectedProductId != null
                        ? [
                            TableActionWidget(
                              title: "COPY",
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.copy)),
                            ),
                            TableActionWidget(
                              title: "DELETE",
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete)),
                            )
                          ]
                        : [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {},
                              label: const Text("ADD NEW PRODUCT"),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                  ),
                ),
              ),
              const VerticalDivider(),
              if (selectedProductId == null)
                const Center(child: Icon(Icons.question_mark)),
              if (selectedProductId != null && animationEnded)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ProductDetailsScreen(
                    id: selectedProductId!,
                    isDone: (val) {
                      if (val) {
                        setState(() {
                          animationEnded = false;
                          initWidth = 0.9;
                          selectedProductId = null;
                        });
                        context.showSnackBar(
                            "Product details updated successfully");
                      } else {
                        setState(() {
                          selectedProductId = null;
                        });
                      }
                    },
                  ),
                )
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('PRODUCTS')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        return Scaffold(
          appBar: AppBar(title: const Text('PRODUCTS')),
          body: Center(child: Text("Error: $error")),
        );
      },
    );
  }
}
